## Logging
MagicalRecord has logging built in to every fetch request and other Core Data operation. When errors occur when fetching or saving data, these errors are captured by MagicalRecord. By default, these logs use NSLog to present logging information. However, if you have CocoaLumberjack installed in your project, MagicalRecord will use CocoaLumberjack and it's configuration to send logs to their proper output.

All logging in MagicalRecord can be enabled by placing this define preprocessor statement prior to the main import of `MagicalRecord.h`

    #define MR_LOGGING_ENABLED 1
