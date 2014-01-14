# ![Awesome](https://github.com/magicalpanda/magicalpanda.github.com/blob/master/images/awesome_logo_small.png?raw=true) MagicalRecord

In software engineering, the active record pattern is a design pattern found in software that stores its data in relational databases. It was named by Martin Fowler in his book Patterns of Enterprise Application Architecture. The interface to such an object would include functions such as Insert, Update, and Delete, plus properties that correspond more-or-less directly to the columns in the underlying database table.

>	Active record is an approach to accessing data in a database. A database table or view is wrapped into a class; thus an object instance is tied to a single row in the table. After creation of an object, a new row is added to the table upon save. Any object loaded gets its information from the database; when an object is updated, the corresponding row in the table is also updated. The	wrapper class implements accessor methods or properties for each column in the table or view.

>	*- [Wikipedia]("http://en.wikipedia.org/wiki/Active_record_pattern")*

MagicalRecord was inspired by the ease of Ruby on Rails' Active Record fetching. The goals of this code are:

* Clean up my Core Data related code
* Allow for clear, simple, one-line fetches
* Still allow the modification of the NSFetchRequest when request optimizations are needed

# Cabbiepete Fork

This fork was created so that I can install MagicalRecord using
[Cocoapods](http://cocoapods.org) the pod spec on cocoapods is still
currently pointing to the official MagicalRecord repo but I get an error
when building with that one about the ddLogLevel const. The
MagicalRecord guys assure me there is a good fix in the next major
release for MagicalRecord (3.0) but its not out yet.

My pod file reads like this for including my fork.

```
pod 'MagicalRecord', :git => 'https://github.com/cabbiepete/MagicalRecord.git'
```
