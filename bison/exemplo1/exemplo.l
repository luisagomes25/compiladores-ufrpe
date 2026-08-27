%{
#include "exemplo.tab.h"
#include <stdlib.h>
%}

%option noyywrap

%%
"+"         {return SOMA;}
"-"         {return MENOS;}
[0-9]+      { yylval = atoi(yytext); return NUM; }
[ \t]+      { }
\n          { return PULAR_LINHA; }
.           { return yytext[0]; }
%%
