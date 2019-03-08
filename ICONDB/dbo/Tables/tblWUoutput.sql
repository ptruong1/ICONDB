CREATE TABLE [dbo].[tblWUoutput] (
    [fileID]     INT          NOT NULL,
    [WUfileName] VARCHAR (10) NOT NULL,
    [importdate] DATETIME     CONSTRAINT [DF_tblWUoutput_importdate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_tblWUoutput] PRIMARY KEY CLUSTERED ([WUfileName] ASC)
);

