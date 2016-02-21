#!/usr/bin/ruby

require './parser.rb'
require './dumblexer.rb'

lex("id = int ; eof")
beginParse()

#Test parseAssignStatement

lex("id = ( int + int )")
parseAssignStatement()

lex("id = int + int")
parseAssignStatement()

