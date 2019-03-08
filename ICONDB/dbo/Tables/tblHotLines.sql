CREATE TABLE [dbo].[tblHotLines] (
    [FacilityID]  INT          NOT NULL,
    [PhoneNo]     CHAR (10)    NOT NULL,
    [Description] CHAR (10)    NULL,
    [PhoneNo1]    VARCHAR (10) NULL,
    [PhoneNo2]    VARCHAR (10) NULL,
    [Prea1]       VARCHAR (10) NULL,
    [Prea2]       VARCHAR (10) NULL,
    [Prea3]       VARCHAR (10) NULL,
    [Tip1]        VARCHAR (10) NULL,
    [Tip2]        VARCHAR (10) NULL,
    [Tip3]        VARCHAR (10) NULL,
    CONSTRAINT [PK_tblHotLines] PRIMARY KEY CLUSTERED ([FacilityID] ASC, [PhoneNo] ASC),
    CONSTRAINT [FK_tblHotLines_tblFacility] FOREIGN KEY ([FacilityID]) REFERENCES [dbo].[tblFacility] ([FacilityID])
);

