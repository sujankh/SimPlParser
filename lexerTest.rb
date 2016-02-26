#!/usr/bin/ruby

require './parser.rb'
require './dumblexer.rb'
require './parseError.rb'
require './newLexer.rb'
require './tokens.rb'


lexer = Tokenizer.new
lexer.readFile("simpl1.txt")
lexer.nextToken();
c= 0
while lexer.getTokenId() != Token::T_EOF
  puts lexer.getTokenId()
  lexer.nextToken()
end
    
  