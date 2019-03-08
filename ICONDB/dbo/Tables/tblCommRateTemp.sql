CREATE TABLE [dbo].[tblCommRateTemp] (
    [FacilityID] INT            NOT NULL,
    [AgentID]    INT            NOT NULL,
    [BillType]   CHAR (2)       NOT NULL,
    [Calltype]   CHAR (2)       NOT NULL,
    [CommRate]   NUMERIC (6, 4) NULL,
    [PifPaid]    BIT            NULL,
    [Descript]   VARCHAR (50)   NULL,
    [username]   VARCHAR (25)   NULL,
    [inputDate]  SMALLDATETIME  NULL,
    [modifyDate] SMALLDATETIME  NULL
);

