# Lumpen Radio (iOS)

Available on the [iOS App Store](https://apps.apple.com/us/app/lumpen/id1494420362)

## Tag Schema
Follows [Semantic Versioning](https://semver.org/)

Tags will be applied as follows:

`[x].[y]b[num]` or `[x].[y].[z]b[num]`

where:

- x: First (major) number in semver
- y: Second (minor) number in semver
- z: third (patch) number in semver
- num: Build number, as noted in XCode

## Switching to SwiftUI
This project originally started as a SwiftUI but then shifted to UIKit to support iOS <13, since SwiftUI is only available to iOS 13+

In order to bring back the SwiftUI base files, do the following:

1. Edit the `Info.plist` entry, find property `Scene ConfigurationBACK` and rename it to `Scene Configuration` which will tell the app to look for a scene to initialize with
2. Open up `AppDelegate.swift` and remove/comment out the `var window: UIWindow?`
3. in `AppDelegate.swift`, uncomment the bottom part after `// SwiftUI - iOS 13+` comment
4. Under the SwiftUI folder, assign all files to the Lumpen Radio target (and UI tests if needed)
5. Find the `Radio.swift`, comment out the UIKit block at the top, unncomment the SwiftUI version 
5. In Lumpen Radio project settings, switch iOS version to 13+
6. Optional: In Lumpen Radio project settings, change Main Interface to blank entry

The app should now be SwiftUI driven from start up.
