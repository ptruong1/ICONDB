CREATE TABLE [dbo].[tblVisitSendConfirm] (
    [ApmNo]       BIGINT       NOT NULL,
    [ConfirmType] TINYINT      NOT NULL,
    [ConfirmDate] DATETIME     NOT NULL,
    [ConfirmBy]   VARCHAR (20) NULL
);

