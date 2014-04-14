create table pessoa(
idPessoa SERIAL PRIMARY KEY,
sexo char(1) NOT NULL,
nome varchar(80) NOT NULL,
sobrenome varchar(80) NOT NULL,
cpf char(11) NOT NULL,
idDeptoFK integer NOT NULL,
idFuncaoFK integer NOT NULL,
CONSTRAINT idDeptoFK FOREIGN KEY (idDeptoFK) REFERENCES departamentos ( idDepto ),
CONSTRAINT idFuncaoFK FOREIGN KEY (idFuncaoFK) REFERENCES funcoes ( idFuncao ));

drop table pessoa



create table departamentos(
idDepto SERIAL PRIMARY KEY,
departamento varChar(80));

drop table departamentos

insert into departamentos ( idDepto, departamento ) values ('1', 'Gerente'),
							   ('2', 'Programacao'),
						           ('3', 'Limpeza'),
						           ('4', 'Secretaria');
select * from departamentos


create table funcoes(
idFuncao SERIAL PRIMARY KEY,
funcao varChar(80));

drop table funcoes

insert into funcoes values(1,'Gerente de Projetos'),
			  (2,'Estagiário'),
			  (3, 'Programador'),
			  (4, 'Faxineiro'),
			  (5, 'Secretária');

select * from funcoes

alter table pessoa ADD salario decimal(10,2);

insert into pessoa ( sexo, nome, sobrenome, cpf, salario, idDeptoFK, idFuncaoFK ) values ('M', 'Adriano', 'Duarte' , '01234567891','5000', '1', '1'),
											 ('M', 'Henrique', 'Schwab' , '09876543210','2000', '2', '3'),
											 ('M', 'Ronaldo', 'Freitas', '12352014578', '900', '2', '2'),
											 ('F', 'Tami', 'Rochelle', '85214789652', '500', '3', '4'),
											 ('F', 'Barbara', 'Autenticadora', '96325874105', '900','4', '5');

select * from pessoa

--Function soma total do salario

CREATE OR REPLACE FUNCTION Total_Salario_Depto (integer) RETURNS decimal(10,2) AS $$

DECLARE 
	soma decimal(10,2);

BEGIN
	select into soma sum(salario) FROM pessoa, departamentos
			 WHERE pessoa.idDeptoFK = departamentos.idDepto
			 AND departamentos.idDepto = $1;
RETURN soma;
END;
$$ LANGUAGE 'plpgsql';

select * from Total_Salario_Depto(2);


--Function soma salario por funcao

CREATE OR REPLACE FUNCTION Total_Salario_Funcao (integer) RETURNS

TABLE (funcao varChar, total_soma decimal(10,2)) AS $$

BEGIN
	RETURN QUERY select funcoes.funcao,sum(salario) FROM pessoa, funcoes
		     WHERE funcoes.idFuncao = pessoa.idFuncaoFK
		     AND funcoes.idFuncao = $1 group by funcoes.funcao;
RETURN;
END;
$$ LANGUAGE 'plpgsql';

select * from Total_Salario_Funcao(2)

--Function mostra pessoas de cada depto

CREATE OR REPLACE FUNCTION Pessoas_Funcao (integer) RETURNS
TABLE ( nome varchar, depto varchar) AS $$

BEGIN
	RETURN QUERY SELECT pessoa.nome, departamentos.departamento FROM pessoa, departamentos
		     WHERE departamentos.idDepto = pessoa.idDeptoFK
		     AND departamentos.idDepto = $1;
RETURN;		     
END;
$$ LANGUAGE 'plpgsql'

select * from Pessoas_Funcao(2)


--Function mostra todas as pessoas de uma funcao

CREATE OR REPLACE FUNCTION Funcoes_Pessoa (integer) RETURNS
TABLE ( nome varchar, funcao varchar) AS $$

BEGIN
	RETURN QUERY SELECT pessoa.nome, funcoes.funcao FROM pessoa, funcoes
		     WHERE funcoes.idFuncao = pessoa.idFuncaoFK
		     AND funcoes.idFuncao = $1;
RETURN;		     
END;
$$ LANGUAGE 'plpgsql'

select * from Funcoes_Pessoa(2);



--Function mostra todos os departamentos de uma funcao

CREATE OR REPLACE FUNCTION Funcao_Depto ( integer ) RETURNS
TABLE ( depto varchar, funcao  varchar ) AS $$

BEGIN
	RETURN QUERY SELECT funcoes.funcao, departamentos.departamento FROM funcoes, departamentos
		     WHERE funcoes.idFuncao = departamentos.idDepto
		     AND funcoes.idFuncao = $1;
RETURN;
END;
$$ LANGUAGE 'plpgsql'		    

select * from Funcao_Depto(2);

