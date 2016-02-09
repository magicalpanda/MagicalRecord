## Logging

MagicalRecord has logging built in to most of it's interactions with Core Data. When errors occur during fetching or saving data, these errors are captured and (if you've enabled them) logged to the console.

Logging can be enabled by placing the following preprocessor statement before your first import of `MagicalRecord.h`, like so:

```objective-c
#define MR_LOGGING_ENABLED 1
#import <MagicalRecord/MagicalRecord.h>
```

Logging can be configured by calling `[MagicalRecord setLoggingLevel:…];` using one of the predefined logging masks:

- **MagicalRecordLoggingLevelOff**: Don't log anything
- **MagicalRecordLoggingLevelFatal**: Log all fatal messages
- **MagicalRecordLoggingLevelError**: Log all errors and fatal messages
- **MagicalRecordLoggingLevelWarn**: Log warnings, errors and fatal messages
- **MagicalRecordLoggingLevelInfo**: Log informative, warning and error messages
- **MagicalRecordLoggingLevelVerbose**: Log verbose diagnostic, informative, warning and error messages

The logging level defaults to `MagicalRecordLoggingLevelVerbose`.

## Disabling Logs

Setting the logging mask to **MagicalRecordLoggingLevelOff** completely disables MagicalRecord's logging.

## CocoaLumberjack

If it's available, MagicalRecord will direct it's logs to [CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack). All you need to do is make sure you've imported CocoaLumberjack before you import MagicalRecord, like so:

```objective-c
#import <CocoaLumberjack/DDLog.h>
#define MR_LOGGING_ENABLED 1
#import <MagicalRecord/MagicalRecord.h>
```
