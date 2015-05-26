require File.expand_path '../../test_helper.rb', __FILE__

class Person < AR::Base
  attr_accessor :name
  self.yaml_file = 'fixtures/people.test'
end

class AR::BaseTest < Minitest::Test

  def setup
    path = './fixtures/people.test.yml'
    File.delete(path) if File.exist?(path)
  end

  def test_create
    batman = Person.create name: 'Bruce Wayne'
    refute_equal nil, batman.id
  end

  def test_all
    Person.create name: 'Bruce Wayne'
    assert_equal Array, Person.all.class
    assert_equal Person, Person.all.first.class
  end

  def test_find
    batman = Person.create name: 'Bruce Wayne'
    assert_equal 'Bruce Wayne', Person.find(batman.id).name
  end

  def test_where
    batman = Person.create name: 'Bruce Wayne'
    superman = Person.create name: 'Clark Kent'
    results = Person.where(name: 'Clark Kent')
    assert_equal Array, results.class
    assert_equal superman.id, results.first.id
  end

  def test_find_by
    batman = Person.create name: 'Bruce Wayne'
    assert_equal 'Bruce Wayne', Person.find_by(name: 'Bruce Wayne').name
  end

  def test_delete
    superman = Person.create name: 'Clark Kent'
    id = superman.id
    Person.delete(superman)
    assert_equal nil, Person.find(id)
  end

end
