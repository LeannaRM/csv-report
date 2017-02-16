require 'sinatra'
require_relative "./classes/edit.rb"
require 'pry'

enable :sessions

get("/"){
	@user = session[:currentuser]
	erb :login
}

post("/login"){
	name = params["username"]
	password = params["password"]

	session[:currentuser] = name
	session[:userAccount] = AccountByTransaction.new
	session[:userAccount].setup(session[:currentuser]) #When this is included...
	binding.pry #session[:currentuser] and session[:userAccount] are as expected here
	redirect('/index')
}

get("/index") {
	binding.pry #session[:currentuser] and session[:userAccount] are nil
	@name = session[:currentuser]
	checkUsername(@name)
	erb :index
}