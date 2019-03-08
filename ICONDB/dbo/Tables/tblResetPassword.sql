CREATE TABLE [dbo].[tblResetPassword] (
    [TempPassword] UNIQUEIDENTIFIER NOT NULL,
    [UserID]       VARCHAR (20)     NOT NULL,
    [RequestDate]  DATETIME         NOT NULL
);

