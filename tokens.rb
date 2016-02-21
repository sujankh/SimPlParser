class Token
  T_EOF = 0
  T_SEMICOLON = 1
  T_IDENT = 2
  T_EQUAL = 3
  T_IF = 4
  T_THEN = 5
  T_ELSE = 6
  T_WHILE = 7
  T_DO = 8
  T_END = 9
  T_PLUS = 10
  T_MINUS = 11
  T_MULT = 12
  T_DIVIDE = 13
  T_INTEGER = 14
  T_LEFT_PAREN = 15
  T_RIGHT_PAREN = 16
end

$keywords = {
  "eof" => Token::T_EOF,
  ";" => Token::T_SEMICOLON,
  "id" => Token::T_IDENT,
  "=" => Token::T_EQUAL,
  "if" => Token::T_IF,
  "then" => Token::T_THEN,
  "else" => Token::T_ELSE,
  "while" => Token::T_WHILE,
  "do" => Token::T_DO,
  "end" => Token::T_END,
  "+" => Token::T_PLUS,
  "-" => Token::T_MINUS,
  "*" => Token::T_MULT,
  "/" => Token::T_DIVIDE,
  "int" => Token::T_INTEGER,
  "(" => Token::T_LEFT_PAREN,
  ")" =>Token::T_RIGHT_PAREN
}
