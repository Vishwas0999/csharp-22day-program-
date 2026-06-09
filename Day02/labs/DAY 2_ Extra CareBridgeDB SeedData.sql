CREATE DATABASE CareBridgeDB;   
USE CareBridgeDB;


CREATE TABLE Department (
    DepartmentId   INT IDENTITY(1,1) PRIMARY KEY,
    Name           NVARCHAR(100) NOT NULL,
    Location       NVARCHAR(100) NULL
);

select * from Department;

CREATE TABLE Provider (
    ProviderId     INT IDENTITY(1,1) PRIMARY KEY,
    FullName       NVARCHAR(150) NOT NULL,
    Specialty      NVARCHAR(100) NOT NULL,
    DepartmentId   INT NOT NULL
        REFERENCES Department(DepartmentId)
);

CREATE TABLE Patient (
    PatientId      INT IDENTITY(1,1) PRIMARY KEY,
    MRN            NVARCHAR(20) NOT NULL UNIQUE,
    FullName       NVARCHAR(150) NOT NULL,
    DateOfBirth    DATE NOT NULL,
    Gender         CHAR(1) NOT NULL
        CHECK (Gender IN ('M','F','O')),
    City           NVARCHAR(100) NULL,
    IsActive       BIT NOT NULL DEFAULT 1
);


CREATE TABLE Insurance (
    InsuranceId    INT IDENTITY(1,1) PRIMARY KEY,
    PatientId      INT NOT NULL REFERENCES Patient(PatientId),
    Payer          NVARCHAR(120) NOT NULL,
    PolicyNumber   NVARCHAR(50) NOT NULL,
    EffectiveDate  DATE NOT NULL,
    ExpiryDate     DATE NULL
);

CREATE TABLE Encounter (
    EncounterId    INT IDENTITY(1,1) PRIMARY KEY,
    PatientId      INT NOT NULL REFERENCES Patient(PatientId),
    ProviderId     INT NOT NULL REFERENCES Provider(ProviderId),
    DepartmentId   INT NOT NULL REFERENCES Department(DepartmentId),
    AdmitDate      DATETIME2 NOT NULL,
    DischargeDate  DATETIME2 NULL,
    EncounterType  NVARCHAR(30) NOT NULL
        CHECK (EncounterType IN ('Inpatient','Outpatient','ED'))
);

select * from Encounter;

CREATE TABLE Diagnosis (
    DiagnosisId    INT IDENTITY(1,1) PRIMARY KEY,
    EncounterId    INT NOT NULL REFERENCES Encounter(EncounterId),
    IcdCode        NVARCHAR(10) NOT NULL,
    Description    NVARCHAR(200) NOT NULL,
    DiagnosedOn    DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

CREATE TABLE [Procedure] (
    ProcedureId    INT IDENTITY(1,1) PRIMARY KEY,
    EncounterId    INT NOT NULL REFERENCES Encounter(EncounterId),
    CptCode        NVARCHAR(10) NOT NULL,
    Description    NVARCHAR(200) NOT NULL,
    PerformedOn    DATETIME2 NOT NULL
);

CREATE TABLE Claim (
    ClaimId        INT IDENTITY(1,1) PRIMARY KEY,
    EncounterId    INT NOT NULL REFERENCES Encounter(EncounterId),
    InsuranceId    INT NOT NULL REFERENCES Insurance(InsuranceId),
    BilledAmount   DECIMAL(12,2) NOT NULL,
    ReimbursedAmt  DECIMAL(12,2) NULL,
    Status         NVARCHAR(20) NOT NULL
        CHECK (Status IN ('Submitted','Paid','Denied'))
);

select * from Encounter;