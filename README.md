
# AutoDownloader and Subtitle Sync

This repository contains two Python scripts that automatically download subtitles for video files and synchronize them with the video using `ffsubsync`. Both scripts interact with OpenSubtitles and require a properly configured environment.

## Files

1. **`opensubtitles.py`**: This script scans a given folder for video files, downloads the best matching Romanian ( or any other language) subtitles from OpenSubtitles, and saves them as `.srt` files in UTF-8 encoding.

2. **`sub_and_sync.py`**: This script extends the functionality of `opensubtitles.py` by additionally synchronizing the downloaded subtitles with the video using `ffsubsync`.

## Prerequisites

- Python 3.x
- `subliminal` library for subtitle downloading
- `ffsubsync` for subtitle synchronization
- OpenSubtitles account for API access (username, password, and API key)
- Virtual environment with necessary dependencies (e.g., `babelfish`, `dogpile.cache`)

### Install dependencies:

```bash
pip install subliminal ffsubsync
```

## Setup

1. **Configuration**:
   - The scripts are designed to work in a virtual environment where `ffsubsync` is installed at a specific path (`/config/autodownloader/venv/bin/ffsubsync`).
   - Replace the OpenSubtitles login credentials (`username`, `password`, and `apikey`) in both scripts with your own account details.

2. **Cache Configuration**:  
   Both scripts use `dogpile.cache.dbm` for caching downloaded subtitles. Ensure that the cache file (`/config/autodownloader/cachefile.dbm`) is writable and exists.

3. **Video Folder**:  
   The scripts assume you have a folder containing video files for which you want to download and sync subtitles. Provide the path to this folder when running the scripts.

## Usage

### 1. `opensubtitles.py`

This script scans the provided directory for video files (older than 4 weeks) and downloads the best matching subtitles in Romanian (`ro`).

To run the script:

```bash
python opensubtitles.py <Root Folder>
```

Where `<Root Folder>` is the directory containing your video files.

### 2. `sub_and_sync.py`

This script performs the same steps as `opensubtitles.py` but adds the functionality to synchronize the downloaded subtitles with the video file using `ffsubsync`.

To run the script:

```bash
python sub_and_sync.py <Root Folder>
```

Where `<Root Folder>` is the directory containing your video files.

### Example

```bash
python opensubtitles.py /path/to/videos
python sub_and_sync.py /path/to/videos
```

### How it works

1. Both scripts:
   - Scan the provided folder for video files newer than 4 weeks.
   - Download the best Romanian ( or any other language ) subtitles from OpenSubtitles.
   - Save the subtitles as `.srt` files in UTF-8 encoding.

2. The `sub_and_sync.py` script:
   - After downloading the subtitles, it synchronizes them with the video using `ffsubsync`.

## Notes

- Make sure `ffsubsync` is correctly installed and accessible in the virtual environment.
- The scripts expect video files to be in formats that `subliminal` supports.
- The subtitle files will be saved in the same directory as the video files with the `.srt` extension.
- The `sub_and_sync.py` script will synchronize subtitle timings after the subtitle is downloaded and saved.

## License

This project is open-source and available under the MIT License.
