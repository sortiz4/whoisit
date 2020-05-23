# Whoisit
Whoisit is a completely free and open source WHOIS client for Android with the
goal of providing a more private domain name searching experience. All queries
are sent directly to the most appropriate WHOIS server and no one else.

Whoisit is available on the [Google Play Store][1].

## Compilation
Those seeking to compile must have...

- Flutter SDK 1.0
- Android Studio 3.2
- Android SDK 28
- Python 3

Once these requirements have been met, simply clone the repository and execute
`py setup.py -f` (this will download the required fonts). Once completed, the
application can be compiled by executing `flutter build apk --release`.

[1]: https://play.google.com/store/apps/details?id=me.stevenortiz.whoisit "Whoisit"
