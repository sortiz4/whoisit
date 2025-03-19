#!/usr/bin/env python
import argparse
import os
from io import BytesIO
from urllib import request
from zipfile import ZipFile


class Command:

    def __init__(self) -> None:
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

    def run(self) -> None:
        base_path = os.path.dirname(os.path.abspath(__file__))

        def fonts() -> None:
            font_url = 'https://fonts.google.com/download?family=Roboto%20Mono'
            font_path = os.path.join(base_path, 'fonts')
            font_names = ['RobotoMono-Regular.ttf']

            # Make the directory if it doesn't exist
            if not os.path.exists(font_path):
                os.makedirs(font_path)

            # Download the font archive to memory
            archive = ZipFile(BytesIO(request.urlopen(font_url).read()))

            # Extract the fonts
            for name in font_names:
                content = archive.read(f'static/{name}')
                with open(os.path.join(font_path, name), 'wb') as font:
                    font.write(content)

        if self.args.fonts:
            fonts()


if __name__ == '__main__':
    Command().run()
