
CREATE PROCEDURE [dbo].[p_create_temp_WUfile]

AS

CREATE TABLE ##tempWU (
	[CustSeqNo] [int] ,
	[RecordType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PSCNo] [char] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ClientID] [char] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CustAcctNo] [char] (23) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[FirstName] [char] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LastName] [char] (21) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Address] [char] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[City] [char] (24) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[State] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Zip] [char] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Country] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Phone] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ProcessType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[IssueCard] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]

