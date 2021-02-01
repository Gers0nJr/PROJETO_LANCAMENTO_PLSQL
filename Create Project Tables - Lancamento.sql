-- ---------------------- Historico de Manutencao ------------------------------------------

-- Versao : M001
-- Autor  : Gerson Batista
-- Data   : 27/01/2021
-- Descr. : Criando Projeto

-- ---------------------- Create Tables ------------------------------------------

==============================================================================================================
CREATE TABLE categoria
(
 codigo INT NOT NULL,
 NOME VARCHAR2(50) NOT NULL,
 PRIMARY KEY (codigo)
); --M001

==============================================================================================================

CREATE SEQUENCE seq_categoria
 START WITH     1
 INCREMENT BY   1
 NOCACHE; --M001

==============================================================================================================

INSERT INTO categoria (codigo, nome) values (1, 'Lazer'); --M001
INSERT INTO categoria (codigo, nome) values (2, 'Alimentação'); --M001
INSERT INTO categoria (codigo, nome) values (3, 'Supermercado'); --M001
INSERT INTO categoria (codigo, nome) values (4, 'Farmácia'); --M001
INSERT INTO categoria (codigo, nome) values (5, 'Outros'); --M001

==============================================================================================================

CREATE TABLE pessoa (
  codigo INT not null primary key,
  nome VARCHAR(50) NOT NULL,
  logradouro VARCHAR(30),
  numero VARCHAR(30),
  complemento VARCHAR(30),
  bairro VARCHAR(30),
  cep VARCHAR(30),
  cidade VARCHAR(30),
  estado VARCHAR(30),
  ativo SMALLINT NOT NULL
); --M001

==============================================================================================================

CREATE SEQUENCE seq_pessoa
 START WITH     1
 INCREMENT BY   1
 NOCACHE; --M001

==============================================================================================================

INSERT INTO pessoa (codigo, nome, logradouro, numero, complemento, bairro, cep, cidade, estado, ativo) 
 values (seq_pessoa.nextval,'João Silva', 'Rua do Abacaxi', 
 '10', null, 'Brasil', '38.400-121', 'Uberlândia', 'MG', 1); --M001

==============================================================================================================

CREATE TABLE lancamento (
  codigo int not null PRIMARY KEY,
  descricao VARCHAR(50) NOT NULL,
  data_vencimento DATE NOT NULL,
  data_pagamento DATE,
  valor DECIMAL(10,2) NOT NULL,
  observacao VARCHAR(100),
  tipo VARCHAR(20) NOT NULL,
  codigo_categoria int NOT NULL,
  codigo_pessoa int NOT NULL,
  FOREIGN KEY (codigo_categoria) REFERENCES categoria(codigo),
  FOREIGN KEY (codigo_pessoa) REFERENCES pessoa(codigo)
); --M001

==============================================================================================================

CREATE SEQUENCE seq_lancamento
 START WITH     1
 INCREMENT BY   1
 NOCACHE; --M001
 
==============================================================================================================

INSERT INTO lancamento 
(codigo, descricao, data_vencimento, data_pagamento, valor, observacao, tipo, codigo_categoria, codigo_pessoa) 
values (seq_lancamento.nextval,'Salário mensal', sysdate, null, 6500.00, 'Distribuição de lucros', 'RECEITA', 1, 1); --M001

==============================================================================================================

CREATE TABLE usuario (
	codigo int not null PRIMARY KEY,
	nome VARCHAR(50) NOT NULL,
	email VARCHAR(50) NOT NULL,
	senha VARCHAR(150) NOT NULL
); --M001

==============================================================================================================

CREATE SEQUENCE seq_usuario
 START WITH     1
 INCREMENT BY   1
 NOCACHE; --M001
 
==============================================================================================================

INSERT INTO usuario (codigo, nome, email, senha) 
values (1, 'Administrador', 'admin@algamoney.com', '$2a$10$X607ZPhQ4EgGNaYKt3n4SONjIv9zc.VMWdEuhCuba7oLAL5IvcL5.'); --M001

==============================================================================================================

CREATE TABLE permissao (
	codigo int not null PRIMARY KEY,
	descricao VARCHAR(50) NOT NULL
); --M001

==============================================================================================================

CREATE SEQUENCE seq_permissao
 START WITH     1
 INCREMENT BY   1
 NOCACHE; --M001
 
==============================================================================================================

INSERT INTO permissao (codigo, descricao) values (1, 'ROLE_CADASTRAR_CATEGORIA'); --M001
INSERT INTO permissao (codigo, descricao) values (2, 'ROLE_PESQUISAR_CATEGORIA'); --M001

INSERT INTO permissao (codigo, descricao) values (3, 'ROLE_CADASTRAR_PESSOA'); --M001
INSERT INTO permissao (codigo, descricao) values (4, 'ROLE_REMOVER_PESSOA'); --M001
INSERT INTO permissao (codigo, descricao) values (5, 'ROLE_PESQUISAR_PESSOA'); --M001

INSERT INTO permissao (codigo, descricao) values (6, 'ROLE_CADASTRAR_LANCAMENTO'); --M001
INSERT INTO permissao (codigo, descricao) values (7, 'ROLE_REMOVER_LANCAMENTO'); --M001
INSERT INTO permissao (codigo, descricao) values (8, 'ROLE_PESQUISAR_LANCAMENTO'); --M001

==============================================================================================================

CREATE TABLE usuario_permissao (
	codigo_usuario int not null,
	codigo_permissao int NOT NULL,
	PRIMARY KEY (codigo_usuario, codigo_permissao),
	FOREIGN KEY (codigo_usuario) REFERENCES usuario(codigo),
	FOREIGN KEY (codigo_permissao) REFERENCES permissao(codigo)
); --M001

==============================================================================================================

INSERT INTO usuario_permissao (codigo_usuario, codigo_permissao) values (1, 1); --M001
INSERT INTO usuario_permissao (codigo_usuario, codigo_permissao) values (1, 2); --M001
INSERT INTO usuario_permissao (codigo_usuario, codigo_permissao) values (1, 3); --M001
INSERT INTO usuario_permissao (codigo_usuario, codigo_permissao) values (1, 4); --M001
INSERT INTO usuario_permissao (codigo_usuario, codigo_permissao) values (1, 5); --M001
INSERT INTO usuario_permissao (codigo_usuario, codigo_permissao) values (1, 6); --M001
INSERT INTO usuario_permissao (codigo_usuario, codigo_permissao) values (1, 7); --M001
INSERT INTO usuario_permissao (codigo_usuario, codigo_permissao) values (1, 8); --M001

==============================================================================================================

select 
l.descricao,
l.data_vencimento,
l.valor,
l.observacao,
l.tipo,
c.nome as descricao
from lancamento l
inner join categoria c on l.codigo_categoria = c.codigo; --M001

==============================================================================================================
