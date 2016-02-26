#!/usr/bin/ruby

require_relative './lexer'
require_relative './parser'

def getTokenKind()
  $tokenizer.getTokenKind()
end

def getTokenText()
  $tokenizer.getTokenText()
end

#consume token
def nextToken()
  $tokenizer.nextToken()
end

def parseProgram()
  begin
    $tokenizer.readFile("simpl1.txt")
    nextToken()
    
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
$tokenizer = Tokenizer.new
parseProgram()
