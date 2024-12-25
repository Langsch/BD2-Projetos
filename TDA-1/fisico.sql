CREATE TABLE Eleicao (
    ID INT PRIMARY KEY,
    Nome VARCHAR(255),
    Ano INT
);

CREATE TABLE Cargo (
    ID INT PRIMARY KEY,
    Nome VARCHAR(255)
);

CREATE TABLE Candidato (
    Matricula INT PRIMARY KEY,
    Nome VARCHAR(255),
    DataNascimento DATE,
    CPF VARCHAR(11),
    RG VARCHAR(20),
    CargoID INT,
    FOREIGN KEY (CargoID) REFERENCES Cargo(ID)
);

CREATE TABLE Zona (
    ID INT PRIMARY KEY,
    Nome VARCHAR(255)
);

CREATE TABLE Secao (
    ID INT PRIMARY KEY,
    Nome VARCHAR(255),
    ZonaID INT,
    FOREIGN KEY (ZonaID) REFERENCES Zona(ID)
);

CREATE TABLE Eleitor (
    TituloEleitor INT PRIMARY KEY,
    Nome VARCHAR(255),
    CPF VARCHAR(11),
    RG VARCHAR(20),
    ZonaID INT,
    SecaoID INT,
    FOREIGN KEY (ZonaID) REFERENCES Zona(ID),
    FOREIGN KEY (SecaoID) REFERENCES Secao(ID)
);

CREATE TABLE Mesario (
    ID INT PRIMARY KEY,
    EleitorID INT,
    ZonaID INT,
    SecaoID INT,
    FOREIGN KEY (EleitorID) REFERENCES Eleitor(TituloEleitor),
    FOREIGN KEY (ZonaID) REFERENCES Zona(ID),
    FOREIGN KEY (SecaoID) REFERENCES Secao(ID)
);

CREATE TABLE Voto (
    ID INT PRIMARY KEY,
    EleicaoID INT,
    SecaoID INT,
    CandidatoID INT,
    TipoVoto VARCHAR(10) CHECK (TipoVoto IN ('Branco', 'Nulo', 'Valido')),
    FOREIGN KEY (EleicaoID) REFERENCES Eleicao(ID),
    FOREIGN KEY (SecaoID) REFERENCES Secao(ID),
    FOREIGN KEY (CandidatoID) REFERENCES Candidato(Matricula)
);

CREATE TABLE Resultado (
    ID INT PRIMARY KEY,
    EleicaoID INT,
    CargoID INT,
    CandidatoID INT,
    SecaoID INT,
    ZonaID INT,
    Turno INT,
    TotalVotos INT,
    FOREIGN KEY (EleicaoID) REFERENCES Eleicao(ID),
    FOREIGN KEY (CargoID) REFERENCES Cargo(ID),
    FOREIGN KEY (CandidatoID) REFERENCES Candidato(Matricula),
    FOREIGN KEY (SecaoID) REFERENCES Secao(ID),
    FOREIGN KEY (ZonaID) REFERENCES Zona(ID)
);
