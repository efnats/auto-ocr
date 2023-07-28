# ScanOCR Script

An automatic OCR (Optical Character Recognition) script for newly added PDF files. Utilizes [OCRmyPDF](https://ocrmypdf.readthedocs.io/en/latest/) and [inotify-tools](https://github.com/inotify-tools/inotify-tools/wiki).

## Prerequisites

- Linux (e.g., Ubuntu)
- OCRmyPDF
- inotify-tools

Install prerequisites on Ubuntu:

```bash
sudo apt-get -y install ocrmypdf inotify-tools tesseract-ocr-deu
```

## Setup

1. Clone the repository and copy files:

```bash
git clone https://github.com/username/repo.git
cd scanocr
sudo cp ./scanocr.sh /usr/local/bin
sudo chmod +x /usr/local/bin/scanocr.sh
sudo cp ./scanocr.service /etc/systemd/system/
```

2. Setup the service:

```bash
sudo systemctl daemon-reload
sudo systemctl enable scanocr.service
sudo systemctl start scanocr.service
```

## Operation

Monitors directories for new files, renaming with timestamp, performing OCR, moving to processed directory, and deleting the original.

## Note on the Service File

The service file contains the directive `OOMScoreAdjust=-1000`. This directive is used to prevent the Out of Memory (OOM) killer from targeting the `scanocr` service. This is particularly important when running the service in an LXC container with limited RAM (e.g., 500MB). If the system disk is fast, consider raising swap to 1GB to provide additional virtual memory and prevent OOM situations.
