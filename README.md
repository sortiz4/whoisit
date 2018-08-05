# Whoisit
Whoisit is a completely free and open source WHOIS client for Android with the
goal of providing a more private domain name searching experience. All queries
are sent directly to the most appropriate WHOIS server and no one else.

Whoisit is available on the [Google Play Store](
https://play.google.com/store/apps/details?id=me.stevenortiz.whoisit).

## Compilation
Those seeking to compile must have...

- Flutter SDK 0.5 (or greater)
- Android Studio 3.1 (or greater)
  - Plugins: Flutter and Dart
- Android SDK 28 (or greater)
- Python 3.5 (or greater)

Once these requirements have been met, simply clone the repository and execute
`py setup.py -f` (this will download the required fonts). Once completed, the
application can be compiled by executing `flutter build apk --release`.
