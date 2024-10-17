
# Flutter Package: My Widgets

## Overview
This Flutter package, originally created by **Bilal MurtaZa**, offers a comprehensive set of reusable widgets, utility functions, dialogs, and services for Flutter development. The package is designed to simplify common tasks in Flutter apps and allows users to perform big actions with just a single line of code.

## Features
- Reusable widgets such as `Btn`, `Txt`, `Input`,`Dialogs`, `Dates` and almost all commonly used widgets. 
- Custom dialogs like `OverlayLoading` and `DialogForPage`.
- Utility functions for shared preferences (`Pref`), date formatting (`Dates`), and HTTP calls (`HttpCalls`).
- **Users can change colors for every app** using built-in functions.

## Getting Started

To allow users to change colors for the entire app, you can set color schemes with ease. Users can also manage shared preferences and localize dates with simple function calls.

## Usage

### Set Application Colors
Users can set a color scheme for their app using the following code. It is preferable to use this before the `main()` function.
```dart
WidgetsFlutterBinding.ensureInitialized();

String prdBaseURL = 'https://xvz/api/'; // optional
String stgBaseURL = 'https://xvz/api/'; // optional
await pSetSettings(
    primaryColor: Colors.blueAccent,
    secondaryColor: Colors.white,
    defaultImage: 'assets/images/avatar.png',
    defImageIsAsset: true,
    baseUrlLive: prdBaseURL,
    baseUrlTest: stgBaseURL,
    isLive: false,
    defaultRadius: Siz.defaultRadius,
    defaultBtnHeight: Siz.defaultBtnHeight,
    txtInputHasBorder: true,
    txtInputHasLabel: true,
    txtInputHasLabelOnTop: true,
    txtInputHasLabelWithStar: false,
    txtInoutDefaultContentPadding: const EdgeInsets.symmetric(horizontal: 10),
    fontWeight: FontWeight.w600,
    defaultFontSize: Siz.body17,
    localization: 'ar',
    onHttpCallError: callHttpError
);
runApp(const MyApp());
runMain();
```

### Use Shared Preferences
If you want to use Shared Preferences in your app, make sure to call `Pref.getPref()` before `pSetSettings`.
```dart
await Pref.getPref();
pSetSettings();
runMain();
```

### Localize Dates
If you need to localize dates in your app, use the `Dates.initializeDateFormat()` method before `pSetSettings`.
```dart
await Dates.initializeDateFormat();
pSetSettings();
runMain();
```

### Example
```dart
await Pref.getPref();
await Dates.initializeDateFormat();
pSetSettings();
runMain();
```

## Android and iOS Configuration

### URL Launcher Configuration
To use `pUrlLaunch` for opening links or making calls/SMS, follow the platform-specific steps below:

#### Android
Add the following queries in your `AndroidManifest.xml`:
```xml
<queries>
    <intent>
        <action android:name="android.intent.action.VIEW" />
        <data android:scheme="sms" />
    </intent>
    <intent>
        <action android:name="android.intent.action.VIEW" />
        <data android:scheme="tel" />
    </intent>
    <intent>
        <action android:name="android.intent.action.VIEW" />
        <data android:scheme="http" />
    </intent>
    <intent>
        <action android:name="android.intent.action.VIEW" />
        <data android:scheme="https" />
    </intent>
    <intent>
        <action android:name="android.intent.action.SEND" />
        <data android:mimeType="*/*" />
    </intent>
</queries>
```

#### iOS
In `info.plist`, add the following entries:
```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>sms</string>
    <string>tel</string>
    <string>http</string>
    <string>https</string>
</array>
```

### Some other useful commands

## Uninstalling the Package
To uninstall the package from your app, use the following adb command:
```
adb uninstall "com.domain.yourapp"
```

## Finding SHA1 and SHA-256
To find the SHA1 and SHA-256 keys, navigate to your Android folder in the terminal and run:
```
./gradlew signingReport
```

## Generating Android Certificates
To create a certificate for Android from a MacBook, use the following command:
```
keytool -genkey -v -keystore ~/key-<flavor_name>.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key <flavor_name>
```

## Related Packages

- **[Flutter Error Handler](https://pub.dev/packages/flutter_error_handler)**: A comprehensive global error handler package for Flutter applications, designed to simplify error tracking and improve app stability. It captures both framework-level and asynchronous errors, ensuring no error goes unnoticed.

- **[Flutter Loading Overlay](https://pub.dev/packages/flutter_loading_overlay)**: Provides a simple and flexible way to manage loading overlays in Flutter apps. It allows you to start and stop loading overlays effortlessly and customize their appearance with ease.

## Additional Information
If you encounter any issues, please contact us at **bilal.faith@gmail.com**.
