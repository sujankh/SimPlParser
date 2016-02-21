#!/usr/bin/ruby

require './parser.rb'
require './dumblexer.rb'
require './parseError.rb'
require "test/unit"

class TestParser < Test::Unit::TestCase

  def test_beginParse
  lex("id = int ; eof")
  assert_nothing_raised(ParseError){beginParse()}
  end

  def test_Assign1
    lex("id = ( int + int )")
    assert_nothing_raised(ParseError){parseAssignStatement()}
  end

  def test_Assign2
    lex("id = int + int")
    assert_nothing_raised(ParseError){parseAssignStatement()}
  end

  def test_Assign3
    lex("id = ( int + int")
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

  def test_mulop2
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
end
