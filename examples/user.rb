require 'pry'
require '../lib/base'

class User < AR::Base
  attr_accessor :name, :email
  self.yaml_file = '../fixtures/users'
end

binding.pry

User.all
User.create name: 'Francisco Martins', email: 'franciscomxs@gmail.com'
User.create name: 'Bruce Wayne', email: 'batman@justiceleague.com'

User.find_by name: 'Bruce Wayne', email: 'batman@justiceleague.com' # Ok
User.find_by name: 'Bruce Wayne' # Ok
User.find_by name: 'Bruce' # No record
User.all
