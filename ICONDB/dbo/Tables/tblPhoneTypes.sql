CREATE TABLE [dbo].[tblPhoneTypes] (
    [PhoneType] TINYINT      NOT NULL,
    [Descript]  VARCHAR (15) NULL,
    CONSTRAINT [PK_tblPhoneTypes] PRIMARY KEY CLUSTERED ([PhoneType] ASC)
);

