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
  inputFile = ARGV[0]
  
  begin    
    $tokenizer.readFile(inputFile)
    nextToken() #initialize the lexer to put the cursor to current token
    
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
