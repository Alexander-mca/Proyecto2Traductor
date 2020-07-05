/*
  Ejemplo mi primer proyecto con Jison
 */

/* Definición Léxica */
%lex

%options case-insensitive

%%
\s+
/*Simbolos*/
";"                 return 'PUNTOYCOMA';
","                 return 'COMA';
":"                 return 'DOSPUNTOS';
"("                 return 'PARABRE';
")"                 return 'PARCIERRA';
"["                 return 'CORIZQ';
"]"                 return 'CORDER';
"{"                 return 'LLAVEDER';
"}"                 return 'LLAVEIZQ';
"+"                 return 'MAS';
"-"                 return 'MENOS';
"*"                 return 'POR';
"/"                 return 'DIVIDIDO';
"="                 return 'IGUAL';
"<"                 return 'MENOR';
">"                 return 'MAYOR';
"!"                 return 'NOT';
">="                return 'MAYORIGUAL';
"<="                return 'MENORIGUAL';
"!="                return 'DIFERENTE';
"=="                return 'IGUALIGUAL';
"&&"                return 'AND';
"||"                return 'OR';

/*Tipos de datos*/
"int"       return 'RINT';
"double"    return 'RDOUBLE';
"char"      return 'RCHAR';
"bool"      return 'RBOOL';
"string"    return 'RSTRING';

/*Palabras Reservadas*/
"void"              return 'VOID';
"main"              return 'MAIN';
"if"                return 'IF';
"else"              return 'ELSE';
"while"             return 'WHILE';
"do"                return 'DO';
"switch"            return 'SWITCH';
"case"              return 'CASE';
"default"           return 'DEFAULT';
"console\.write"    return 'PRINT';
"break"             return 'BREAK';
"true"              return 'TRUE';
"false"             return 'FALSE';
"return"            return 'RETURN';
"continue"          return 'CONTINUE';

/* Comentario 1 linea */
"//".*\n

/* Comentario multilinea */
"/*".*"*/"

/* Cadena */
"\"".*"\""              return 'CADENA';

/* ID */
([A-Za-z])[A-Za-z0-9_]*  return 'ID';

/* Espacios en blanco */
[ \r\t]+            {}
\n                  {}

"'"."'"                 return 'CHAR';
"'"..+"'"               return  'CADENAHTML';
[0-9]+("."[0-9]+)?\b    return 'DOUBLE';
[0-9]+\b                return 'INT';

<<EOF>>                 return 'EOF';

.                       {    const error=instruccionesAPI.Error('Léxico',this._$.first_line,this._$.first_column,yytext);listaErrores.push(error);
                            console.error('Este es un error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column); }
/lex
%{

  	const TIPO_OPERACION={
        SUMA:           'OP_SUMA',
        RESTA:          'OP_RESTA',
        MULTIPLICACION: 'OP_MULTIPLICACION',
        DIVISION:       'OP_DIVISION',
        NEGATIVO:       'OP_NEGATIVO',
        MAYOR_QUE:      'OP_MAYOR_QUE',
        MENOR_QUE:      'OP_MENOR_QUE',

        MAYOR_IGUAL: 	'OP_MAYOR_IGUAL',
        MENOR_IGUAL:    'OP_MENOR_IGUAL',
        DOBLE_IGUAL:    'OP_DOBLE_IGUAL',
        DIFERENTE:    	'OP_DIFERENTE',

        AND:  			'OP_AND',
        OR: 			'OP_OR',
        NOT:   			'OP_NOT',
        AUMENTO:        'AUMENTO',
        DECREMENTO:     'DECREMENTO'

    }
    const TIPO_INSTRUCCION={
        Declaracion: 'Declaracion',
        DO_WHILE:    'DO_WHILE',
        ASIGNACION:'ASIGNACION',
        Imprimir: 'Imprimir',
        SWITCH: 'Switch',
        Sent_If: 'If',
        ELSE:   'ELSE',
        LLAMADA: 'LLAMADA',
        Sent_While: 'While',
        Sent_For: 'For',
        Metodo: 'Metodo',
        Funcion: 'Funcion',
        Main: 'Main',
        CONDICION: 'CONDICION',
        RETURN: 'RETURN',
        CONTINUE:'CONTINUE',
        BREAK:'BREAK'

    }
    const TIPO_VALOR={
        Entero:'Val_Entero',
        Double:'Val_Double',
        Cadena:'Val_Cadena',
        Identificador:'Val_Id',
        Caracter:'Val_Caracter',
        Booleano:'Val_Bool',
        CADENAHTML:'CADENAHTML'
    }
    const TIPO_OPCION_SWITCH = {
        CASO: 			'CASO',
        DEFECTO: 		'DEFECTO'
    }
    function nuevaOperacion(operandoIzq, operandoDer, tipo) {
        return {
            operandoIzq: operandoIzq,
            operandoDer: operandoDer,
            tipo: tipo
        }
    }
    const instruccionesAPI={
        nuevoValor: function(valor, tipo) {
            return {
                tipo: tipo,
                valor: valor
            }
        },
        nuevoReturn:function (expresion) {
            return expresion;
        }
        ,
        nuevoContinue:function(){
          return{
              tipo:TIPO_INSTRUCCION.CONTINUE
          }
        },
        nuevoBreak:function(){
          return{
              tipo:TIPO_INSTRUCCION.BREAK
          }
        },
        nuevoImprimir: function(expresionCadena) {
            return {
                tipo: TIPO_INSTRUCCION.Imprimir,
                expresionCadena: expresionCadena
            };
        },
        nuevaLlamada:function (id,valores) {
                return{
                    tipo:TIPO_INSTRUCCION.LLAMADA,
                    id:id,
                    valores:valores
                };
        }
        ,
        nuevoOperacionBinaria: function(operandoIzq, operandoDer, tipo) {
            return nuevaOperacion(operandoIzq, operandoDer, tipo);
        },
        nuevoOperacionUnaria: function(operando, tipo) {
            return nuevaOperacion(operando, undefined, tipo);
        },
        nuevaFuncion:function(tipoFuncion,id,parametros, instrucciones){
             return{
                tipo:TIPO_INSTRUCCION.Funcion,
                tipoFuncion:tipoFuncion,
                id:id,
                parametros:parametros,
                instrucciones:instrucciones
             };
        },
        nuevoMientras: function(expresionLogica, instrucciones) {
            return {
                tipo: TIPO_INSTRUCCION.Sent_While,
                expresionLogica: expresionLogica,
                instrucciones: instrucciones
            };
        },
        nuevoDoWhile:function(condiciones,instrucciones){
          return{
              tipo:TIPO_INSTRUCCION.DO_WHILE,
              condiciones:condiciones,
              instrucciones:instrucciones
          };
        },
        nuevaListaValores:function(valor){
           var valores=[];
           valores.push(valor);
           return valores;
        },
        nuevoFor: function (variable,expresionLogica, aumento, instrucciones) {
            return {
                tipo: TIPO_INSTRUCCION.Sent_For,
                expresionLogica: expresionLogica,
                instrucciones: instrucciones,
                aumento: aumento,
                variable: variable
            }
        },
        nuevaDeclaracion: function(identificador, tipo,asignacion) {
            return {
                tipo: TIPO_INSTRUCCION.Declaracion,
                identificador: identificador,
                asignacion:asignacion,
                tipo_dato: tipo
            }
        },
        main:function(instrucciones){
            return{
              tipo:TIPO_INSTRUCCION.Main,
              instrucciones:instrucciones
            };
        },
        nuevoMetodo:function (id,parametros,instrucciones) {
                return{
                    tipo:TIPO_INSTRUCCION.Metodo,
                    id:id,
                    parametros:parametros,
                    instrucciones:instrucciones
                };
        }
        ,
         Error:function (tipoError,fila,columna,descripcion) {

                return{
                  tipoError:tipoError,
                  fila:fila,
                  columna:columna,
                  descripcion:descripcion
                };

         }
        ,
        nuevaListaIds:function(id){
           var ids=[];
           ids.push(id);
           return ids;
        },
        nuevaAsignacion: function(identificador, expresionNumerica) {
            return {
                tipo: TIPO_INSTRUCCION.ASIGNACION,
                identificador: identificador,
                expresionNumerica: expresionNumerica
            }
        },
        nuevoIf: function(expresionLogica, instrucciones) {
            return {
                tipo: TIPO_INSTRUCCION.Sent_If,
                expresionLogica: expresionLogica,
                instrucciones: instrucciones
            }
        },
        nuevoElse: function(instrucciones) {
            return {
                tipo: TIPO_INSTRUCCION.ELSE,
                instrucciones: instrucciones
            }
        },
        nuevoSwitch: function(expresionNumerica, casos) {
            return {
                tipo: TIPO_INSTRUCCION.SWITCH,
                expresionNumerica: expresionNumerica,
                casos: casos
            }
        },
        nuevaListaCondiciones:function(condicion){
            var condiciones=[];
            condiciones.push(condicion);
            return condiciones;
        },
        nuevaListaCasos: function (caso) {
            var casos = [];
            casos.push(caso);
            return casos;
        },nuevoListaIfs:function(si){
            var ifs = [];
            ifs.push(si);
            return ifs;
        },
        nuevoCaso: function(expresionNumerica, instrucciones) {
            return {
                tipo: TIPO_OPCION_SWITCH.CASO,
                expresionNumerica: expresionNumerica,
                instrucciones: instrucciones
            }
        },
        nuevoCasoDef: function(instrucciones) {
            return {
                tipo: TIPO_OPCION_SWITCH.DEFECTO,
                instrucciones: instrucciones
            }
        },
        nuevoOperador: function(operador){
            return operador
        }

    }
    //para jalar el tipo de dato
  	const TIPO_DATO = {
        INT: 'ENTERO',
        STRING: 'STRING',
        DOUBLE:'DOUBLE',
        BOOLEAN:'BOOLEANO',
        CHAR:'CHAR'

    }

    var listaErrores=[];
    var codigohtml=undefined;
%}
/* Asociación de operadores y precedencia */

%left 'OR'
%left  'AND'
%left 'MAS' 'MENOS'
%left 'POR' 'DIVIDIDO'
%left 'UMENOS'

%start ini

%% /* Definición de la gramática */

ini
	: instrucciones EOF {return $1;}
;

instrucciones
	: instrucciones instruccion  { $1.push($2); $$ = $1; }/* Se realiza el cambio por la gramática Ascendente */
	| instruccion                 { $$ = [$1]; }

;

instruccion
	: declaracion PUNTOYCOMA           {$$=$1;}
	| asignacion PUNTOYCOMA            {$$=$1;}
	| metodo                           {$$=$1;}
	| funcion                          {$$=$1;}
	| main                             {$$=$1;}
	| sent_if                          {$$=$1;}
	| sent_while                       {$$=$1;}
	| sent_switch                      {$$=$1;}
	| sent_for                         {$$=$1;}
	| sent_dowhile PUNTOYCOMA          {$$=$1;}
	| imprimir PUNTOYCOMA              {$$=$1;}
	| CONTINUE PUNTOYCOMA              {$$=instruccionesAPI.nuevoContinue();}
	| BREAK PUNTOYCOMA                 {$$=instruccionesAPI.nuevoBreak();}
	| RETURN expresion PUNTOYCOMA      {$$=instruccionesAPI.nuevoReturn($1);}
	| RETURN PUNTOYCOMA                {$$=instruccionesAPI.nuevoReturn(undefined);}
	| llamada PUNTOYCOMA               {$$=$1;}
	| error { const error=instruccionesAPI.Error('sintactico',this._$.first_line,this._$.first_column,yytext);this.listaErrores.push(error);
	        console.error('Este es un error sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column); }
	
;
llamada
        :ID PARABRE valores PARCIERRA  {$$=instruccionesAPI.nuevaLlamada($1,$3);}
        |ID PARABRE PARCIERRA          {$$=instruccionesAPI.nuevaLLamada($1,undefined);}
;
valores
        :valores COMA expresion   {$1.push($3); $$=$1;}
         |expresion               {$$=instruccionesAPI.nuevaListaValores($1);}
;
sent_dowhile
            : DO bloque WHILE PARABRE condiciones PARCIERRA {$$=instruccionesAPI.nuevoDoWhile($5,$2);}
;
funcion
    :tipo ID PARABRE  parametros PARCIERRA bloque {$$=instruccionesAPI.nuevaFuncion($1,$2,$4,$6);}
;
asignacion
    :ID IGUAL expresion {$$=instruccionesAPI.nuevaAsignacion($1,$3);}
;
sent_for
    :FOR PARABRE ford PUNTOYCOMA condicion PUNTOYCOMA aumf PARCIERRE bloque {$$=instruccionesAPI.nuevoFor($3,$5,$7,$9);}
;
aumf
    :ID MAS MAS       {$$=instruccionesAPI.nuevaOperacionUnaria(instruccionesAPI.nuevoValor($1,TIPO_VALOR.Identificador),TIPO_OPERACION.AUMENTO);}
      |ID MENOS MENOS  {$$=instruccionesAPI.nuevaOperacionUnaria(instruccionesAPI.nuevoValor($1,TIPO_VALOR.Identificador),TIPO_OPERACION.DECREMENTO);}
;
ford
       : declaracion   {$$=$1;}
       |asignacion  {$$=$1;}
;
sent_while
        : WHILE PARABRE condiciones PARCIERRA bloque {$$=instruccionesAPI.nuevoMientras($3,$5);}
;

sent_switch
        :SWITCH PARABRE ID PARCIERRA LLAVEIZQ casos LLAVEDER {$$=instrucccionesAPI.nuevoSwitch($3,$6);}
;
casos
    :casos caso {$1.push($2);}
      |caso      {$$=instruccionesAPI.nuevaListaCasos($1);}
;
caso
    :CASE valor DOSPUNTOS instrucciones {$$=instruccionesAPI.nuevoCaso($2,$4);}
    |DEFAULT DOSPUNTOS instrucciones    {$$=instruccionesAPI.nuevoCasoDef($3);}
   
;
valor
    : CADENA   {$$=instruccionesAPI.nuevoValor($1,TIPO_VALOR.Cadena);}
      |CHAR     {$$=instruccionesAPI.nuevoValor($1,TIPO_VALOR.Caracter);}
      |INT      {$$=instruccionesAPI.nuevoValor(Number($1),TIPO_VALOR.Entero);}
      |DOUBLE   {$$=instruccionesAPI.nuevoValor(Number($1),TIPO_VALOR.Double);}
      |BOOL     {$$=instruccionesAPI.nuevoValor($1,TIPO_VALOR.Booleano);}
      |CADENAHTML { codigohtml+=$1; $$=instruccionesAPI.nuevoValor($1,TIPO_VALOR.CADENAHTML);}


;
sents_ifs: sents_ifs ELSE sent_if   {$1.push($3); $$=$1;}
            |sents_ifs ELSE bloque  {$1.push(instruccionesAPI.nuevoElse($3)); $$=$1;}
            |sent_if                {$$=instruccionesAPI.nuevoListaIfs($1);}
;
sent_if: IF PARABRE condiciones PARCIERRA bloque {$$=instruccionesAPI.nuevoIf($3,$5);}
;

condiciones: condiciones oplogico condicion {$1.push($2);$1.push($3);$$=$1;}
            |condicion                      {$$=instruccionesAPI.nuevaListaCondiciones($1);}
;
oplogico: AND     {$$=instruccionesAPI.nuevoOperador(TIPO_OPERACION.AND);}
        |OR       {$$=instruccionesAPI.nuevoOperador(TIPO_OPERACION.OR);}
;
condicion: expresion scomp expresion  {$$=instruccionesAPI.nuevaOperacionBinaria($1,$2,$3);}
;
scomp: MAYOR          {$$=instruccionesAPI.nuevoOperador(TIPO_OPERACION.MAYOR_QUE);}
        |MENOR        {$$=instruccionesAPI.nuevoOperador(TIPO_OPERACION.MENOR_QUE);}
        |MAYORIGUAL   {$$=instruccionesAPI.nuevoOperador(TIPO_OPERACION.MAYOR_IGUAL);}
        |MENORIGUAL   {$$=instruccionesAPI.nuevoOperador(TIPO_OPERACION.MENOR_IGUAL);}
        |IGUALIGUAL   {$$=instruccionesAPI.nuevoOperador(TIPO_OPERACION.DOBLE_IGUAL);}
        |DIFERENTE    {$$=$$=instruccionesAPI.nuevoOperador(TIPO_OPERACION.DIFERENTE);}
;
declaracion: tipo ID declvarias IGUAL expresion {$$=instruccionesAPI.nuevaDeclaracion($2,$1,$5);}
            | tipo ID declvarias     {$$=instruccionesAPI.nuevaDeclaracion($2,$1,undefined);}
;


declvarias: declvarias COMA ID  {$1.push($3);$$=$1;}
            |COMA ID            {$$=instruccionesAPI.nuevaListaIds($2);}
;

tipo: RCHAR        {$$=TIPO_DATO.CHAR;}
        |RSTRING   {$$=TIPO_DATO.STRING;}
        |RDOUBLE   {$$=TIPO_DATO.DOUBLE;}
        |RINT      {$$=TIPO_DATO.INT;}
        |RBOOL     {$$=TIPO_DATO.BOOLEAN;}


;
main: RMAIN PARABRE  PARCIERRA bloque{$$=instruccionesAPI.main($4);}
;
metodo:RVOID ID PARABRE parametros PARCIERRA bloque  {$$=instruccionesAPI.nuevoMetodo($2,$4,$6);}
        |RVOID ID PARABRE PARCIERRA bloque           {$$=instruccionesAPI.nuevoMetodo($2,undefined,$5);}

;

parametros: parametros COMA tipo ID  {$1.push(instruccionAPI.nuevaDeclaracion($3,$2,undefined));$$=$1;}
            |COMA tipo ID            {$$=[instruccionAPI.nuevaDeclaracion($3,$2,undefined)];}
;
bloque:LLAVEIZQ instrucciones LLAVEDER{$$=$2;}
        | LLAVEIZQ LLAVEDER{$$=undefined;}
;
imprimir: PRINT PARABRE expresion PARCIERRA{$$=instruccionesAPI.nuevoImprimir($3);}
;
expresion
	: MENOS expresion %prec UMENOS  {$$=instruccionesAPI.nuevoOperacionUnaria($2,TIPO_OPERACION.NEGATIVO);}
	| expresion MAS expresion       {$$=instruccionesAPI.nuevoOperacionBinaria($1,$3,TIPO_OPERACION.SUMA);}
	| expresion MENOS expresion     {$$=instruccionesAPI.nuevoOperacionBinaria($1,$3,TIPO_OPERACION.RESTA);}
	| expresion POR expresion       {$$=instruccionesAPI.nuevoOperacionBinaria($1,$3,TIPO_OPERACION.MULTIPLICACION);}
	| expresion DIVIDIDO expresion  {$$=instruccionesAPI.nuevoOperacionBinaria($1,$3,TIPO_OPERACION.DIVISION);}
	| valor                         {$$=$1; }
	| ID                            {$$=instruccionesAPI.nuevoValor($1,TIPO_VALOR.Identificador); }
	| aumf                          {$$=$1; }
	|condicion                      {$$=$1; }
	|llamada                        {$$=$1}
	|NOT expresion                  {$$=instruccionesAPI.nuevoOperacionUnaria($2,TIPO_OPERACION.NOT); }
	| PARIZQ expresion PARDER       {$$=$2; }
;
