#getTokenKind - returns symbol for next seqToken
require './tokens.rb'
require './parseError.rb'

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

def parseProgram()
  begin
    parseStatements()
    
    puts "Successful parse."
  rescue ParseError => e
    puts "Syntax error:"
    puts e.message
    #puts e.backtrace.inspect
  end
end

def parseStatements()
  parseStatement()
  check(Token::T_SEMICOLON, "Statement should end with semi-colon")

  if getTokenKind == Token::T_EOF      
    puts "End of file"
    nextToken() #consume EOF
    return; #done with parsing
  end

  if getTokenKind == Token::T_ELSE or getTokenKind == Token::T_END
    return
  end
  
  parseStatements()
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
  check(Token::T_ASN, "Identifier should be followed by a equals sign")
  parseAddOp()
end

def parseIfStatement()
  check(Token::T_IF, "Expected IF")
  parseLexpr()
  check(Token::T_THEN, "Expected THEN")
  parseStatements()
  check(Token::T_ELSE, "Expected ELSE")
  parseStatements()
  check(Token::T_END, "Expected END")
end

def parseLexpr()
  parseLterm() #todo
end

def parseLterm()
  parseLfactor() #todo
end

#todo
def parseLfactor()
  if getTokenKind == Token::T_BOOLEAN # || getTokenKind == Token::T_FALSE
    nextToken()
  end
end

def parseIdentifier()
  check(Token::T_IDENT, "Invalid value for an identifier")
end

def parseAddOp()
  parseMulOp()
  if getTokenKind == Token::T_ADDOP
    nextToken() #consume the token
    parseAddOp()
  end
end

def parseMulOp()
  parseFactor()

  if getTokenKind == Token::T_MULOP
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
    check(Token::T_RIGHT_PAREN, "Expected a parenthesis.")
  else
    parse_error_value("Invalid value for a factor")
  end
end

#Error Handling
def parse_error_value(message)
  message = message + "\nUnexpected Value: " + "%s" % getTokenText()

  parse_error(message)
end

def parse_error(message)
  raise ParseError, message
end

#check if the next token is same as the passed token
#if not an exception is raised with the provided message
def check(token, message)
  if getTokenKind != token
    parse_error_value(message)
  end
  nextToken() #consume the token
end
