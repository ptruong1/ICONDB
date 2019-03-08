﻿

CREATE PROCEDURE [dbo].[p_create_tblBicTemp]  AS
if ( object_id(N'tempdb.dbo.##tblBICTemp') is not Null )
	drop table [##tblBICTemp]
CREATE TABLE [##tblBICTemp] (
	[RecordID] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CallDate] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FromNoLength] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL default '10' ,
	[FromNo] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Unused1] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL default '000' ,
	[ToNoLength] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL default '10',
	[ToNo] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ChargeAmt] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Unused2] [char] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL  default '000000000',
	[ConnectTime] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BillableTime] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Unused3] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL default '0' ,
	[MethodOfRecord] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ReturnCode] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL default '00' ,
	[Unused4] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL default '000000' ,
	[RatePeriod] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RateClass] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[MessageType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Unused5] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL default '0' ,
	[Indicator1] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Indicator2to5] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL  default '0000' ,
	[Indicator6] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Indicator7] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL  default '0' ,
	[Indicator8] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL  default '7',
	[Indicator9to13] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL  default '00000' ,
	[Indicator14] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL  default '4',
	[Indicator15] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL  default '5' ,
	[Indicator16] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL   default '0',
	[Indicator17] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL default '4'  ,
	[Indicator18] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL   default '0',
	[Indicator19] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Indicator20] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL  default '0' ,
	[Pindigits] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL  default '0000' ,
	[Unused6] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL  default '0000000',
	[BillToNo] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FromCity] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FromState] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ToCity] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ToState] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LibraryCode] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SettlementCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CICCode] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL  default '081' ,
	[Unused7] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL default '00000' ,
	[Indicator21] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL default '4' ,
	[Indicator22] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL  default '3',
	[Indicator23to26] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL  default '0000',
	[Indicator27] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL  default '0',
	[Indicator28to30] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL  default '000',
	[EntityCode] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL  default '000',
	[CustomerData] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL default '00000'  --,
	--[AuthName]	varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL default '',
) ON [PRIMARY]
