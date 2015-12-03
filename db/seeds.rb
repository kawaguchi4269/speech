require_relative '../config/init'
%w(foo bar baz qux).each do |name|
  Employee.create(name: name)
end
