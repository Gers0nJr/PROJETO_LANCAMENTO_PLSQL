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

-- ---------------------- Package V5------------------------------------------

CREATE OR REPLACE PACKAGE PKG_LANCAMENTOS AS

    msg_geral EXCEPTION;
    msg_erro EXCEPTION;

    TYPE rows IS TABLE OF lancamento%ROWTYPE 
    INDEX BY PLS_INTEGER;
    
    t_lancamento rows;
    
    /*FUNCTION VALIDAR_CODIGO(
      P_CODIGO IN LANCAMENTO.CODIGO%TYPE) 
      return LANCAMENTO.DESCRICAO%TYPE;*/
      
    /*FUNCTION VALIDAR_CODIGO(
      P_CODIGO IN LANCAMENTO.CODIGO%TYPE, 
      V_COD_RET OUT NUMBER,
      V_RETORNO OUT VARCHAR2
      ) 
      return LANCAMENTO.CODIGO%TYPE;*/
      
      FUNCTION VALIDAR_CODIGO(
      P_CODIGO IN LANCAMENTO.CODIGO%TYPE
      ) 
      return BOOLEAN;
       
    PROCEDURE CRIAR(V_ROW IN LANCAMENTO%ROWTYPE, --M001
        V_COD_RET OUT NUMBER,  --M003
        V_RETORNO OUT VARCHAR2); --M003
  
    PROCEDURE EXCLUIR(P_CODIGO IN LANCAMENTO.CODIGO%TYPE,
        V_COD_RET OUT NUMBER,
        V_RETORNO OUT VARCHAR2);
        
     PROCEDURE ATUALIZAR(P_CODIGO IN LANCAMENTO.CODIGO%TYPE,
        V_ROW IN LANCAMENTO%ROWTYPE,
        V_COD_RET OUT NUMBER,
        V_RETORNO OUT VARCHAR2);
        
     PROCEDURE BUSCAR_POR_CODIGO(P_CODIGO IN LANCAMENTO.CODIGO%TYPE,
        listaLancamento out clob,
        P_COD_RET OUT NUMBER,
        P_RETORNO OUT VARCHAR2);
    
END PKG_LANCAMENTOS;
