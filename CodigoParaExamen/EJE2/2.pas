program programa;
type
    archivo = file of integer;

    procedure informa(var arch:archivo);
    var
        n:integer;
        cuenta:integer;
        nombre:string;
        total:integer;
        promedio:real;
    begin
        assign(arch,'test');
        reset(arch);

        cuenta:=0;
        total:= (filesize(arch));
        while not eof(arch)do begin
            read(arch,n);
            if(n < 1500)then
                writeln(n);
            cuenta:= cuenta + n;
        end;
        promedio:= (cuenta / total);
        writeln('el promedio de los numeros ingresados es: ',promedio:2:0);
        close(arch);
        writeln('proceso finalizado \o/');
    end;

var
    arch:archivo;
begin
    informa(arch);
end.