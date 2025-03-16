%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <stdbool.h>

void yyerror(const char *s);
extern int yylex();
extern int yyparse();
extern FILE *yyin;

// variable storage
typedef struct {
    char* name;
    double value;
} variable;

variable vars[100];
int var_count = 0;
int calc_count = 0;

// function to find a variable by name
int find_variable(char* name) {
    for (int i = 0; i < var_count; i++) {
        if (strcmp(vars[i].name, name) == 0) {
            return i;
        }
    }
    return -1;
}

// function to add or update a variable
void set_variable(char* name, double value) {
    int index = find_variable(name);
    if (index >= 0) {
        vars[index].value = value;
    } else {
        vars[var_count].name = strdup(name);
        vars[var_count].value = value;
        var_count++;
    }
}

// function to get a variable's value
double get_variable(char* name) {
    int index = find_variable(name);
    if (index >= 0) {
        return vars[index].value;
    }
    yyerror("Variable not found!");
    return 0.0;
}

%}

%union {
    double dval;
    char* sval;
}

%token <dval> NUMBER
%token <sval> IDENTIFIER
%token PLUS MINUS MULTIPLY DIVIDE POWER LPAREN RPAREN ASSIGN
%token EOL INVALID

%type <dval> expr factor term power unary

/* define operator precedence, from lowest to highest */
%left PLUS MINUS
%left MULTIPLY DIVIDE
%right POWER
%right UMINUS UPLUS

%%

program:
    | program line
    ;

line: EOL 
    | expr EOL { 
        calc_count++;
        printf("[%d] =%g\n", calc_count, $1); 
    }
    | IDENTIFIER ASSIGN expr EOL {
        calc_count++;
        set_variable($1, $3);
        printf("[%d] Variable %s is assigned to %g\n", calc_count, $1, $3);
        free($1);
    }
    | IDENTIFIER EOL {
        calc_count++;
        int index = find_variable($1);
        if (index >= 0) {
            printf("[%d] =%g\n", calc_count, vars[index].value);
        } else {
            printf("[%d] Error: \"Variable, %s, not found!\" at calculation: %d\n", 
                   calc_count, $1, calc_count);
        }
        free($1);
    }
    | error EOL { 
        calc_count++;
        printf("[%d] Error: \"syntax error\" at calculation: %d\n", calc_count, calc_count); 
        yyerrok; 
    }
    ;

expr: term { $$ = $1; }
    | expr PLUS term { $$ = $1 + $3; }
    | expr MINUS term { $$ = $1 - $3; }
    ;

term: power { $$ = $1; }
    | term MULTIPLY power { $$ = $1 * $3; }
    | term DIVIDE power { 
        if ($3 == 0) {
            calc_count++;
            printf("[%d] Error: \"divide by zero !!\" at calculation: %d\n", 
                   calc_count, calc_count);
            $$ = 0;
            YYERROR;
        } else {
            $$ = $1 / $3;
        }
    }
    ;

power: unary { $$ = $1; }
    | power POWER unary { $$ = pow($1, $3); }
    ;

unary: factor { $$ = $1; }
    | MINUS unary %prec UMINUS { $$ = -$2; }
    | PLUS unary %prec UPLUS { $$ = $2; }
    ;

factor: NUMBER { $$ = $1; }
    | IDENTIFIER { 
        int index = find_variable($1);
        if (index >= 0) {
            $$ = vars[index].value;
        } else {
            printf("[%d] Error: \"Variable, %s, not found!\" at calculation: %d\n", 
                   calc_count, $1, calc_count);
            free($1);
            YYERROR;
        }
        free($1);
    }
    | LPAREN expr RPAREN { $$ = $2; }
    ;

%%

void yyerror(const char *s) {
    // error messages are handled in the grammar rules
}

int main() {
    printf("Enter Any Arithmetic expression.\n");
    yyparse();
    return 0;
}