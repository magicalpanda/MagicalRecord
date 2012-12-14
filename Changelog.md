# Changelog

## Version 2.0.8
* Fixed issue #287 - MR_findByAttribute:withValue:andOrderBy:ascending:inContext does not pass context through - [Stephen Vanterpool](mailto:stephen@vanterpool.net)

## Version 2.0.7
* Fix small error in README with regard to MR_SHORTHAND - [Maik Gosenshuis](mailto:maik@gosenshuis.nl)
* Hide intended private cleanUpErrorHandling method - [Saul Mora](mailto:saul@magicalpanda.com)
* Call completion handler on main thread. - [Brandon Williams](mailto:brandon@opetopic.com)
* Persist changes to disk when using: - [NSManagedObjectContext MR_saveInBackgroundErrorHandler:completion:] methods, AND the context is the default context - [MagicalRecord saveInBackground…] methods - [Saul Mora](mailto:saul@magicalpanda.com)
* [NSManagedObjectContext MR_saveInBackgroundErrorHandler:completion:] - [Jwie](mailto:joey.daman@twoup.eu)
* [NSManagedObjectContext MR_saveInBackgroundErrorHandler:completion:] - [Jwie](mailto:joey.daman@twoup.eu)
* update - [Peter Paulis](mailto:peterpaulis@Admins- acBook-Air-2.local)
* Correct typo - [Ryan Maxwell](mailto:ryanm@xwell.co.nz)
* Update MR_SHORTHAND installation note to match main readme - [Ryan Maxwell](mailto:ryanm@xwell.co.nz)
* Correct typo of "persistent" in method name  - m[Ryan Maxwell](mailto:ryanm@xwell.co.nz)
* Make all requestAllSortedBy* methods consistent (allows sortTerms with commas) - [vguerci](mailto:vguerci@gmail.com)
* dispatch_release is not needed by the <REDACTED> compiler - [Saul Mora](mailto:saul@magicalpanda.com)
* Don't run completion block if non specified - [Saul Mora](mailto:saul@magicalpanda.com)
* Make platform requirements more explicit - [Saul Mora](mailto:saul@magicalpanda.com)
* Update MagicalRecord/Core/MagicalRecordShorthand.h - [Ryan Maxwell](mailto:ryanm@xwell.co.nz)
* Added automatic store deletion if the store does not match the model - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* Missed the configuration - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* Updating readme with a short blurb - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* Cleanup code is now debug-only - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* Clarified the DEBUG only nature of the fix - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* Making background save asynchronous and fix the callback not firing - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* Added expecta matchers for tests - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* Fixing formatting issues to match project style - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* Fixed KVC relationship mapping bug. - [Joshua Greene](mailto:jrg.developer@gmail.com)
* Fixed an issue with aggregate actions not being performed in the specified context - [Brian King](mailto:bking@agamatrix.com)
* Adding an observer to check for icloud being setup after default context has been set. Should fix race condition in Issue #241 - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* Updated test model to actually build - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* Clean up comments - [Saul Mora](mailto:saul@magicalpanda.com)
* Remove compile warnings - [Saul Mora](mailto:saul@magicalpanda.com)
* Cleaning up iCloud setup observer code some - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* Removes dispatch_release when iOS >= 6 || OSX >= 1080 - [Rod Wilhelmy](mailto:rwilhelmy@gmail.com)
* Modifiying generateShorthand.rb to use user specified ruby - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* Automatically obtain permanent IDs when saving the default context. This should fix several crashes the community is hitting - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* Making all relevant contexts obtain a permanent id before saving - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* Adding recommended journalling mode - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* fixup compiler warnings in Xcode 4.5 - [Saul Mora](mailto:saul@magicalpanda.com)
* Fix compile warnings once and for all :/ - [Saul Mora](mailto:saul@magicalpanda.com)
* refactor internal method names to match more general objects to traverse fix another compile warning - [Saul Mora](mailto:saul@magicalpanda.com)
* - auto- igration options bug fix - [Alexander Belyavskiy](mailto:diejmon@me.com)
* Don't adjust incoming NSDates for DST - [Saul Mora](mailto:saul@magicalpanda.com)
* fix compile error with pragma option - [Saul Mora](mailto:saul@magicalpanda.com)
* Add findFirstOrderedByAttribute:ascending:context: method for getting min/max values easier - [Saul Mora](mailto:saul@magicalpanda.com)
* Bumping podspec to 2.0.4 - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* Added new nestedContextSave method with completion handler - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* Bumping podspec with bugfix - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* Fixing rookie mistake :/ - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* Require ARC in podspec (was compiling with retain/release in pod installations) - [Ryan Maxwell](mailto:ryanm@xwell.co.nz)
* Bump tag to 2.0.6 - [Ryan Maxwell](mailto:ryanm@xwell.co.nz)
* Properly removing existing on-save notificaitons before replacing the default or root contexts - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* Fixing potential concurrency issue with creating the actionQueue - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* Cherry picking changes that make the context description more... descriptive - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* Rolled back a commit that broke things if cleanup was used. It created the action_queue in a dispatch_once block, and never recreated it after a cleanup - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* saveWithBlock was not saving parent contexts - [Tony Arnold](mailto:tony@thecocoabots.com)
* Test that the current thread saveWith method actually saves - [Tony Arnold](mailto:tony@thecocoabots.com)
* Bumped podspec to 2.0.7 - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
