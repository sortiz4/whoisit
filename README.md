# Whoisit
Whoisit is a completely free and open source WHOIS client for Android that
provides a more private domain name searching experience. All queries are sent
directly to the most appropriate WHOIS server and no one else.

Whoisit is available on the [Google Play Store][1].

## Compilation
Those seeking to compile must have...

- Flutter SDK 2.2
- Android Studio 4.2
- Android SDK 30
- Python 3

Once these requirements have been met, simply clone the repository and execute
`py setup.py -f` (this will download the required fonts). Once completed, the
application can be compiled by executing `flutter build apk --release`.

[1]: https://play.google.com/store/apps/details?id=me.stevenortiz.whoisit
