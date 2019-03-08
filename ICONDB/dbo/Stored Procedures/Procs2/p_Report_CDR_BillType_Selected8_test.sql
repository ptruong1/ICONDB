
CREATE PROCEDURE [dbo].[p_Report_CDR_BillType_Selected8_test]

@FacilityID	int,
@divisionID	int,
@locationID	int,
@phoneID	varchar(100),
@PIN		varchar(12),
@FName	varchar(25),
@LName varchar(25),
@callingCard	varchar(12),
@DNI		varchar(16),
@complete	tinyint,
@uncomplete	tinyint,
@private	tinyint,
@billtype	char(2),
@callType       char(2),
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime ,
@startRowIndex int,
 @maximumRows int,
@totalRecord	int  OUTPUT
 AS

DECLARE @first_id int, @startRow int
	
SET NOCOUNT ON

SET  @phoneID = isnull( @phoneID,'')
SET @phoneID = rtrim(@phoneID)

If (@PIN ='') set @PIN ='0'
SET @PIN = isnull(@PIN,'0')
--SET @totalRecord =0

create table  #tempCDR  ([RecordIDS] [bigint] IDENTITY (1, 1) NOT NULL , PhoneID varchar(20), RecordID numeric(12), toNo varchar(16), StartTime datetime, 
ConnectDateTime datetime,	 CallingCard	varchar(12),
			PIN varchar(12), Fname	varchar(25), LName varchar(25), BillType  varchar(25), CallType  varchar(25), State varchar(16), Duration 
numeric(5,2), CallRevenue  numeric(5,2), Descript varchar(25), RecordFile varchar(20))


	 Begin
		
		Insert   #tempCDR ( PhoneID, RecordID, toNo , StartTime, ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType, CallType  , State , 
Duration,CallRevenue, Descript, RecordFile )
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID, toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime , (case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo ,  tblcallsBilled.PIN,  FirstName, LastName 
,   
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,CAST( CAST(duration as numeric(7,2))/60 as 
Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
		   from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), 
tblPhonetypes with(nolock)
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.PIN  = tblInmate.PIN and
			 tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.PhoneType and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.PhoneID in ( @phoneID) and 
			 tblInmate.PIN  = @PIN and 
			 tblcallsBilled.CreditcardNo = @callingCard  and
			 tblcallsBilled.ToNo =  @DNI  and @complete =1 
			and tblcallsBilled.BillType = @BillType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as ConnectDateTime, DebitCardNo,  
tblcallsUnbilled.PIN,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.PIN  = tblInmate.PIN and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			 isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.PhoneType and  
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	
			and tblANIs.PhoneID in ( @phoneID) and
			 tblInmate.PIN  = @PIN and 
			 DebitCardNo = @callingCard and
			 tblcallsUnBilled.ToNo = @DNI  and @uncomplete =1
			and tblcallsUnBilled.BillType = @BillType

			UNION

		 SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono , ReportTime as StartTime, ReportTime as ConnectDateTime   ,'' 
  DebitCardNo, tblincidentreport.PIN, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.PIN = tblInmate.Pin and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.PIN  = @PIN  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End

	drop table   #tempCDR
