# Whoisit
Whoisit is a mobile WHOIS client specifically designed for Android users. It
prioritizes user privacy during domain name searches by sending all queries
directly to the most appropriate WHOIS server without intermediaries,
effectively preventing domain name scalping by registrars.

## Compilation
Those seeking to compile must have...

- Flutter SDK 2.2
- Android Studio 4.2
- Android SDK 30
- Python 3.8

Once these requirements have been met, simply clone the repository and execute
`py setup.py -f` (this will download the required fonts). Once completed, the
application can be compiled by executing `flutter build apk --release`.
