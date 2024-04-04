(*Realizar un programa que permita:
a) Crear un archivo binario a partir de la información almacenada en un archivo de
texto. El nombre del archivo de texto es: “novelas.txt”. La información en el
archivo de texto consiste en: código de novela, nombre, género y precio de
diferentes novelas argentinas. Los datos de cada novela se almacenan en dos
líneas en el archivo de texto. La primera línea contendrá la siguiente información:
código novela, precio y género, y la segunda línea almacenará el nombre de la
novela.
b) Abrir el archivo binario y permitir la actualización del mismo. Se debe poder
agregar una novela y modificar una existente. Las búsquedas se realizan por
código de novela.
NOTA: El nombre del archivo binario es proporcionado por el usuario desde el teclado.
*)

program EJE7;
type
    novela = record
        codigo:integer;
        nombre:string;
        genero:string;
        precio:real;
    end;
    
    archivo_novelas = file of novela;

    procedure leoNovela(var n:novela);
    begin
        writeln('codigo');
        readln(n.codigo);
        writeln('nombre');
        readln(n.nombre);
        writeln('genero');
        readln(n.genero);
        writeln('precio');
        readln(n.precio);
    end;

    procedure imprimoN(n:novela);
    begin
        writeln('codigo');
        writeln(n.codigo);
        writeln('nombre');
        writeln(n.nombre);
        writeln('genero');
        writeln(n.genero);
        writeln('precio');
        writeln(n.precio);
    end;


    procedure crearBinario(var txt:text);
    var
        nombre_archivo:string;
        n:novela;
        arch:archivo_novelas;
    begin
        writeln('ingrese el nombre del binario a crear');
        readln(nombre_archivo);
        assign(arch,nombre_archivo);
        rewrite(arch);

        assign(txt,'novelas.txt');
        reset(txt);

        while not eof(txt)do begin
            readln(txt,n.codigo,n.precio,n.genero);
            readln(txt,n.nombre);
            write(arch,n);
        end;
        writeln('==================================================');
        writeln('el archivo binario fue creado correctamente :)');
        writeln('==================================================');
        close(arch);
        close(txt);
    end;

    procedure agregarDato(var arch:archivo_novelas);
    var
        n:novela;
        nombre_archivo:string;
        sigo:integer;
    begin
        sigo:=1;
        writeln('==================================================');
        writeln('ingrese el nombre del archivo en el cual agregar');
        writeln('==================================================');
        readln(nombre_archivo);
        assign(arch,nombre_archivo);
        reset(arch);
        while sigo <> 0 do begin
           seek(arch,filesize(arch));
            leoNovela(n);
            write(arch,n);
            writeln('========================================================');
            writeln('ingrese 1 para ingresar otra novela o 0 para finalizar');
            writeln('========================================================');
            readln(sigo);
        end;
        close(arch);
    end;

    procedure modificarNovela(var arch:archivo_novelas);
    var
        n:novela
        nombre_archivo:string;
        cod:integer;
        
    begin
        writeln('==================================================');
        writeln('ingrese el nombre del archivo en el cual agregar');
        writeln('==================================================');
        readln(nombre_archivo);
        assign(arch,nombre_archivo);
        reset(arch);
        writeln('==================================================');
        writeln('ingrese el codigo de la novela a modificar');
        writeln('==================================================');
        readln(cod);
        while not eof(arch)do begin
            read(arch,n);
            if(n.codigo = cod)then
                writeln('=========================================================');
                writeln('ingrese los nuevos datos para la novela numero: ', cod);
                writeln('=========================================================');
                leoNovela(n);
                seek(arch,filesize(arch) - 1);
                write(arch,n);
        end;
        close(arch);
    end;
var
    txt:text;
begin
    assign(txt,'novelas.txt');
    crearBinario(txt);
end.