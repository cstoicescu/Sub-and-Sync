from datetime import timedelta
import logging
import sys
from babelfish import Language
from subliminal import download_best_subtitles, region, save_subtitles, scan_videos
from subliminal.providers.opensubtitlescom import OpenSubtitlesComProvider  # Assuming it's imported from your package
from subliminal import provider_manager

# Configure logging to display info about the subtitles and providers
logging.basicConfig(level=logging.INFO)

def main(root_folder):
    # configure the cache
    region.configure('dogpile.cache.dbm', arguments={'filename':'/config/autodownloader/cachefile.dbm'})

    # Scan for videos newer than 4 weeks and their existing subtitles in the provided folder
    videos = scan_videos(root_folder, age=timedelta(weeks=4))

    # Define the languages
    languages = {Language.fromalpha2('ro')}

    # Initialize and log in to OpenSubtitlesComProvider
    provider = OpenSubtitlesComProvider(username='user', password='pass', apikey="key")
    provider.initialize()
    provider.login(wait=True)

    # Download the best subtitles
    subtitles = download_best_subtitles(videos, languages, providers=["opensubtitlescom"])

    # Save the subtitles and display the provider info
    for video in videos:
        if video in subtitles:
            print(f"Video: {video.name}")
            for subtitle in subtitles[video]:
                print(f"Downloaded subtitle from provider: {subtitle.provider_name}")
                print(f"Subtitle language: {subtitle.language}")
            save_subtitles(video, subtitles[video], encoding='utf-8', extension='.srt')

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python script.py <Root Folder>")
    else:
        root_folder = sys.argv[1]
        main(root_folder)
