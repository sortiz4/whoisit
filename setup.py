#!/usr/bin/env python
import argparse
import os
import zipfile
from io import BytesIO
from urllib import request

BASE_DIR = os.path.dirname(os.path.abspath(__file__))


class Fonts:
    HELP = 'Download font assets.'
    URL = 'https://fonts.google.com/download?family=Roboto%20Mono'
    DIR = os.path.join(BASE_DIR, 'fonts')
    NAMES = ['RobotoMono-Regular.ttf']


class Command:
    help = 'Downloads assets for this application.'

    def __init__(self):
        parser = argparse.ArgumentParser(description=Command.help)
        parser.add_argument('-f', '--fonts', action='store_true', help=Fonts.HELP)
        self.args = parser.parse_args()

    def handle(self):
        if self.args.fonts:
            Command.fonts()

    @staticmethod
    def fonts():
        # Make the directory if it doesn't exist
        if not os.path.exists(Fonts.DIR):
            os.makedirs(Fonts.DIR)

        # Download the font archive as an in-memory file
        buffer = request.urlopen(Fonts.URL).read()
        zip_file = BytesIO(buffer)

        # Read the archive and extract the fonts
        archive = zipfile.ZipFile(zip_file)
        for name in Fonts.NAMES:
            buffer = archive.read(name)
            font_path = os.path.join(Fonts.DIR, name)
            with open(font_path, 'wb') as font:
                font.write(buffer)


if __name__ == '__main__':
    Command().handle()
