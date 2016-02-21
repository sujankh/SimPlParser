require './tokens.rb'

#creates an array of Token values from the given program text
#stores the tokens in a $tokens global variable
def lex(programText)
  #replace all line endings by a space
  programText = programText.gsub("\n", " ")
  programTextArray = programText.split(" ")

  #return an array of Token s
  $tokens = programTextArray.collect { |x| $keywords[x] }  
end

