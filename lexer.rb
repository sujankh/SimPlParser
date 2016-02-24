#!/usr/bin/ruby

require './tokens.rb'
$space = " "
$nochar = ""
$newline = "\n"
$start_tok = [":", "<", "/"]
$end_tok = ["=", ";", "(", ")", "+", "-", "*", "/", "<", ">"]
$token = Array.new

class Tokenizer
  attr_reader : curr_token_id

  def initialize()
    @seek_ptr = 0;
    @len = 0;
    @numToken = 0;
    @curr_token_id = 0;
    @fileBuffer = Array.new
    @partialToken = String.new
  end

  def readFile(fileName)
    file = File.open('code.txt', 'r');
    #Step through the file for each char
    while !file.eof && (cchar = file.readchar)
      @fileBuffer.push(cchar);
    end
    @len = @fileBuffer.size;
    # get a token
    newToken = formNextToken();
    # do while no more tokens can be formed
    until newToken.nil?
      if newToken == -1
        puts "Invalid token detected, exiting parser\n";
        return nil;
      end
      $tokens.push(newToken);
      @numToken = @numToken + 1;
      newToken = formNextToken();
    end
    # add EOF token
    $tokens.push(Tokens::T_EOF);
  end
  

  def move_to_next_line()
    while @seek_ptr < @len && @fileBuffer.at(@seek_ptr) != $newline
      @seek_ptr = @seek_ptr + 1;
    end
  end

  
  def formNextToken()
    temp = String.new;
    newTok = -1;
    while @seek_ptr < @len
      # read one character at a time
      readChar = @fileBuffer.at(@seek_ptr);
      # if blank, read in next character
      if readChar.eq? $space || readChar.eq? $nochar || readChar.eq? $newline
        if temp.empty?
          @seek_ptr = @seek_ptr + 1;
          continue;
        else
          newTok = match(temp);
          return newTok;
        end
      end
        
      # check for comment start
      if (readChar+@fileBuffer.at(@seek_ptr + 1)) == "//"
        # if comment is the beginning of the token ie space before comment
        if temp.empty?
          #move to next line
          move_to_next_line();
          continue;
        else
          newTok = match(temp);
          return newTok;
        end
      end

      #check for := or <=
      if (readChar + @fileBuffer.at(@seek_ptr + 1)) == ":="
        if temp.empty?
          @seek_ptr = @seek_ptr + 2;
          return Token::T_ASN;
        else
          newTok = match(temp);
          return newTok;
        end
      end
      if (readChar + @fileBuffer.at(@seek_ptr + 1)) == "<="                         
        if temp.empty?
          @seek_ptr = @seek_ptr + 2;
          return Token::T_RELOP;
        else
          newTok = match(temp);
          return newTok;
        end
      end                 
      
      if $end_tok.include?(readChar)
        if temp.empty?
          temp = readChar;
          newTok = match(temp);
          @seek_ptr = @seek_ptr + 1;
          return newTok;
        else
          newTok = match(temp);
          return newTok;
        end
      else
        temp = temp + readChar;
        @seek_ptr = @seek_ptr + 1;
      end
    end
    return nil;
  end

  def match(temp)
    
    if temp == "=" || temp == "<"
      return Token::T_RELOP;
    elsif temp == ";"
      return Token::T_SEMICOLON;
    elsif temp == "+" || temp == "-"
      return Token::T_ADDOP;
    elsif temp == "*" || temp == "/"
      return Token::T_MULOP;
    elsif temp == "("
      return Token::T_LEFT_PAREN;
    elsif temp == ")"
      return Token::T_RIGHT_PAREN;
    elsif temp == "if"
      return Token::T_IF;
    elsif temp == "then"
      return Token::T_THEN;
    elsif temp == "else"
      return Token::T_ELSE;
    elsif temp == "while"
      return Token::WHILE;
    elsif temp == "do"
      return Token::T_DO;
    elsif temp == "end"
      return Token::T_END;
    elsif temp == "and"
      return Token::T_AND;
    elsif temp == "not"
      return Token::T_NOT;
    elsif temp == "true" || temp == "false"
      return Token::T_BOOL
    elsif #match to regexp for identifier and regexp for integer
      
  end

end
# Returns symbol for the next sequential token                                       
def getTokenKind()                                                               
end

# Returns textual representation of a token
def getTokenText(tokens, tokenId)
  id = tokens.key(tokenId)
end

# Consumes next token
def nextToken()

end



# Step through each line in the file
#code.readlines.each do |line|
 # s = '';
  # Print every character
  #line.split('').each do |ch|
   # s = s+ch;
  #end
  #puts s+ "\n";
  #puts getTokenText(tokens, 101);
#end
