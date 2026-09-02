%{
#include "calc.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%option noyywrap

%%
"variaveis"        { return PRINT_VARS;  }
[0-9]+(\.[0-9]+)?  { yylval.val = atof(yytext); return NUM; }
">>>"              { return ATRIB;       }
"**"               { return POT;         }
"+"                { return MAIS;        }
"-"                { return MENOS;       }
"*"                { return VEZES;       }
"/"                { return DIVISAO;     }
"("                { return ABRE_PAREN;  }
")"                { return FECHA_PAREN; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return VAR; }
[ \t]+             { }
\n                 { return '\n'; }
.                  { return yytext[0]; }
%%
