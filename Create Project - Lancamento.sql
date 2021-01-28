-- ---------------------- Historico de Manutencao ------------------------------------------

-- Versao : M001
-- Autor  : Gerson Batista
-- Data   : 27/01/2021
-- Descr. : Criando Projeto

-- ---------------------- -------------------------- ----------------------

-- Versao : M002
-- Autor  : Gerson Batista
-- Data   : 27/01/2021
-- Descr. : Adicionando validações e retorno

-- ---------------------- -------------------------- ----------------------

-- Versao : M003
-- Autor  : Gerson Batista
-- Data   : 28/01/2021
-- Descr. : Adicionando codigo no retorno proc

-- ---------------------- -------------------------- ----------------------

-- Versao : M004
-- Autor  : Gerson Batista
-- Data   : 27/01/2021
-- Descr. : Adicionando deletar e validação codigo

-- ---------------------- Package ------------------------------------------

CREATE OR REPLACE PACKAGE PKG_LANCAMENTOS AS

    TYPE rows IS TABLE OF lancamento%ROWTYPE 
    INDEX BY PLS_INTEGER; --M004
    
    t_lancamento rows; --M004
    
    FUNCTION VALIDAR_CODIGO(
      P_CODIGO IN LANCAMENTO.CODIGO%TYPE) 
      return LANCAMENTO.DESCRICAO%TYPE; --M004
       
    PROCEDURE CRIAR(V_ROW IN LANCAMENTO%ROWTYPE, --M001
        V_COD_RET OUT NUMBER,  --M003
        V_RETORNO OUT VARCHAR2); --M003

END PKG_LANCAMENTOS;


-- ---------------------- Package Body ------------------------------------------

CREATE OR REPLACE PACKAGE BODY PKG_LANCAMENTOS AS

	FUNCTION VALIDAR_CODIGO(
	    P_CODIGO IN LANCAMENTO.CODIGO%TYPE) 
	      return LANCAMENTO.DESCRICAO%TYPE is

	    v_descricao LANCAMENTO.DESCRICAO%TYPE;

	  begin
	    select * BULK COLLECT into t_lancamento from lancamento l where l.codigo = P_CODIGO;

	    FOR i IN 1 .. t_lancamento.COUNT
		LOOP
		 v_descricao := t_lancamento(i).descricao;
		END LOOP;

	     return v_descricao;
	  end; --M004

	PROCEDURE CRIAR(V_ROW IN LANCAMENTO%ROWTYPE,
        V_COD_RET OUT NUMBER,  --M003
        V_RETORNO OUT VARCHAR2) is --M003

      BEGIN

        INSERT INTO LANCAMENTO (codigo, 
                                descricao,
                                data_vencimento,
                                data_pagamento,
                                valor,
                                observacao,
                                tipo,
                                codigo_categoria,
                                codigo_pessoa)
                                values (V_ROW.codigo,
                                        V_ROW.descricao,
                                        V_ROW.data_vencimento,
                                        V_ROW.data_pagamento,
                                        V_ROW.valor,
                                        V_ROW.observacao,
                                        V_ROW.tipo,
                                        V_ROW.codigo_categoria,
                                        V_ROW.codigo_pessoa); --M001

        V_COD_RET := 200; --M003
        V_RETORNO := 'Dados inseridos com sucesso.'; --M003
	    --DBMS_OUTPUT.PUT_LINE('Dados inseridos com sucesso.'); --M003
        COMMIT;
        
        EXCEPTION --M002
          WHEN OTHERS THEN --M002
            ROLLBACK; --M002
                V_COD_RET := 500; --M003
               V_RETORNO := 'Erro ao inserir dados: ' || SQLERRM; --M003
            --DBMS_OUTPUT.PUT_LINE('Erro ao inserir dados: ' || SQLERRM); 

      END; --M001
      
      PROCEDURE EXCLUIR(P_CODIGO IN LANCAMENTO.CODIGO%TYPE,
        V_COD_RET OUT NUMBER,
        V_RETORNO OUT VARCHAR2) IS
        
      BEGIN
       
      delete from lancamento t where t.codigo = P_CODIGO;

        V_COD_RET := 200; 
        V_RETORNO := 'Dados excluidos com sucesso.';
        COMMIT;
        
        EXCEPTION
          WHEN OTHERS THEN
            ROLLBACK;
               V_COD_RET := 500;
               V_RETORNO := 'Erro ao excluir dados: ' || SQLERRM;

      END; --M004

END PKG_LANCAMENTOS; --M001

-- ---------------------- Test ------------------------------------------
-- ---------------------- CRIAR -----------------------------------------
declare 
  V_ROW lancamento%ROWTYPE; --M001
  vData lancamento.data_vencimento%TYPE := sysdate; --M002
begin
  
  --V_ROW.codigo := 1;
  V_ROW.codigo := seq_lancamento.nextval; --M003
  V_ROW.descricao := 'Teste'; --M001
  V_ROW.data_vencimento := vData; --M002
  V_ROW.data_pagamento := sysdate; --M001
  V_ROW.valor := 100.00; --M001
  V_ROW.observacao := 'OBS teste'; --M001
  V_ROW.tipo := 'DESPESA'; --M001
  V_ROW.codigo_categoria := 1; --M001
  V_ROW.codigo_pessoa := 1; --M001
 
   pkg_lancamentos.criar(v_row => v_row, --M001
                        v_cod_ret => :v_cod_ret, --M003
                        v_retorno => :v_retorno); --M003
end; --M001

-- ---------------------- VALIDAR_CODIGO -----------------------------------------
declare
V_CODIGO LANCAMENTO.CODIGO%TYPE := 3;
begin
  :result := pkg_lancamentos.validar_codigo(p_codigo => V_CODIGO);
end; --M004

-- ---------------------- EXCLUIR -----------------------------------------
declare
V_CODIGO LANCAMENTO.CODIGO%TYPE := 3;
begin
  pkg_lancamentos.excluir(p_codigo => V_CODIGO,
                          v_cod_ret => :v_cod_ret,
                          v_retorno => :v_retorno);
end; --M004
