DatabaseCachedAttribute
=========================
[![Code Climate](https://codeclimate.com/github/twohlix/database_cached_attribute.png)](https://codeclimate.com/github/twohlix/database_cached_attribute)
[![Build Status](https://travis-ci.org/twohlix/database_cached_attribute.png?branch=master)](https://travis-ci.org/twohlix/database_cached_attribute)
[![Gem Version](https://badge.fury.io/rb/database_cached_attribute.png)](http://badge.fury.io/rb/database_cached_attribute)

Description
------------------------
Ruby gem that adds simple functions to invalidate single columns as a cache on an ActiveRecord models.

Using DatabaseCachedAttribute
-----------------------------
DatabaseCachedAttribute is an ActiveSupport Concern and creates 1 set of helpers on inclusion and another on a different usage.

```
 gem install database_cached_attribute
```

```ruby
class YourFunClass < ActiveRecord::Base
  include DatabaseCachedAttribute
  
  database_cached_attribute :your_column
end
```
That will create a few functions for your model such as:
```ruby
your_obj = YourFunClass.new
your_obj.invalidate_your_column #invalidates and persists the change to the db if appropriate
your_obj.cache_your_column      #attempts to save your cache change to the db if appropriate
your_obj.only_your_column_changed? #tells you if your objects only change is that column
```
These helpers let you do nice things in your model like:
```ruby
class YourFunClass < ActiveRecord::Base
  include DatabaseCachedAttribute
  database_cached_attribute :your_column

  has_many :other_things, before_add: :invalidate_your_column
end
```
