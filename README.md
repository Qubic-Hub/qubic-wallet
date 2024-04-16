# Qubic Wallet
Official wallet app for the QUBIC network (https://qubic.org/). Find more about QUBIC on (https://doc.qubic.world/). Find us on discord (https://discord.com/invite/2vDMR8m). 

## Functionality

- [x] Multi account: Add and manage multiple IDs
- [x] Transfers: Send and receive $QUBIC
- [x] Manual resend: Manual resend failed transfers
- [x] Block Explorer: View complete tick / transacation / ID info
- [x] Assets: View shares in your accounts
- [x] Asset transfers: Allow to send and receive shares

## Other features

- [x] Require password to login
- [x] Require password view seed / make transfer
- [x] Biometric authentication (provided that your phone has the required hardware)
- [x] Use QR codes

# Supported Platforms

- [x] Android
- [x] Windows
- [x] Linux
- [ ] iOS - submitted
- [ ] MacOS - submitted
- [ ] Web - submitted

## Distribution

- [x] Android: Signed APK (check qubic-hub releases page)
- [x] Windows: Executable
- [ ] Android: App stores

# Security

All stored data is encrypted via (https://pub.dev/packages/flutter_secure_storage)

- Android : Use of EncryptedSharedPreferences
- iOS: KeyChain
- MacOS: KeyChain
- Windows: Windows Credentials Manager

## Cryptographic operations

### Mobile version
Open source Dart cryptographic libraries for required algorithms state that are not audited / production ready. For this, we are using an embedded web browser
which features the Web Crypto API and use Javascript libs for the cryptographic operations. This is transparent to the end user. Javascript libs are extracted by qubic.li wallet and added as an asset.

### Desktop version
In order to not have to embed a javascript runtime inside the application, for desktop apps, we have compiled the Javascript libs to standalone executables using pkg. You can find them here: https://github.com/Qubic-Hub/qubic-helper-utils 
Desktop versions try to locate the appropriate executable and if it's missing it automatically downloads it (or allows the user to manually download it).

### Anti-tampering
Both mobile and desktop version check the Hashes of the assets / executables before using them, in order to prevent tampering.

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

Feel free to contribute to the project. Just create an MR. Feel free to post any found bugs in Issues page. We cannot support you in any case. You are welcome to provide updates, bugfixes or other code changes by pull requests.




# Donations
If you want to support us, please donate to WZFSPXPLXKNWFDLNMZHQTGMSRIHBEBITVDUXOSVSZGBREGIUVNWVZBIETEQF
