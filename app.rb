require 'sinatra'
require 'json'

get '/' do
  {ruby_version: RUBY_VERSION, author: 'Tatsuhiro Ujihisa'}.inspect
end

post '/' do
  #content_type :text
  json = JSON.parse(request.body.string)
  json["events"].map {|e|
    text = e["message"]["text"]
    if /\A[\d(].*[\d)]\z/m =~ text
      '(matched)'
    else
      ''
    end
  }.join
end
