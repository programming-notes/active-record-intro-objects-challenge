#Active Record Intro:  Objects

## Summary

In this challenge, we'll continue working with our models in the console.  We'll begin to work with the instances of our classes created when we pull data from the database.

```ruby
class Dog < ActiveRecord::Base
end
```

*Figure 1.*  Code for `Dog` class.

We will once again work with a pre-written, empty `Dog` class.  The class is defined in the file `app/models/dog.rb`, whose code is shown in Figure 1.  Again, there are no methods defined within the class itself; however, by inheriting from `ActiveRecord::Base`, we have access to a number of instance methods.  We are going to explore some of those methods in this challenge.

## Releases

### Pre-release: Create, Migrate, and Seed the Database

1. Run Bundler to ensure that the proper gems have been installed.

2. Use the provided Rake task to create the database.

3. Use the provided Rake task to migrate the database.

4. Use the provided Rake task to seed the database.

### Release 0: Getter and Setter Methods

Use the provided Rake task to open the console:  `bundle exec rake console`.

From within the console run ...

-  `Dog`

  This will return the `Dog` class, and we will see in parentheses a list of attribute names and types that are associated with instances of `Dog`.   
  
  Active Record derives these attributes from the columns in the `dogs` table in our database.  And for every column in the database, Active Record provides getter and setter instance methods.


- `tenley = Dog.find_by(name: "Tenley")`

  We've now assigned the variable `tenley` the value of an instance of the `Dog` class.  We'll use `tenley` to explore the getter and setter methods.

- `tenley.name`

  As stated earlier, Active Record provides us with getter and setter methods for all of the object's attributes.  In this case, we're calling the `#name` instance method to *get* the value of the `name` attribute.  The value of the attribute is `"Tenley"`.

- `tenley.breed`

  As with the `name` attribute, we can also get the value of the `breed` attribute—and the value of any other column in the database.

- `tenley.age = 2`

  In addition to getter methods, we also get setter methods.  Given an instance of `Dog`, we can *set* the value of any of its attributes.  In this case, we're changing the age of the `tenley` object to `2`.

- `tenley`

  Inspecting the current status of the `tenley` object, we can see that its `age` is now `2`.

- `tenley = Dog.find_by(name: "Tenley")`

  Here we're reassigning the variable `tenley` the value of fresh database query.  You'll notice that the value of `age` is `1`.
  
  This is because we've only updated the Ruby object.  In order to have persisted the change in age to the database, we would have needed to call `#save` on the `tenley` object.

- `tenley.age = 2`

  Again, changing the value of the Ruby object's `age` attribute.

- `tenley.save`

  Attempting to update the record in the database.
  
  Because the `tenley` object already has an `id` set, Active Record will not make in SQL `INSERT` query.  Instead, it will make an `UPDATE` query:
  
  `UPDATE "dogs" SET "age" = ?, "updated_at" = ? WHERE "dogs"."id" = 1  [["age", 2], ["updated_at", "2014-09-08 20:26:06.781373"]]`
  
  We've only changed the `age` attribute, but Active Record also updates the `updated_at` attribute.  Active Record will handle working with the `created_at` and `updated_at` fields on its own.  We don't need to worry about them.

### Release 1: Updating and Deleting Methods

- `tenley.update_attributes(age: 3, license: "OH-9876543")`

  `#update_attributes` is an instance method that allows us to set multiple attributes at the same time.  The attributes are updated in the Ruby object and also saved to the database.  Take a look at the console output to see the SQL `UPDATE` query.
  
- `tenley`

  We can see that the `age` and `license` attributes have been updated in the Ruby object.

- `rabid_dog = Dog.create()`

  We now have a new instance of `Dog` and have assigned it to the variable `rabid_dog`.
  
- `rabid_dog.destroy`

  `#destroy` is an instance method that deletes a record from the database.  The SQL executed was `DELETE FROM "dogs" WHERE "dogs"."id" = ?  [["id", 4]]`.

### Release 2: Edit Records in `ratings` Table

We've been working with the `Dog` class.  For this challenge, the seeds file has also seeded the database with data in the `ratings` table.  The records in the table need to be edited.  Some tests have been provided to guide you through the process.  Working in the console, edit the records in the `ratings` table until all the tests pass.  Then, submit this challenge.