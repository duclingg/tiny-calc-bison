%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tiny-calc.h"
%}

digit [0-9]
integer {digit}+
float {integer}\.{integer}|{integer}\.|\.[0-9]+
number {integer}|{float}
identifier [a-zA-Z][a-zA-Z0-9]*
ws [ \t]+
nl \n


%%
{number} {
    yylval.dval = atof(yytext);
    return NUMBER;
}

{identifier} {
    yylval.sval = strdup(yytext);
    return IDENTIFIER;
}

"=" { return ASSIGN; }
"+" { return PLUS; }
"-" { return MINUS; }
"*" { return MULTIPLY; }
"/" { return DIVIDE; }
"^" { return POWER; }
"(" { return LPAREN; }
")" { return RPAREN; }

{ws} { } /* ignore whitespace */

{nl} { return EOL; }

"//".*  { /* ignore comments */ }

. { return INVALID; }

%%

int yywrap() { return 1; }