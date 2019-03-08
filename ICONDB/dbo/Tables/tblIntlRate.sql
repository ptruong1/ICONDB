CREATE TABLE [dbo].[tblIntlRate] (
    [RateID]      VARCHAR (4)    NOT NULL,
    [CountryCode] VARCHAR (4)    NOT NULL,
    [ConnectFee]  NUMERIC (5, 2) NOT NULL,
    [firstMinute] NUMERIC (5, 2) NOT NULL,
    [NextMinute]  NUMERIC (5, 2) NULL,
    [Descript]    VARCHAR (50)   NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_country]
    ON [dbo].[tblIntlRate]([RateID] ASC, [CountryCode] ASC);

