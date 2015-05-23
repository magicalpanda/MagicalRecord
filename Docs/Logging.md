## Logging

MagicalRecord has logging built in to most of its interactions with Core Data. When errors occur during fetching or saving data, these errors are captured and (if you've enabled them) logged to the console.

Logging is configured to output debugging messages (**MagicalRecordLoggingLevelDebug**) by default in debug builds, and will output error messages (**MagicalRecordLoggingLevelError**) in release builds.

Logging can be configured by calling `[MagicalRecord setLoggingLevel:];` using one of the predefined logging levels:

- **MagicalRecordLogLevelOff**: Don't log anything
- **MagicalRecordLoggingLevelError**: Log all errors
- **MagicalRecordLoggingLevelWarn**: Log warnings and errors
- **MagicalRecordLoggingLevelInfo**: Log informative, warning and error messages
- **MagicalRecordLoggingLevelDebug**: Log all debug, informative, warning and error messages
- **MagicalRecordLoggingLevelVerbose**: Log verbose diagnostic, informative, warning and error messages

The logging level defaults to `MagicalRecordLoggingLevelWarn`.

## CocoaLumberjack

If it's available, MagicalRecord will direct its logs to [CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack). All you need to do is make sure you've imported CocoaLumberjack before you import MagicalRecord, like so:

```objective-c
// Objective-C
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <MagicalRecord/MagicalRecord.h>
```

```swift
// Swift
import CocoaLumberjack
import MagicalRecord
```

## Disabling Logging Completely

For most people this should be unnecessary. Setting the logging level to **MagicalRecordLogLevelOff** will ensure that no logs are printed.

Even when using `MagicalRecordLogLevelOff`, a very quick check may be performed whenever a log call is made. If you absolutely need to disable the logging, you will need to define the following when compiling MagicalRecord:

```objective-c
#define MR_LOGGING_DISABLED 1
```

Please note that this will only work if you've added MagicalRecord's source to your own project. You can also add this to the MagicalRecord project's `OTHER_CFLAGS` as `-DMR_LOGGING_DISABLED=1`.
