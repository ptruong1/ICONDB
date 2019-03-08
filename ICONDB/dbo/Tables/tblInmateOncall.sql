CREATE TABLE [dbo].[tblInmateOncall] (
    [PIN]        VARCHAR (12) NULL,
    [FacilityID] INT          NULL,
    [AccessTime] DATETIME     NOT NULL,
    [fromNo]     CHAR (10)    NULL,
    [InmateID]   VARCHAR (12) NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_pin]
    ON [dbo].[tblInmateOncall]([PIN] ASC, [FacilityID] ASC, [AccessTime] ASC);

