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
-- Data   : 27/01/2021
-- Descr. : Adicionando codigo no retorno proc

-- ---------------------- Package ------------------------------------------

CREATE OR REPLACE PACKAGE PKG_LANCAMENTOS AS
       
    PROCEDURE CRIAR(V_ROW IN LANCAMENTO%ROWTYPE, --M001
        V_COD_RET OUT NUMBER,  --M003
        V_RETORNO OUT VARCHAR2); --M003

END PKG_LANCAMENTOS;


-- ---------------------- Package Body ------------------------------------------

CREATE OR REPLACE PACKAGE BODY PKG_LANCAMENTOS AS

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

END PKG_LANCAMENTOS; --M001

-- ---------------------- Test ------------------------------------------

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

-- ---------------------------------------------------------------------------
