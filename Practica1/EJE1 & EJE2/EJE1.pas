(*Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. La carga finaliza
cuando se ingresa el número 30000, que no debe incorporarse al archivo. El nombre del
archivo debe ser proporcionado por el usuario desde teclado.
*)

program EJE1;
type
    archivo_numeros = file of integer;

var
    nombre_fisico:string[20];
    num:integer;
    numeros:archivo_numeros;
begin
    writeln('Ingrese nombre para el archivo');
    readln(nombre_fisico);
    assign (numeros, nombre_fisico); // le pongo nombre al archivo
    rewrite (numeros); // creo el archivo propiamente dicho y lo abro para escribir en él
    writeln('Ingrese numero o 30000 para terminar ');
    readln(num);
    while(num <> 30000)do begin
        write(numeros,num);
        writeln('Ingrese numero o 30000 para terminar ');
        readln(num);
    end;
    writeln(filesize(numeros));
    close(numeros);
end.