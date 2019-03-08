CREATE TABLE [dbo].[system_general] (
    [ID]          INT           IDENTITY (1, 1) NOT NULL,
    [node]        VARCHAR (100) NULL,
    [channel]     INT           NULL,
    [event_time]  DATETIME      NULL,
    [type]        INT           NULL,
    [description] VARCHAR (200) NULL,
    [expression]  VARCHAR (250) NULL
);

