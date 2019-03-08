CREATE TABLE [dbo].[tblSearchList] (
    [SearchID]   INT          NOT NULL,
    [SearchName] VARCHAR (50) NOT NULL,
    [InputDate]  DATETIME     NULL,
    [FacilityID] INT          NULL,
    [UserName]   VARCHAR (50) NULL,
    CONSTRAINT [PK_tblSearchList] PRIMARY KEY CLUSTERED ([SearchName] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Ind_Facility_user]
    ON [dbo].[tblSearchList]([FacilityID] ASC, [UserName] ASC);

