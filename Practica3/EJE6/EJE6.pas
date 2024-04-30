(* https://justpaste.it/9m662 *)
program EJE6;

type
    prenda = record
        cod_prenda:integer;
        descripcion:string[50];
        colores:integer;
        tipo_prenda:integer;
        stock:integer;
        precio_unitario:real;
    end;

    maestro = file of prenda;
    obsoletas = file of integer;

    procedure leerPrenda(var p:prenda);
    begin
        with p do begin
            readln(cod_prenda);
            readln(descripcion);
            readln(colores);
            readln(tipo_prenda);
            readln(stock);
            readln(precio_unitario);
        end;
    end;


    procedure crearMaestro(var mae:maestro);
    var
        texto:text;
        p:prenda;
    begin
        assign(mae, 'maestro');
        assign(texto,'datosMaestro.txt');
        rewrite(mae);
        reset(texto);

        while not eof(texto)do begin
            with p do begin
                readln(texto,cod_prenda,descripcion);
                readln(texto,colores,tipo_prenda,stock,precio_unitario);
                write(mae,p);
            end;
        end;
        close(mae);
        close(texto);
        writeln('== maestro creado ==');
    end;

    procedure crearObsoletas(var obso:obsoletas);
    var
        i:integer;
        texto:text;
    begin
        assign(obso,'obsoletas');
        rewrite(obso);
        assign(texto,'obsoletas.txt');
        reset(texto);
        while not eof(texto)do begin
            read(texto,i);
            write(obso,i);
        end;
        writeln('== obsoletas creado ==');
    end;

    procedure borradoLogico(var mae:maestro; var obso:obsoletas);
    var
        cod:integer;
        encontrado:boolean;
        p:prenda;
    begin
        assign(mae,'maestro');
        assign(obso,'obsoletas');
        reset(mae);
        reset(obso);
        
        while not eof(obso)do begin
            read(obso,cod);
            encontrado:=false;
            while not eof(mae) and (not encontrado) do begin
                read(mae,p);
                if(p.cod_prenda = cod)then begin
                    encontrado:=true;
                    seek(mae, filepos(mae)-1);
                    p.stock:= p.stock * (-1);
                    write(mae,p);
                end;
            end;
            if(not encontrado)then
                writeln('!!! ese codigo de prenda no existe !!!');
        end;
        close(mae);
        close(obso);
        writeln('=== borrado logico correctamente ejecutado ===');
    end;


    procedure borradoFisico(var mae:maestro);
    var
        aux:maestro;
        p:prenda;
    begin
        assign(mae,'maestro');
        assign(aux,'sinMarca');
        reset(mae);
        rewrite(aux);
        while not eof(mae)do begin
            read(mae,p);
            if(p.stock > 0)then begin
                write(aux,p);
            end;
        end;
        close(mae);
        close(aux);
        erase(mae);
        rename(aux, 'maestro');
        writeln('=== borrado fisico correctamente ejecutado ===');
    end;

    procedure imprimir(var mae:maestro);
    var
        p:prenda;
    begin
        assign(mae,'maestro');
        reset(mae);
        while not eof(mae)do begin
            read(mae,p);
            with p do begin
                writeln('codigo ',cod_prenda);
                writeln('descripcion ',descripcion);
                writeln('colores ',colores);
                writeln('tipo de prenda ',tipo_prenda);
                writeln('stock ',stock);
                writeln('precio unitario $',precio_unitario:0:2);
            end;
        end;
    end;

var
    mae:maestro;
    obso:obsoletas;
begin
    //crearMaestro(mae);
    //crearObsoletas(obso);
    //borradoLogico(mae,obso);
    borradoFisico(mae);
    imprimir(mae);
end.