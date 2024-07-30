program programa;
type
    producto = record
        codigo:integer;
        nombre:string;
        des:string;
        precio_compra:real;
        precio_venta:real;
        ubicacion:string;
    end;

    procedure quitarProducto(var archivoMae:archivo_maestro);
    var
        p,pnuevo:producto;
        encontrado:boolean;
        pos:=integer;
    begin
        assign(archivoMae,'maestro');
        reset(archivoMae);

        seek(archivoMae,1); // pongo al archivo en la pos 1 asi no leo la cabecera cuando entro al while de busqueda
        encontrado:=false;
        leerProducto(pnuevo); // esto le pide ingresar el producto al usuario
        if(existeProducto(archivoMae))then begin
            while not eof(archivoMae) or not(encontrado) do begin
                read(archivoMae,p);
                if(p.codigo = pnuevo.codigo)then begin
                    encontrado:= true;
                    pos:= filepos(archivoMae);
                end;
            end;
            seek(archivoMae,0);//vuelvo a la cabecera
            read(archivoMae,p)//me guardo los datos de la cabecera
            seek(archivoMae,pos)//voy a la posicion en donde esta el que tengo que borrar
            write(archivoMae,p);// escribo lo que habia en la cabecera
            seek(archivoMae,0);//vuelvo a la cabecera
            p.codigo:= pos * -1; // lo pongo negativo y guardo la posicion
            write(archivoMae,p);
        end else writeln('el producto no existe y no se puede eliminar');
    end;

        procedure agregarProducto(var archivoMae:archivo_maestro);
    var
        p,aux:producto;
        pos:integer;
    begin
        assign(archivoMae, 'maestro');
        reset(archivoMae);
        leerProducto(p); // esto le pide ingresar el producto al usuario
        if not(existeProducto(archivoMae))then begin //existeProducto recorre el archivo y te dice si existe o no el codigo del que quiero agregar
            read(archivoMae,aux); // leo la cabecera
            pos:= aux.codigo * -1; // guardo en pos la posicion que tiene la cabecera
            seek(archivoMae,pos); // voy a la posicion
            read(archivoMae,aux);//me guardo la posicion que hay ahi para ponerla en la cabecera
            seek(archivoMae,pos); // vuelvo a la posicion
            write(archivoMae,p); // escribo el nuevo producto
            seek(archivoMae,0); // voy a la cabecera
            write(archivoMae,aux); //escribo lo que habia en la posicion que sobreescribi
        end else writeln('el producto ingresado ya existia y no pudo ser agregado');
    end;
