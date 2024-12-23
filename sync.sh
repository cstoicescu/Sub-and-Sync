#!/bin/bash

# Check if a directory path is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <path>"
  exit 1
fi

# Get the provided directory path
base_dir="$1"
echo "Starting sync in directory: $base_dir"

# Check if the provided directory exists
if [ ! -d "$base_dir" ]; then
  echo "Error: Directory '$base_dir' does not exist."
  exit 1
fi

# Source the virtual environment
if [ -f "/config/autodownloader/venv/bin/activate" ]; then
  echo "Activating virtual environment..."
  source /config/autodownloader/venv/bin/activate
else
  echo "Error: Virtual environment not found at /config/autodownloader/venv."
  exit 1
fi

# Find all .srt files in the given directory and subdirectories
echo "Searching for subtitle files..."
find "$base_dir" -type f -name "*.srt" | while read subtitle; do
  echo "Found subtitle: $subtitle"
  # Extract the base name of the subtitle file without language code
  base_name=$(basename "$subtitle" .srt)
  base_name_no_lang="${base_name%.*}"  # Remove the language code (last part after the last dot)

  # Search for associated video files in the directory and subdirectories
  video=$(find "$base_dir" -type f -iname "$(printf "%q" "$base_name_no_lang")*.mkv" | head -n 1)
  echo "Looking for associated video file: $video"

  if [[ -f "$video" ]]; then
    echo "Syncing subtitle '$subtitle' with video '$video'"
    ffsubsync "$video" -i "$subtitle" --output-encoding utf-8 --overwrite-input
  else
    echo "No associated video found for subtitle '$subtitle'."
  fi
done

# Deactivate the virtual environment after the script is done
echo "Deactivating virtual environment."
deactivate
