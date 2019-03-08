CREATE TABLE [dbo].[tblPINTimeCall] (
    [PIN]        VARCHAR (12)  NOT NULL,
    [days]       TINYINT       NOT NULL,
    [hours]      BIGINT        NULL,
    [inputdate]  SMALLDATETIME NULL,
    [modifydate] SMALLDATETIME NULL,
    [userName]   VARCHAR (20)  NULL,
    [FacilityID] INT           NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_pin]
    ON [dbo].[tblPINTimeCall]([PIN] ASC, [days] ASC, [hours] ASC, [FacilityID] ASC);

