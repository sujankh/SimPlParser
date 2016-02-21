#!/usr/bin/ruby

require './parser.rb'
require './tokens.rb'


#id = int ;
$tokens =
  [
    Token::T_IDENT, Token::T_EQUAL, Token::T_INTEGER, Token::T_SEMICOLON,
    Token::T_EOF
  ]

# $tokens =
#   [
    
#   ]

beginParse()
