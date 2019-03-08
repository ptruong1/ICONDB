CREATE TABLE [dbo].[tblTroubleTicketDetail] (
    [DetailID]         INT           NOT NULL,
    [ticketID]         INT           NOT NULL,
    [LegacyDetailNote] VARCHAR (500) NULL,
    [ReplyDetailNote]  VARCHAR (500) NULL,
    [AssignedTo]       VARCHAR (30)  NULL,
    [UserName]         VARCHAR (25)  NULL,
    [ReplyDate]        DATETIME      CONSTRAINT [DF_tblTroubleTicketDetail_ReplyDate] DEFAULT (getdate()) NULL,
    [serviceLevelID]   TINYINT       NULL,
    [AssignDeptID]     TINYINT       NULL,
    CONSTRAINT [PK_tblTroubleNote] PRIMARY KEY CLUSTERED ([DetailID] ASC),
    CONSTRAINT [FK_tblTroubleNote_tblTroubleTicket] FOREIGN KEY ([ticketID]) REFERENCES [dbo].[tblTroubleTicket] ([TicketID])
);

