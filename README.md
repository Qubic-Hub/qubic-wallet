# Qubic Wallet

This is a fully functional wallet for the Qubic project (https://discord.com/invite/2vDMR8m). It is developed using flutter and compiles successfully for Android. There are some issues with Windows and MacOS builds which will soon be ironed out

## Functionality

- [x] Multi account: Add and manage multiple IDs
- [x] Transfers: Send and receive $QUBIC
- [x] Manual resend: Manual resend failed transfers
- [x] Block Explorer: View complete tick / transacation / ID info
- [x] Assets: View shares in your accounts
- [ ] Asset transfers: Allow to send and receive shares - coming soon
- [ ] Automatic resend: Automatically resend transfers - coming soon

## Other features

- [x] Require password to login
- [x] Require password view seed / make transfer
- [x] Biometric authentication (provided that your phone has the required hardware)
- [x] Dark / light themes
- [x] Use QR codes
- [ ] Address book - coming soon
- [ ] One-touch backup / restore - coming soon

# Supported Platforms

- [x] Android
- [x] Windows - ~~coming soon~~
- [ ] Linux - coming soon
- [ ] iOS - coming soon
- [ ] MacOS - coming soon
- [ ] Web - coming soon

## Distribution

- [x] Android: Signed APK
- [x] Windows: Executable
- [ ] Android: App stores - coming soon

# Security

All stored data is encrypted via (https://pub.dev/packages/flutter_secure_storage)

- Android : Use of EncryptedSharedPreferences
- iOS: KeyChain
- MacOS: KeyChain
- Windows: Windows Credentials Manager

## Cryptographic operations

Open source Dart cryptographic libraries for required algorithms state that are not audited / production ready. For this, we are using an embedded web browser
which features the Web Crypto API and use Javascript libs for the cryptographic operations. This is transparent to the end user. Javascript libs are extracted by qubic.li wallet and added as an asset.

## Backend

Your keys are never shared to any 3rd party. Yet the wallet uses some backend services:

### Access to Qubic Network

Access to the Qubic Network is currently provided by the wonderful work of (https://www.qubic.li). We are working with a new version to iterface directly with the Computor nodes.

### Version checking

The wallet makes some calls to wallet.qubic-hub.com in order to check for updates or critical fixes.

# Compiling - Downloading - Running

Soon there will be a dedicated compilation manual page. Until then here's some brief instructions:

## Android

- Run : `flutter build apk --split-per-abi` for Android and run the .apk file on your device.

## Windows

- Run : `flutter build windows` to build the windows version. Run it in your windows
- Please note that running the windows version requires the VC++ Redistributables which can be found here(https://www.microsoft.com/en-gb/download/details.aspx?id=48145)

# Contribution - Bug reports

Feel free to contribute to the project. Just create an MR. Tests are being written and will be added to the repo. Until then, checking is manual.
Feel free to post any found bugs in Issues page.
