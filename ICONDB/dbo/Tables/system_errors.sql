CREATE TABLE [dbo].[system_errors] (
    [ID]          INT           IDENTITY (1, 1) NOT NULL,
    [node]        VARCHAR (100) NULL,
    [channel]     INT           NULL,
    [event_time]  DATETIME      NULL,
    [type]        INT           NULL,
    [script_name] VARCHAR (200) NULL,
    [script_desc] VARCHAR (200) NULL,
    [err_code]    VARCHAR (50)  NULL,
    [err_desc]    VARCHAR (200) NULL
);

