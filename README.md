# YPAppMonitor

app fluency/crash monitor

Demo Project
==============
See `Demo/YPAppMonitor.xcodeproj`

- using '+ (void)start' method can only print backtrace in console if APP in DEBUG mode.
- using '+ (void)startWithAlertShowResult' method can show an alert view in your Viewcontroller.
- using '+ (void)startWithCompletedHandler:(yp_flunecy_handler)handler' method, your can handle backtrace in the block.

Installation
==============

### CocoaPods

1. Add `pod 'YPAppMonitor'` to your Podfile.
2. Run `pod install` or `pod update`.
3. Import \<YPAppMonitor/YPAppMonitor.h\>.
4. Add '[YPAppFluencyMonitor start]' in your code to moniting UI fluency.Also you can stop by using 'stop' menthod.

Requirements
==============
This library requires `iOS 6.0+` and `Xcode 8.0+`.