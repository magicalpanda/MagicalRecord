# ![Awesome](https://github.com/magicalpanda/magicalpanda.github.com/blob/master/images/awesome_logo_small.png?raw=true) MagicalRecord

[![Circle CI](https://circleci.com/gh/magicalpanda/MagicalRecord/tree/develop.svg?style=svg)](https://circleci.com/gh/magicalpanda/MagicalRecord/tree/develop)

In software engineering, the active record pattern is a design pattern found in software that stores its data in relational databases. It was named by Martin Fowler in his book Patterns of Enterprise Application Architecture. The interface to such an object would include functions such as Insert, Update, and Delete, plus properties that correspond more-or-less directly to the columns in the underlying database table.

>	Active record is an approach to accessing data in a database. A database table or view is wrapped into a class; thus an object instance is tied to a single row in the table. After creation of an object, a new row is added to the table upon save. Any object loaded gets its information from the database; when an object is updated, the corresponding row in the table is also updated. The	wrapper class implements accessor methods or properties for each column in the table or view.

>	*- [Wikipedia](https://en.wikipedia.org/wiki/Active_record_pattern)*

MagicalRecord was inspired by the ease of Ruby on Rails' Active Record fetching. The goals of this code are:

* Clean up my Core Data related code
* Allow for clear, simple, one-line fetches
* Still allow the modification of the NSFetchRequest when request optimizations are needed

## Status of the project

This project's activity has stopped, superseded by Core Data itself. Our latest versions available are:

- MagicalRecord 2.4.0, a stable version, available from tag '2.4.0' or `pod 'MagicalRecord', :git => 'https://github.com/magicalpanda/MagicalRecord'`.
- MagicalRecord 3.0.0, an experimental version, available in two flavors, one is branch `release/3.0` and the other is branch `maintenance/3.0`.

## Documentation

- [Installation](Docs/Installing-MagicalRecord.md)
- [Getting Started](Docs/Getting-Started.md)
- [Working with Managed Object Contexts](Docs/Working-with-Managed-Object-Contexts.md)
- [Creating Entities](Docs/Creating-Entities.md)
- [Deleting Entities](Docs/Deleting-Entities.md)
- [Fetching Entities](Docs/Fetching-Entities.md)
- [Saving Entities](Docs/Saving-Entities.md)
- [Importing Data](Docs/Importing-Data.md)
- [Logging](Docs/Logging.md)
* [Other Resources](Docs/Other-Resources.md)

## Support

This project's activity has stopped. MagicalRecord is provided as-is, free of charge. For support, you have a few choices:

- Ask your support question on [Stack Overflow](https://stackoverflow.com), and tag your question with **MagicalRecord**.
- If you believe you have found a bug in MagicalRecord, please submit a support ticket on the [GitHub Issues page for MagicalRecord](https://github.com/magicalpanda/magicalrecord/issues) or a pull request. Please do **NOT** ask general questions on the issue tracker. Support questions will be closed unanswered.
- For more personal or immediate support, [MagicalPanda](http://magicalpanda.com/) is available for hire to consult on your project.
