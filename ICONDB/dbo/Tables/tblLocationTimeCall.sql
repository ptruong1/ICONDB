CREATE TABLE [dbo].[tblLocationTimeCall] (
    [FacilityID] INT           NULL,
    [LocationID] INT           NOT NULL,
    [days]       TINYINT       NOT NULL,
    [hours]      BIGINT        NULL,
    [inputdate]  SMALLDATETIME NULL,
    [modifydate] SMALLDATETIME NULL,
    [userName]   VARCHAR (20)  NULL,
    CONSTRAINT [PK_tblLocationTimeCall] PRIMARY KEY CLUSTERED ([LocationID] ASC, [days] ASC)
);

