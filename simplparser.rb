#!/usr/bin/ruby

#require_relative './lexer'
require_relative './parser'

#TODO: create Tokenizer object

def getTokenKind()
  #TODO: call tokenizer method
end

def getTokenText()
  #TODO: call tokenizer method
end

#consume token
def nextToken()
  #TODO: call tokenizer method
end

def parseProgram()
  begin
    parseStatements()

    nextToken() #consume EOF
    puts "End Of File"
    puts "Successful parse."
  rescue ParseError => e
    puts "Syntax error:"
    puts e.message
  end
end

#start parser program
parseProgram()
