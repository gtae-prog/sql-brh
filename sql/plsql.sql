CREATE OR REPLACE PROCEDURE insere_projeto(p_NOME IN BRH.PROJETO.NOME%type, p_RESPONSAVEL IN BRH.PROJETO.RESPONSAVEL%type)
IS
BEGIN
    INSERT INTO BRH.PROJETO (NOME, RESPONSAVEL,INICIO) VALUES (p_NOME, p_RESPONSAVEL, SYSDATE);
END;

EXECUTE insere_projeto('CIA','G123');

--------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION calcula_idade(p_DATA DATE)
RETURN NUMBER
IS
     v_idade NUMBER;
BEGIN
      --v_idade :=  EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM p_DATA);
      v_idade :=  TRUNC(MONTHS_BETWEEN(p_DATA, SYSDATE)/12);
    RETURN ABS(v_idade);
END;

SELECT calcula_idade(TO_DATE('01-10-1979','DD/MM/YYYY')) AS IDADE FROM DUAL;

--------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION finaliza_projeto(p_ID IN NUMBER)
RETURN DATE
IS
     v_data_fim BRH.PROJETO.FIM%TYPE;
BEGIN
    SELECT P.FIM INTO v_data_fim FROM PROJETO P WHERE P.ID = p_ID;
    RETURN v_data_fim;
END;

SELECT NVL(TO_CHAR(finaliza_projeto(2), 'YYYY-MM-DD HH:MM:SS'),0) AS FIM FROM DUAL;

--------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE insere_projeto(p_NOME IN BRH.PROJETO.NOME%type, p_RESPONSAVEL IN BRH.PROJETO.RESPONSAVEL%type)
IS
BEGIN
           
    IF LENGTH(p_NOME) >= 2  OR p_NOME IS NOT NULL THEN
        INSERT INTO BRH.PROJETO (NOME, RESPONSAVEL,INICIO) VALUES (p_NOME, p_RESPONSAVEL, SYSDATE);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Erro: Nome do projeto não pode ser nulo ou conter menos que duas letras .');
    END IF;
    
END;

SET SERVEROUTPUT ON;

EXECUTE insere_projeto('A','G123');

--------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION calcula_idade(p_DATA IN DATE)
RETURN NUMBER
IS
     v_idade NUMBER;
     v_data_nascimento DATE;
BEGIN
      v_data_nascimento := p_DATA;
     
      IF v_data_nascimento <= SYSDATE THEN
       
         v_idade :=  TRUNC(MONTHS_BETWEEN(p_DATA, SYSDATE)/12);
           
      ELSE
      
        RAISE_APPLICATION_ERROR(-20001, 'Impossível calcular idade! Data inválida: ' || TO_CHAR(v_data_nascimento, 'DD/MM/YYYY'));
        
     END IF;
     
     RETURN ABS(v_idade);
     
END;

SELECT calcula_idade(TO_DATE('01/10/2024','DD/MM/YYYY')) AS IDADE FROM DUAL;

--------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE define_atribuicao (
    p_nome_colaborador VARCHAR2,
    p_nome_projeto VARCHAR2,
    p_nome_papel VARCHAR2
) IS
    v_colaborador_id BRH.COLABORADOR.MATRICULA%type;
    v_projeto_id BRH.PROJETO.ID%type;
    v_papel_id BRH.PAPEL.ID%type;

BEGIN
    
    SELECT MATRICULA INTO v_colaborador_id
    FROM BRH.COLABORADOR
    WHERE NOME = p_nome_colaborador;
    
    SELECT ID INTO v_projeto_id
    FROM BRH.PROJETO
    WHERE NOME = p_nome_projeto;

    SELECT ID INTO v_papel_id
    FROM BRH.PAPEL
    WHERE NOME = p_nome_papel;

    IF v_colaborador_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Colaborador inexistente: ' || p_nome_colaborador);
    ELSIF v_projeto_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20002, 'Projeto inexistente: ' || p_nome_projeto);
    ELSIF v_papel_id IS NULL THEN
        INSERT INTO BRH.PAPEL (NOME) VALUES (p_nome_papel);
    END IF;
END;

EXECUTE define_atribuicao('Ana','Comex','as');

commit;