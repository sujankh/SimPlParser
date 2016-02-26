class TokenVal
	attr_accessor :id, :text
	
	def initialize()
		@id = -1
		@text = ""
	end
end

class Tokenizer
  attr_reader :curr_token

  def initialize()
    @seek_ptr = 0
    @len = 0
    @curr_token = TokenVal.new
    @fileBuf = Array.new
  end

  def readFile(fileName)
    file = File.open(fileName, 'r')
    #Step through the file for each char
    while !file.eof && (cchar = file.readchar)
      @fileBuf.push(cchar)
    end
    @len = @fileBuf.size
    # get the first token
    #nextToken()
  end
  
	# jump to next line
  def move_to_next_line()
    while @seek_ptr < @len && @fileBuf.at(@seek_ptr) != "\n"
      @seek_ptr = @seek_ptr + 1
    end
  end
	
	# get the id of the next token
	def getTokenId()
		return @curr_token.id
	end
	
	# get the text of the token
	def getTokenText()
		return @curr_token.text
	end
	
	def createTok(tokenId, tokenText)
		@curr_token.id = tokenId
		@curr_token.text = tokenText
	end
	
	def nextToken()
		curr_state = -1
		if (@seek_ptr > @len)
			createTok(Token::T_EOF, "eof")
      return;
		else
			temp = String.new
			# read in the first character
			newChar = @fileBuf.at(@seek_ptr)
			@seek_ptr = @seek_ptr + 1
			# check for space, new line
			while newChar == " " || newChar == "\n" || newChar == "\r"
				newChar = @fileBuf.at(@seek_ptr)
        @seek_ptr = @seek_ptr + 1
      end
			# check if first char is letter, number or a symbol
			if newChar =~ /[A-Za-z]/
				curr_state = Token::T_IDENT
			elsif newChar =~ /[0-9]+/
				curr_state = Token::T_INTEGER
			else
				curr_state = -1
			end
			# if a symbol then need to check if valid symbol
			if curr_state == -1
				if (newChar + @fileBuf.at(@seek_ptr)) == ":="
					curr_state = Token::T_ASN
					createTok(curr_state, newChar+@fileBuf.at(@seek_ptr))
					@seek_ptr = @seek_ptr + 1
				elsif (newChar + @fileBuf.at(@seek_ptr)) == "<="
					curr_state = Token::T_RELOP
					createTok(curr_state, newChar+@fileBuf.at(@seek_ptr))
					@seek_ptr = @seek_ptr + 1
				elsif (newChar + @fileBuf.at(@seek_ptr)) == "//"
					move_to_next_line()
					nextToken()
				elsif newChar == "+" || newChar == "-"
					curr_state = Token::T_ADDOP
					createTok(curr_state, newChar)
				elsif newChar == "*" || newChar == "/"
					curr_state = Token::T_MULOP
					createTok(curr_state, newChar)
				elsif (newChar == "<" &&  @fileBuf.at(@seek_ptr) != "=") || newChar == "="
					curr_state = Token::T_RELOP
					createTok(curr_state, newChar)
				elsif newChar == "(" 
					curr_state = Token::T_LEFT_PAREN
					createTok(curr_state, newChar)
				elsif newChar == ")"
					curr_state = Token::T_RIGHT_PAREN
					createTok(curr_state, newChar)
				elsif newChar == ";"
					curr_state = Token::T_SEMICOLON
					createTok(curr_state, newChar)
				else
					if curr_state == -1
					  parse_error_value("Unidentified symbol, quitting" + newChar, newChar)
          end
				end
			# if it is a number or integer value
			elsif curr_state == Token::T_INTEGER
				temp = temp + newChar
				while (@seek_ptr < @len)			
					newChar = @fileBuf.at(@seek_ptr)
					if newChar =~ /[0-9]/
						temp = temp + newChar
						@seek_ptr = @seek_ptr + 1
					else
						createTok(curr_state, temp)
						return nil
					end
				end
			# it must be an identifier or variable name
			else
				#temp = temp + newChar
        while @seek_ptr <= @len 
          if newChar =~ /[A-Za-z0-9_]/
            temp = temp + newChar
            newChar = @fileBuf.at(@seek_ptr)
            @seek_ptr = @seek_ptr + 1
          else
            @seek_ptr = @seek_ptr - 1
            break
          end
        end
				if temp == "if"
					curr_state = Token::T_IF
				elsif temp == "then"
					curr_state = Token::T_THEN
				elsif temp == "else"
					curr_state = Token::T_ELSE
        elsif temp == "while"
				  curr_state = Token::T_WHILE
        elsif temp == "do"
					curr_state = Token::T_DO
				elsif temp == "end"
					curr_state = Token::T_END
				elsif temp == "true"
					curr_state = Token::T_BOOLEAN
				elsif temp == "false"
					curr_state = Token::T_BOOLEAN
				elsif temp == "and"
					curr_state = Token::T_AND
				elsif temp == "not"
					curr_state = Token::T_NOT
				else
					curr_state = Token::T_IDENT
				end
				createTok(curr_state, temp)
        puts temp
			end
		end
	end
	
	
	def parse_error_value(message, newChar)
		message = message + "\nUnexpected Value: " + "%s" % newChar

		parse_error(message)
	end

	def parse_error(message)
		raise ParseError, message
	end
end
	
	
	