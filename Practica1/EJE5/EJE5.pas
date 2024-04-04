(*Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:
a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares deben contener: código de celular, nombre,
descripción, marca, precio, stock mínimo y stock disponible.
b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
stock mínimo.
c. Listar en pantalla los celulares del archivo cuya descripción contenga una
cadena de caracteres proporcionada por el usuario.
d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
“celulares.txt” con todos los celulares del mismo. El archivo de texto generado
podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que
debería respetar el formato dado para este tipo de archivos en la NOTA 2.
NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario.
NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en
tres líneas consecutivas. En la primera se especifica: código de celular, el precio y
marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera
nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo
“celulares.txt”.*)

program tienda;
type
    celular = record
        codigo:integer;
        nombre:string;
        descripcion:string;
        marca:string;
        precio:real;
        stock_minimo:integer;
        stock_disponible:integer;
    end;

    archivo_celulares = file of celular;

    procedure cargarBinario(var txt:text; var arch:archivo_celulares);
    var
        c:celular;
        nombre:string;
    begin
        writeln('ingrese nombre del binario a crear');
        readln(nombre);
        assign(arch,nombre); // le pongo el nombre
        rewrite(arch); // lo creo

        reset(txt); // abro el texto porque ya esta creado
        while not eof(txt)do begin
            readln(txt, c.codigo,c.precio,c.marca);
            readln(txt,c.stock_disponible,c.stock_minimo,c.descripcion);
            readln(txt,c.nombre);
            write(arch,c);
        end;
        writeln('archivo binario creado correctamente :)');
        close(arch);
        close(txt);
    end;

    procedure imprimirC(c:celular);
    begin
        writeln('codigo');
        writeln(c.codigo);
        writeln('precio');
        writeln(c.precio);
        writeln('marca');
        writeln(c.marca);
        writeln('stock disponible');
        writeln(c.stock_disponible);
        writeln('stock minimo');
        writeln(c.stock_minimo);
        writeln('descrpcion');
        writeln(c.descripcion);
        writeln('nombre');
        writeln(c.nombre);
    end;

    procedure listarStockMenor(var celulares:text; var arch:archivo_celulares);
    var
        nombre_archivo:string;
        c:celular;

    begin
        writeln('ingrese nombre del archivo en el cual buscar');
        readln(nombre_archivo);
        if(nombre_archivo = 'celulares.txt')then begin
            assign(celulares,nombre_archivo);
            reset(celulares);
            while not eof(celulares)do begin
                readln(celulares, c.codigo,c.precio,c.marca);
                readln(celulares,c.stock_disponible,c.stock_minimo,c.descripcion);
                readln(celulares,c.nombre);
                if(c.stock_disponible<c.stock_minimo)then
                    imprimirC(c);
            end;
            close(celulares);
        end
        else
        begin
            assign(arch,nombre_archivo);
            reset(arch);
            while not eof(arch)do begin
                read(arch,c);
                if(c.stock_disponible < c.stock_minimo)then
                    imprimirC(c);
            end;
            close(arch);
        end;
    end;    
    

    procedure listarDescripcion(var celulares:text; var arch:archivo_celulares);
    var
        nombre_archivo:string;
        c:celular;
        desc_buscar:string;
    begin
        writeln('ingrese nombre del archivo en el cual buscar');
        readln(nombre_archivo);
        writeln('ingrese la descripcion a buscar');
        readln(desc_buscar);
        if(nombre_archivo = 'celulares.txt')then begin
            assign(celulares,nombre_archivo);
            reset(celulares);
            while not eof(celulares)do begin
                readln(celulares, c.codigo,c.precio,c.marca);
                readln(celulares,c.stock_disponible,c.stock_minimo,c.descripcion);
                readln(celulares,c.nombre);
                if(c.descripcion = desc_buscar)then
                    imprimirC(c);
            end;
            close(celulares);
        end
        else
        begin
            assign(arch,nombre_archivo);
            reset(arch);
            while not eof(arch)do begin
                read(arch,c);
                if(c.descripcion = desc_buscar)then
                    imprimirC(c);
            end;
            close(arch);
        end;
    end;

    procedure exportarTXT(var arch:archivo_celulares);
    var
        nombreB:string;
        c:celular;
        texto:text;
    begin
        writeln('ingrese nombre del binario a exportar a txt');
        readln(nombreB);
        assign(arch,nombreB);
        reset(arch);

        assign(texto,'celularess.txt');
        rewrite(texto);

        while not eof(arch)do begin
            read(arch,c);
            writeln(texto, c.codigo,c.precio,c.marca);
            writeln(texto,c.stock_disponible,c.stock_minimo,c.descripcion);
            writeln(texto,c.nombre);
            writeln(texto);
        end;
        writeln('el archivo fue creado correctamente');
        close(arch);
        close(texto);
        
    end;

    var
        celulares:text; // tipo txt
        arch:archivo_celulares; // tipo binario
        nombreArchivoTexto:string;
        opcion:char;
    begin
        assign(celulares,'celulares.txt');
        writeln('===============================MENU=====================================');
        writeln('ingrese A para crear un archivo de registros desde un archivo de texto denominado celulares.txt');
        writeln('');
        writeln('ingrese B para listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock minimo');
        writeln('');
        writeln('ingrese C para listar en pantalla los celulares del archivo cuya descripcion sea = a una descripcion ingresada');
        writeln('');
        writeln('ingrese D para exportar el archivo creado en el inciso a) a un archivo de texto denominado celularess.txt con todos los celulares del mismo');
        writeln('========================================================================');
        readln(opcion);
        case opcion of
            'A': cargarBinario(celulares,arch);
            'B': listarStockMenor(celulares,arch);
            'C': listarDescripcion(celulares,arch);
            'D': exportarTXT(arch);
        else
            writeln('error, opción incorrecta');
    end;
    end.
