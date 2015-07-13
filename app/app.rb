require 'sinatra/base'
require 'sinatra/flash'

class Chitter < Sinatra::Base

  enable :sessions
  register Sinatra::Flash
  set :session_secret, 'super secret'

  get '/' do
    erb :'users/welcome_page'
  end

  post '/user' do
    session[:user] = params[:username]
    @current_user = session[:user]
    erb :'users/user'
  end

  get '/user' do
    @current_user = session[:user]
    erb :'users/user'
  end

  post '/sign_up' do
    erb :'users/sign_up'
  end

  post '/user/new' do
    @user = User.create(name: params[:name],
                        email: params[:email],
                        username: params[:username],
                        password: params[:password],
                        password_confirmation: params[:password_confirmation])
    if @user.save
      session[:user] = @user.username
      @current_user = session[:user]
      redirect to('/user')
    else
      flash.now[:errors] = @user.errors.full_messages
      erb :'users/user' 
    end

    erb :'users/user'
  end
end
