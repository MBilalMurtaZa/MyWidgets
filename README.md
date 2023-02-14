
## Features

Users can change colors for every app .

## Getting started

Users can change colors for every app. 

## Usage
user can set color bow according to his color requirement.
if you use before main will be preferable.

for more detail please check example 
```
pSetSettings();
runMain();
```

## Additional information
 in case of any issue please contact us at bilal.faith@gmail.com

## if you use pUrlLaunch you have to set android and iOS keys 
in android side please add below queries in AndroidManifest.xml
```
<queries>
    <!-- If your app checks for SMS support -->
<intent>
<action android:name="android.intent.action.VIEW" />
<data android:scheme="sms" />
</intent>
<!-- If your app checks for call support -->
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



for iOS side please add below queries in info.plist

```
<key>LSApplicationQueriesSchemes</key>
<array>
<string>sms</string>
<string>tel</string>
<string>http</string>
<string>https</string>
</array>
```



# to uninstall package 
# adb uninstall "com.domain.yourapp"