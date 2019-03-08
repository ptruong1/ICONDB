CREATE TABLE [dbo].[tblTroubleTicket] (
    [TicketID]       INT           NOT NULL,
    [FacilityID]     INT           NULL,
    [TroubleID]      TINYINT       NULL,
    [TroubleSubject] VARCHAR (50)  NULL,
    [TroubleNote]    VARCHAR (500) NULL,
    [userName]       VARCHAR (25)  NULL,
    [ContactName]    VARCHAR (40)  NULL,
    [ContactEmail]   VARCHAR (50)  NULL,
    [ContactPhone]   VARCHAR (25)  NULL,
    [CreateDate]     SMALLDATETIME CONSTRAINT [DF_tblTroubleTicket_CreateDate] DEFAULT (getdate()) NULL,
    [TroubleDate]    SMALLDATETIME NULL,
    [ResolveDate]    SMALLDATETIME NULL,
    [ResolveNote]    VARCHAR (500) NULL,
    [statusID]       TINYINT       CONSTRAINT [DF_tblTroubleTicket_statusID] DEFAULT ((1)) NULL,
    [ServiceLevelID] TINYINT       NULL,
    [AssignDeptID]   TINYINT       NULL,
    CONSTRAINT [PK_tblTroubleTicket] PRIMARY KEY CLUSTERED ([TicketID] ASC),
    CONSTRAINT [FK_tblTroubleTicket_tblTroubleTicketStatus] FOREIGN KEY ([statusID]) REFERENCES [dbo].[tblTroubleTicketStatus] ([statusID])
);


GO
CREATE NONCLUSTERED INDEX [ind_facilityID]
    ON [dbo].[tblTroubleTicket]([FacilityID] ASC, [TroubleID] ASC);

