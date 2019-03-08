CREATE TABLE [dbo].[tblTroubleTicketStatus] (
    [statusID] TINYINT      NOT NULL,
    [Descript] VARCHAR (15) NULL,
    CONSTRAINT [PK_tblTroubleTicketStatus] PRIMARY KEY CLUSTERED ([statusID] ASC)
);

