CREATE TABLE [dbo].[tblFreePhones] (
    [PhoneNo]     CHAR (10)     NOT NULL,
    [FacilityID]  INT           NOT NULL,
    [FirstName]   VARCHAR (20)  NULL,
    [LastName]    VARCHAR (25)  NULL,
    [Descript]    VARCHAR (250) NULL,
    [Username]    VARCHAR (25)  NULL,
    [InputDate]   SMALLDATETIME CONSTRAINT [DF_tblFreePhones_InputDate] DEFAULT (getdate()) NOT NULL,
    [ModifyDate]  SMALLDATETIME NULL,
    [AuthCode]    VARCHAR (10)  NULL,
    [MaxCalltime] SMALLINT      NULL,
    [AcceptOpt]   TINYINT       NULL,
    [GroupID]     INT           NULL,
    CONSTRAINT [PK_tblFreePhones] PRIMARY KEY CLUSTERED ([PhoneNo] ASC, [FacilityID] ASC),
    CONSTRAINT [FK_tblFreePhones_tblFacilityID] FOREIGN KEY ([FacilityID]) REFERENCES [dbo].[tblFacility] ([FacilityID])
);

