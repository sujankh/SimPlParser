#!/usr/bin/ruby

require_relative '../parser'
require_relative  './dumblexer'
require_relative '../parseError'
require "test/unit"

#Dummy methods that the parser calls to get the tokens

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

class TestParser < Test::Unit::TestCase

  def test_correctProgram
    lex("
id := int ;
id := int ;
id := int ;

while id < id do
id := id + int ;
id := id + id ;
end ; eof
")
    assert_nothing_raised(ParseError){parseStatements()}    
  end

  def test_invalidProgram
    lex("
while id - do
 id = int ;
end
")
    assert_raise(ParseError){parseStatements()}    
  end

  def test_allStatements
    lex("
id := int + int - ( int + id ) ;
if not true and id <= int then
   while id < int do
     if true and false then
       id := int * int ;
     else
       id := ( int + int ) - id ;
     end ;
   end ;
else
   id := id ;
end ; eof
")
    assert_nothing_raised(ParseError){parseStatements()}        
  end
  
  def test_parseStatements
  lex("id := int ; id := int - int ; eof")
  assert_nothing_raised(ParseError){parseStatements()}
  end

  def test_Assign1
    lex("id := ( int + int )")
    assert_nothing_raised(ParseError){parseAssignStatement()}
  end

  def test_Assign2
    lex("id := int + int")
    assert_nothing_raised(ParseError){parseAssignStatement()}
  end

  def test_Assign3
    lex("id := ( int + int")
    assert_raise(ParseError){parseAssignStatement()}
  end

  def test_addop1
    lex("int * int + int")
    assert_nothing_raised(ParseError){parseAddOp()}
  end

  def test_addop2
    lex("int / int + id")
    assert_nothing_raised(ParseError){parseAddOp()}
  end

  def test_addop3
    lex("int + ")
    assert_raise(ParseError){parseAddOp()}
  end

  def test_addop4
    lex("int")
    assert_nothing_raised(ParseError){parseAddOp()}
  end

  def test_addop5
    lex("id")
    assert_nothing_raised(ParseError){parseAddOp()}
  end

  def test_mulop1
    lex("int * int / ( int + int )")
    assert_nothing_raised(ParseError){parseAddOp()}
  end

  def test_mulop2
    lex("id * id / ( id + id )")
    assert_nothing_raised(ParseError){parseAddOp()}
  end

  def test_mulop3
    lex("id * / ( id + id )")
    assert_raise(ParseError){parseAddOp()}
  end
  
  def test_parseFactor1
    lex("int")
    assert_nothing_raised(ParseError){parseFactor()}
  end

  def test_parseFactor2
    lex("id")
    assert_nothing_raised(ParseError){parseFactor()}
  end

  def test_parseFactor3
    lex("int + int")
    assert_nothing_raised(ParseError){parseFactor()}
  end

  def test_if1
    lex(
      "if true then 
         id := int ; 
         id := int + int ; 
       else 
         id := int - int ;
       end
       ")
    assert_nothing_raised(ParseError){parseIfStatement()}
  end

  def test_if2
    lex(
      "if true then
         if false then 
           id := int ;
         else
           id := int - int ;
         end ;
       else 
         id := int - int ;
       end
       ")
    assert_nothing_raised(ParseError){parseIfStatement()}
  end

  #should have ; and eof
  def test_ifStatement
    lex(
      "if true then
         if false then 
           id := int ;
         else
           id := int - int ;
         end ;
       else 
         id := int - int ;
       end ; eof
       ")
    assert_nothing_raised(ParseError){parseStatements()}
  end

  
  def test_parseStatements1
    lex("
id := int ;
if false then id := int / int ; else id := int ; end ;
id := id / id ;
eof
")
    assert_nothing_raised(ParseError){parseStatements()}
  end

   #no semi colons
  def test_parseStatements2
    lex("
id := int ;
if false then id := int / int ; else id := int ; end ;
id := id / id 
eof
")
    assert_raise(ParseError){parseStatements()}
  end

  #------------------LEXPR TEST----------------------------#

  def test_parseLexpr_true
    lex("true");
    assert_nothing_raised(ParseError){parseLexpr()}
  end

  def test_parseLexpr_false
    lex("false");
    assert_nothing_raised(ParseError){parseLexpr()}
  end

  def test_parseLexpr_trueandfalse
    lex("true and false");
    
    assert_nothing_raised(ParseError){parseLexpr()}
  end

  def test_parseLexpr_nottrueandfalse
    lex("not true and false");
    assert_nothing_raised(ParseError){parseLexpr()}
  end

  def test_parseLexpr_manycases
    lex("not true and true and false and id <= int and int < id and not int = int and not id = id");
    assert_nothing_raised(ParseError){parseLexpr()}
  end
  
  def test_relop_le
    lex("( int - int ) <= ( int + id )")
    assert_nothing_raised(ParseError){parseRelOp()}

    lex("( int - int ) <= ( int + id )")
    assert_nothing_raised(ParseError){parseLexpr()}
  end

  def test_relop_lt
    lex("( int - int ) < int + id - int * id / int")
    assert_nothing_raised(ParseError){parseRelOp()}

    lex("( int - int ) < int + id - int * id / int")
    assert_nothing_raised(ParseError){parseLexpr()}
  end

  def test_relop_eq
    lex("id  = ( int + id )")
    assert_nothing_raised(ParseError){parseRelOp()}

    lex("not id  = ( int + id )")
    assert_nothing_raised(ParseError){parseLexpr()}
  end
  #------------------LEXPR TESTS END----------------------------#


  #---------------WHILE LOOP TESTS--------------------#

  def test_while_1
    lex("while id < id do
id := id + id ;
id := id ;
id := id + int ;
end
");

    assert_nothing_raised(ParseError){parseWhileLoop()}
  end


  def test_while_negative
    lex("while id < id
id := id + id ;
id := id ;
id := id + int ;
end
");
    assert_raise(ParseError){parseWhileLoop()}
  end

  #---------------WHILE LOOP TESTS--------------------#
end
