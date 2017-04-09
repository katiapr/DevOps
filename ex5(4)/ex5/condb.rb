def connect_db
                # set the ip address to the DB server IP
                $db = Mysql2::Client.new(:host => "localhost", :username => "root",
				:password =>"1Qwertyuiop-",:database =>"students")
			
end

connect_db()