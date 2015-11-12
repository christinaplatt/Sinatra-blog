require 'sinatra'
require 'sinatra/activerecord'

configure(:development){set :database, "sqlite3:test_2.sqlite3"}
require './models'
require './blog'
set :sessions, true

get '/' do
	@user = User.new
	erb :home
end

post '/create_user' do 
	"My params are:" + params.inspect
	@user = User.create(params)
	session[:user_id] = @user.id
	redirect '/create_blog'
end

post '/sign-in' do
	 @user = User.where(email: params[:email]).first

	 if @user.password == params[:password]
	 	session[:user_id] = @user.id
	 	redirect '/create_blog'
	 else
	 	redirect '/home'
	 	puts "email or passowrd are incorrect"
	 end
end

get '/create_blog' do
	if session[:user_id] 
		erb :new
	else
		redirect '/'
	end
end

post '/create_blog' do
	if session[:user_id]
		Blog.create!(params)
		redirect '/blogs'
	else
		redirect '/'
	end
end

get '/blogs' do 
	if @user = User.find(session[:user_id])
	@blogs = Blog.all 
	erb :show
else
	redirect '/'
end
end

get '/sign-out' do
	session[:user_id] = nil
	redirect '/'
end

get '/profile' do
	 @user = User.find(session[:user_id])
	 erb :index
end

get '/destroy' do
	 @user = User.destroy(session[:user_id])
	redirect '/'
	erb :home

end

# get '/' do 
# 	puts "home"
# 	erb :home
# end
# post '/sign-in' do 
# 	{"username" => "tiabeanbart@gmail.com", "password"=>"password"}
# 	puts "my params are" + params.inspect
# end