CREATE TABLE [dbo].[tblDivisionTimeCall] (
    [FacilityID] INT           NULL,
    [DivisionID] INT           NOT NULL,
    [days]       TINYINT       NOT NULL,
    [hours]      BIGINT        NULL,
    [inputdate]  SMALLDATETIME NULL,
    [modifydate] SMALLDATETIME NULL,
    [userName]   VARCHAR (20)  NULL,
    CONSTRAINT [PK_tblDivisionTimeCall] PRIMARY KEY CLUSTERED ([DivisionID] ASC, [days] ASC)
);

