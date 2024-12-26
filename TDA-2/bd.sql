CREATE TABLE Usuario (
    ID SERIAL PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    "login" VARCHAR(50) NOT NULL UNIQUE,
    IP VARCHAR(15) NOT NULL
);

CREATE TABLE Algoritmo (
    Id SERIAL PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Tipo VARCHAR(50) NOT NULL,
    Complexidade INT NOT NULL
);

CREATE TABLE Treinamento (
    UsuarioID INT REFERENCES Usuario(ID),
    AlgId INT REFERENCES Algoritmo(Id),
    "Data" DATE NOT NULL,
    Dataset VARCHAR(255) NOT NULL,
    PRIMARY KEY (UsuarioID, AlgId, "Data")
);

CREATE TABLE Modelo (
    Id SERIAL PRIMARY KEY,
    UsuarioID INT REFERENCES Usuario(ID),
    AlgId INT REFERENCES Algoritmo(Id),
    "Data" DATE NOT NULL,
    "Path" VARCHAR(255) NOT NULL,
    FOREIGN KEY (UsuarioID, AlgId, "Data") REFERENCES Treinamento(UsuarioID, AlgId, "Data")
);
