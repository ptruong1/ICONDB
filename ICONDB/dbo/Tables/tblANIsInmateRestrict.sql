CREATE TABLE [dbo].[tblANIsInmateRestrict] (
    [ANI]        CHAR (10)    NOT NULL,
    [InmateID]   VARCHAR (12) NOT NULL,
    [FacilityID] INT          NOT NULL,
    [Inputdate]  DATETIME     CONSTRAINT [DF_tblANIsInmate_Inputdate] DEFAULT (getdate()) NOT NULL,
    [UserName]   VARCHAR (25) NOT NULL
);

