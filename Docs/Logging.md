## Logging

MagicalRecord has logging built in to most of it's interactions with Core Data. When errors occur during fetching or saving data, these errors are captured and (if you've enabled them) logged to the console.

Logging can be enabled by placing the following preprocessor statement before your first import of `CoreData+MagicalRecord.h`, like so:

```objective-c
#define MR_LOGGING_ENABLED 1
#import <MagicalRecord/CoreData+MagicalRecord.h>
```

Logging can be configured by calling `[MagicalRecord setLoggingMask:…];` using one of the predefined logging masks:

- **MagicalRecordLogMaskOff**: Don't log anything
- **MagicalRecordLoggingMaskFatal**: Log all fatal messages
- **MagicalRecordLoggingMaskError**: Log all errors and fatal messages
- **MagicalRecordLoggingMaskWarn**: Log warnings, errors and fatal messages
- **MagicalRecordLoggingMaskInfo**: Log informative, warning and error messages
- **MagicalRecordLoggingMaskVerbose**: Log verbose diagnostic, informative, warning and error messages

The logging level defaults to `MagicalRecordLoggingMaskWarn`.

## Disabling Logs

Setting the logging mask to **MagicalRecordLogMaskOff** completely disables MagicalRecord's logging.

## CocoaLumberjack

If it's available, MagicalRecord will direct it's logs to [CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack). All you need to do is make sure you've imported CocoaLumberjack before you import MagicalRecord, like so:

```objective-c
#import <CocoaLumberjack/DDLog.h>
#define MR_LOGGING_ENABLED 1
#import <MagicalRecord/CoreData+MagicalRecord.h>
```
