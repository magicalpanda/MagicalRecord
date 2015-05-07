# Changelog

## Version 2.3
* Added NSManagedObjectContext+ChainSave method just like the [MagicalRecord saveWithBlock…] methods, this set of methods start with the receiver context and creates a child context. Upon saving, the child context saves to parent and chain up the save operation
* Use context passed in as parameter instead of +MR_contextForCurrentThread `cfb210c` - [Aaron Abt](mailto:aabt@firesoftllc.com)
* Revert broken check for default context `700ae7e` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Added a 3rd condition for the migration error case `ff93015` - [Edward Ishaq](mailto:edward.ishaq@gmail.com)
* Add workaround for Travis builds failing — see https://github.com/travis-ci/travis-ci/issues/2836 `c2e1ac0` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Update podspec to 2.3.0-beta 5 `aff51ab` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Update logging documentation for 2.3.0 `ab27bcb` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Make parameter names consistent `e14a982` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Update documentation around Getting Started and iCloud `4461312` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Add a few missing calls to super in the iOS sample project `12b98e3` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Lots of updates to the documentation from the wiki (and some new content, too) `0c35d9f` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Remove commented line `0f6e3cb` - [Hung Truong](mailto:hung@hung-truong.com)
* Revamp logging and support CocoaLumberjack 2.0.0-beta4 `208b3b4` - [Ernesto Rivera](mailto:rivera_ernesto@cyberagent.co.jp)
* Adjust default MagicalRecordLoggingLevel `dfcc7c6` - [Ernesto Rivera](mailto:rivera_ernesto@cyberagent.co.jp)
* Look up the entity name from the default managed object model if it's available `2753ee5` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Fix test for entity name no longer returning the class name by default when none is provided `26233d2` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Iterate entities, not the model itself `5e5c8f1` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Build CI using Xcode 6.1 `6570233` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Fix -import<relationship> called before -shouldImport<relationship> `23c29b9` - [Aaron Abt](mailto:aabt@firesoftllc.com)
* Revert "Merge branch 'shouldImport-fix' into develop" `15e89d8` - [Aaron Abt](mailto:aabt@firesoftllc.com)
* Fix concurrency exception for MR_inContext if receiver has temporary objectID `746d265` - [Aaron Abt](mailto:aabt@firesoftllc.com)
* Change the error to have block prefix `c227054` - [Aaron Abt](mailto:aabt@firesoftllc.com)
* Rename Importing.md to Importing-Data.md `3f6a524` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Properly set NDEBUG for release builds `1b6be0c` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Revert "Look up the entity name from the default managed object model if it's available" `17dc113` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Revert "Fix test for entity name no longer returning the class name by default when none is provided" `55aecdf` - [Tony Arnold](mailto:tony@thecocoabots.com)
* fix link typo `862ffa4` - [Christian Tietze](mailto:christian.tietze@gmail.com)
* fix the link, this time for real `342bad4` - [Christian Tietze](mailto:christian.tietze@gmail.com)
* Added unit test `b846444` - [Lei Zhang](mailto:leizhang0121@gmail.com)
* Updated method names `8a81dbf` - [Lei Zhang](mailto:leizhang0121@gmail.com)
* Updated unit test `a0ada38` - [Lei Zhang](mailto:leizhang0121@gmail.com)
* Sort test target source `df3e18c` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Remove unused methods `3be8978` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Move calls to `MR_setWorkingName:` inside the `performBlockAndWait:` block to fix potential thread access issues `0cbe372` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Update documentation to use headerdoc. `745c8a1` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Formatting and casting fixes `3b51514` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Remove redundant or non-required header imports `1f66715` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Update category name, and header comments `8cb6d64` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Fix copyright year `8602ecf` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Replace MagicalRecordVersionNumber with MagicalRecordVersionTag to avoid conflicts with default values provided dynamic frameworks and CocoaPods `9a81ab2` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Provide proper framework targets `0cdde5b` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Minor rename of framework targets, and use CURRENT_PROJECT_VERSION `395dacb` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Update LICENSE `7906413` - [Saul Mora](mailto:saul@casademora.com)
* Update dynamic iOS framework to target iOS 8.0 and higher `c1987e3` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Hide warnings for a couple of deprecated method calls on NSPersistentStoreCoordinator `53e0b94` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Fix dynamic framework test targets `c2d32e2` - [Tony Arnold](mailto:tony@thecocoabots.com)
* NSPersistentStoreUbiquitousContentURLKey cannot contain non-alphanumeric characters (such as periods) `e3f4159` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Fix whitespace formatting to match project defaults `32c1bac` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Remove missing files from project `1b2b910` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Update CI build scripts to exclude Expecta `2e8f7ae` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Update linked frameworks `0667651` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Only log errors when running tests `0c28b60` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Remove unused variables `92306ff` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Consistently use the same variable within the local scope `052041b` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Actually test that the context does not have changes `dcdab00` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Enable Core Data concurrency debugging for the test suite `dc08d90` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Fix failing test `568c948` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Fix removal of save mask option `b33976f` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Turn on modules, and update Expecta `e753947` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Latests build server scripts `156d165` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Create a proper umbrella header, and update docs to reflect the change `159f188` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Update LICENSE `dd92efa` - [Saul Mora](mailto:saul@casademora.com)
* add method with parameter configuration `be02a7e` - [lx](mailto:lixiang@camera360.com)
* Add doc sections about custom contexts and debugging `a382935` - [thomassnielsen](mailto:me@thomassnielsen.com)
* Don't cycle through the documents and app support directories for a default — just use app support `a539832` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Remove unprefixed function `2f71f50` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Update target and scheme names `748fa5e` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Update shorthand support — which I'm pretty sure is still unusable `d4f775c` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Add missing headers to the umbrella header `440b935` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Whitespace `880d325` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Don't swizzle entityName/MR_entityName when shorthand support is enabled `13aa8de` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Enable shorthand support by default — there's no way for framework users to do this for themselves `b2a7e5d` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Latest Expecta `50ef73b` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Go build, go! `9e35f5e` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Fix runpaths and framework bundling for framework tests `c63ddb9` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Test fixes `9334e1a` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Remove Usage Patterns from README `58353f1` - [Orta](mailto:orta.therox@gmail.com)
* Return success result from performFetch `a731519` - [Eric Jensen](mailto:jensen39@gmail.com)
* Consistent whitespace `ea0388b` - [Eric Jensen](mailto:jensen39@gmail.com)
* add precision about default entity creation context `e834e65` - [dlajarretie](mailto:dlajarretie@airintservices.com)
* fix typo `64ad78d` - [dlajarretie](mailto:dlajarretie@airintservices.com)
* Update Installing docs. `4f90801` - [Stas Zhukovskiy](mailto:stzhuk@gmail.com)
* -- Fixes https://github.com/magicalpanda/MagicalRecord/issues/972 -- Fixes https://github.com/magicalpanda/MagicalRecord/issues/864 `6caf84f` - [Christos Sotiriou](mailto:csotiriou86@gmail.com)
* -- formatting fixed `60b0c9b` - [Christos Sotiriou](mailto:csotiriou86@gmail.com)
* -- more formatting changes `55c8756` - [Christos Sotiriou](mailto:csotiriou86@gmail.com)
* Formatting and documentation fixes for the last commit `635b183` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Update README.md `11e1dcd` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Update podspec for modules branch `c12a4e2` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Update clang-format to latest syntax `2033d01` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Sort order in project `4391c69` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Don't expose the default batch size in a header `4439a0d` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Remove shorthand category methods, and update documentation `7a1b79a` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Don't use prefix headers and make imports explicit `67626b4` - [Tony Arnold](mailto:tony@thecocoabots.com)
* Remove shorthand generation script `1c0cf24` - [Tony Arnold](mailto:tony@thecocoabots.com)

## Version 2.2
* Updated examples and fixed errors in README - [Tony Arnold](mailto:tony@thecocoabots.com)
* Changes block saves to use child context of rootSavingContext so that large saves do not channel through the default context and block the main thread - r-peck
* Using contextDidSave notifications to perform merges - r-peck
* Included CoreDataRecipies sample application updated to use Magical Record - [Saul Mora](mailto:saul@magicalpanda.com)

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
>>>>>>> release/2.1.0
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
