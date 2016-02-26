class Token
  T_EOF = 0
  T_SEMICOLON = 1
  T_IDENT = 2
  T_RELOP = 3
  T_IF = 4
  T_THEN = 5
  T_ELSE = 6
  T_WHILE = 7
  T_DO = 8
  T_END = 9
  T_ADDOP = 10
  T_MULOP = 11
  T_ASN = 12 #Assign
  T_NOT = 13
  T_INTEGER = 14
  T_LEFT_PAREN = 15
  T_RIGHT_PAREN = 16
  T_BOOLEAN = 17
  T_AND = 18
end

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
  ":=" => Token::T_ASN
}
