# YPAppMonitor

This is an App fluency/crash monitor.it can update record to the specific server.


# Using (CocoaPods)

1. Add `pod 'YPAppMonitor'` to your Podfile.
2. Run `pod install` or `pod update`.
3. `#import <YPAppMonitor/YPAppMonitor.h>`.


In your project APPDelegate ,method didFinishLaunchingWithOption:

``` objective-c
YPAppMonitorConfiguration *config = [YPAppMonitorConfiguration new];
config.useCrashMonitoring = YES;
config.useFluencymonitoring = YES;
config.reportServerBaseUrl = [NSURL URLWithString:@"http://127.0.0.1:8088/YPAppMonitor/"];
[YPAppMonitor startWithConfiguration:config];
```

# Requirements
This library requires `iOS 7.0+` and `Xcode 8.0+`.


# Component diagram
<img src="https://raw.github.com/zhuyuping/YPAppMonitor/master/Demo/Snapshots/YPAPPMonitorComponent diagram.png" width="826"><br/>

# Other

The progress of delevepment work :

- YPAppMonitor framework for iOS,now is Release;

- YPAppMonitorrServer for node.js,now is developing;

- YPAppMonitorViewer for mac OS,now is developing;
