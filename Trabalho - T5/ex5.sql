CREATE OR REPLACE FUNCTION Pais_Continente()
  RETURNS TABLE (nome VARCHAR, continente VARCHAR) AS
$$
DECLARE
  cur CURSOR FOR SELECT name, continent FROM countries WHERE length(name) <= 15;
  result RECORD;
BEGIN
  OPEN cur;
  
  LOOP
    FETCH cur INTO result;
    EXIT WHEN NOT FOUND;
    
    nome := result.name;
    continente := result.continent;
    RETURN NEXT;
  END LOOP;
  
  CLOSE cur;
END;
$$
LANGUAGE plpgsql;