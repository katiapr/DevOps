#Katia Prigon
#322088154
#ex1
##################################################
puts "\n***********************************\n"
puts "* Welcome to JCE registration site *\n"
puts "***********************************\n"

##################################################
def register_func()
 
  flag = true
  puts "Please enter your email\n"
  string = gets.chomp
  check_template = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]{2,}\z/
  email = check_template.match(string)
  unless email  
    puts "There was no match of your email" 
    flag = false
  end  
  if(flag == true)
    puts "\nPlease enter your password\n"
    string = gets.chomp
    check_template = /[a-zA-Z0-9_~!@$%^&*()]{6,}/
    password = check_template.match(string)
    unless email  
      puts "There was no match of your password" 
      flag = fase
    end  
  end
  if(flag == true)
    puts "\nYour input is valid\nTank you\n"
   else puts "Start again one of your data is wrong" 
  end
  
end
##################################################
def choice_handle(choice)
  #SWITCH-CASE
  case choice
  when 1
    puts "Login!"
  when 2
    puts "Register new"
    register_func
  when 3
   puts 'Recover Password'
  when 4
    puts "Remove me"
  when 5
    puts "Show all"
  when 6
    puts "Quit!"
end

end
######################################################


while (true)
choice = 0
while choice < 1 or choice > 6 do
  puts "Please enter your choice\n"
  puts "1. Login\n
2. Register new\n
3. Recover Password\n
4. Remove me\n
5. Show all\n
6. Quit\n"
printf "Your choice:"
  choice = gets.chomp.to_i
end
choice_handle(choice)

end




