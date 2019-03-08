CREATE TABLE [dbo].[tblAccuPIN] (
    [FacilityID] INT      NOT NULL,
    [QuestionID] SMALLINT NOT NULL,
    [ModifyDate] DATETIME NULL,
    CONSTRAINT [PK_tblAccuPIN] PRIMARY KEY CLUSTERED ([FacilityID] ASC, [QuestionID] ASC)
);

