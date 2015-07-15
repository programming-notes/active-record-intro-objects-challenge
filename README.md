#Active Record Intro:  Objects

## Summary
In this challenge, we're going to explore the instance methods available to instances of our Active Record models.  Up to this point, we've primarily been working with class methods for retrieving data from the database and writing data to the database.  We've only touched a couple of instance methods (e.g., `#save`).  In this challenge we'll take a look at what we can do with objects after we instantiate them.

```ruby
class Dog < ActiveRecord::Base
end
```

*Figure 1.*  Code for the class `Dog`.

We will be working primarily with a pre-written, empty `Dog` class (see Figure 1 and the file `app/models/dog.rb`).  There are no methods defined within the class itself.  The behaviors that we'll explore in this challenge are inherited through its parent class, `ActiveRecord::Base`.  


## Releases
### Pre-release: Setup
```
$ bundle install
$ bundle exec rake db:create
$ bundle exec rake db:migrate
$ bundle exec rake db:seed
```
*Figure 2*.  Setting up and seeding the database.

Before we begin inserting records into the database, we need to create our database. We'll seed it with a few records, too: three dogs and also a handful of ratings.  All the files necessary for this are provided:  the migrations and the seeds file.  We simply need to run the Rake tasks (see Figure 2).

```
bundle exec rake console
```
*Figure 3*.  Executing the Rake task to open IRB with our environment loaded.

We're going to work with our `Dog` class from within the Rake console.  Let's begin by opening the console (see Figure 3).  Once it's open, we can begin interacting with our models.  As we work through each release, we should execute the provided example code ourselves and look at the return values.


### Release 0: Dog Attributes
```ruby
Dog
```
*Figure 4*. Returning the `Dog` class.

Running the code in Figure 4 will return the `Dog` class itself, and we will see displayed in parentheses a list of attribute names and types that are associated with the class.  From where does Active Record build this list of attributes?

Active Record derives these attributes from the columns in the dogs table in our database.  Every column in the database is considered an attribute.  So, our dogs have a name attribute, a license attribute, a breed attribute, etc.  These attributes are similar to the instance variables that we assign to our plain Ruby objects.


### Release 1: Getter and Setter Methods
```ruby
class Book
  attr_accessor :title
  
  def initialize(args)
    @title = args[:title]
  end
end

book = Book.new(title: "The Cat in the Hat")
book.title
# => "The Cat in the Hat"
book.title = "Green Eggs and Ham"
# => "Green Eggs and Ham"
book.title
# => "Green Eggs and Ham"
```
*Figure 5*. A plain Ruby object with getter and setter methods for the title.

When we assign an instance variable in our plain Ruby objects, we often provide methods for getting the value of the instance variable and also setting the value of the instance variable (see Figure 5).  We might be more familiar with referring to these methods as reader and writer methods.

With an Active Record model, getter and setter methods are provided automatically.  There's no need to create them ourselves.  For every column in the database, Active Record provides getter and setter instance methods.

```ruby
tenley = Dog.find_by(name: "Tenley")
tenley.name
# => "Tenley"
tenley.breed
# => "Golden Doodle"
tenley.age
# => 1
tenley.age = 2
# => 2
tenley.age
# => 2
```
*Figure 6*. Using the getter and setter methods of an Active Record model.

In Figure 6, we're accessing the attributes of our Active Record `Dog` model; we get the values of the name, breed, and age attributes, and we set the value of the age attribute.  As stated earlier, Active Record provides us with getter and setter methods for all of the object's attributes.  Our `Dog` class is empty; we haven't defined any of these methods.

Going through Figure 6 in more detail, after we have our dog object assigned to the variable `tenley`, we're calling the `#name` instance method to *get* the value of the name attribute.  The value of the name attribute is returned:  the string `"Tenley"`.  As with the name attribute, we're also able to get the value of the breed and age attributes—and would be able to get the value of any other column in the database.

In addition to getter methods, we also get setter methods.  Given an instance of `Dog`, we can *set* the value of any of its attributes.  In this case, we're changing the age of our dog to 2.  And after setting the new age, when we again get the age, we see that Tenley's age is now 2.


### Release 2: Persisting Attribute Changes
```ruby
jayda = Dog.find_by(name: "Jayda")
jayda.age
# => 3
jayda.age = 4
# => 4
jayda.age
# => 4

Dog.find_by(name: "Jayda").age
# => 3
```
*Figure 7*.  Changing the age of a dog, but not updating the database.

In Figure 7, we retrieve the data for the dog named Jayda.  We then proceed to update the Jayda's age, increasing it from 3 to 4.  However, when we retrieve the data for Jayda from the database a second time, Jayda's age is still 3.

When we set an object's attributes using setter methods, those changes are only applied to the in-memory Ruby object.  Those changes are not automatically persisted in the database.


```ruby
jayda.save

Dog.find_by(name: "Jayda").age
# => 4
```
*Figure 8*.  Saving a dog to persist changes to its attributes.

If we want to persist our change to Jayda's age, we need to call the `#save` method on the dog object.

Because our `jayda` object already has an id, Active Record will not make an SQL `INSERT` query.  Instead, our call to `#save` will result in executing an `UPDATE` query like `UPDATE "dogs" SET "age" = ?, "updated_at" = ? WHERE "dogs"."id" = ?  [["age", 4], ["updated_at", "2015-07-15 18:57:41.762752"], ["id", 2]]`.
  
We've only changed the `age` attribute, but Active Record also updates the `updated_at` attribute.  Active Record will handle working with the `created_at` and `updated_at` fields on its own.  We don't need to worry about them.


### Release 3: Updating Multiple Attributes
```ruby
tenley = Dog.find_by(name: "Tenley")
tenley.age
# => 1
tenley.license
# => "OH-9384764"

tenley.assign_attributes(age: 3, license: "OH-1234567")

tenley.age
# => 3
tenley.license
# => "OH-1234567"
```
*Figure 9* Simultaneously updating a dog's age and license.

Sometimes we wan't to update multiple attributes at the same time.  If we wanted, we could use an object's individual setter methods one at a time.  However, Active Record provides methods for updating multiple attributes at one time (see Figure 9).

`#assign_attributes` and `#update_attributes` both allow us to update the values of multiple attributes at one time.  Can we guess the difference between them?  One of the methods persists changes to the database while the other only updates the attributes of the in-memory Ruby object.  Which one is which?
 

- `rabid_dog = Dog.create()`

  We now have a new instance of `Dog` and have assigned it to the variable `rabid_dog`.
  
- `rabid_dog.destroy`

  `#destroy` is an instance method that deletes a record from the database.  The SQL executed was `DELETE FROM "dogs" WHERE "dogs"."id" = ?  [["id", 4]]`.

### Release 2: Edit Records in `ratings` Table

We've been working with the `Dog` class.  For this challenge, the seeds file has also seeded the database with data in the `ratings` table.  The records in the table need to be edited.  Some tests have been provided to guide you through the process.  Working in the console, edit the records in the `ratings` table until all the tests pass.  Then, submit this challenge.

***Note:***  The tests provided to guide you through updating the records in the database are not tests that you would normally write.  They are written only to provide guidance for this challenge.  Don't mimic them.