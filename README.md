# Lumpen Radio

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

## Asset Credits

### Radio off button
<div>Icons made by <a href="https://www.flaticon.com/authors/kiranshastry" title="Kiranshastry">Kiranshastry</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>

### Radio on button
<div>Icons made by <a href="https://www.flaticon.com/authors/kiranshastry" title="Kiranshastry">Kiranshastry</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>
