class Calc
macro
  WHITESPACE \s+
  ID \d+
rule
  {WHITESPACE}
  {ID} { [:ID, /\./ =~ text ? text.to_f : text.to_i] }
  \* { [:AST, ''] }
  \+ { [:PLS, ''] }
  \( { [:L_PAREN, ''] }
  \) { [:R_PAREN, ''] }
inner
end
