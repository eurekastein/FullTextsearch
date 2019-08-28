# Busqueda por texto

Full Text Search (FTS) se refiere a técnicas de recuperación de información de texto, en documentos o bases de datos.
Utiliza criterios de busqueda en forma de querys para encotrar coincidencias dentro del dopcumento. 
Para su uso en bases de datos es necesario tokenizar las columnas de tipo texto donde se quieren realizar las busquedas. 
Para ello se usa el tipo de dato tsvector, que representa una forma optimizada de buscada en el texto separando los documentos en tokens. En postgres la tokenización permite no depender del índice, esto devolverá un vector donde cada token es un lexema (unidad de significado léxico) con punteros (las posiciones en el documento), y donde las palabras que tienen poco significado, como artículos y conjunciones son eliminados.




Preparación de los datos 

__1. Convertir a 'utf-8'las columnas que se van a tokenizar__

``` sql 
update dim_denue set denue_nombre_razon_social = convert_from(convert_to(nom_v_e_1, 'latin-1'), 'utf-8') 
update dim_denue set actividad_nombre = convert_from(convert_to(nom_v_e_1, 'latin-1'), 'utf-8') 
```

__2. Posteriormente se agregar de tipo texto__

``` sql 
alter table dim_denue add column denue_nombre_razon_social_ts text;
alter table dim_denue add column actividad_nombre_ts text;
```

__NOTA__: Este es un ejemplo de como prepara los datos, el backup que se les va a entregar ya tienen estas columnas 

__3. Seleccionar de la columna con la que se va a trabaja, para tokenizarla__

``` sql 
update denue_2015 set denue_nombre_razon_social_ts = to_tsvector ('spanish', dim_denue.denue_nombre_razon_social)
update denue_2015 set actividad_nombre_ts = to_tsvector ('spanish', dim_denue.actividad_nombre)
```

__4. Realizar consultas a partir de ts_query__ 

__Consulta simple__ 

``` sql 
SELECT * FROM TABLA WHERE COLUMNA_TOKENIZADA @@ to_tsquery('PALABRA_A_BUSCAR'); 
--Ejemplu denue
SELECT * FROM dim_denue WHERE denue_nombre_razon_social_ts @@ to_tsquery('consultorio'); 
```

__Uso de operadores__ 

__AND__
``` sql
SELECT * FROM dim_denue WHERE denue_nombre_razon_social_ts @@ to_tsquery('consultorio & farmacia'); 
```

__OR__
``` sql
SELECT * FROM dim_denue WHERE denue_nombre_razon_social_ts @@ to_tsquery('consultorio | farmacia'); 
```

__Negación__
``` sql
SELECT * FROM denue_2015 WHERE denue_nombre_razon_social_ts @@ to_tsquery('!consultorio'); 
```


https://www.compose.com/articles/mastering-postgresql-tools-full-text-search-and-phrase-search/
https://wiki.hsr.ch/Datenbanken/files/Full_Text_Search_in_PostgreSQL_Luetolf_Paper_final.pdf
