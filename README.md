# QR code diff

A mobile application to generate diff between two QR codes.

![QR code diff logo](https://github.com/lusimeon/qrcode-diff/blob/gh-pages/_images/logo.jpg)

## Getting Started

```bash
python3.12 -m venv ./functions/venv/
source ./functions/venv/bin/activate
pip install -r ./functions/requirements.txt

flutterfire configure # Configure firebase options.
firebase emulators:start --only functions # Emulate firebase server (for dev env).

flutter doctor -v
flutter clean
flutter pub get
flutter run --dart-define=EMULATOR_HOST="127.0.0.1" --dart-define=FUNCTIONS_EMULATOR_PORT="5001"
```
