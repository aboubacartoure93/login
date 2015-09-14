require 'sinatra'
require 'sinatra/activerecord'
require 'bundler/setup'
require 'rack-flash'
require './models'

configure(:development) { set :database, "sqlite3:login.sqlite3" }
set :sessions, true
use Rack::Flash, sweep: true

def current_user
	if session[:user_id]
		User.find(session[:user_id])
	else
		nil
	end
end

get '/' do
	@users = User.all
	erb :index
end

get '/profile' do
	@user = current_user
	erb :show
end

get '/profile/edit' do
	@user = current_user
	erb :edit
end

post '/profile/edit' do
	current_user.update(params[:user])
	flash[:notice] = "Profile was successfully updated, bruh."
	redirect to '/'
end
# kfhdlsjl;whlgask;lkh abou test /delete/editlgfljhslj;lksljkjlf;hiewk



get '/tweet' do
	@user = current_user
	erb :tweet
	# redirect to '/profile'
end

post '/show' do
	current_user.update(params[:user])
	flash[:notice] = "you tweet, bruh."
	redirect to '/tweet'
end




#khd;gdnlskhljtlhkldg;kl ABOU FIN DE TEST geKGFDLGJLJHKGJKLK


post '/delete' do
	current_user.destroy
	flash[:notice] = "Profile was successfully deleted, bruh."
	session[:user_id] = nil

  	erb :delete 
end

get '/follow/:id' do
	@relationship = Relationship.create(follower_id: current_user.id, 
																			followed_id: params[:id])
	flash[:notice] = "Followed!"
	redirect to '/'
end

get '/unfollow/:id' do
	@relationship = Relationship.find_by(follower_id: current_user.id,
											 followed_id: params[:id])
	@relationship.destroy
	flash[:notice] = "Unfollowed!"
	redirect to '/'
end

get '/users/:id' do
	begin
		@user = User.find(params[:id])
		erb :show
	rescue
		flash[:notice] = "That user does not exist."
		redirect to "/"
	end
end

get '/signup' do
	erb :signup
end

post '/signup' do
	user = User.create(params[:user])
	session[:user_id] = user.id
	redirect to '/welcome'
end

get '/login' do
	erb :login
end

get '/logout' do
	session[:user_id] = nil
	flash[:notice] = "Logged out!"
	redirect to '/login'
end

post '/sessions' do
	user = User.find_by(email: params[:email])
	if user and user.password == params["password"]
		session[:user_id] = user.id
		flash[:notice] = "Logged in!"
		redirect to '/welcome'
	else
		flash[:notice] = "There was a problem logging in!"
		redirect to '/login'
	end
end

get '/welcome' do
	@user = current_user
	erb :welcome
end