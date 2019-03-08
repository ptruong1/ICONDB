CREATE TABLE [dbo].[tblFacilityKeyWords] (
    [FacilityID]      INT           NOT NULL,
    [KeyWords]        VARCHAR (500) NULL,
    [InputDate]       SMALLDATETIME CONSTRAINT [DF_tblFacilityKeyWords_InputDate] DEFAULT (getdate()) NULL,
    [ModifyDate]      SMALLDATETIME NULL,
    [UserName]        VARCHAR (25)  NULL,
    [AlertEmail]      VARCHAR (200) NULL,
    [AlertCellPhones] VARCHAR (200) NULL,
    CONSTRAINT [PK_tblFacilityKeyWords] PRIMARY KEY CLUSTERED ([FacilityID] ASC),
    CONSTRAINT [FK_tblFacilityKeyWords_tblFacility] FOREIGN KEY ([FacilityID]) REFERENCES [dbo].[tblFacility] ([FacilityID])
);

