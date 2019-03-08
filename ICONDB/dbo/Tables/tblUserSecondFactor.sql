CREATE TABLE [dbo].[tblUserSecondFactor] (
    [UserName]   VARCHAR (20) NOT NULL,
    [AuthCode]   INT          NOT NULL,
    [ActiveDate] DATETIME     NOT NULL,
    CONSTRAINT [PK_tblUserSecond] PRIMARY KEY CLUSTERED ([UserName] ASC, [AuthCode] ASC)
);

