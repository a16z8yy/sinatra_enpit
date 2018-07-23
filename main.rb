require 'sinatra'

get "/" do
    erb :index
end

get '/login' do
    @uname = ""
    erb :login
end

post '/login' do
    @uname = params[:uname]
    if @uname == ""
        @uname = "Guest"
    else
        @uname = @uname.gsub(/</, "&lt")
        @uname = @uname.gsub(/>/, "&gt")
    end
    erb :message
end

@@msgSet = []
@@msgNumber = 0
@@messages = ""

get '/message' do
    erb :message
end

post '/message' do
    @msgTime = "#{(Time.now).strftime("%Y/%m%d %H:%M - ")}"
    @uname = params[:uname] + " san wrote:"
    @msgDes = params[:message]
    @msgDes = @msgDes.gsub(/</, "&lt")     	 # sunitize for XSS vulnerablity
    @msgDes = @msgDes.gsub(/>/, "&gt")
    @@msgNumber += 1
    @@msgSet << [ @@msgNumber, @msgTime, @uname, @msgDes]
    puts @@msgSet
    i = @@msgSet.length
    msg = "#{'(' + @@msgNumber.to_s + ') '}" 	# Add message number, prepare for delete message
    msg = msg + @@msgSet[i-1][1] + @@msgSet[i-1][2] + '<br>'
    @@messages = msg + @@msgSet[i-1][3] + '<hr>' + @@messages
    erb :message
end
