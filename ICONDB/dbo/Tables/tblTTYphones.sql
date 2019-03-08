CREATE TABLE [dbo].[tblTTYphones] (
    [FacilityId] INT          NOT NULL,
    [State]      CHAR (2)     NOT NULL,
    [TTYphone]   CHAR (10)    NULL,
    [InputDate]  DATETIME     NULL,
    [Notes]      VARCHAR (20) NULL,
    CONSTRAINT [PK_tblTTYphones] PRIMARY KEY CLUSTERED ([FacilityId] ASC)
);

