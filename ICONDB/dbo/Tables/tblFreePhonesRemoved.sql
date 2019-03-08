CREATE TABLE [dbo].[tblFreePhonesRemoved] (
    [PhoneNo]     CHAR (10)     NOT NULL,
    [FacilityID]  INT           NOT NULL,
    [FirstName]   VARCHAR (20)  NULL,
    [LastName]    VARCHAR (25)  NULL,
    [Descript]    VARCHAR (250) NULL,
    [Username]    VARCHAR (25)  NULL,
    [InputDate]   SMALLDATETIME NOT NULL,
    [ModifyDate]  SMALLDATETIME NULL,
    [AuthCode]    VARCHAR (10)  NULL,
    [MaxCalltime] SMALLINT      NULL,
    [AcceptOpt]   TINYINT       NULL,
    [GroupID]     INT           NULL
);

