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
