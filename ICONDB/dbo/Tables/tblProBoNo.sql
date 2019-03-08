CREATE TABLE [dbo].[tblProBoNo] (
    [FacilityID] INT          NOT NULL,
    [PhoneNo]    CHAR (10)    NOT NULL,
    [Descript]   VARCHAR (50) NULL,
    CONSTRAINT [PK_tblProBoNo] PRIMARY KEY CLUSTERED ([FacilityID] ASC, [PhoneNo] ASC),
    CONSTRAINT [FK_tblProBoNo_tblFacility] FOREIGN KEY ([FacilityID]) REFERENCES [dbo].[tblFacility] ([FacilityID])
);

