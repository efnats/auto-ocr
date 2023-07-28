# ScanOCR Script

This bash script is designed to monitor specific directories and automatically perform OCR (Optical Character Recognition) on newly added PDF files. The script utilizes [OCRmyPDF](https://ocrmypdf.readthedocs.io/en/latest/) for the OCR process, and [inotify-tools](https://github.com/inotify-tools/inotify-tools/wiki) to monitor the directories.

## Prerequisites

- A Linux environment (e.g., Ubuntu)
- [OCRmyPDF](https://ocrmypdf.readthedocs.io/en/latest/installation.html)
- [inotify-tools](https://github.com/inotify-tools/inotify-tools/wiki#downloading-and-installation)

These packages can be installed on Ubuntu with the following command:

```bash
sudo apt-get -y install ocrmypdf inotify-tools
```

## Setup

1. Clone the repository:

```bash
git clone https://github.com/username/repo.git
```

2. Move `scanocr.sh` to `/usr/local/bin`:

```bash
sudo mv repo/scanocr.sh /usr/local/bin
```

3. Make the script executable:

```bash
sudo chmod +x /usr/local/bin/scanocr.sh
```

4. If you wish to run the script as a service, move the provided `scanocr.service` file to the systemd directory:

```bash
sudo mv repo/scanocr.service /etc/systemd/system/
```

5. Reload systemd manager configuration:

```bash
sudo systemctl daemon-reload
```

6. Enable the service to start on boot:

```bash
sudo systemctl enable scanocr.service
```

7. Start the service:

```bash
sudo systemctl start scanocr.service
```

## How It Works

The script uses inotify-tools to monitor directories for the `close_write` event, which is triggered when a file has been closed, indicating that it's ready for processing.

Upon detecting a new file, the script will:

- Rename the file with the current timestamp.
- Use OCRmyPDF to perform OCR on the file.
- Move the processed file to a designated processed directory.
- Delete the original file from the incoming directory.

Note: In case of an error during the OCR process, the file will be left in the incoming directory, and an error message will be displayed.
