CREATE TABLE [dbo].[tblNonRecordPhones] (
    [PhoneNo]    CHAR (10)     NOT NULL,
    [FacilityID] INT           NOT NULL,
    [LastName]   VARCHAR (25)  NULL,
    [FirstName]  VARCHAR (25)  NULL,
    [DescriptID] SMALLINT      NULL,
    [UserName]   VARCHAR (25)  NULL,
    [Inputdate]  SMALLDATETIME CONSTRAINT [DF_tblNonRecordPhones_Inputdate] DEFAULT (getdate()) NULL,
    [modifyDate] SMALLDATETIME NULL,
    [Note]       VARCHAR (200) NULL,
    [GroupID]    INT           NULL,
    CONSTRAINT [PK_tblNonRecordPhones] PRIMARY KEY CLUSTERED ([PhoneNo] ASC, [FacilityID] ASC),
    CONSTRAINT [FK_tblNonRecordPhones_tblDescript] FOREIGN KEY ([DescriptID]) REFERENCES [dbo].[tblDescript] ([DescriptID]),
    CONSTRAINT [FK_tblNonRecordPhones_tblFacility] FOREIGN KEY ([FacilityID]) REFERENCES [dbo].[tblFacility] ([FacilityID])
);

