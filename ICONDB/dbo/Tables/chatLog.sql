CREATE TABLE [dbo].[chatLog] (
    [N]          BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [chatRoomId] INT           NULL,
    [sessionId]  INT           NULL,
    [time]       DATETIME      NULL,
    [userName]   VARCHAR (255) NULL,
    [message]    NTEXT         NULL
);

