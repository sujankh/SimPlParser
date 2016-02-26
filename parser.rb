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

    nextToken() #consume EOF
    puts "End Of File"
    puts "Successful parse."
  rescue ParseError => e
    puts "Syntax error:"
    puts e.message
    #puts e.backtrace.inspect
  end
end

# <stmts> ::= <stmt> ;
# 	| <stmt> ; <stmts>

#Continue parsing statements until an endToken is found
#by default the endToken is EOF

def parseStatements(endToken = Token::T_EOF)
  parseStatement()
  check(Token::T_SEMICOLON, "Statement should end with semi-colon")

  #This will loop until we reach the end of the block
  if getTokenKind == endToken
    return
  end
  
  parseStatements(endToken)
end

def parseStatement()
  if getTokenKind == Token::T_IDENT
    parseAssignStatement()  
  elsif getTokenKind == Token::T_IF
    parseIfStatement()
  elsif getTokenKind == Token::T_WHILE
    parseWhileLoop()
  else
    parse_error_value("A statement begins with IDENTIFIER, IF or WHILE")
  end
end

def parseAssignStatement()
  parseIdentifier()
  check(Token::T_ASN, "Identifier should be followed by a equals sign")
  parseAddOp()
end

#if <lexpr> then <stmts> else <stmts> end
def parseIfStatement()
  check(Token::T_IF, "Expected IF")
  parseLexpr()
  check(Token::T_THEN, "Expected THEN")
  parseStatements(Token::T_ELSE)
  check(Token::T_ELSE, "Expected ELSE")
  parseStatements(Token::T_END)
  check(Token::T_END, "Expected END")
end

#while <lexpr> do <stmts> end
def parseWhileLoop()
  check(Token::T_WHILE, "Expected WHILE")
  parseLexpr()
  check(Token::T_DO, "Expected DO after lexpr")
  parseStatements(Token::T_END)
  check(Token::T_END, "Expected END at the end of while loop")
end

# <lexpr>::= <lterm> and <lexpr>
#            | <lterm>
def parseLexpr()
  parseLterm()

  if getTokenKind == Token::T_AND
    nextToken() #consume and
    
    parseLexpr()
  end
end

# <lterm> ::= not <lfactor>
#          | <lfactor>
def parseLterm()
  
  #accept the not keyword
  if getTokenKind == Token::T_NOT
    nextToken()
  end
  
  parseLfactor()
end

# <lfactor>:= true
#            | false
# 	     | <relop>
def parseLfactor()
  if getTokenKind == Token::T_BOOLEAN
    nextToken()
  else    
    parseRelOp()
  end
end

# <relop> ::= <addop> <= <addop>
#          | <addop> < <addop>
#          | <addop> = <addop>
def parseRelOp()
  parseAddOp()
  #now check if the next token is <=, < or =
  check(Token::T_RELOP, "Expected a relational operator")
  parseAddOp()
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

# <factor> ::= integer
# 	| identifier
# 	| ( <addop> )
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
