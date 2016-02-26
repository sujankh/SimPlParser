require_relative '../tokens'

$keywords = {
  "eof" => Token::T_EOF,
  ";" => Token::T_SEMICOLON,
  "id" => Token::T_IDENT,
  "=" => Token::T_RELOP,
  "<" => Token::T_RELOP,
  "<=" => Token::T_RELOP,
  "if" => Token::T_IF,
  "then" => Token::T_THEN,
  "else" => Token::T_ELSE,
  "while" => Token::T_WHILE,
  "do" => Token::T_DO,
  "end" => Token::T_END,
  "+" => Token::T_ADDOP,
  "-" => Token::T_ADDOP,
  "*" => Token::T_MULOP,
  "/" => Token::T_MULOP,
  "int" => Token::T_INTEGER,
  "(" => Token::T_LEFT_PAREN,
  ")" =>Token::T_RIGHT_PAREN,
  "true" => Token::T_BOOLEAN,
  "false" => Token::T_BOOLEAN,
  ":=" => Token::T_ASN,
  "not" => Token::T_NOT,
  "and" => Token::T_AND
}

#creates an array of Token values from the given program text
#stores the tokens in a $tokens global variable
def lex(programText)
  #replace all line endings by a space
  programText = programText.gsub("\n", " ").downcase
  programTextArray = programText.split(" ")

  #return an array of Token s
  $tokens = programTextArray.collect { |x| $keywords[x] }  
end

