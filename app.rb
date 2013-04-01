require 'sinatra'
require 'json'
#require 'strscan'

get '/' do
  {ruby_version: RUBY_VERSION, author: 'Tatsuhiro Ujihisa'}.inspect
end

#Token = Struct.new(:type, :value)
#def lex(str)
#  s = StringScanner.new(str)
#  memo = []
#  until s.eos?
#    case
#    when x = s.scan(/\d+/)
#      memo << Token.new(:id, x.to_i)
#    when x = s.scan(/\(/)
#      memo << Token.new(:l_paren)
#    when x = s.scan(/\)/)
#      memo << Token.new(:r_paren)
#    when x = s.scan(/\+/)
#      memo << Token.new(:pls)
#    when x = s.scan(/\*/)
#      memo << Token.new(:ast)
#    when x = s.scan(/\s+/)
#      memo << Token.new(:whitespace)
#    else
#      warn "must not happen: #{s}"
#    end
#  end
#  memo
#end

#def parse(tokens)
#  # not implemented yet!
#  tokens = tokens.reject {|s| s.type == :whitespace }
#  tokens.map {|t| "#{t.type}(#{t.value})" }.join
#end

require './calc.tab'
def to_sexpstr(str)
  c = Calc.new
  begin
    c.scan_str(str)
  rescue ParseError
    ''
  end
end

post '/' do
  #content_type :text
  json = JSON.parse(request.body.string)
  json["events"].map {|e|
    text = e["message"]["text"]
    if /\A[\d(].*[\d)]\z/m =~ text
      val, str, memo = to_sexpstr(text)
      memo = memo.size < 10 ?
        memo :
        (memo.take(3) + ['...'] + memo.last(3))
      ([str] + memo).join "\n"
    else
      ''
    end
  }.join
end
