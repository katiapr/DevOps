#Author: Katia Prigon
#ID: 322088154
#Date :22.11.16
#Notes: 1. using gem mysql2 instead of mysql
#       2. connection to MySQL DB
#------------------- Class : User ---------------------------#
class User
  attr_accessor :name, :email, :passwd, :hint, :hintAnswer

  def initialize(name, email, passwd, hint, hintAnswer)
    @name = name
    @email = email
    @passwd = passwd
    @hint = hint
    @hintAnswer = hintAnswer
  end
  
  def match_passwd(passwd)
    return @passwd == passwd
  end
  
  def print_data
   # printf("%-20s %-20s %-20s %-20s %-20s", @name, @email, @passwd, @hint, @hintAnswer)
   return "<td>#{@name}</td> <td>#{@email}</td> <td>#{@passwd}</td>  <td>#{@hint}</td>  <td>#{@hintAnswer}</td>"
  end
end