%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
void yyerror(const char *s);
extern FILE *yyin;

struct Var {
    char *name;
    struct Var *next;
};

struct Var *vars_head = NULL;
int count = 0;
char *current_type = NULL;

int is_declared(char *name) {
    struct Var *curr = vars_head;
    while (curr) {
        if (strcmp(curr->name, name) == 0) {
            return 1;
        }
        curr = curr->next;
    }
    return 0;
}

void declare_var(char *type, char *name) {
    if (is_declared(name)) {
        printf("erro: %s já foi declarada\n", name);
        free(name);
    } else {
        printf("%s %s\n", type, name);
        struct Var *new_var = (struct Var *)malloc(sizeof(struct Var));
        new_var->name = name;
        new_var->next = vars_head;
        vars_head = new_var;
        count++;
    }
}
%}

%union {
    char *str;
}

%token <str> TIPO ID
%token VIRGULA PONTO_VIRGULA

%%
programa: 
        | programa declaracao
        | programa error PONTO_VIRGULA { yyerrok; }
        ;

declaracao: TIPO { current_type = $1; } lista_ids PONTO_VIRGULA { free($1); current_type = NULL; }
          ;

lista_ids: ID { declare_var(current_type, $1); }
         | lista_ids VIRGULA ID { declare_var(current_type, $3); }
         ;

%%

void yyerror(const char *s)
{
    // Ignore error printing as per the assignment output style unless needed
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

    yyparse();
    
    printf("+++++ %d variáveis declaradas\n", count);
    
    return 0;
}
