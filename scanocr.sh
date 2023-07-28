#!/bin/bash

# Uncomment the next line if you need to install ocrmypdf and inotify-tools
# install ocrmypdf tesseract-ocr-deu inotify-tools

# Display current date and time
echo
echo "Current date and time: $(date)"
echo
# List of directories to monitor
directories=(
"/path/to/dir1"
"/path/to/dir2"
"/path/to/dir3"
# Add more directories if needed
)

# Function to OCR incoming files
ocr_new_file() {
    incoming_dir=$1
    incoming_file=$2
    processed_dir="${incoming_dir}/.."


    # Generate a timestamped filename
    timestamp=$(date +"%Y%m%d-%H%M%S")
    timestamped_file="${timestamp}.pdf"

    echo "Processing new file: ${incoming_file}..."

    # Rename incoming file with timestamp
    mv "${incoming_dir}/${incoming_file}" "${incoming_dir}/${timestamped_file}"

    # Perform OCR on the file and move it to the processed directory
    ocrmypdf -d -c -i -r -l eng+deu -q "${incoming_dir}/${timestamped_file}" "${processed_dir}/${timestamped_file}"

    if [ $? -eq 0 ]
    then
        echo "File processed and moved to ${processed_dir}/${timestamped_file}"
        
        # Remove the original file from the incoming directory
        rm -f "${incoming_dir}/${timestamped_file}"
    else
        echo "An error occurred during the OCR process. The file has been left in ${incoming_dir}."
    fi
}

# Monitor each provided directory for new files and process them
for dir in "${directories[@]}"
do
    echo "Watching directories: ${dir}"
    inotifywait -m -e close_write --format "%f" "${dir}" \
    | while read -r incoming_file
    do
        ocr_new_file "${dir}" "${incoming_file}"
    done &
done

# Wait for all background jobs to complete
wait
