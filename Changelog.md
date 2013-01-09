# Changelog
## Version 2.1.0
* Fixed issue #287 - MR_findByAttribute:withValue:andOrderBy:ascending:inContext does not pass context through `4b97d0e` - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* Adding changelog `da70884` - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* Cleanup contextWillSave method Update deleting incompatible store `2eaec27` - [Saul Mora](mailto:saul@magicalpanda.com)
* don't check the error, rely only on the return value of methods to determine success `64a81c6` - [Saul Mora](mailto:saul@magicalpanda.com)
* removed MR_saveErrorHandler, as it and MR_saveWithErrorCallback were essentially duplicates MR_save now only saves the current context (it was essentially doing a MR_saveNestedContexts). If you need to save all the way out to disk, use MR_saveNestedContexts. Removed the action queue, unneccesary since core data introduced it's own queue support `f7c4350` - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* Separate printing context chain method into its own method change contextWorkingName to property workingName `0fb7d36` - [Saul Mora](mailto:saul@magicalpanda.com)
* Added fetchAllWithDelegate: method for NSFRC `c0a1657` - [Saul Mora](mailto:saul@magicalpanda.com)
* Fixed Issue #294 - MR_requestAllSortedBy:ascending:inContext: did not use correct context `3656e74` - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* Bumping podspec version `fb81b5b` - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* Updating changelog `20f02ba` - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* Re-Added obtaining permanent ids automatically `cfccd40` - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* Minor formatting updates `1440623` - [Saul Mora](mailto:saul@magicalpanda.com)
* Pass errorCallback through convenience method `5376700` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Implement new save methods `4f35e4e` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Update existing save tests to reflect save changes. Also begin adding tests for deprecated methods to ensure consistent behaviour in unmodified code. `c763d4a` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Fix compilation problems under latest Xcode. `af84aff` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Update gitignore and remove user specific xcuserdata `d0e771d` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Add Kiwi for saner asynchronous testing and remove existing GHUnit tests for save methods `55af799` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Flesh out tests for MagicalRecord+Actions and the NSManagedObjectContext+MagicalSaves category `a28d421` - [Tony Arnold](mailto:tony@thecocoabots.com)
* The deprecated saveWithBlock: method should do it's work on the current thread `2c66056` - [Tony Arnold](mailto:tony@thecocoabots.com)
* All deprecated and non-deprecated methods have tests to ensure their function `c2fa8c4` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Update README with details of the changes in this branch `4316422` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Update shorthand methods and import the magical saves category so that MRSaveCompletionHandler resolves `1af1201` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Updated podspec to 2.1.beta.1 `5ed45f6` - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* Minor text editing. `710d643` - [nerdery-isaac](mailto:isaac.greenspan@nerdery.com)
* Added additional case that will trigger persistant store cleanup `36d1630` - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* Alter saveWithBlock: so that it runs asynchronously. Fixes #349. `357b62e` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Execute save completion blocks on the main dispatch queue. `065352d` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Fix broken GHUnit tests after recent changes to the save methods `0c83121` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Add Clang-style documentation for the MagicalSaves category. Also add Clang's -Wdocumentation warning to assist in writing in future documentation. `eb8865a` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Remove unused notification constant `5a40bcc` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Finalise documentation for MagicalRecord 2.1.0 `f370cdb` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Update pod spec to MagicalRecord 2.1.0 `46b6004` - [Tony Arnold](mailto:tony@thecocoabots.com)

## Version 2.0.8
* Fixed issue #287 - MR_findByAttribute:withValue:andOrderBy:ascending:inContext does not pass context through `4b97d0e` - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* Adding changelog `da70884` - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* Cleanup contextWillSave method Update deleting incompatible store `2eaec27` - [Saul Mora](mailto:saul@magicalpanda.com)
* don't check the error, rely only on the return value of methods to determine success `64a81c6` - [Saul Mora](mailto:saul@magicalpanda.com)
* removed MR_saveErrorHandler, as it and MR_saveWithErrorCallback were essentially duplicates MR_save now only saves the current context (it was essentially do
* Separate printing context chain method into its own method change contextWorkingName to property workingName `0fb7d36` - [Saul Mora](mailto:saul@magicalpanda
* Added fetchAllWithDelegate: method for NSFRC `c0a1657` - [Saul Mora](mailto:saul@magicalpanda.com)
* Fixed Issue #294 - MR_requestAllSortedBy:ascending:inContext: did not use correct context `3656e74` - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
* Bumping podspec version `fb81b5b` - [Stephen Vanterpool](mailto:stephen@vanterpool.net)
## Version 2.0.7
* Fix small error in README with regard to MR_SHORTHAND `[31m8c14cc7[m` - [1;34m[Maik Gosenshuis](mailto:maik@gosenshuis.nl)[m
* Hide intended private cleanUpErrorHandling method `[31ma903e7e[m` - [1;34m[Saul Mora](mailto:saul@magicalpanda.com)[m
* Call completion handler on main thread. `[31mc639ce4[m` - [1;34m[Brandon Williams](mailto:brandon@opetopic.com)[m
* Persist changes to disk when using: - [NSManagedObjectContext MR_saveInBackgroundErrorHandler:completion:] methods, AND the context is the default context - [MagicalRecord saveInBackground…] methods `[31m8bb0d0d[m` - [1;34m[Saul Mora](mailto:saul@magicalpanda.com)[m
* [NSManagedObjectContext MR_saveInBackgroundErrorHandler:completion:] `[31mf0246e9[m` - [1;34m[Jwie](mailto:joey.daman@twoup.eu)[m
* [NSManagedObjectContext MR_saveInBackgroundErrorHandler:completion:] `[31meabb147[m` - [1;34m[Jwie](mailto:joey.daman@twoup.eu)[m
* update `[31m8b7c1c8[m` - [1;34m[Peter Paulis](mailto:peterpaulis@Admins-MacBook-Air-2.local)[m
* Correct typo `[31mf99215b[m` - [1;34m[Ryan Maxwell](mailto:ryanm@xwell.co.nz)[m
* Update MR_SHORTHAND installation note to match main readme `[31m222c956[m` - [1;34m[Ryan Maxwell](mailto:ryanm@xwell.co.nz)[m
* Correct typo of "persistent" in method name `[31m86db065[m` - [1;34m[Ryan Maxwell](mailto:ryanm@xwell.co.nz)[m
* Make all requestAllSortedBy* methods consistent (allows sortTerms with commas) `[31m33f3994[m` - [1;34m[vguerci](mailto:vguerci@gmail.com)[m
* dispatch_release is not needed by the <REDACTED> compiler `[31m7128091[m` - [1;34m[Saul Mora](mailto:saul@magicalpanda.com)[m
* Don't run completion block if non specified `[31m3aa2845[m` - [1;34m[Saul Mora](mailto:saul@magicalpanda.com)[m
* Make platform requirements more explicit `[31macff79a[m` - [1;34m[Saul Mora](mailto:saul@magicalpanda.com)[m
* Update MagicalRecord/Core/MagicalRecordShorthand.h `[31m7daf3ad[m` - [1;34m[Ryan Maxwell](mailto:ryanm@xwell.co.nz)[m
* Added automatic store deletion if the store does not match the model `[31mb8326a6[m` - [1;34m[Stephen Vanterpool](mailto:stephen@vanterpool.net)[m
* Missed the configuration `[31m22fe81a[m` - [1;34m[Stephen Vanterpool](mailto:stephen@vanterpool.net)[m
* Updating readme with a short blurb `[31md8394cf[m` - [1;34m[Stephen Vanterpool](mailto:stephen@vanterpool.net)[m
* Cleanup code is now debug-only `[31m45d764a[m` - [1;34m[Stephen Vanterpool](mailto:stephen@vanterpool.net)[m
* Clarified the DEBUG only nature of the fix `[31m8842d8f[m` - [1;34m[Stephen Vanterpool](mailto:stephen@vanterpool.net)[m
* Making background save asynchronous and fix the callback not firing `[31m22311b7[m` - [1;34m[Stephen Vanterpool](mailto:stephen@vanterpool.net)[m
* Added expecta matchers for tests `[31mcff0304[m` - [1;34m[Stephen Vanterpool](mailto:stephen@vanterpool.net)[m
* Fixing formatting issues to match project style `[31m3bc55de[m` - [1;34m[Stephen Vanterpool](mailto:stephen@vanterpool.net)[m
* Fixed KVC relationship mapping bug. `[31meaa78c2[m` - [1;34m[Joshua Greene](mailto:jrg.developer@gmail.com)[m
* Fixed an issue with aggregate actions not being performed in the specified context `[31m9348ef5[m` - [1;34m[Brian King](mailto:bking@agamatrix.com)[m
* Adding an observer to check for icloud being setup after default context has been set. Should fix race condition in Issue #241 `[31m5341e84[m` - [1;34m[Stephen Vanterpool](mailto:stephen@vanterpool.net)[m
* Updated test model to actually build `[31m2df10b1[m` - [1;34m[Stephen Vanterpool](mailto:stephen@vanterpool.net)[m
* Clean up comments `[31mef16c57[m` - [1;34m[Saul Mora](mailto:saul@magicalpanda.com)[m
* Remove compile warnings `[31m8f93070[m` - [1;34m[Saul Mora](mailto:saul@magicalpanda.com)[m
* Cleaning up iCloud setup observer code some `[31m32f9f80[m` - [1;34m[Stephen Vanterpool](mailto:stephen@vanterpool.net)[m
* Removes dispatch_release when iOS >= 6 || OSX >= 1080 `[31m28a864b[m` - [1;34m[Rod Wilhelmy](mailto:rwilhelmy@gmail.com)[m
* Modifiying generateShorthand.rb to use user specified ruby `[31m25081d0[m` - [1;34m[Stephen Vanterpool](mailto:stephen@vanterpool.net)[m
* Automatically obtain permanent IDs when saving the default context. This should fix several crashes the community is hitting `[31m0e34179[m` - [1;34m[Stephen Vanterpool](mailto:stephen@vanterpool.net)[m
* Making all relevant contexts obtain a permanent id before saving `[31m0b00e39[m` - [1;34m[Stephen Vanterpool](mailto:stephen@vanterpool.net)[m
* Adding recommended journalling mode `[31ma9a7643[m` - [1;34m[Stephen Vanterpool](mailto:stephen@vanterpool.net)[m
* fixup compiler warnings in Xcode 4.5 `[31m5203cc1[m` - [1;34m[Saul Mora](mailto:saul@magicalpanda.com)[m
* Fix compile warnings once and for all :/ `[31m11e5ee1[m` - [1;34m[Saul Mora](mailto:saul@magicalpanda.com)[m
* refactor internal method names to match more general objects to traverse fix another compile warning `[31m0a6f523[m` - [1;34m[Saul Mora](mailto:saul@magicalpanda.com)[m
* - auto-migration options bug fix `[31m1924d73[m` - [1;34m[Alexander Belyavskiy](mailto:diejmon@me.com)[m
* Don't adjust incoming NSDates for DST `[31mda39710[m` - [1;34m[Saul Mora](mailto:saul@magicalpanda.com)[m
* fix compile error with pragma option `[31m51fe465[m` - [1;34m[Saul Mora](mailto:saul@magicalpanda.com)[m
* Add findFirstOrderedByAttribute:ascending:context: method for getting min/max values easier `[31mabb7314[m` - [1;34m[Saul Mora](mailto:saul@magicalpanda.com)[m
* Bumping podspec to 2.0.4 `[31m4091c78[m` - [1;34m[Stephen Vanterpool](mailto:stephen@vanterpool.net)[m
* Added new nestedContextSave method with completion handler `[31m2660e73[m` - [1;34m[Stephen Vanterpool](mailto:stephen@vanterpool.net)[m
* Bumping podspec with bugfix `[31ma451eb4[m` - [1;34m[Stephen Vanterpool](mailto:stephen@vanterpool.net)[m
* Fixing rookie mistake :/ `[31m72dc5a4[m` - [1;34m[Stephen Vanterpool](mailto:stephen@vanterpool.net)[m
* Require ARC in podspec (was compiling with retain/release in pod installations) `[31m48cc383[m` - [1;34m[Ryan Maxwell](mailto:ryanm@xwell.co.nz)[m
* Bump tag to 2.0.6 `[31mf2e2b7b[m` - [1;34m[Ryan Maxwell](mailto:ryanm@xwell.co.nz)[m
* Properly removing existing on-save notificaitons before replacing the default or root contexts `[31m343b027[m` - [1;34m[Stephen Vanterpool](mailto:stephen@vanterpool.net)[m
* Fixing potential concurrency issue with creating the actionQueue `[31m52139bd[m` - [1;34m[Stephen Vanterpool](mailto:stephen@vanterpool.net)[m
* Cherry picking changes that make the context description more... descriptive `[31ma41ceee[m` - [1;34m[Stephen Vanterpool](mailto:stephen@vanterpool.net)[m
* Rolled back a commit that broke things if cleanup was used. It created the action_queue in a dispatch_once block, and never recreated it after a cleanup `[31mb81e70d[m` - [1;34m[Stephen Vanterpool](mailto:stephen@vanterpool.net)[m
* saveWithBlock was not saving parent contexts `[31m870ca22[m` - [1;34m[Tony Arnold](mailto:tony@thecocoabots.com)[m
* Test that the current thread saveWith method actually saves `[31md41d744[m` - [1;34m[Tony Arnold](mailto:tony@thecocoabots.com)[m
* Bumped podspec to 2.0.7 `[31m601869e[m` - [1;34m[Stephen Vanterpool](mailto:stephen@vanterpool.net)[m
