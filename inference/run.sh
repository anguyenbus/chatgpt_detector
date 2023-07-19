#!/bin/bash

# Check if the "latest" file exists locally
if [ -f "$local_directory$latest_file" ]; then
    echo "Latest file already exists locally. Skipping download."
else
    echo "Latest file does not exist locally. Downloading..."
    aws s3 sync s3://chatgptdetector/chatgptdetector/latest/model/ latest
fi

python3 inference.py