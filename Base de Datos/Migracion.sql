CREATE DATABASE Migracion;


-- Usar la base de datos recién creada
USE Migracion;


-- Crear la tabla Viajeros
CREATE TABLE Viajeros (
    ViajeroID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Apellido VARCHAR(100) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    Nacionalidad VARCHAR(50) NOT NULL,
    CONSTRAINT UQ_Viajero UNIQUE (Nombre, Apellido, FechaNacimiento),
    CONSTRAINT CHK_FechaNacimiento CHECK (FechaNacimiento < GETDATE())
);

-- Crear la tabla Documentos
CREATE TABLE Documentos (
    DocumentoID INT IDENTITY(1,1) PRIMARY KEY,
    ViajeroID INT NOT NULL,
    TipoDocumento VARCHAR(50) NOT NULL,
    NumeroDocumento VARCHAR(50) NOT NULL,
    FechaExpedicion DATE NOT NULL,
    FechaVencimiento DATE NOT NULL,
    CONSTRAINT FK_Documento_Viajero FOREIGN KEY (ViajeroID) REFERENCES Viajeros(ViajeroID),
    CONSTRAINT UQ_Documento UNIQUE (TipoDocumento, NumeroDocumento)
);

-- Crear la tabla Viajes
CREATE TABLE Viajes (
    ViajeID INT IDENTITY(1,1) PRIMARY KEY,
    ViajeroID INT NOT NULL,
    FechaEntrada DATETIME NOT NULL,
    FechaSalida DATETIME,
    PaisOrigen VARCHAR(50) NOT NULL,
    PaisDestino VARCHAR(50) NOT NULL,
    CONSTRAINT FK_Viaje_Viajero FOREIGN KEY (ViajeroID) REFERENCES Viajeros(ViajeroID),
    CONSTRAINT CHK_FechaEntrada CHECK (FechaEntrada <= GETDATE())
);

-- Crear la tabla OficialesAduana
CREATE TABLE OficialesAduana (
    OficialID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Apellido VARCHAR(100) NOT NULL,
    NumeroIdentificacion VARCHAR(50) NOT NULL,
    CONSTRAINT UQ_NumeroIdentificacion UNIQUE (NumeroIdentificacion)
);

-- Crear la tabla EntradasSalidas
CREATE TABLE EntradasSalidas (
    RegistroID INT IDENTITY(1,1) PRIMARY KEY,
    ViajeID INT NOT NULL,
    OficialID INT NOT NULL,
    TipoRegistro VARCHAR(50) NOT NULL, -- Entrada/Salida
    FechaRegistro DATETIME NOT NULL,
    Observaciones VARCHAR(255),
    CONSTRAINT FK_EntradaSalida_Viaje FOREIGN KEY (ViajeID) REFERENCES Viajes(ViajeID),
    CONSTRAINT FK_EntradaSalida_Oficial FOREIGN KEY (OficialID) REFERENCES OficialesAduana(OficialID),
    CONSTRAINT CHK_FechaRegistro CHECK (FechaRegistro <= GETDATE()),
    CONSTRAINT CHK_TipoRegistro CHECK (TipoRegistro IN ('Entrada', 'Salida'))
);