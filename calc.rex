class Calc
macro
  WHITESPACE \s+
  ID [\d+[\.(\d+)]?]
rule
  {WHITESPACE}
  {ID} { [:ID, text.to_f] }
  \* { [:AST, ''] }
  \+ { [:PLS, ''] }
  \( { [:L_PAREN, ''] }
  \) { [:R_PAREN, ''] }
inner
end
