-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_mass_CDR]
@FacilityID int,
@fromDate date,
@toDate	  date

AS
BEGIN

truncate table  [dbo].[tblCDR];
--	INSERT [leg_Icon].[dbo].tblCDR 

INSERT INTO [dbo].[tblCDR]
           ([FacilityName]
           ,[FacilityID]
           ,[FromNo]
           ,[toNo]
           ,[RecordID]
           ,[FromCity]
           ,[FromState]
           ,[ToCity]
           ,[ToState]
           ,[StationID]
           ,[LocationName]
           ,[InmateID]
           ,[PIN]
           ,[CallingCard]
           ,[RevenuePeriod]
           ,[CallStart]
           ,[CallEnd]
           ,[Duration]
           ,[BillType]
           ,[CallType]
           ,[CallRevenue]
           ,[Tax]
           ,[Validation]
           ,[ErrorCode]
           ,[LIDBcode]
           ,[Complete])

select		'HCJ',
		   a.facilityID,
		  fromNo,
		   tono,
		   RecordID,
		   fromCity,
		   fromState,
		   tocity,
		   toState,
		   left(StationID,20),
		   left(l.descript,25) LocationName,
		   InmateID,
		   PIN,
		   Case a.billtype when '07' then CreditCardNo else '' end, 
		   left(calldate,4),
		   DATEADD(SECOND,-duration, RecordDate),
		   RecordDate,
		    duration,
		    d.Descript billtype,
			c.descript callType,
			Callrevenue,
			0,
			'Approved',
			'Accept', 
			CASE responsecode when '050'  then 'Approved'  when '0'  then 'Approved'  else 'Denial' end,
			'Y'
from [leg_Icon].[dbo].tblCallsbilled a with(nolock) , [leg_Icon].[dbo].tblANIs b  with(nolock), [leg_Icon].[dbo].tblcalltype c  with(nolock), [leg_Icon].[dbo].tblbilltype d  with(nolock), tblfacilitylocation l  with(nolock) where
a.billtype = d.Billtype and
c.Abrev = a.callType and
a.FromNo = b.ANINo and
b.locationID = l.locationID and b.divisionID = l.DivisionID and
a.facilityID = b.facilityID and
RecordDate >=@fromDate and RecordDate < @toDate and a.facilityID = @FacilityID  and errorcode=0


--Unbilled calls
--INSERT [leg_Icon].dbo.tblCDR 


INSERT INTO [dbo].[tblCDR]
           ([FacilityName]
           ,[FacilityID]
           ,[FromNo]
           ,[toNo]
           ,[RecordID]
           ,[FromCity]
           ,[FromState]
           ,[ToCity]
           ,[ToState]
           ,[StationID]
           ,[LocationName]
           ,[InmateID]
           ,[PIN]
           ,[CallingCard]
           ,[RevenuePeriod]
           ,[CallStart]
           ,[CallEnd]
           ,[Duration]
           ,[BillType]
           ,[CallType]
           ,[CallRevenue]
           ,[Tax]
           ,[Validation]
           ,[ErrorCode]
           ,[LIDBcode]
           ,[Complete])

select		'HCJ',
		  a.facilityID,
		  fromNo,
		   tono,
		   a.FacilityID,
		   '',
		   '',
		   '',
		   '',
		   left(StationID,20),
		   left(l.descript,25) LocationName,
		   InmateID,
		   PIN,
		   Case a.billtype when '07' then DebitCardNo else '' end, 
		    right( convert (varchar(6), RecordDate,112),4),
		   RecordDate,
		   RecordDate,
		   0,
		    d.Descript billtype,
			c.descript callType,
			0,
			0,
			'NA',
			left(t.Descript,25) as ErrorType, 
			CASE responsecode when '050'  then 'Approved'  when '0'  then 'NA'  else 'Denial' end,
			'N'
	from [leg_Icon].[dbo].tblCallsUnbilled a with(nolock) ,
	[leg_Icon].[dbo].tblANIs b  with(nolock),
	[leg_Icon].[dbo].tblcalltype c  with(nolock), 
	[leg_Icon].[dbo].tblbilltype d  with(nolock), 
	tblfacilitylocation l  with(nolock) ,
	tblErrorType t with(nolock) 
	where a.billtype = d.Billtype and
		c.Abrev = a.callType and
		a.FromNo = b.ANINo and
		b.locationID = l.locationID and b.divisionID = l.DivisionID and
		a.facilityID = b.facilityID and 
		a.errorType = t.ErrorType and
		RecordDate >=@fromDate and RecordDate < @toDate and a.facilityID = @FacilityID ;


-- Voice message

INSERT INTO [dbo].[tblCDR]
           ([FacilityName]
           ,[FacilityID]
           ,[FromNo]
           ,[toNo]
           ,[RecordID]
           ,[FromCity]
           ,[FromState]
           ,[ToCity]
           ,[ToState]
           ,[StationID]
           ,[LocationName]
           ,[InmateID]
           ,[PIN]
           ,[CallingCard]
           ,[RevenuePeriod]
           ,[CallStart]
           ,[CallEnd]
           ,[Duration]
           ,[BillType]
           ,[CallType]
           ,[CallRevenue]
           ,[Tax]
           ,[Validation]
           ,[ErrorCode]
           ,[LIDBcode]
           ,[Complete])

select		'HCJ',
		  a.facilityID,
		  b.MessengerNo,
		   '',
		   a.FacilityID,
		   '',
		   '',
		   '',
		   '',
		   '',
		   '',
		   InmateID,
		   InmateID,
		   'NA', 
		    right( convert (varchar(6), MessageDate,112),4),
		   MessageDate,
		   MessageDate,
		   0,
		    'Prepaid',
			'VoiceMail',
			isnull(b.Charge,0),
			0,
			'NA',
			'NA', 
			'NA',
			'Y'
	from 	 tblMailbox a with(nolock) , tblMailboxDetail b with(nolock)
	where a.MailboxID = b.MailBoxID and FacilityID= @FacilityID AND MessageTypeID=1 and MessageDate >=@fromDate and MessageDate < @toDate ;

END



