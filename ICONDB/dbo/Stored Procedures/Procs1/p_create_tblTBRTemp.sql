

CREATE PROCEDURE [dbo].[p_create_tblTBRTemp]  AS
if ( object_id(N'tempdb.dbo.##tblTBRTemp') is not Null )
	drop table [##tblTBRTemp]
CREATE TABLE [##tblTBRTemp] (
	[FromNo] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ToNo] [char] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ConnectDate]  [char](6)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ConnectTime] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CallDuration] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SequenceNo]	[char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Authorization] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CCNo]  [char] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CCExp]  [char] (23) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RatedCharge]    [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SurCharge]    [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL default '00000',
	[ServiceCode] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL default '099' ,
	[Principal]  [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL  default '000',
	
	[filler] [char] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Lib]  [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL  default 'TQ',
	[MethodOfRecord]  [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL  default '1'
) ON [PRIMARY]

