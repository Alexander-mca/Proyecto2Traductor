
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
module.exports.TIPO_OPERACION = TIPO_OPERACION;
module.exports.TIPO_INSTRUCCION = TIPO_INSTRUCCION;
module.exports.TIPO_VALOR = TIPO_VALOR;
module.exports.instruccionesAPI = instruccionesAPI;
module.exports.TIPO_OPCION_SWITCH = TIPO_OPCION_SWITCH;