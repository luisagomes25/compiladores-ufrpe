%{
#include <stdio.h>

int  yylex(void);
void yyerror(const char *s);
extern FILE *yyin;
%}

%token NUM PULAR_LINHA SOMA MENOS

%%
entrada :
        | entrada listas PULAR_LINHA   { printf("soma = %d\n", $2); }
        ;
listas: lista {$$ = $1;}
        | listas lista {$$ = $1;}

lista : NUM            { $$ = $1;      }
      | NUM SOMA NUM      { $$ = $1 + $3; }
      | NUM MENOS NUM     {$$ = $1 - $3}
      ;


%%

void yyerror(const char *s)
{
    fprintf(stderr, "%s\n", s);
}

int main(int argc, char **argv)
{
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            perror("Erro ao abrir o arquivo");
            return 1;
        }
        yyin = file;
    }

    return yyparse();
}
