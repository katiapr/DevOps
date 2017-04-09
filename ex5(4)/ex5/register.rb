#Author: Katia Prigon
#Date:10/12/16
#DevOPs - ex5 

require 'sinatra'
require 'rubygems'
require 'mysql2'
require 'erb'
require './User'
require './condb'

set :port, 8080
set :views, "views"

get '/' do
    erb :select 
end



get '/login' do
	'<!DOCTYPE html>
<html>
    <head>
        <title>JCE Registration Site</title>
    </head>
<body>
<form method="post" action="/login">
    <input  name="_email" value="email">
    <input  name="_passwd" value="password">
    <input class="btn btn-primary" type="submit" value="Login">
</form>
</body>
</html>'

end

post '/login' do
mess = login_handle(params[:_email], params[:_passwd])
  erb:messages , :locals => {:message => mess}

end

get '/register' do
'<html>
    <head>
        <title>JCE Registration Site</title>
    </head><body>
<form method="post" action="/register">
<input  name="_name" value="Name">
    <input  name="_email" value="Email">
    <input  name="_passwd" value="Password">
	'+show_hints_questions+
	'<input name ="_answer" type="textbox">
	 <input class="btn btn-primary" type="submit" value="Register">
</form>
</body>
</html>'
end

post '/register' do

@rs_hints = $db.query("SELECT * FROM hints")
@rs_users = $db.query("SELECT * FROM users")
mess = register_handle(params[:_name],params[:_email],params[:_passwd],params[:hintID],params[:_answer])
erb:messages , :locals => {:message => mess}
end

get '/remove' do
	'<html>
    <head>
        <title>JCE Registration Site</title>
    </head>
<body>
<form method="post" action="/remove">
    <input  name="_email" value="Email">
    <input  name="_passwd" value="Password">
	<input class="btn btn-primary" type="submit" value="Remove me">
</form></body>
</html>'
#show_hints_questions()
end

post '/remove' do

@rs_hints = $db.query("SELECT * FROM hints")
@rs_users = $db.query("SELECT * FROM users")
mess = remove_me_handle(params[:_email], params[:_passwd])
erb:messages , :locals => {:message => mess}
end

get '/recover' do
'<html>
    <head>
        <title>JCE Registration Site</title>
    </head><body>
<form method="post" action="/recover">
    <input  name="_email" value="Email">
	'+show_hints_questions+
	'<input name ="_answer" type="textbox">
	 <input class="btn btn-primary" type="submit" value="Recover">
</form>
</body>
</html>'
end

post '/recover' do

@rs_hints = $db.query("SELECT * FROM hints")
@rs_users = $db.query("SELECT * FROM users")
'<html>
    <head>
        <title>JCE Registration Site</title>
    </head><body>
	Your password is : ' +recover_password_handle(params[:_email], params[:hintID],params[:_answer])+
	'</body>
</html>'

end

get '/showall' do
    @rs_hints = $db.query("SELECT * FROM hints")
    @rs_users = $db.query("SELECT * FROM users")
	user_array_init()
	show_all_handle()
end



get '/quit' do
	 Process.kill  'TERM',  Process.pid
end




#----------------- Register -------------------------------------#
def register_handle(_name,_eml,_passwd,hintID,_answer)	
  _flag = true
  loop do
      _flag = true
      #reg. exp. check - email template
      _check_template = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]{2,}\z/
      @_email = _check_template.match(_eml)
	 
      unless @_email  
        return "Wrong email" 
        _flag = false
      end  
      if(_flag == true)
        #reg. exp. check - password template
        _check_template = /[a-zA-Z0-9_~!@$%^&*()]{6,}/
        @_password = _check_template.match(_passwd)
        unless @_password  
			return "Your password's template is wrong!"
          _flag = false
        end  
      end
  break if _flag == true
  end
  #all checks alright
  if(_flag == true)   
    _exist = $db.query("SELECT * FROM students.users WHERE email = '#{@_email}'")
    #if not exist in the collection
    if(_exist.count == 0)
        #write_to_DB
      $db.query("INSERT INTO users(name,email,passwd,hintID,hintAnswer)
        VALUES('#{_name}','#{@_email}','#{@_password}',#{hintID},'#{_answer}');")
           
        return "       Registered successfully
		                  Thank you"
   else return "This user is already exist!"
   end
  else return "Start again one of your data is wrong" 
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


def show_hints_questions()
	@rs_hints = $db.query("SELECT * FROM hints")
    @rs_users = $db.query("SELECT * FROM users")
	str = "<select name='hintID'>"
	@rs_hints.each do |hint|
		str<<  " <option value='#{hint['id']}'> #{hint['hint']} </option>"
	end
	str << "</select></body></html>"
	return str
end
#-------------- Recover-Password --------------#
def recover_password_handle(_email,hintID,_answer)
	user = $db.query("SELECT * FROM `students`.`users`
	WHERE email = '#{_email}' AND hintID = #{hintID} AND hintAnswer = '#{_answer}';")
	if user.count == 1
		user.each do |u|
			return "#{u['passwd']}"
		end
	else return "One of your insertions was wrong"
	end
end
#--------------- Remove -----------------------#
def remove_me_handle(_email,_passwd)
  $db.query("DELETE FROM `students`.`users`
  WHERE email = '#{_email}' AND passwd = '#{_passwd}';")
  _user = $db.query("SELECT * FROM `students`.`users` WHERE email = '#{_email}';")
  if(_user.count == 0)
    return "Deletion successful"
  else return "There is no user like that"
  end
end
##------------- Show all -----------------------##
def show_all_handle ()
  @str="<!DOCTYPE html>
<html>
    <head>
        <title>JCE Registration Site</title>
    </head>
<body>
JCE Registration 
<p>
<table>
"
@str << "<tr>
    <th>Name</th>
    <th>Email</th>
	<th>Password</th>
	<th>HintID</th>
	<th>Answer</th>
  </tr>"	
  
  @collection.each do |col|
  @str<< "<tr>"
	@str << col.print_data() 
  @str << "</tr>"
  end
  @str << " </table> 
  </body>
</html>"
  return @str
end

##------------- Login -----------------------##
def login_handle(_email,_passwd)
 
  count = 0
  while count < 3 do
    count+=1
   _user = $db.query("SELECT * FROM users WHERE email = '#{_email}';")
    if _user.count == 1
		_user.each do |user|
			@user_obj = User.new(user['name'],user['email'], user['passwd'], user['hintID'], user['hintAnswer'])
		end
		if @user_obj.match_passwd(_passwd)
		return "\t\tHello #{@user_obj.name}, Wellcome to JCE site"
       
		else return  "Wrong password"
		end
   else return "Wrong email"
   end
  end
end

