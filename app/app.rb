require 'sinatra/base'
require 'sinatra/flash'
require_relative 'data_mapper_setup'

class Chitter < Sinatra::Base

  enable :sessions
  register Sinatra::Flash
  set :session_secret, 'super secret'

  get '/' do
    if session[:user]
      @current_user = session[:user]
    end
    if params[:New_Peep]
      Peep.create(message: params[:New_Peep])
      @peep = Peep.all
    end
    erb :'users/welcome_page'
  end

  post '/user' do
    user = User.authenticate(params[:username], params[:password])
    if user
      session[:user] = params[:username]
      @current_user = session[:user]
      erb :'users/homepage'
    else
      flash.now[:errors] = ['Unknown username or incorrect password']
      erb :'users/welcome_page'
    end
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
      redirect to('/')
    else
      flash.now[:errors] = @user.errors.full_messages
      erb :'users/sign_up'
    end
  end

  get '/user/delete' do
  if session[:user]
    session.delete(:user)
  end
  erb :'users/delete'
  end


end
