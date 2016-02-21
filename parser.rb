#getTokenKind - returns symbol for next seqToken
require './tokens.rb'

#peek at the next token
def getTokenKind()
  $tokens.at(0)
end

def getTokenText()
  $tokens.at(0)
end

#consume token
def nextToken()
  $tokens.shift
  #print $tokens
end

def beginParse()
begin
  loop do
    parseStatements()    
    if getTokenKind == Token::T_EOF      
      puts "End of file"
      nextToken() #consume EOF
      break
    end
  end
  puts "Successful parsing"
rescue Exception => e
  puts "Syntax error:"
  puts e.message
  #puts e.backtrace.inspect
end
end

def parseStatements()
  parseStatement()
  if getTokenKind != Token::T_SEMICOLON
    parse_error_value("Statement should end with semi-colon")
  end
  nextToken() #consume the semicolon
end

def parseStatement()
  if getTokenKind == Token::T_IDENT
    parseAssignStatement()  
  elsif getTokenKind == Token::T_IF
    parseIfStatement()
  elsif getTokenKind == Token::T_WHILE
  else
    parse_error_value("A statement begins with IDENTIFIER, IF or WHILE")
  end
end

def parseAssignStatement()
  parseIdentifier()

  if getTokenKind != Token::T_EQUAL
    parse_error_value("Identifier should be followed by a equals sign")
  end
  nextToken() #Consume the T_EQUAL token
    
  parseAddOp()
end

def parseIdentifier()
  if getTokenKind == Token::T_IDENT
    nextToken() #consume the identifier
  else
    parse_error_value("Invalid value for an identifier")
  end
end

def parseAddOp()
  parseMulOp()
  if getTokenKind == Token::T_PLUS or getTokenKind == Token::T_MINUS
    nextToken() #consume the token
    parseAddOp()
  end
end

def parseMulOp()
  parseFactor()

  if getTokenKind == Token::T_MULT or getTokenKind == Token::T_DIVIDE
    nextToken() #consume the * or / token
    parseMulOp()
  end  
end

def parseFactor()
  if getTokenKind == Token::T_INTEGER || getTokenKind == Token::T_IDENT
    nextToken()
  elsif getTokenKind == Token::T_LEFT_PAREN
    nextToken() #consume (
    parseAddOp()

    if nextToken != Token::T_RIGHT_PAREN
      parse_error_value("Expected a parenthesis.")
    end

    nextToken() #consume )
  else
    parse_error_value("Invalid value for a factor")
  end
end

def parse_error_value(message)
  message = message + "\nUnexpected Value: " + "%s" % getTokenText()

  parse_error(message)
end

def parse_error(message)
  puts message
  raise message
end
  
#beginParse()
