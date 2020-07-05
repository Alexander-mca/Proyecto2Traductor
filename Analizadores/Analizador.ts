// @ts-ignore
import fs=require("fs");
//@ts-ignore
import Parser=require("/src/Analizadores/gramatica");


let listaErrores: { TipoError: string, Descripcion:string, Fila:number, Columna:number}[];
var codigohtml:string="";

class Analizador_L{
     //Array

     Tokens_Error: { TipoError: string, Descripcion:string, Fila:number, Columna:number}[];
     constructor(){

          this.Tokens_Error=[{"TipoError":"INICIO", "Descripcion":"INICIO","Fila":0,"Columna":0}];
     }

    public Analizar_Cadena(Contenido: string) {
         let ast;
         try{
             ast=Parser.parse(Contenido);
             codigohtml=ast.codigoHtml;
             listaErrores=ast.getAttribute('listaErrores');
             fs.writeFileSync('./ast.json', JSON.stringify(ast, null, 2));

         }catch(e){
             console.log(e);
             return;
         }

        //Damos valor a la L_Tokens

    }
}

function Analizar(Contenido:string){
    let nuevo=new Analizador_L();
    nuevo.Analizar_Cadena(Contenido);
    //Realizamos Analisis Sintactico

}
function getErrores(): { TipoError: string, Descripcion:string, Fila:number, Columna:number}[]{
      return listaErrores;
}

function getCodigoHtml():string{
      return codigohtml;
}