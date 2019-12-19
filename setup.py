#!/usr/bin/env python
import argparse
import os
from io import BytesIO
from urllib import request
from zipfile import ZipFile

BASE_DIR = os.path.dirname(os.path.abspath(__file__))


class Fonts:
    HELP = 'Downloads the font assets.'
    NAMES = ['RobotoMono-Regular.ttf']
    DIR = os.path.join(BASE_DIR, 'fonts')
    URL = 'https://fonts.google.com/download?family=Roboto%20Mono'


class Command:
    help = 'Downloads the assets required by this application.'

    def __init__(self):
        parser = argparse.ArgumentParser(description=self.help)
        parser.add_argument('-f', '--fonts', action='store_true', help=Fonts.HELP)
        self.args = parser.parse_args()

    def handle(self):
        if self.args.fonts:
            self.fonts()

    @classmethod
    def fonts(cls):
        # Make the directory if it doesn't exist
        if not os.path.exists(Fonts.DIR):
            os.makedirs(Fonts.DIR)

        # Download the font archive to memory
        buffer = request.urlopen(Fonts.URL).read()
        archive = BytesIO(buffer)

        # Extract the fonts
        archive = ZipFile(archive)
        for name in Fonts.NAMES:
            buffer = archive.read(name)
            path = os.path.join(Fonts.DIR, name)
            with open(path, 'wb') as font:
                font.write(buffer)


if __name__ == '__main__':
    Command().handle()
