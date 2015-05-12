## Logging

MagicalRecord has logging built in to most of its interactions with Core Data. When errors occur during fetching or saving data, these errors are captured and (if you've enabled them) logged to the console.

Logging can be enabled by placing the following preprocessor statement before your first import of `CoreData+MagicalRecord.h`, like so:

```objective-c
#define MR_LOGGING_ENABLED 1
#import <MagicalRecord/MagicalRecord.h>
```

Logging can also be enabled by passing `-DMR_LOGGING_ENABLED=1` to `OTHER_CFLAGS` (shown as "Other C Flags" in Xcode's Build Settings). If you have trouble with with the first approach, adding this build setting should work.

Logging can be configured by calling `[MagicalRecord setLoggingLevel:…];` using one of the predefined logging levels:

- **MagicalRecordLogLevelOff**: Don't log anything
- **MagicalRecordLoggingLevelError**: Log all errors
- **MagicalRecordLoggingLevelWarn**: Log warnings and errors
- **MagicalRecordLoggingLevelInfo**: Log informative, warning and error messages
- **MagicalRecordLoggingLevelDebug**: Log all debug, informative, warning and error messages
- **MagicalRecordLoggingLevelVerbose**: Log verbose diagnostic, informative, warning and error messages

The logging level defaults to `MagicalRecordLoggingLevelWarn`.

## Disabling Logs

Setting the logging level to **MagicalRecordLogLevelOff** completely disables MagicalRecord's logging.

## CocoaLumberjack

If it's available, MagicalRecord will direct its logs to [CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack). All you need to do is make sure you've imported CocoaLumberjack before you import MagicalRecord, like so:

```objective-c
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <MagicalRecord/MagicalRecord.h>
```
