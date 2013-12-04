require 'temping'
require 'database_cached_attribute'

ActiveRecord::Base.establish_connection("sqlite3:///:memory:")

Temping.create :no_include_class do
  with_columns do |t|
    t.string :string_attribute
    t.integer :integer_attribute
  end
end
Temping.create :include_class do
  include DatabaseCachedAttribute
  database_cached_attribute :string_attribute
  database_cached_attribute :integer_attribute

  with_columns do |t|
    t.string :string_attribute
    t.integer :integer_attribute
  end
end

describe DatabaseCachedAttribute do
  # JUST INCLUDED TESTS
  context "included" do
    before do
      @test_obj = IncludeClass.new
    end

    it "creates functions for invalidating cache" do
      expect(@test_obj.respond_to? :invalidate_cache).to eq(true)
    end

    it "creates functions for saving cache" do
      expect(@test_obj.respond_to? :update_cache)
    end

    it "using database_cached_attribute in the model adds nice functions to invalidate cache" do
      expect(@test_obj.respond_to? :invalidate_string_attribute).to eq(true)
      expect(@test_obj.respond_to? :invalidate_integer_attribute).to eq(true)
      expect(@test_obj.respond_to? :invalidate_non_attribute).to eq(false)
    end

    it "using database_cached_attribute in the model adds nice functions to save caches" do
      expect(@test_obj.respond_to? :cache_string_attribute).to eq(true)
      expect(@test_obj.respond_to? :cache_integer_attribute).to eq(true)
      expect(@test_obj.respond_to? :cache_non_attribute).to eq(false)
    end
  end

  # NEW OBJECT TESTS
  context "new objects not yet saved" do
    before(:each) do
      @test_obj = IncludeClass.new
      @test_obj.string_attribute = "original string"
      expect(@test_obj.new_record?).to eq(true)
      expect(@test_obj.persisted?).to eq(false)
    end

    it "does not persist cache updates" do
      @test_obj.cache_string_attribute
      @test_obj.string_attribute = "new string"
      @test_obj.cache_string_attribute
      expect(@test_obj.new_record?).to eq(true)
      expect(@test_obj.persisted?).to eq(false)
    end

    it "does not persist cache invalidations" do
      @test_obj.invalidate_string_attribute
      @test_obj.string_attribute = "new string"
      @test_obj.invalidate_string_attribute
      expect(@test_obj.new_record?).to eq(true)
      expect(@test_obj.persisted?).to eq(false)
    end

    it "using .invalidate_attribute_name does change the data" do
      expect(@test_obj.string_attribute).to eq("original string")
      @test_obj.invalidate_string_attribute
      expect(@test_obj.string_attribute).to eq(nil)
    end

    it "using .cache_attribute_name does not change the data" do
      expect(@test_obj.string_attribute).to eq("original string")
      @test_obj.cache_string_attribute
      expect(@test_obj.string_attribute).to eq("original string")
    end
  end

  # SAVED OBJECT TESTS
  context "objects persisted in the database" do
    before(:each) do
      @test_obj = IncludeClass.new
      @test_obj.string_attribute = "original string"
      @test_obj.save
      expect(@test_obj.new_record?).to eq(false)
      expect(@test_obj.persisted?).to eq(true)
    end

    it "persists a cache invalidation" do
      expect(@test_obj.string_attribute).to eq("original string")
      @test_obj.invalidate_string_attribute
      expect(@test_obj.string_attribute).to eq(nil)
      @compare_obj = IncludeClass.last
      expect(@compare_obj.id).to eq(@test_obj.id)
      expect(@compare_obj.string_attribute).to eq(nil)
    end
  end
  
end