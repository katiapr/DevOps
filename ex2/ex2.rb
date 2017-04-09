
#Katia Prigon
#322088154
#ex2
#12/11/16
##################################################
def register_handle()
  _email = ""
  _password = ""
  _flag = true
  loop do
      _flag = true
      puts "Please enter your email\n"
      _string = gets.chomp
      _check_template = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]{2,}\z/
      _email = _check_template.match(_string)
      unless _email  
        puts "Wrong email" 
        _flag = false
      end  
      if(_flag == true)
        puts "\nPlease enter your password\n"
        _string = gets.chomp
        _check_template = /[a-zA-Z0-9_~!@$%^&*()]{6,}/
        _password = _check_template.match(_string)
        unless _password  
          puts "Wrong password" 
          _flag = false
        end  
      end
  break if _flag == true
  end
  if(_flag == true)   
    _exist = @collection.has_key? "#{_email}"
    #already exist in the collection
    if(_exist == false)
        puts "Choose your question"
        i = 1
        @hints.each do |hint|
        puts "#{i} - #{hint}"  
        i+=1 
        end
        _question = gets.chomp.to_i
        puts "Your Answer:\n"
        _answer = gets.chomp
        #write_to_file
        @studentsFile.puts("#{_email} #{_password} #{_question-1} #{_answer}")
        @collection.store("#{_email}","#{_password}")
        puts "\nYour input is valid\nTank you\n"
   else puts "This user is already exist!"
   end
  else puts "Start again one of your data is wrong" 
  end
end

def login_handle()
  count = 0
  while count < 3 do
    count+=1
    puts "Your email"
    _email = gets.chomp
    puts "Your password"
    _password = gets.chomp
    _temp = @collection["#{_email}"]
    if _temp == _password
        puts "Hello, Wellcome to JCE site"
        return
    else puts "Wrong password/email"
    end
  end
end


def choice_handle(_choice)
   #SWITCH-CASE
   case _choice
   when 1
    #Login
     login_handle
   when 2
  # puts "Register new"
     register_handle
   when 3
    puts "Recover Password"
   when 4
     puts "Remove me"
   when 5
     puts "Show all"
   when 6
     #Quit
     puts "Bye Bye!"
     exit
 end
 
 end
##################################################
####__MAIN__####
puts "\n***********************************\n"
puts "* Welcome to JCE registration site *\n"
puts "***********************************\n"

@hints = []
File.open("hints.txt").readlines.each do |hint|   
  @hints << hint
end
@collection  = Hash.new

@studentsFile = File.open("students.txt",'a+')
File.open("students.txt").readlines.each do |user| 
line = user.split(" ")
  @collection.store("#{line[0]}","#{line[1]}")
end

while (true)
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

 