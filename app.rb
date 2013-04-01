require 'sinatra'
require 'json'
require 'strscan'

get '/' do
  {ruby_version: RUBY_VERSION, author: 'Tatsuhiro Ujihisa'}.inspect
end

Node = Struct.new(:type, :value)
def lex(str)
  s = StringScanner.new(str)
  memo = []
  until s.eos?
    case
    when x = s.scan(/\d+/)
      memo << Node.new(:id, x.to_i)
    when x = s.scan(/\(/)
      memo << Node.new(:l_paren)
    when x = s.scan(/\)/)
      memo << Node.new(:r_paren)
    when x = s.scan(/\+/)
      memo << Node.new(:pls)
    when x = s.scan(/\*/)
      memo << Node.new(:ast)
    when x = s.scan(/\s+/)
      memo << Node.new(:whitespace)
    else
      warn "must not happen: #{s}"
    end
  end
  memo
end

post '/' do
  #content_type :text
  json = JSON.parse(request.body.string)
  json["events"].map {|e|
    text = e["message"]["text"]
    if /\A[\d(].*[\d)]\z/m =~ text
      lex(text).reject {|s| s.type == :whitespace }.inspect
    else
      ''
    end
  }.join
end
