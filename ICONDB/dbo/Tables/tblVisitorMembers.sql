CREATE TABLE [dbo].[tblVisitorMembers] (
    [MemberID]       INT           NOT NULL,
    [VisitorID]      INT           NOT NULL,
    [FirstName]      VARCHAR (25)  NOT NULL,
    [LastName]       VARCHAR (25)  NOT NULL,
    [RelationshipID] TINYINT       NOT NULL,
    [InputDate]      SMALLDATETIME NULL,
    [ModifyDate]     SMALLDATETIME NULL,
    [DLID]           VARCHAR (12)  NULL,
    [Phone]          VARCHAR (10)  NULL,
    [Address]        VARCHAR (100) NULL,
    [City]           VARCHAR (30)  NULL,
    [State]          VARCHAR (2)   NULL,
    [Zipcode]        VARCHAR (5)   NULL,
    [Status]         TINYINT       NULL,
    CONSTRAINT [PK_tblVisitorMembers] PRIMARY KEY CLUSTERED ([MemberID] ASC),
    CONSTRAINT [FK_tblVisitorMembers_tblRelationship] FOREIGN KEY ([RelationshipID]) REFERENCES [dbo].[tblRelationShip] ([RelationshipID]),
    CONSTRAINT [FK_tblVisitorMembers_tblVisitorMemberStatus] FOREIGN KEY ([Status]) REFERENCES [dbo].[tblVisitorMemberStatus] ([Status]),
    CONSTRAINT [FK_tblVisitorMembers_tblVisitors] FOREIGN KEY ([VisitorID]) REFERENCES [dbo].[tblVisitors] ([VisitorID])
);


GO
CREATE NONCLUSTERED INDEX [ind_visitorID]
    ON [dbo].[tblVisitorMembers]([VisitorID] ASC);

