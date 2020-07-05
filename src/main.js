
//Evento
window.addEventListener('load', inicio, false);
//Funciones
function inicio() {
    document.getElementById('archivo').addEventListener('change', cargar, false); 
}

function cargar(ev) {   
    var arch=new FileReader();
    //Cargar Archivos
    arch.addEventListener('load',leer,false);
    arch.readAsText(ev.target.files[0]);
}

function leer(ev) {
  Limpiar();
  //Agregamos
  document.getElementById('cmdcsharp').value=ev.target.result;
}

function Limpiar(){
  //Limpiamos
  document.getElementById('cmdcsharp').value="";
}
document.getElementById("Nuevo_archivo").onclick=function(){
  Limpiar();
}
document.getElementById('Salir').onclick=function () {
   if(confirm('¿Esta seguro de Salir?')) {
     window.close();
   }
}

function Guardar(){
  var nombre=prompt("Escriba el nombre del archivo")+".cs";
  var ContenidoDeArchivo = document.getElementById('CampoTexto').value;

  var element = document.createElement('a');
  element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(ContenidoDeArchivo));
  element.setAttribute('download', nombre);

  element.style.display = 'none';
  document.body.appendChild(element);
  element.click();
  document.body.removeChild(element);
} 
document.getElementById("guardar").onclick=function(){
  Guardar();
}

function GuardarPy(){
  var NombreArchivo=prompt("Ingrese Nombre del Archivo")+".py";
  var ContenidoDeArchivo = document.getElementById('CampoTextoPython').value;

  var element = document.createElement('a');
  element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(ContenidoDeArchivo));
  element.setAttribute('download', NombreArchivo);

  element.style.display = 'none';
  document.body.appendChild(element);
  element.click();
  document.body.removeChild(element);
} 
document.getElementById("Des_Py").onclick=function(){
  GuardarPy();
}

function GuardarHtml(){
  var NombreArchivo=prompt("Ingrese Nombre del Archivo")+".html";
  var ContenidoDeArchivo = document.getElementById('CampoTextoHTML').value;

  var element = document.createElement('a');
  element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(ContenidoDeArchivo));
  element.setAttribute('download', NombreArchivo);

  element.style.display = 'none';
  document.body.appendChild(element);
  element.click();
  document.body.removeChild(element);
} 
document.getElementById("Des_Html").onclick=function(){
  GuardarHtml();
}

function GuardarJson(){
  var NombreArchivo=prompt("Ingrese Nombre del Archivo")+".json";
  var ContenidoDeArchivo = document.getElementById('CampoTextoJSON').value;

  var element = document.createElement('a');
  element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(ContenidoDeArchivo));
  element.setAttribute('download', NombreArchivo);

  element.style.display = 'none';
  document.body.appendChild(element);
  element.click();
  document.body.removeChild(element);
} 
document.getElementById("Des_Json").onclick=function(){
  GuardarJson();
}

/*function Enviar_Analisis_L(){
  var Contenido = document.getElementById('cmdcsharp').value
  //Analizar(ContenidoDeArchivo);
  let ast;
  try{
    ast=Parser.parse(Contenido);
    var codigohtml=ast.codigoHtml;
    var listaErrores=ast.listaErrores;
    document.getElementById('json').innerHTML=JSON.stringify(codigohtml,undefined,2);
  }catch(e){
    console.log(e);
    return;
  }
} 
document.getElementById('analizar').onclick=function(){
  
  Enviar_Analisis_L();

}*/
