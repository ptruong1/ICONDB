CREATE TABLE [dbo].[tblTransactionLogsService] (
    [TransactionID]                   BIGINT         NOT NULL,
    [AccountNo]                       VARCHAR (18)   NULL,
    [ExpDate]                         VARCHAR (6)    NULL,
    [MechantID]                       VARCHAR (10)   NULL,
    [Bill_to_country]                 VARCHAR (15)   NULL,
    [Bill_to_Address]                 VARCHAR (50)   NULL,
    [Bill_to_city]                    VARCHAR (20)   NULL,
    [Bill_to_Zip]                     VARCHAR (10)   NULL,
    [Bill_to_state]                   VARCHAR (2)    NULL,
    [Bill_to_firsName]                VARCHAR (30)   NULL,
    [Bill_to_lastName]                VARCHAR (30)   NULL,
    [Bill_to_Email]                   VARCHAR (40)   NULL,
    [TransactionTime]                 DATETIME       NULL,
    [requestID]                       VARCHAR (24)   NULL,
    [reasonCode]                      VARCHAR (3)    NULL,
    [decision]                        VARCHAR (10)   NULL,
    [AuthReply_amount]                NUMERIC (7, 2) NULL,
    [authorizationCode]               VARCHAR (6)    NULL,
    [ccCaptureReply_reasonCode]       VARCHAR (3)    NULL,
    [ccCaptureReply_reconciliationID] VARCHAR (50)   NULL,
    [PhoneNo]                         CHAR (10)      NULL
);

