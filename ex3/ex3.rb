#Author: Katia Prigon
#ID: 322088154
#Date :22.11.16
#Notes: 1. using gem mysql2 instead of mysql
#       2. connection to MySQL DB
require 'rubygems'
require 'mysql2'
require './User'
#--------------------------------------------------------------------------------------#


#------------------- MySQL-Connection ---------------------------#
def mysql_connection()
begin
@db = Mysql2::Client.new(:host => "localhost", :username => "root", :password =>"1Qwertyuiop-",
:database =>"students")

@rs_hints = @db.query("SELECT * FROM hints")
@rs_users = @db.query("SELECT * FROM users")
end
end
#----------------- Register -------------------------------------#
def register_handle()
  _email = ""
  _password = ""
  _flag = true
  puts "Wellcome,\nPlease enter your name:"
  _name = gets.chomp
  loop do
      _flag = true
      puts "Please enter your email\n"
      _string = gets.chomp
      #reg. exp. check - email template
      _check_template = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]{2,}\z/
      _email = _check_template.match(_string)
      unless _email  
        puts "Wrong email" 
        _flag = false
      end  
      if(_flag == true)
        puts "\nPlease enter your password\n"
        _string = gets.chomp
        #reg. exp. check - password template
        _check_template = /[a-zA-Z0-9_~!@$%^&*()]{6,}/
        _password = _check_template.match(_string)
        unless _password  
          puts "Wrong password" 
          _flag = false
        end  
      end
  break if _flag == true
  end
  #all checks alright
  if(_flag == true)   
    _exist = @db.query("SELECT * FROM students.users WHERE email = '#{_email}'")
    #if not exist in the collection
    if(_exist.count == 0)
        puts "Choose your question"
        i = 1
        @rs_hints.each do |hint|
        puts "#{hint['id']} - #{hint['hint']}"  
        i+=1 
        end
        _question = gets.chomp.to_i
        puts "Your Answer:\n"
        _answer = gets.chomp
        #write_to_DB
      @db.query("INSERT INTO users(name,email,passwd,hintID,hintAnswer)
        VALUES('#{_name}','#{_email}','#{_password}',#{_question},'#{_answer}');")
           
        puts "\n\tRegistered successfully\n\tThank you\n\n\n"
   else puts "This user is already exist!"
   end
  else puts "Start again one of your data is wrong" 
  end
end
##---------------- Array init --------------------##
def user_array_init()
  @collection  = Array.new
  if @rs_users.count > 0
  @rs_users.each do |user|
  user_obj = User.new(user['name'], user['email'], user['passwd'], user['hintID'], user['hintAnswer'])
  @collection.push(user_obj)
  end
  end 
end

#-------------- Recover-Password --------------#
def recover_password_handle()
  puts"Please enter your email"
  _email = gets.chomp
  
  @rs_hints.each do |hint|
    puts "#{hint['id']} - #{hint['hint']}"
  end
  puts "Choose your question"
  _question = gets.chomp
  
  puts "Enter your answer"
  _answer = gets.chomp
  
  user = @db.query("SELECT * FROM `students`.`users`
WHERE email = '#{_email}' AND hintID = #{_question} AND hintAnswer = '#{_answer}';")
if user.count == 1
  puts "your password is:\n"
  user.each do |u|
    puts "#{u['passwd']}"
  end
else puts "One of your insertions was wrong"
end
end
#--------------- Remove -----------------------#
def remove_me_handle()
  puts "Please enter your email"
  _email = gets.chomp
  puts "Please enter your password"
  _passwd = gets.chomp
  
  @db.query("DELETE FROM `students`.`users`
  WHERE email = '#{_email}' AND passwd = '#{_passwd}';")
  _user = @db.query("SELECT * FROM `students`.`users` WHERE email = '#{_email}';")
  if(_user.count == 0)
    puts "Deletion successful"
  else puts "There is no user like that"
  end
end
##------------- Show all -----------------------##
def show_all_handle ()
  puts "-- Name ----------------- E-mail -------- Password --------- HintID -------------- Answer --\n"
  @collection.each do |col|
    col.print_data() 
    puts "\n"
  end
  puts "--------------------------------------------------------------------------------------------\n\n"
end

##------------- Login -----------------------##
def login_handle()
  count = 0
  while count < 3 do
    count+=1
    puts "Your email"
    _email = gets.chomp
    puts "Your password"
    _password = gets.chomp
    _user = @db.query("SELECT `users`.`name`,`users`.`email`,`users`.`passwd`,
    `users`.`hintID`,`users`.`hintAnswer`
    FROM `students`.`users`
    WHERE email = '#{_email}';")
  
    if _user.count == 1
    _user.each do |user|
        @user_obj = User.new(user['name'],user['email'], user['passwd'], user['hintID'], user['hintAnswer'])
      end
      
     if @user_obj.match_passwd(_password)
        puts "\t\tHello #{@user_obj.name}, Wellcome to JCE site"
        return
     else puts "Wrong password"
     end
    else puts "Wrong email"
    end
  end
end
  ##------------- Choice -----------------------##
  def choice_handle(_choice)
     #SWITCH-CASE
     case _choice
     when 1 then login_handle
     when 2 then register_handle
     when 3 then recover_password_handle
     when 4 then remove_me_handle
     when 5 then show_all_handle
     when 6 then 
       puts "Bye Bye!"
       exit
     end
  end
#--------------------------------------------------------------------------------------#

#--------------------------------------------------------------------------------------#

####-----------------------MAIN-----------------------####
puts "\n***********************************\n"
puts "* Welcome to JCE registration site *\n"
puts "***********************************\n"

mysql_connection()##connection to DB
user_array_init()##init Array with all users

while (true)##infinity loop for the main menu
  _choice = 0
  while _choice < 1 or _choice > 6 do
    puts "Please enter your choice\n"
    puts "1. Login\n
2. Register new\n
3. Recover Password\n
4. Remove me\n
5. Show all\n
6. Quit\n"
    puts  "Your choice:"
  _choice = gets.chomp.to_i
  end
choice_handle(_choice)
end
####-----------------------END-----------------------####

#--------------------------------------------------------------------------------------#
  
#--------------------------------------------------------------------------------------#