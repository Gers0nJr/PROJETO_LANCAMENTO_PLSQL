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
