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
  before do
    @test_no_include = NoIncludeClass.new
    @test_include    = IncludeClass.new
  end

  it "being included in a class creates functions for invalidating cache" do
    expect(@test_include.respond_to? :invalidate_cache).to eq(true)
    expect(@test_no_include.respond_to? :invalidate_cache).to eq(false)
  end
  
end