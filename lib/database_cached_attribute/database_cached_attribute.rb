require 'active_support/concern'

# CachedAttribute adds a method to add a set of easy to use cache invalidation 
# methods/callbacks for specified attributes
# 
# On the model where you possibly may want to cache things from this model that may
# be heavy to create:
#   include CachedAttribute
#   cached_attribute :attribute_name, :another_attribute_name
# This will create the methods
#   invalidate_attribute_name(optional_object)
#   invalidate_another_attribute_name(optional_object)
#   cache_attribute_name(optional_object)
#   cache_another_attribute_name(optional_object)
# Which means invalidating that attribute is easy, say when you add an associated object
#   has_many :things, before_add: :invalidate_attribute, before_remove: :invalidate_other_attribute
#   
module CachedAttribute
  extend ActiveSupport::Concern

  included do
    # Cache invalidation by column
    def invalidate_cache (column_name)
      self[column_name] = nil
      update_cache column_name
    end

    # Update cache by column
    def update_cache (column_name)
      save if only_change? column_name && persisted?
    end
    
    # Determines if the provided column name is the only change
    def only_change? (column_name)
      changes.length == 1 && changes.has_key?(column_name)
    end

    # Determines if the provided column names are the only changes
    def only_changes? (*column_names)
      return false if changes.length != column_names.length

      column_names.each do |column_name|
        return false if !changes.has_key?(column_name)
      end

      true
    end

    # Determines if the changes, if any, are only in the list of column names provided
    def only_changes_in? (*column_names)
      return false if changes.length > column_names.length

      our_changes = changes.slice column_names
      return false if our_changes.length < changes.length

      true
    end
  end

  module ClassMethods
    # Sets up cache invalidation callbacks for the provided attributes
    def cached_attribute(*attrs)
      attrs.each do |attr|
        define_method("invalidate_#{attr}") do |arg=nil| # default arg to allow before_blah callbacks
          invalidate_cache attr.to_sym
        end

        define_method("only_#{attr}_changed?") do 
          only_change? attr.to_sym
        end

        define_method("cache_#{attr}") do
          update_cache attr.to_sym
        end
      end
    end
  end



end
