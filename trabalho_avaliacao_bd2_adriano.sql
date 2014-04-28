create table clientes (
cpf char(11),
nome varchar(40),
endereco varchar(60),
cidade varchar(40),
uf char(2),
cep varchar(20),
telefone varchar(10),
data_cadastro date,
data_nascimento date
);

create table funcionarios (
cpf char(11),
nome varchar(40),
endereco varchar(60),
cidade varchar(40),
uf char(2),
cep varchar(20),
telefone varchar(10),
data_admissao date,
data_nascimento date
);

create table produtos (
codigo_produto varchar(10),
nome varchar(40) unique,
unidade varchar(20),
quantidade integer,
preco_unitario decimal(10,2),
estoque_minimo integer,
estoque_maximo integer
);

create table vendas (
codigo_venda varchar(10),
data_venda date,
cpf_cliente char(11),
cpf_funcionario char(11)
);

create table vendas_itens (
codigo_item char(10),
codigo_venda char(10),
codigo_produto char(10),
quantidade_item integer
);

create table bonus (
codigo_bonus char(10),
cpf_cliente char(11),
codigo_venda char(10),
bonus numeric(10,2)
);

create table comissoes (
codigo_comissao char(10),
cpf_funcionario char(11),
codigo_venda char(10),
comissao numeric(10,2)
);


alter table clientes add constraint cliente_cpf_pk primary key(cpf);
alter table funcionarios add constraint funcionario_cpf_pk primary key(cpf);
alter table produtos add constraint codigo_prod_pk primary key(codigo_produto);
alter table vendas add constraint codigo_venda_pk primary key(codigo_venda);
alter table vendas add constraint cliente_cpf_fk foreign key(cpf_cliente) references clientes(cpf);
alter table vendas add constraint funcionario_cpf_fk foreign key(cpf_funcionario) references funcionarios(cpf);
alter table vendas_itens add constraint codigo_item_pk primary key(codigo_item);
alter table vendas_itens add constraint codigo_venda_fk foreign key(codigo_venda) references vendas(codigo_venda)
alter table vendas_itens add constraint codigo_produto_fk foreign key(codigo_produto) references produtos(codigo_produto)
alter table bonus add constraint codigo_bonus_pk primary key(codigo_bonus);
alter table bonus add constraint cliente_cpf_bonus_fk foreign key(cpf_cliente) references clientes(cpf);
alter table bonus add constraint codigo_venda_bonus_fk foreign key(codigo_venda) references vendas(codigo_venda);
alter table comissoes add constraint codigo_comissao_pk primary key(codigo_comissao);
alter table comissoes add constraint comissao_venda_fk foreign key(codigo_venda) references vendas(codigo_venda);
alter table comissoes add constraint funcionario_cpf_fk foreign key(cpf_funcionario) references funcionarios(cpf);                       
alter table clientes drop constraint cliente_cpf_pk cascade;
alter table clientes add constraint clientes_pk primary key(cpf);
alter table vendas add constraint vendas_cliente_fk foreign key(cpf_cliente) references clientes(cpf);
alter table bonus add constraint bonus_cliente_fk foreign key(cpf_cliente) references clientes(cpf);

alter table produtos alter column preco_unitario set not null;

alter table produtos add check (estoque_minimo > 0);

alter table produtos rename column nome to descricao;

alter table clientes rename to clientes2;
alter table clientes2 rename to clientes;

alter table produtos alter column quantidade type numeric(12,2);


insert into clientes values ('11234567891','Carlos Bezerra','Rua Brasil, 7878','Porto Alegre','RS','99887744','1234567812','19/12/2013','16/05/1971'),
       ('85274196378','Souza Peres','Rua Bonamassa,  990','Porto Alegre','RS','91256060','5241789842','05/05/2012','25/12/1968'),
       ('78945612345','Guilherme','Rua Merege, 3231','Porto Alegre','RS','91235187','1597531234','14/05/2011','23/12/1985'),
       ('75315945210','Juliana','Rua Nonoai, 1233','Porto Alegre','RS','91235487','1020305040','12/08/2010','01/01/1899');
select * from clientes;

insert into funcionarios values ('16565646545','Verdoze Soares','Rua Morche, 2310','Porto Alegre','RS','82561040','912454142','06/06/2000','02/05/1972'),
           ('12903912319','Jesus Nscimento Morto','Rua Azulado, 12320','Porto Alegre','RS','81020501','912545515','05/02/2001','09/04/1969'),
    ('78231283713','May Feel Goodmann','Rua Melhoresa, 9092','Porto Alegre','RS','82050100','916216576','17/10/2001','05/05/1983');
select * from funcionarios;

insert into produtos values (01,'Tubo','10',15,'45.50','2','25'),
       (02,'Caixa','20',23,'75.50','5','55'),
       (03,'Prendedor','30',37,'50.00','5','35');
select * from produtos;

insert into vendas values (01,'12/05/2014','11234567891','12903912319'),
     (02,'07/05/2014','85274196378','78231283713'),
     (03,'02/05/2014','78945612345','16565646545');
select * from vendas;

insert into vendas_itens values (2,2,3,2),
                                (1,1,2,4),
    (3,3,2,5);
select * from vendas_itens;

insert into bonus values (01,'78945612345',01,'10.00'),
    (02,'85274196378',03,'7.00'),
    (03,'78945612345',02,'8.00'),
                         (04,'78945612345',01,'15.00'),
    (05,'75315945210',03,'17.00'),
    (06,'11234567891',02,'28.00'),
    (07,'75315945210',01,'23.00');

select * from bonus;

insert into comissoes values (01,'12903912319',02,'6.00'),
        (02,'78231283713',03,'7.50'),
        (03,'16565646545',01,'5.00'),
                             (04,'12903912319',02,'12.00'),
        (05,'12903912319',02,'17.50'),
        (06,'16565646545',02,'25.00');
select * from comissoes

--	 Criar uma view que retorne o bônus de cada Cliente

create or replace view bonus_cliente (clientes, bonus) as select bonus.cpf_cliente as cpf, bonus.bonus as bonus 
		       from bonus, clientes
		       where bonus.cpf_cliente = clientes.cpf
		       order by bonus.cpf_cliente desc

select * from bonus_cliente 		     

--	Criar uma view que retorne as comissões de cada funcionário

create or replace view comissao_funcionario (funcionarios, comissoes) as select cpf_funcionario as funcionario, comissoes as comissao
		       from comissoes, funcionarios
		       where funcionarios.cpf = comissoes.cpf_funcionario
		       order by comissoes.cpf_funcionario

	       
select * from comissao_funcionario		       

--	Criar uma função que guarde a soma dos bônus por cliente. Receberá um cliente(cpf) e retornará sua soma

create or replace function soma_bonus (varchar) returns decimal as
$$
declare
bonuscli decimal(10,2);
begin
 select into bonuscli sum(bonus) from bonus where cpf_cliente = $1;
 return bonuscli;
end;
$$ language 'plpgsql';

select soma_bonus('11234567891');



--	Criar uma função que retorne guarde a soma das comissões por funcionário. Receberá um funcionário (cpf)  e retornará sua soma;

create or replace function comissao_soma (varchar) returns decimal as
$$
declare
comissao_func decimal (10,2);
begin
	select into comissao_func sum(comissao) from comissoes where cpf_funcionario =$1;
	return comissao_func;
end;
$$ language 'plpgsql';

select comissao_soma('16565646545')


--	Criar uma transação com o bloco:
	-- Venda e Atualização do estoque,
	-- Atualização do bônus do cliente,
	-- Atualização da comissão do vendedor


begin;

update produtos set codigo_produto = 1
		where produtos.quantidade = quantidade - 2;

savepoint produtos_quantidade;

update bonus set bonus = 20
	     where bonus.cpf_cliente = '11234567891';

savepoint bonus_cliente;

update comissoes set comissao = 30
		 where comissoes.cpf_funcionario = '16565646545';

savepoint comissoes_funcionario;

commit;


--	Faça uma função para Consultar qual o produto mais caro

create or replace function produto_caro() returns setof record as
$$

begin
	return query select max(preco_unitario) from produtos
	group by preco_unitario limit 1;
	return;

end;

$$language 'plpgsql';

drop function produto_caro()

select * from produto_caro() as (preco_unitario decimal);



--	Faça uma função para Consultar qual o produto e o mais barato;

create or replace function produto_barato() returns setof record as
$$
begin
	return query select preco_unitario from produtos
	order by preco_unitario asc limit 1;
end;

$$language 'plpgsql';

drop function produto_barato()

select * from produto_barato() as (preco_unitario decimal);


--	Faça uma função para mostrar qual o cliente mais antigo;

create or replace function cliente_antigo() returns setof record as
$$
begin
	return query select data_cadastro from clientes order by data_cadastro asc limit 1;
end;

$$language 'plpgsql';

drop function cliente_antigo()

select * from cliente_antigo() as (data_cadastro date);


--	Faça uma função que consulte qual o cliente que não tem bônus e o remova da tabela

insert into clientes values ('56293850681','Ronaldo Nazario','Rua Angra, 7698','Porto Alegre','RS','90473614','5443554878','29/10/2014','16/06/1978');

insert into vendas values (04,'12/05/2014','56293850681','12903912319');

insert into bonus values (08,'56293850681',04,'0');


create or replace function cliente_sem_bonus () returns setof record as
$$
begin 
	return query select cpf_cliente from bonus where bonus = 0;

	delete from bonus where bonus = '0'; 
end;

$$language 'plpgsql';

drop function cliente_sem_bonus();

select * from cliente_sem_bonus() as (cpf_cliente char(11));


--	Faça uma view que mostre as vendas por  cliente

create or replace view venda_por_cliente(vendas, clientes) as select vendas.codigo_venda as venda, clientes.cpf as cliente 
		       from vendas, clientes
		       where vendas.cpf_cliente = clientes.cpf
		       order by vendas.codigo_venda

drop view venda_por_cliente

select * from venda_por_cliente


--	Faça uma função que mostre as vendas de um cliente  Parâmetro de entrada (cpf)


create or replace function vendas_de_cliente (char(11)) returns 
table (cliente char(11), codigo_vendas varchar(40)) as
$$
begin
	return query select clientes.cpf, vendas.codigo_venda from vendas, clientes
	where clientes.cpf = vendas.cpf_cliente
	and vendas.cpf_cliente=$1;
	
end;
$$language 'plpgsql';

drop function vendas_de_cliente(char)

select vendas_de_cliente('85274196378')