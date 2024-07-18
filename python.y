%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "python.tab.h"

extern FILE *yyin;
extern int yylex(void);
void yyerror(const char *s);
%}

%union {
    char *str;
}

%token<str> ABREP FECHAP ID STR NUM FIM_ENTRADA DOISP WHILE DO SWITCH CASE DEFAULT DIFERENTEIGUAL IGUALIGUAL IGUAL MAIS MENOS VEZES IDENTA FIM_DE_LINHA DIVIDIR

%type<str> COMANDOS COMANDO FUNCAO LOOP CONDICIONAL EXPRESSAO ATRIBUICAO VALOR COMPARACAO

%start COMANDOS

%%

// Regra de comandos
COMANDOS: COMANDO COMANDOS
         | FIM_ENTRADA {return 0;}
         ;

COMANDO: FUNCAO
       | LOOP
       | CONDICIONAL
       | ATRIBUICAO { printf("%s", $1); }
       | EXPRESSAO { printf("%s", $1); }
       ;

// Definições de FUNCAO, LOOP, CONDICIONAL, EXPRESSAO, e ATRIBUICAO
FUNCAO: ID ABREP VALOR FECHAP FIM_DE_LINHA {
            $$ = malloc (1000);
            printf("int %s(int %s);\n", $1, $3);
        }
      | ID ABREP FECHAP FIM_DE_LINHA {
            $$ = malloc (1000);
            printf("int %s();\n", $1);
        }
      ;

LOOP: DO ABREP VALOR COMPARACAO VALOR FECHAP DOISP FIM_DE_LINHA IDENTA
            ID IGUAL NUM MAIS NUM FIM_DE_LINHA  {
                $$ = malloc (1000);
                printf("do {\nint %s=%s+%s} while (%s %s %s);\n", $10,$12,$14, $3, $4, $5);
            }
     |DO ABREP VALOR COMPARACAO VALOR FECHAP DOISP FIM_DE_LINHA IDENTA
            ID IGUAL NUM VEZES NUM FIM_DE_LINHA  {
                $$ = malloc (1000);
                printf("do {\nint %s=%s*%s} while (%s %s %s);\n", $10,$12,$14, $3, $4, $5);
            }
     |DO ABREP VALOR COMPARACAO VALOR FECHAP DOISP FIM_DE_LINHA IDENTA
            ID IGUAL NUM MENOS NUM FIM_DE_LINHA  {
                $$ = malloc (1000);
                printf("do {\nint %s=%s-%s} while (%s %s %s);\n", $10,$12,$14, $3, $4, $5);
            } 
     |DO ABREP VALOR COMPARACAO VALOR FECHAP DOISP FIM_DE_LINHA IDENTA
            ID IGUAL NUM DIVIDIR NUM FIM_DE_LINHA  {
                $$ = malloc (1000);
                printf("do {\nint %s=%s/%s} while (%s %s %s);\n", $10,$12,$14, $3, $4, $5);
            }    
     | DO ABREP VALOR COMPARACAO VALOR FECHAP DOISP FIM_DE_LINHA IDENTA
            ATRIBUICAO {
                $$ = malloc (1000);
                printf("do {\n%s} while (%s %s %s);\n", $10, $3, $4, $5);
            }
     ;

CONDICIONAL: SWITCH ABREP VALOR FECHAP DOISP FIM_DE_LINHA IDENTA
                CASE VALOR DOISP FIM_DE_LINHA IDENTA IDENTA
                ID IGUAL NUM MAIS NUM FIM_DE_LINHA {
                    $$ = malloc (10000);
                    printf("switch (%s) {\ncase %s:\nint %s=%s+%s;\n}\n", $3, $9, $14,$15,$16);
                }
           |SWITCH ABREP VALOR FECHAP DOISP FIM_DE_LINHA IDENTA
                CASE VALOR DOISP FIM_DE_LINHA IDENTA IDENTA
                ID IGUAL NUM MENOS NUM FIM_DE_LINHA {
                    $$ = malloc (10000);
                    printf("switch (%s) {\ncase %s:\nint %s=%s-%s;\n}\n", $3, $9, $14,$15,$16);
                }
           |SWITCH ABREP VALOR FECHAP DOISP FIM_DE_LINHA IDENTA
                CASE VALOR DOISP FIM_DE_LINHA IDENTA IDENTA
                ID IGUAL NUM VEZES NUM FIM_DE_LINHA {
                    $$ = malloc (10000);
                    printf("switch (%s) {\ncase %s:\nint %s=%s*%s;\n}\n", $3, $9, $14,$15,$16);
                }
            |SWITCH ABREP VALOR FECHAP DOISP FIM_DE_LINHA IDENTA
                CASE VALOR DOISP FIM_DE_LINHA IDENTA IDENTA
                ID IGUAL NUM DIVIDIR NUM FIM_DE_LINHA {
                    $$ = malloc (10000);
                    printf("switch (%s) {\ncase %s:\nint %s=%s/%s;\n}\n", $3, $9, $14,$15,$16);
                }

           | SWITCH ABREP VALOR FECHAP DOISP FIM_DE_LINHA IDENTA
                CASE VALOR DOISP FIM_DE_LINHA IDENTA
                ATRIBUICAO {
                    $$ = malloc (10000);
                    printf("switch (%s) {\n%s    case %s:\n%s\n}\n", $3, $6, $5, $13);
                }
           | SWITCH ABREP VALOR FECHAP DOISP FIM_DE_LINHA IDENTA
                DEFAULT DOISP FIM_DE_LINHA IDENTA
                EXPRESSAO {
                    $$ = malloc (1000);
                    printf("switch (%s) {\n%s    default:\n%s}\n", $3, $6, $12);
                }
           | SWITCH ABREP VALOR FECHAP DOISP FIM_DE_LINHA IDENTA
                DEFAULT DOISP FIM_DE_LINHA IDENTA
                ATRIBUICAO {
                    $$ = malloc (1000);
                    printf("switch (%s) {\n%s    default:\n%s}\n", $3, $6, $12);
                }
           ;

EXPRESSAO: ID IGUAL NUM MAIS NUM FIM_DE_LINHA {
                $$ = malloc (1000);
                printf("int %s = %s + %s;\n", $1, $3, $5);
            }
         | ID IGUAL NUM MENOS NUM FIM_DE_LINHA {
                $$ = malloc (1000);
                printf("int %s = %s - %s;\n", $1, $3, $5);
            }
         | ID IGUAL NUM VEZES NUM FIM_DE_LINHA {
                $$ = malloc (1000);
                printf("int %s = %s * %s;\n", $1, $3, $5);
            }
         | ID IGUAL NUM DIVIDIR NUM FIM_DE_LINHA {
                $$ = malloc (1000);
                printf("int %s = %s / %s;\n", $1, $3, $5);
            }
         ;

ATRIBUICAO: ID IGUAL NUM FIM_DE_LINHA {
	        $$ = malloc (1000);
                printf("int %s = %s;\n", $1, $3);
            }
          | ID IGUAL STR FIM_DE_LINHA {
                $$ = malloc (1000);
                printf("char %s[] = %s;\n", $1, $3);
            }
          ;

VALOR: ID { $$ = $1; }
      | STR { $$ = $1; }
      | NUM { $$ = $1; }
      ;

COMPARACAO: IGUALIGUAL { $$ = "==";}
	| DIFERENTEIGUAL { $$ = "!=";};
	
%%
int main(int argc, char **argv) {
    if (argc != 2) {
        printf("Modo de uso: ./transpilador arquivo.print\n");
        return 1;
    }

    FILE *arquivo = fopen(argv[1], "r");
    if (!arquivo) {
        printf("Arquivo %s não encontrado!\n", argv[1]);
        return 1;
    }

    yyin = arquivo;
    yyparse();

    fclose(arquivo);
    return 0;
}

extern int linenum;
void yyerror(const char *s) {
    fprintf(stderr, "Erro: %s\n", s);
}

