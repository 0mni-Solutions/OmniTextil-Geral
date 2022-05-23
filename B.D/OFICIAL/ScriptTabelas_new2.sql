CREATE DATABASE omni_textil;
USE omni_textil;

CREATE TABLE Empresa (
idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
nomeEmpresa VARCHAR(45),
responsavel VARCHAR(70),
cadastroEmpresa DATE
);

CREATE TABLE Usuario (
idUsuario INT PRIMARY KEY AUTO_INCREMENT,
fkEmpresa INT, 
FOREIGN KEY (fkEmpresa) REFERENCES Empresa(idEmpresa),
fkAdmin INT, 
FOREIGN KEY (fkAdmin) REFERENCES Usuario(idUsuario),
nomeUsuario VARCHAR(80),
email VARCHAR(60),
senha VARCHAR(40),
cargo CHAR(5) CONSTRAINT chkCargo 
CHECK (cargo = 'ADMIN' or cargo = 'COMUM'),
cadastroUsuario TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Endereco (
idEndereco INT PRIMARY KEY AUTO_INCREMENT,
estado CHAR(2),
cidade VARCHAR(30),
bairro VARCHAR(25),
rua VARCHAR(45),
numero INT
);

CREATE TABLE Unidade (
idUnidade INT PRIMARY  KEY AUTO_INCREMENT,
fkEmpresa INT, 
FOREIGN KEY (fkEmpresa) REFERENCES Empresa(idEmpresa),
fkEndereco INT, 
FOREIGN KEY (fkEndereco) REFERENCES Endereco(idEndereco),
nomeUnidade VARCHAR(15),
fusoHorario CHAR(5) CONSTRAINT chkFuso 
CHECK (fusoHorario IN('GMT-2', 'GMT-3', 'GMT-4', 'GMT-5'))
);

CREATE TABLE Localidade (
idLocalidade INT PRIMARY KEY AUTO_INCREMENT,
descricao VARCHAR(50)
);

CREATE TABLE Setor (
idSetor INT AUTO_INCREMENT,
fkUnidade INT, 
FOREIGN KEY (fkUnidade) REFERENCES Unidade(idUnidade),
fkLocalidade INT, 
FOREIGN KEY (fkLocalidade) REFERENCES Localidade(idLocalidade),
PRIMARY KEY (idSetor, fkUnidade, fkLocalidade),
nomeSetor CHAR(6)
);

CREATE TABLE Sensor (
idSensor INT PRIMARY KEY AUTO_INCREMENT,
fkUnidade INT,
FOREIGN KEY (fkUnidade) REFERENCES Unidade(idUnidade),
fkSetor INT, 
FOREIGN KEY (fkSetor) REFERENCES Setor(idSetor),
fkLocalidade INT, 
FOREIGN KEY (fkLocalidade) REFERENCES Localidade(idLocalidade)
);

CREATE TABLE Dados (
idDados INT PRIMARY KEY AUTO_INCREMENT,
fkSensor INT, 
FOREIGN KEY (fkSensor) REFERENCES Sensor(idSensor),
temperatura INT,
umidade INT,
data_hora DATETIME   
);

-- INSERTS INICIAIS
-- EMPRESA
INSERT INTO Empresa VALUES
(1, 'SPTech', 'Alessandro Goulart', '2022-03-15'),
(2, 'Valtex', 'Breno Gomes', '2022-02-22');
SELECT * FROM Empresa;

-- USUARIO
INSERT INTO Usuario VALUES
(NULL, 1, NULL, 'SPTECH', 'contato@sptech.com', 'sptech', 'ADMIN', DEFAULT),
(NULL, 1, 1, 'Fernando Brandão', 'fernando.brandao@sptech.com', 'sptech', 'ADMIN', DEFAULT),
(NULL, 1, 2, 'Marco Rover', 'marco.rover@sptech.com', 'sptech', 'COMUM', DEFAULT),

(NULL, 2, NULL, 'VALTEX', 'valtexsbc@uol.com.br', 'valtex159753', 'ADMIN', DEFAULT),
(NULL, 2, 4, 'Rafael Larucci', 'rafael.lara@valtex.com.br', 'rafavaltex123', 'COMUM', DEFAULT);
SELECT * FROM Usuario;

-- ENDEREÇO
INSERT INTO Endereco VALUES
(NULL, 'SP', 'São Paulo', 'Cerqueira César', 'Rua Haddock Lobo', 595),
(NULL, 'SP', 'São Bernardo do Campo', 'Vila Flórida', 'Rua Ranieri Mazzilli', 50),
(NULL, 'MG', 'Montes Claros', 'Vila Regina', 'Av. Dr. Sidney Chaves', 300),
(NULL, 'AM', 'Manaus', 'Distrito Industrial I', 'Av. Guaruba', 200);
SELECT * FROM Endereco;

-- UNIDADE
INSERT INTO Unidade VALUES
(NULL, 1, 1, 'Matriz-Paulista', 'GMT-3'),
(NULL, 2, 2, 'Matriz-ABC', 'GMT-3'),
(NULL, 1, 3, 'Unidade-MG', 'GMT-3'),
(NULL, 2, 4, 'Filial-AM', 'GMT-4');
SELECT * FROM Unidade;

-- LOCALIDADE
INSERT INTO Localidade VALUES
(NULL, 'Ala norte'),
(NULL, 'Ala sul'),
(NULL, 'Ala leste'),
(NULL, 'Ala oeste');
SELECT * FROM Localidade;

-- SETOR
INSERT INTO Setor VALUES
(NULL, 1, 4, 'SetorA'),
(NULL, 1, 3, 'SetorB'),
(NULL, 2, 1, 'SetorA'),
(NULL, 3, 2, 'SetorA'),
(NULL, 3, 3, 'SetorB'),
(NULL, 4, 1, 'SetorA');
SELECT * FROM Setor;

-- SENSOR 
INSERT INTO Sensor VALUES
(NULL, 2, 1, 1),
(NULL, 1, 2, 2);
SELECT * FROM Sensor;

INSERT INTO Dados VALUES 
(NULL, 1, 25, 17, '2022-05-23 11:11:11'),
(NULL, 1, 23, 18, '2022-05-24 11:13:11'),
(NULL, 1, 21, 19, '2022-05-25 11:14:11'),
(NULL, 2, 19, 17, '2022-05-23 11:11:11'),
(NULL, 2, 23, 18, '2022-05-26 11:12:11');
SELECT * FROM Dados;

SELECT * FROM Dados JOIN Sensor ON idSensor = fkSensor;

-- SELECT DE TODOS OS DADOS DE TODOS OS SENSORES DE UM SETOR ESPECIFICO;

SELECT * FROM Dados JOIN Sensor ON idSensor = fkSensor JOIN Setor ON idSetor = fkSetor WHERE idSetor = 1;

SELECT AVG(Temperatura) , fksensor, fksetor FROM Dados JOIN Sensor ON idSensor = fkSensor JOIN Setor ON idSetor = fkSetor WHERE idSetor = 1;

SELECT AVG(Umidade) , fksensor, fksetor FROM Dados JOIN Sensor ON idSensor = fkSensor JOIN Setor ON idSetor = fkSetor WHERE idSetor = 2;

INSERT INTO Dados VALUES 
(NULL, 1, 21, 19, '2022-05-25 11:14:11'),
(NULL, 1, 24, 15, '2022-05-25 11:14:11'),
(NULL, 1, 26, 13, '2022-05-25 11:14:11');


SELECT AVG(Umidade) , fksensor, fksetor FROM Dados JOIN Sensor ON idSensor = fkSensor JOIN Setor ON idSetor = fkSetor WHERE idSetor = 2;

-- AGRUPAR AS MEDIAS DE ACORDO COM OS HORARIOS

SELECT AVG(Temperatura) , HOUR( data_hora ) FROM Dados JOIN Sensor ON idSensor = fkSensor JOIN Setor ON idSetor = fkSetor WHERE idSetor = 1 AND DATE_SUB(  data_hora , INTERVAL 1 HOUR ) GROUP BY HOUR( data_hora );

-- AGRUPAR AS MEDIAS DE ACORDO COM O DIA

SELECT AVG (temperatura), AVG (umidade), fkSensor, DATE_FORMAT(data_hora, '%D:%M') AS momento_grafico from dados WHERE fkSensor = 1;








