#!/usr/bin/env python
import argparse
import os
from io import BytesIO
from urllib import request
from zipfile import ZipFile

BASE_PATH = os.path.dirname(os.path.abspath(__file__))
FONT_SRC_URL = 'https://fonts.google.com/download?family=Roboto%20Mono'
FONT_SRC_NAMES = ['RobotoMono-Regular.ttf']
FONT_DEST_PATH = os.path.join(BASE_PATH, 'fonts')


class Command:

    def __init__(self):
        # Construct the argument parser
        options = {
            'description': 'Downloads the required assets.',
        }
        parser = argparse.ArgumentParser(**options)

        # Add the arguments to the parser
        arguments = [
            [
                [
                    '-f',
                    '--fonts',
                ],
                {
                    'action': 'store_true',
                    'help': 'Downloads the font assets.',
                },
            ],
        ]
        for argument in arguments:
            parser.add_argument(*argument[0], **argument[1])

        # Parse the arguments from the system
        self.args = parser.parse_args()

    def handle(self):
        def fonts():
            # Make the directory if it doesn't exist
            if not os.path.exists(FONT_DEST_PATH):
                os.makedirs(FONT_DEST_PATH)

            # Download the font archive to memory
            archive = ZipFile(BytesIO(request.urlopen(FONT_SRC_URL).read()))

            # Extract the fonts
            for name in FONT_SRC_NAMES:
                content = archive.read(f'static/{name}')
                with open(os.path.join(FONT_DEST_PATH, name), 'wb') as font:
                    font.write(content)

        if self.args.fonts:
            fonts()


if __name__ == '__main__':
    Command().handle()
