CREATE TABLE [dbo].[tblWUInputfiles] (
    [WUfileName] CHAR (8)     NOT NULL,
    [CreateDate] VARCHAR (10) NOT NULL,
    [inputDate]  DATETIME     CONSTRAINT [DF_tblWUInputfiles_inputDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_tblWUoutputfiles] PRIMARY KEY CLUSTERED ([WUfileName] ASC, [CreateDate] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ind_createDate]
    ON [dbo].[tblWUInputfiles]([CreateDate] ASC);

