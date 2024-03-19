(* Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creado en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y el
promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla.*)

program EJE2;
type
    archivo_numeros = file of integer;
var
    cant_menor_1500,suma,num,cantidad_numeros:integer;
    nombre_fisico:string[20];
    numeros:archivo_numeros;
begin
    cant_menor_1500:=0;
    suma:=0;
    
    writeln('Ingrese el nombre del archivo a procesar: ');
    readln(nombre_fisico);
    
    assign(numeros, nombre_fisico);
    
    reset(numeros); // aca abrí el archivo
    
    cantidad_numeros:= filesize(numeros);
    
    while not eof (numeros) do begin // empiezo a operar
        read(numeros,num);
        writeln(num);
        suma:= suma + num;
        if(num < 1500)then
            cant_menor_1500:= cant_menor_1500 + 1;
    end;
    close(numeros);
    writeln('-------------------------------------------------------------');
    writeln('La cantidad de numeros menores a 1500 fue: ',cant_menor_1500);
    writeln('El promedio de numeros fue: ',(suma/(cantidad_numeros)):0:2);
    writeln('-------------------------------------------------------------');
end.