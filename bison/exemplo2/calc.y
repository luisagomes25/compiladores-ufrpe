%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

int  yylex(void);
void yyerror(const char *s);
extern FILE *yyin;

struct Var {
    char *name;
    double val;
    struct Var *next;
};

struct Var *vars_head = NULL;
struct Var *vars_tail = NULL;

void set_var(char *name, double val) {
    struct Var *curr = vars_head;
    while (curr) {
        if (strcmp(curr->name, name) == 0) {
            curr->val = val;
            free(name);
            return;
        }
        curr = curr->next;
    }
    struct Var *new_var = (struct Var*) malloc(sizeof(struct Var));
    new_var->name = name;
    new_var->val = val;
    new_var->next = NULL;
    if (vars_tail) {
        vars_tail->next = new_var;
        vars_tail = new_var;
    } else {
        vars_head = vars_tail = new_var;
    }
}

double get_var(char *name) {
    struct Var *curr = vars_head;
    while (curr) {
        if (strcmp(curr->name, name) == 0) {
            double v = curr->val;
            free(name);
            return v;
        }
        curr = curr->next;
    }
    free(name);
    return 0.0;
}

void print_vars() {
    struct Var *curr = vars_head;
    while (curr) {
        printf("%s >>> %g\n", curr->name, curr->val);
        curr = curr->next;
    }
}
%}

%union {
    double val;
    char *str;
}

%token <val> NUM
%token <str> VAR
%token MAIS MENOS VEZES DIVISAO ABRE_PAREN FECHA_PAREN POT ATRIB PRINT_VARS

%type  <val> expr

%left  MAIS MENOS
%left  VEZES DIVISAO
%right POT
%right UMENOS

%%
entrada : 
        | entrada comando '\n'
        | entrada '\n'
        | entrada error '\n' { yyerrok; }
        ;

comando : expr                       { printf("= %g\n", $1); }
        | VAR ATRIB expr             { set_var($1, $3); }
        | PRINT_VARS                 { print_vars(); }
        ;

expr : NUM                          { $$ = $1;          }
     | VAR                          { $$ = get_var($1); }
     | expr MAIS expr               { $$ = $1 + $3;     }
     | expr MENOS expr              { $$ = $1 - $3;     }
     | expr VEZES expr              { $$ = $1 * $3;     }
     | expr DIVISAO expr            { $$ = $1 / $3;     }
     | expr POT expr                { $$ = pow($1, $3); }
     | MENOS expr %prec UMENOS      { $$ = -$2;         }
     | ABRE_PAREN expr FECHA_PAREN  { $$ = $2;          }
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