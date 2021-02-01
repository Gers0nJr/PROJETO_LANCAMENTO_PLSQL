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
-- ---------------------- Package Body V4------------------------------------------

CREATE OR REPLACE PACKAGE BODY PKG_LANCAMENTOS AS

  /*FUNCTION VALIDAR_CODIGO(
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
  end;*/
  
  /*FUNCTION VALIDAR_CODIGO(
      P_CODIGO IN LANCAMENTO.CODIGO%TYPE, 
      V_COD_RET OUT NUMBER,
      V_RETORNO OUT VARCHAR2
      ) 
      return LANCAMENTO.CODIGO%TYPE IS
      
      V_CODIGO LANCAMENTO.CODIGO%TYPE := 0;
      
  begin
    
    select * BULK COLLECT into t_lancamento from lancamento l where l.codigo = P_CODIGO;
    
    FOR i IN 1 .. t_lancamento.COUNT  
    LOOP
        V_CODIGO := t_lancamento(i).codigo;
    END LOOP; 
    
    if t_lancamento.COUNT > 0 then
      RAISE msg_geral;   
    else
      RAISE msg_erro;
    end if;
    
    return V_CODIGO;
    
     EXCEPTION
        WHEN msg_geral THEN
            V_COD_RET := 200;
            V_RETORNO := 'COD: ' || P_CODIGO || ' encontrado.';
            return V_CODIGO;
        WHEN msg_erro THEN
            V_COD_RET := 500;
            V_RETORNO := 'COD: ' || P_CODIGO || ' não encontrado: ' || SQLERRM;  
            return V_CODIGO;      
  end;*/
  
  FUNCTION VALIDAR_CODIGO(
      P_CODIGO IN LANCAMENTO.CODIGO%TYPE
      ) 
      return BOOLEAN IS 
  BEGIN
    select * BULK COLLECT into t_lancamento from lancamento l where l.codigo = P_CODIGO;
    if t_lancamento.COUNT > 0 then
      return true;   
    else
      return false;
    end if;
  END;

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

        V_COD_RET := 201; --M003
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
        
         if pkg_lancamentos.validar_codigo(P_CODIGO) then        
           delete from lancamento t where t.codigo = P_CODIGO;
            V_COD_RET := 200; 
            V_RETORNO := 'Dados excluidos com sucesso.';
            COMMIT;
            
         else
            raise msg_erro;        
         end if;
         
         EXCEPTION
          WHEN msg_erro THEN
              ROLLBACK;
              V_COD_RET := 500;
              V_RETORNO := 'Erro ao excluir dados, codigo: ' || P_CODIGO || ' não existe: ' || SQLERRM;
         
         /*EXCEPTION
              WHEN OTHERS THEN
                ROLLBACK;
                   V_COD_RET := 500;
                   V_RETORNO := 'Erro ao excluir dados: ' || SQLERRM;*/
         
      END;
      
      PROCEDURE ATUALIZAR(P_CODIGO IN LANCAMENTO.CODIGO%TYPE,
        V_ROW IN LANCAMENTO%ROWTYPE,
        V_COD_RET OUT NUMBER,
        V_RETORNO OUT VARCHAR2) is
        
        BEGIN
          
          if pkg_lancamentos.validar_codigo(P_CODIGO) then        
         update lancamento set  descricao = V_ROW.descricao,
                                data_vencimento = V_ROW.data_vencimento,
                                data_pagamento =  V_ROW.data_pagamento,
                                valor = V_ROW.valor,
                                observacao = V_ROW.observacao,
                                tipo = V_ROW.tipo,
                                codigo_categoria = V_ROW.codigo_categoria,
                                codigo_pessoa = V_ROW.codigo_pessoa
                                where codigo = P_CODIGO;
            V_COD_RET := 200; 
            V_RETORNO := 'Dados atualizados com sucesso.';
            COMMIT;
            
         else
            raise msg_erro;        
         end if;
         
         EXCEPTION
          WHEN msg_erro THEN
              ROLLBACK;
              V_COD_RET := 500;
              V_RETORNO := 'Erro ao editar dados, codigo: ' || P_CODIGO || ' não encontrado: ' || SQLERRM;
              
        END;
 
END PKG_LANCAMENTOS; --M001
