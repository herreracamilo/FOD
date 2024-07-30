program programa;

type
    archivo = file of integer;

    procedure crearArchivo(var arch:archivo);
    var
        n:integer;
        nombre:string;
    begin
        writeln('ingrese nombre del archivo');
        readln(nombre);
        assign(arch,nombre);
        rewrite(arch);

        writeln('ingrese un numero al archivo');
        readln(n);
        while(n <> 30000)do begin
            write(arch,n);
            writeln('ingrese un numero al archivo');
            readln(n);
        end;
        close(arch);
        writeln('archivo creado correctamente \o/');
    end;

    procedure imprimirArchivo(var arch:archivo);
    var
        n:integer;
    begin
        reset(arch);
        while not eof (arch) do begin
            read(arch,n);
            writeln(n);
        end;
        close(arch)
    end;

var
    arch:archivo;
begin
    crearArchivo(arch);
    imprimirArchivo(arch);
end.