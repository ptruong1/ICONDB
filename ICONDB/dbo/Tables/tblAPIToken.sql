CREATE TABLE [dbo].[tblAPIToken] (
    [FacilityID]  INT          NOT NULL,
    [Token]       VARCHAR (40) NOT NULL,
    [createdDate] DATETIME     NULL,
    [userID]      VARCHAR (25) NOT NULL,
    [Tkstatus]    BIT          NULL,
    CONSTRAINT [PK_tblAPIToken] PRIMARY KEY CLUSTERED ([Token] ASC)
);

