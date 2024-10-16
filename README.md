# QR code diff

> A mobile application to generate a "git-style" diff between two QR codes.

<img src="https://github.com/lusimeon/qrcode-diff/blob/gh-pages/_images/logo.jpg" width="200">

## Screenshots

<img src="https://github.com/lusimeon/qrcode-diff/blob/gh-pages/_images/qrcode_result.jpg" width="20%">

## Installation

```bash
python3.12 -m venv ./functions/venv/
source ./functions/venv/bin/activate
pip install -r ./functions/requirements.txt

firebase use --add example && firebase use example # Use another firebase project if needed.
flutterfire configure # Configure firebase options.
firebase emulators:start --only functions # Emulate firebase server (for dev env).

flutter doctor -v
flutter clean
flutter pub get
flutter run --dart-define=EMULATOR_HOST="127.0.0.1" --dart-define=FUNCTIONS_EMULATOR_PORT="5001"
```
