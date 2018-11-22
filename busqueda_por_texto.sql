
--What is Full Text Search?
--Full Text Search (FTS) refers to information retrieval techniques for searching a document or
--text data in a full text database. Search criteria (like queries) are used to analyse the
--documents and list all the matching results. 

-- What is a document?
-- A document is defined as the unit of searching in a full text search system. This can be an
-- email message or a book or a magazine article.
-- There are two possibilities to store a document in a database; firstly, the whole text can be
-- stored in a single field or a combination of a few fields in the database. Secondly, it can be
-- referred to a document in the file system, whereof only a special type of vector containing the
-- key word (lexemes) is stored.




-- what is a ts_vecto? 
-- “The tsvector type represents a document in a form optimized for text search by creating a list of tokens” (in postgres differently fron another full text research, 
-- tokenization allows to not depend on the index) Which will return a vector where every token is a lexeme (unit of lexical meaning) with pointers (the positions in the document), 
-- and where words that carry little meaning, such as articles (the) and conjunctions (and, or) are conveniently omitted.


-- PREPARING DATA
-- update denue_2015 set 

nom_v_e_1 = convert_from(convert_to(nom_v_e_1, 'latin-1'), 'utf-8') 

-- Create ts_vector columns 

alter table denue_2015 add column tok_nom_estab text;
alter table denue_2015 add column tok_nom_act text;

-- select the language in which the Full text researches will be carried out, on each token and apply to_tsvector function.
update denue_2015 set tok_nom_estab = to_tsvector ('spanish', denue_2015.nom_estab)
update denue_2015 set tok_nom_act = to_tsvector ('spanish', denue_2015.nom_act)

--Next thing in order to do full-text search, is querying the vector.
-- to_tsquery for querying the vector for occurrences of certain words or phrases.

-- Simple text search  

SELECT * FROM denue_2015 WHERE tok_nom_act @@ to_tsquery('consultorio'); 

--Operators and Uses 
--AND
SELECT * FROM denue_2015 WHERE tok_nom_act @@ to_tsquery('consultorio & farmacia'); 
--OR
SELECT * FROM denue_2015 WHERE tok_nom_act @@ to_tsquery('consultorio | farmacia'); 
-- Negation 
SELECT * FROM denue_2015 WHERE tok_nom_act @@ to_tsquery('!consultorio'); 


-- https://www.compose.com/articles/mastering-postgresql-tools-full-text-search-and-phrase-search/
-- https://wiki.hsr.ch/Datenbanken/files/Full_Text_Search_in_PostgreSQL_Luetolf_Paper_final.pdf






