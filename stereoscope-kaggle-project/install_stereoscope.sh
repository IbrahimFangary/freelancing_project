#!/bin/bash

# Update and install Python 3.8
echo "Updating packages and installing Python 3.8..."
apt-get update
apt install -y python3.8

# Install virtualenv
echo "Installing virtualenv..."
pip install virtualenv

# Create a virtual environment with Python 3.8
echo "Creating virtual environment with Python 3.8..."
cd /kaggle/working
virtualenv venv -p $(which python3.8)

# Activate virtual environment and install dependencies
echo "Installing required packages in Python 3.8 venv..."
/kaggle/working/venv/bin/pip install tiktoken
/kaggle/working/venv/bin/pip install stereoscope

# Make Python and stereoscope binaries executable
echo "Making executables accessible..."
chmod +x /kaggle/working/venv/bin/python3.8
chmod +x /kaggle/working/venv/bin/stereoscope

# Write test Python file
echo "Writing test Python script..."
cat <<EOF > /kaggle/working/test.py
import tiktoken
print("Python 3.8 and tiktoken are working!")
EOF

# Run the test Python file
echo "Running test Python script..."
/kaggle/working/venv/bin/python3.8 /kaggle/working/test.py

# Run stereoscope with test command
echo "Running stereoscope test..."
/kaggle/working/venv/bin/stereoscope test

echo "✅ Done!"
