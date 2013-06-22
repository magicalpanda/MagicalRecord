# Installation

1. In your XCode Project, drag the *MagicalRecord* folder (under the main folder) into your project. 
2. Add *CoreData+MagicalRecord.h* file to your PCH file or your AppDelegate file.
3. Optionally preceed the *CoreData+MagicalRecord.h* import with `#define MR_SHORTHAND` to your PCH file if you want to use MagicalRecord methods without the *MR_prefix* like `findAll` instead of `MR_findAll`
4. Start writing code!

# Requirements

MagicalRecord Platform Requirements:

* iOS5.x or newer, or Mac OS 10.7 and newer
* ARC

An iOS4 compatible version is available for use. Reference [tag 1.8.3](https://github.com/magicalpanda/MagicalRecord/tree/1.8.3).

## ARC Support

MagicalRecord fully supports ARC out of the box, there is no configuration necessary. 
The last version to support manually managed memory is 1.8.3, and is available from the downloads page, or by switching to the 1.8.3 tag in the source.

