create table aluno
(
cod serial PRIMARY KEY NOT NULL,
nomeAlun varchar(40) NOT NULL
)

create table disciplina
(
cod serial PRIMARY KEY NOT NULL,
nomeDisc varchar(40) NOT NULL
)

create table alunos
(
aluno_cod integer,
disciplina_cod integer,
frequencia varchar(10),
conceito numeric(10,2),
PRIMARY KEY(aluno_cod, disciplina_cod),
Constraint AlunoFK FOREIGN KEY(aluno_cod) references Aluno(cod),
Constraint DisciplinaFK FOREIGN KEY(disciplina_cod) references Disciplina(cod)
)

INSERT INTO aluno(nomeAlun) values ('Schwab'),
                                   ('Duarte'),
                                   ('Neto'),
								 ('Pedroso');

INSERT INTO disciplina(nomeDisc) values ('Portugues'),
                                        ('Espanhol'),
                                        ('Filosofia');
			   
INSERT INTO alunos(aluno_cod,disciplina_cod,frequencia,conceito) values (2,2,75,'9.2'),
                                                                        (1,2,54,'3.5'),
                                                                        (3,3,97,'9.8'),
                                                                        (4,1,87,'7.8'),
                                                                        (3,1,85,'9.8'),
                                                                        (2,1,79,'9.5');

/**Faça as Views que Mostre : 
 
• Todos os alunos de uma disciplina 
 
• Todas as disciplinas que um aluno está matriculado 
 
• A média dos conceitos de uma disciplina **/

create or replace view viwe_ALUNOS (Aluno,Disciplina) as select nomeAlun as aluno,nomeDisc as disciplina from aluno,disciplina,aludis
                         where aluno.cod = alunos.aluno_cod
                         and disciplina.cod = disciplina_cod
                         and disciplina.cod = 2;
select * from view_ALUNOS

create or replace view view_DISCIPLINA (aluno , disciplina) as select nomeAlun as aluno,nomeDisc as disciplina from aluno,disciplina,aludis
                         where aluno.cod = alunos.aluno_cod
                         and disciplina.cod = disciplina_cod
                         and alunos.aluno_cod = 2;
select * from view_DISCIPLINA

create or replace view view_MEDIA (disciplina,media) as select nomeDisc as disciplina, avg(conceito) as media from Alunos,Disciplina
                                                                  where disciplina.cod = alunos.disciplina_cod
                                                                  group by (disciplina.nomedisc);

                                 
select * from view_MEDIA
                    
                  


