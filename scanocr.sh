#!/bin/bash

# Check for required arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <watch_dir> <output_dir>"
    exit 1
fi

# Directories passed as arguments
watch_dir=$1
output_dir=$2

# Function to OCR incoming files
ocr_new_file() {
    incoming_dir=$1
    incoming_file=$2
    timestamp=$(date +"%Y%m%d-%H%M%S")
    timestamped_file="${timestamp}.pdf"

    echo "Processing new file: ${incoming_file}..."

    # Rename incoming file with timestamp
    mv "${incoming_dir}/${incoming_file}" "${incoming_dir}/${timestamped_file}"

    # Perform OCR on the file and move it to the output directory
    ocrmypdf -d -c -i -r -l eng+deu -q "${incoming_dir}/${timestamped_file}" "${output_dir}/${timestamped_file}"

    if [ $? -eq 0 ]; then
        echo "File processed and moved to ${output_dir}/${timestamped_file}"
        
        # Remove the original file from the incoming directory
        rm -f "${incoming_dir}/${timestamped_file}"
    else
        echo "An error occurred during the OCR process. The file has been left in ${incoming_dir}."
    fi
}

# Monitor the specified directory for new files and process them
echo "Watching directory: ${watch_dir}"
inotifywait -m -e close_write --format "%f" "${watch_dir}" | while read -r incoming_file; do
    sleep 1
    ocr_new_file "${watch_dir}" "${incoming_file}"
done
