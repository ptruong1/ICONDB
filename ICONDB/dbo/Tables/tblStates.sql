CREATE TABLE [dbo].[tblStates] (
    [StateID]       SMALLINT     NOT NULL,
    [StateCode]     CHAR (2)     NOT NULL,
    [StateName]     VARCHAR (20) NOT NULL,
    [UnRegFlag]     BIT          NOT NULL,
    [InterNational] CHAR (1)     NULL,
    [Country]       CHAR (3)     NULL,
    [CountryID]     SMALLINT     NULL,
    CONSTRAINT [PK_tblStates] PRIMARY KEY CLUSTERED ([StateID] ASC),
    CONSTRAINT [FK_tblStates_tblCountryCode] FOREIGN KEY ([CountryID]) REFERENCES [dbo].[tblCountryCode] ([CountryID])
);


GO
CREATE NONCLUSTERED INDEX [ind_coutry]
    ON [dbo].[tblStates]([StateName] ASC, [Country] ASC);

