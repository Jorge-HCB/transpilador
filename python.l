%{
#include <string.h>
#include "python.tab.h"
void yyerror(const char* erro); // Declaração de yyerror
%}

%option noyywrap

DIGITO [0-9]
LETRA [a-zA-Z]
ESPACO [ ]
STRING \"[^"]*\"
LETRAS {LETRA}+
NUMEROS {DIGITO}+
IDENTA {ESPACO}{ESPACO}{ESPACO}
%%


"=="        { return IGUALIGUAL; }
"!="        { return DIFERENTEIGUAL; }
"switch"    { return SWITCH; }
"case"      { return CASE; }
"default"   { return DEFAULT; }
"do"        { return DO; }
"while"     { return WHILE; }
"*"         { return VEZES; }
"+"         { return MAIS; }
"-"         { return MENOS; }
"/"         { return DIVIDIR; }
"="         { return IGUAL; }
"("         { return ABREP; }
")"         { return FECHAP; }
":"         { return DOISP; }
"&&"         { return E; }
"||"         { return OU; }

{LETRAS}   		     { yylval.str = strdup(yytext); return ID; }
{STRING}                     { yylval.str = strdup(yytext); return STR; }
{NUMEROS}                    { yylval.str = strdup(yytext); return NUM; }
{IDENTA} 		     { yylval.str = strdup(yytext); return IDENTA; }
.           { printf("Token desconhecido: %s\n", yytext); yyerror("Token desconhecido."); }
<<EOF>>     { return FIM_ENTRADA; }
"\n"       { yylineno++; return FIM_DE_LINHA; }
%%


