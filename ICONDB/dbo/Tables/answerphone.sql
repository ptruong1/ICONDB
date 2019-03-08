CREATE TABLE [dbo].[answerphone] (
    [N]          BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [chatRoomId] INT           NULL,
    [sessionId]  INT           NULL,
    [time]       DATETIME      NULL,
    [userName]   VARCHAR (255) NULL,
    [status]     INT           NULL,
    [recordFile] NTEXT         NULL,
    PRIMARY KEY CLUSTERED ([N] ASC)
);

