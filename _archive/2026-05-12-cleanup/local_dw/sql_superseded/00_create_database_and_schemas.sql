USE master;
GO

IF DB_ID('CovidMedallionPOC') IS NULL
BEGIN
    CREATE DATABASE CovidMedallionPOC;
END
GO

USE CovidMedallionPOC;
GO

IF SCHEMA_ID('bronze') IS NULL EXEC('CREATE SCHEMA bronze');
IF SCHEMA_ID('silver') IS NULL EXEC('CREATE SCHEMA silver');
IF SCHEMA_ID('gold') IS NULL EXEC('CREATE SCHEMA gold');
IF SCHEMA_ID('control') IS NULL EXEC('CREATE SCHEMA control');
GO

IF OBJECT_ID('control.pipeline_run','U') IS NULL
BEGIN
    CREATE TABLE control.pipeline_run (
        run_id            VARCHAR(40)  NOT NULL PRIMARY KEY,
        run_ts            DATETIME2    NOT NULL DEFAULT SYSUTCDATETIME(),
        stage             VARCHAR(20)  NOT NULL,
        status            VARCHAR(20)  NOT NULL,
        notes             NVARCHAR(1000) NULL
    );
END
GO
