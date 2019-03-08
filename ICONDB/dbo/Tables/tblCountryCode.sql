CREATE TABLE [dbo].[tblCountryCode] (
    [CountryID]   SMALLINT       NOT NULL,
    [Code]        VARCHAR (4)    NOT NULL,
    [CountryName] NVARCHAR (100) NOT NULL,
    [CountryAbbr] CHAR (3)       NULL,
    CONSTRAINT [PK_tblCountryCode] PRIMARY KEY CLUSTERED ([CountryID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ind_code]
    ON [dbo].[tblCountryCode]([Code] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_name]
    ON [dbo].[tblCountryCode]([CountryName] ASC);

