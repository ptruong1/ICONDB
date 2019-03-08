CREATE PROCEDURE [dbo].[p_Report_CDR_BillType_and_CallType_Selected1]

@FacilityID	int,
@divisionID	int,
@locationID	int,
@phoneID	varchar(100),
@InmateID		varchar(12),
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

If (@InmateID ='') set @InmateID ='0'
SET @InmateID = isnull(@InmateID,'0')
--SET @totalRecord =0

create table  #tempCDR  ([RecordIDS] [bigint] IDENTITY (1, 1) NOT NULL , PhoneID varchar(20), RecordID numeric(12), toNo varchar(16), StartTime datetime, 
ConnectDateTime datetime,	 CallingCard	varchar(12),
			InmateID varchar(12), Fname	varchar(25), LName varchar(25), BillType  varchar(25), CallType  varchar(25), State varchar(25), Duration 
numeric(5,2), CallRevenue  numeric(5,2), Descript varchar(25), RecordFile varchar(20))

If(@phoneID <> '')
begin
	If(@InmateID <> '0' and  @callingCard <> ''  and  @DNI <> '' ) 
	 Begin
		
		Insert   #tempCDR ( PhoneID, RecordID, toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  , State , 
Duration,CallRevenue, Descript, RecordFile )
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID, toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime , (case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo ,  tblcallsBilled.InmateID,  FirstName, LastName 
,   
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,CAST( CAST(duration as numeric(7,2))/60 as 
Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
		   from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), 
tblPhonetypes with(nolock)
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			 tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.PhoneType and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.PhoneID in ( @phoneID) and 
			 tblInmate.InmateID  = @InmateID and 
			 tblcallsBilled.CreditcardNo = @callingCard  and
			 tblcallsBilled.ToNo =  @DNI  and @complete =1 
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType
			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as ConnectDateTime, DebitCardNo,  
tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			 isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.PhoneType and  
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	
			and tblANIs.PhoneID in ( @phoneID) and
			 tblInmate.InmateID  = @InmateID and 
			 DebitCardNo = @callingCard and
			 tblcallsUnBilled.ToNo = @DNI  and @uncomplete =1
			and tblcallsUnBilled.BillType = @BillType
			and tblcallsUnBilled.CallType = @CallType
			UNION

		 SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono , ReportTime as StartTime, ReportTime as ConnectDateTime   ,'' 
  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@FName <> '' and  @callingCard <> '') 
	 Begin
		Insert   #tempCDR (  PhoneID , RecordID,toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  , State , 
Duration,CallRevenue, Descript, RecordFile  )
		Select  left( tblANIs.StationID,20) PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime ,  (case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end )  DebitCardNo,  tblcallsBilled.InmateID, 
		FirstName, LastName ,   tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType ,	'Completed' as  State,CAST( 
CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript, RecordFile
		  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs 
		with(nolock) ,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno =  tblANIs.ANINo and  tblcallsBilled.InmateID  = tblInmate.InmateID and
			   tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and 
			 isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and  tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  	(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and tblANIs.PhoneID in ( @phoneID) and  tblInmate.FirstName  =@FName  and 
			 tblcallsBilled.CreditCardNo = @callingCard and  @complete =1
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			 tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
			 tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	
			and tblANIs.PhoneID in ( @phoneID) and
			 tblInmate.FirstName  =@FName  and 
			DebitCardNo = @callingCard  and @uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType

			UNION

		  SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime, ReportTime   as 
ConnectDateTime   ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType  ,  State , 	Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If @FName <> ''  ------- 04/25/2011 ----
              Begin
		Insert   #tempCDR (  PhoneID , RecordID,toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  
		State , Duration,CallRevenue, Descript, RecordFile  )
		Select  left( tblANIs.StationID,20) PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime ,  (case   
		tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end )  DebitCardNo, 
		 tblcallsBilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 
		'Completed' as  State,CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript, 
RecordFile
		    from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs 
		with(nolock) ,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno =  tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			   tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and 
			 isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.PhoneID in ( @phoneID) and 
			 tblInmate.FirstName  =@FName  and 
			 --tblcallsBilled.CreditCardNo = @callingCard and  
			@complete =1
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			 tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
			 tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	
			and tblANIs.PhoneID in ( @phoneID) and
			 tblInmate.FirstName  =@FName  and 
			-- DebitCardNo = @callingCard  and 
			@uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType

			UNION

		 SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime, reportTime   as 
ConnectDateTime   ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType  ,  State ,	Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	End		-----04/25/2011 --
	Else If(@LName <> '' and  @callingCard <> '') 
	 Begin
		Insert   #tempCDR ( PhoneID ,  RecordID,toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  
		State , Duration,CallRevenue, Descript, RecordFile )
			Select  left( tblANIs.StationID,20)  PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime ,(case   
		tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end )  DebitCardNo,  tblcallsBilled.InmateID,  FirstName, LastName ,   
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
  		 from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
		,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			 tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.PhoneID in ( @phoneID) and 
			 tblInmate.LastName  =@LName  and 
			 tblcallsBilled.CreditcardNo = @callingCard and  @complete =1
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			 tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
			 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	
			and tblANIs.PhoneID in ( @phoneID) and
			 tblInmate.LastName  =@LName  and 
			 DebitCardNo = @callingCard  and @uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType

			UNION

		 SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime   ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1		
		
		SET ROWCOUNT @maximumRows
		
		select   RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard, InmateID,  Fname, LName ,  BillType, CallType  ,  State , 
		Duration,CallRevenue, Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If @LName <> ''
	 Begin
		Insert   #tempCDR ( PhoneID ,  RecordID,toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  
		State , Duration,CallRevenue, Descript, RecordFile )
			Select  left( tblANIs.StationID,20)  PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime ,(case   
		tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end )  DebitCardNo,  tblcallsBilled.InmateID,  FirstName, LastName ,   
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
   		from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
		,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			 tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.PhoneID in ( @phoneID) and 
			 tblInmate.LastName  =@LName  and 
			-- tblcallsBilled.CreditcardNo = @callingCard and  
			@complete =1
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			 tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
			 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	
			and tblANIs.PhoneID in ( @phoneID) and
			 tblInmate.LastName  =@LName  and 
			 --DebitCardNo = @callingCard  and 
			@uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType

			UNION

		  SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1		
		
		SET ROWCOUNT @maximumRows
		
		select   RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard, InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@InmateID <> '0' and @DNI <> '' ) 
	 Begin
		Insert   #tempCDR ( PhoneID ,  RecordID, toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  	State 
, Duration,CallRevenue, Descript, RecordFile  )
	
		Select  left( tblANIs.StationID,20) PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime ,(case  tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end )  DebitCardNo,  tblcallsBilled.InmateID,  FirstName, LastName ,  
 
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State, CAST( CAST(duration as numeric(7,2))/60 as 
Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
  		 from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
		,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			 tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.PhoneID in ( @phoneID) and 
			 tblInmate.InmateID  =@InmateID  	and
			 tblcallsBilled.ToNo =  @DNI  and  @complete =1
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			  tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
			 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	
			and tblANIs.PhoneID in ( @phoneID) and
			tblInmate.InmateID  =@InmateID  and
			 tblcallsUnBilled.ToNo =  @DNI   and @uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType
	
			UNION

		  SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime     ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard, InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@InmateID <> '0') 
	 Begin
		Insert   #tempCDR ( PhoneID , RecordID, toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  
		State , Duration,CallRevenue, Descript, RecordFile  )
	
		Select  left( tblANIs.StationID,20) PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime ,(case tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo,  tblcallsBilled.InmateID,  FirstName, LastName ,   
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,CAST( CAST(duration as numeric(7,2))/60 as 
Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
  		 from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			 tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.PhoneID in ( @phoneID) and 
			 tblInmate.InmateID  =@InmateID  	and  @complete =1
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			 tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	
			and tblANIs.PhoneID in ( @phoneID) and
			tblInmate.InmateID  =@InmateID   and @uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType
	
			UNION

		 SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono , ReportTime   as StartTime   ,     ReportTime   as ConnectDateTime   ,''  DebitCardNo, 
tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If( @DNI <> '' ) 
	 Begin
		Insert   #tempCDR (PhoneID ,  RecordID, toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , 
Duration,CallRevenue, Descript, RecordFile  )
	
		Select  left( tblANIs.StationID,20) PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime ,(case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo,  tblcallsBilled.InmateID,  FirstName, LastName ,  
 
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,CAST( CAST(duration as numeric(7,2))/60 as 
Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
		   from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			 tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.PhoneID in ( @phoneID) and 
			 tblcallsBilled.ToNo =  @DNI   and  @complete =1			
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			 tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			  tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			 tblANIs.PhoneID in ( @phoneID) and
			 tblcallsUnBilled.ToNo =  @DNI   and @uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType
	
			UNION

		 SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime      ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@LName <> '' and  @callingCard <> '') 
	 Begin
		Insert   #tempCDR ( PhoneID ,  RecordID, toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  	State 
, Duration,CallRevenue, Descript, RecordFile  )
			Select  left( tblANIs.StationID,20)  PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime ,(case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end )  DebitCardNo,  
			tblcallsBilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  
State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
   			from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			    tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.PhoneID in ( @phoneID) and 
			 tblcallsBilled.CreditcardNo = @callingCard and  @complete =1
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType
			
			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			 tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	
			and tblANIs.PhoneID in ( @phoneID) and			 
			 DebitCardNo = @callingCard  and @uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType

			UNION

		 SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime      ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		SET ROWCOUNT @maximumRows
		
		select   RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@LName <> '' ) 
	 Begin
		Insert   #tempCDR ( PhoneID ,  RecordID, toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  , State , 
Duration,CallRevenue, Descript, RecordFile  )
			Select  left( tblANIs.StationID,20)  PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime ,(case   
		tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end )  DebitCardNo,  tblcallsBilled.InmateID,  FirstName, LastName ,   
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
 		  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			    tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.PhoneID in ( @phoneID) and  @complete =1	
			and tblcallsBilled.BillType = @BillType	
			and tblcallsBilled.CallType = @CallType	

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			 tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  and
			 tblANIs.PhoneID in ( @phoneID) 
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType

			UNION

		  SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime      ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		SET ROWCOUNT @maximumRows
		
		select   RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else
	 Begin
		Insert   #tempCDR ( PhoneID ,RecordID,  toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  	State 
, Duration,CallRevenue, Descript, RecordFile  )
	
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime ,(case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo ,  tblcallsBilled.InmateID,  FirstName, LastName , 
  
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,CAST( CAST(duration as numeric(7,2))/60 as 
Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
  		 from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			    tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.PhoneID in ( @phoneID) and @complete =1
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			 tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and 
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	
			and tblANIs.PhoneID in ( @phoneID) and	 @uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType

			UNION

		 SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime      ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End

 End
else If(@LocationID > 0)    ----------------------------- Location
begin
	If(@InmateID <> '0' and  @callingCard <> ''  and  @DNI <> '' ) 
	 Begin
		Insert   #tempCDR (  PhoneID ,RecordID, toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  	State 
, Duration,CallRevenue, Descript, RecordFile  )
	
		Select  left( tblANIs.StationID,20) PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime ,(case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo ,  tblcallsBilled.InmateID,  FirstName, LastName , 
  
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,CAST( CAST(duration as numeric(7,2))/60 as 
Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
   		from tblcallsBilled with(nolock) ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			    tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.locationID= @LocationID and 
			 tblInmate.InmateID  = @InmateID and 
			 CreditcardNo = @callingCard  and
			 tblcallsBilled.ToNo = @DNI  and  @complete =1
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			 tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			tblANIs.locationID= @LocationID and 
			 tblInmate.InmateID  = @InmateID and 
			DebitCardNo = @callingCard and
			 tblcallsUnBilled.ToNo = @DNI  and @uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType

			UNION

		  SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime      ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@FName <> '' and  @callingCard <> '') 
	 Begin
		Insert   #tempCDR ( PhoneID ,  RecordID, toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , 
Duration,CallRevenue, Descript, RecordFile )
	
		Select  left( tblANIs.StationID,20) PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime ,(case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end )  DebitCardNo ,  tblcallsBilled.InmateID,  FirstName, LastName 
,   
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,CAST( CAST(duration as numeric(7,2))/60 as 
Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
		   from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			    tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.locationID= @LocationID and 
			 tblInmate.FirstName  =@FName  and 
			 CreditcardNo = @callingCard and  @complete =1
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			tblANIs.locationID= @LocationID and 
			 tblInmate.FirstName  =@FName  and 
			 DebitCardNo = @callingCard  and @uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType

			UNION

		 SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime      ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If @FName <> ''  ------- 04/25/2011 ----
             Begin
	Insert   #tempCDR (  PhoneID , RecordID,toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  	State , 
Duration,CallRevenue, Descript, RecordFile  )
			Select  left( tblANIs.StationID,20) PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime ,  (case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end )  DebitCardNo, 
		 tblcallsBilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  
State,CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript, RecordFile
		    from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
,tblPhonetypes with(nolock) 
		 where  tblcallsBilled.fromno =  tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			   tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and 
			 isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.PhoneID in ( @phoneID) and 
			 tblInmate.FirstName  =@FName  and @complete =1
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			 tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
			 tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	
			and tblANIs.PhoneID in ( @phoneID) and
			 tblInmate.FirstName  =@FName  and 
			-- DebitCardNo = @callingCard  and 
			@uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType

			UNION

		  SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime      ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript, 
RecordFile    from  #tempCDR 
			  WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	End		-----04/25/2011 --
	Else If(@LName <> '' and  @callingCard <> '') 
	 Begin
		Insert   #tempCDR ( PhoneID , RecordID, toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , 
Duration,CallRevenue, Descript, RecordFile)
	
		Select  left( tblANIs.StationID,20) PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime ,(case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo,  tblcallsBilled.InmateID,  FirstName, LastName ,  
 
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
 		  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			    tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.locationID= @LocationID and 
			 tblInmate.LastName  =@LName  and 
			 CreditcardNo = @callingCard  and  @complete =1
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			tblANIs.locationID= @LocationID and 
			 tblInmate.LastName  =@LName  and 
			 DebitCardNo = @callingCard  and @uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType

			UNION

		 SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime      ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		SET ROWCOUNT @maximumRows
		
		select   RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , 
			Duration,CallRevenue, Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If @LName <> ''
	Begin
		Insert   #tempCDR ( PhoneID ,  RecordID,toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , 
Duration,CallRevenue, Descript, RecordFile )
			Select  left( tblANIs.StationID,20)  PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime ,(case tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end )  DebitCardNo,  tblcallsBilled.InmateID,  FirstName, LastName ,   
			tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,CAST( CAST(duration as 
numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
 		  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
,tblPhonetypes with(nolock) 
		 where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			 tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.PhoneID in ( @phoneID) and 
			 tblInmate.LastName  =@LName  and  @complete =1
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			 tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
			 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	
			and tblANIs.PhoneID in ( @phoneID) and
			 tblInmate.LastName  =@LName  and 
			-- DebitCardNo = @callingCard  and 
			@uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType
	
			UNION
		 SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime      ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		SET ROWCOUNT @maximumRows
		
		select   RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard, InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@InmateID <> '0' and @DNI <> '' ) 
	 Begin
		Insert   #tempCDR ( PhoneID ,  RecordID,toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , 
Duration,CallRevenue, Descript, RecordFile  )
	
		Select  left( tblANIs.StationID,20) PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime ,(case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo,  tblcallsBilled.InmateID,  FirstName, LastName ,  
 
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,CAST( CAST(duration as numeric(7,2))/60 as 
Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
  		 from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			    tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.locationID= @LocationID and 
			 tblInmate.InmateID  =@InmateID  	and
			 tblcallsBilled.ToNo =  @DNI  and  @complete =1
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			tblANIs.locationID= @LocationID and 
			tblInmate.InmateID  =@InmateID  and
			 tblcallsUnBilled.ToNo =@DNI   and @uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType

			UNION

		 SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime      ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@InmateID <> '0') 
	 Begin
		Insert   #tempCDR (  PhoneID ,RecordID, toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , 
Duration,CallRevenue, Descript, RecordFile  )
	
		Select  left( tblANIs.StationID,20) PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime ,(case   
		tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo,  tblcallsBilled.InmateID,  FirstName, LastName ,   
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
		   from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno =  tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			    tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.locationID= @LocationID and 
			 tblInmate.InmateID  =@InmateID  	and  @complete =1
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType
			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
			RecordDate >= @fromDate  and 
			convert(varchar(10), RecordDate ,101) <= @toDate  and  
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			tblANIs.locationID= @LocationID and 
			tblInmate.InmateID  =@InmateID   and @uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType
	
			UNION

		 SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime      ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If( @DNI <> '' ) 
	 Begin
		Insert   #tempCDR ( PhoneID ,  RecordID, toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , 
Duration,CallRevenue, Descript, RecordFile  )
	
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime ,(case   tblcallsBilled.Billtype when '07' then 	left(CreditcardNo,12) else '' end ) DebitCardNo,  tblcallsBilled.InmateID,  FirstName, 
LastName ,   tblBilltype.Descript  as  BillType, 
		tblCallType.Descript  as  CallType , 'Completed' as  State,	CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, 
CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
 		  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			    tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.locationID= @LocationID and 
			 tblcallsBilled.ToNo =  @DNI  and  @complete =1
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID and  	
			tblANIs.locationID= @LocationID and 
			 tblcallsUnBilled.ToNo =  @DNI  and @uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType
			UNION

		 SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime      ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If( @callingCard <> '') 
	 Begin
		Insert   #tempCDR (PhoneID ,  RecordID, toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, calltype  ,  State , 
Duration,CallRevenue, Descript, RecordFile  )
	
		Select  left( tblANIs.StationID,20) PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime ,(case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo,  tblcallsBilled.InmateID,  FirstName, LastName ,  
 
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,CAST( CAST(duration as numeric(7,2))/60 as 
Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
		   from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			    tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.locationID= @LocationID and 
			 CreditcardNo = @callingCard  and  @complete =1
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and 
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			tblANIs.locationID= @LocationID and 
			 DebitCardNo = @callingCard  and @uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType

			UNION

		 SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime      ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 
		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		SET ROWCOUNT @maximumRows
		
		select   RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else
	 Begin
		Insert   #tempCDR ( PhoneID ,  RecordID, toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , 
Duration,CallRevenue, Descript, RecordFile  )
	
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime ,(case tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo,  tblcallsBilled.InmateID,  FirstName, LastName ,   
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
		   from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			    tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.locationID= @LocationID and 
			 @complete =1
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID and  	
			tblANIs.locationID= @LocationID and 
			  @uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType

			UNION

		 SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime      ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End

 End
else If(@DivisionID > 0)  ---------------Division
begin
	If(@InmateID <> '0' and  @callingCard <> ''  and  @DNI <> '' ) 
	 Begin
		Insert   #tempCDR (  PhoneID ,RecordID, toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , 
Duration,CallRevenue, Descript, RecordFile  )
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime ,(case  tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo,  tblcallsBilled.InmateID,  FirstName, LastName ,   
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,CAST( CAST(duration as numeric(7,2))/60 as 
Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
  		 from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo  and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			    tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.DivisionID= @DivisionID and 
			 tblInmate.InmateID  = @InmateID and 
			 CreditcardNo = @callingCard  and
			 tblcallsBilled.ToNo = @DNI   and  @complete =1
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION	
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			tblANIs.DivisionID= @DivisionID and 
			 tblInmate.InmateID  = @InmateID and 
			DebitCardNo = @callingCard and
			 tblcallsUnBilled.ToNo = @DNI   and @uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType

			UNION

		  SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime      ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@FName <> '' and  @callingCard <> '') 
	 Begin
		Insert   #tempCDR ( PhoneID , RecordID, toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , 
Duration,CallRevenue, Descript, RecordFile  )
	
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime ,(case tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo,  tblcallsBilled.InmateID,  FirstName, LastName ,   
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,CAST( CAST(duration as numeric(7,2))/60 as 
Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
  		 from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo  and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			    tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  			
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.DivisionID= @DivisionID and 
			 tblInmate.FirstName  =@FName  and 
			 CreditcardNo = @callingCard  and  @complete =1			
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			tblANIs.DivisionID= @DivisionID and 
			 tblInmate.FirstName  =@FName  and 
			DebitCardNo = @callingCard  and @uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType

			UNION

		 SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime      ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@FName <> '' ) 
	 Begin
		Insert   #tempCDR ( PhoneID , RecordID, toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , 
Duration,CallRevenue, Descript, RecordFile  )
	
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime , (case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end )  DebitCardNo,  tblcallsBilled.InmateID,  FirstName, LastName 
,   
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,	CAST( CAST(duration as numeric(7,2))/60 as 
Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
  		 from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			    tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  			
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.DivisionID= @DivisionID and 
			 tblInmate.FirstName  =@FName  and 
			 --CreditcardNo = @callingCard  and  
			@complete =1
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			tblANIs.DivisionID= @DivisionID and 
			 tblInmate.FirstName  =@FName  and 
			--DebitCardNo = @callingCard  and 
			@uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType

			UNION

		  SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime      ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
					
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@LName <> '' and  @callingCard <> '') 
	 Begin
		Insert   #tempCDR ( PhoneID ,RecordID,  toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , 
Duration,CallRevenue, Descript, RecordFile  )
	
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime , (case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo,  tblcallsBilled.InmateID,  FirstName, LastName , 
  
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
   		from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo  and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			    tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.DivisionID= @DivisionID and 
			 tblInmate.LastName  =@LName  and 
			 CreditcardNo = @callingCard  and  @complete =1
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			tblANIs.DivisionID= @DivisionID and 
			 tblInmate.LastName  =@LName  and 
			 DebitCardNo = @callingCard  and @uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType

			UNION

		  SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime      ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
					
		SET ROWCOUNT @maximumRows
		
		select   RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@LName <> '' ) 
	 Begin
		Insert   #tempCDR ( PhoneID ,RecordID,  toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , 
Duration,CallRevenue, Descript, RecordFile  )
	
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime , (case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo,  tblcallsBilled.InmateID,  FirstName, LastName , 
  
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,CAST( CAST(duration as numeric(7,2))/60 as 
Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
   		from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo  and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			    tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.DivisionID= @DivisionID and 
			 tblInmate.LastName  =@LName  and   			@complete =1
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			tblANIs.DivisionID= @DivisionID and 
			 tblInmate.LastName  =@LName  and 
			 -- DebitCardNo = @callingCard  and 
			@uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType

			UNION

		 SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime      ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1		
		
		SET ROWCOUNT @maximumRows
		
		select   RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@InmateID <> '0' and @DNI <> '' ) 
	 Begin
		Insert   #tempCDR ( PhoneID , RecordID, toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , 
Duration,CallRevenue, Descript, RecordFile  )
	
		Select  left( tblANIs.StationID,20) PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime ,(case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo,  tblcallsBilled.InmateID,  FirstName, LastName ,  
 
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,CAST( CAST(duration as numeric(7,2))/60 as 
Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
  		 from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 	
,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			    tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.DivisionID= @DivisionID and 
			 tblInmate.InmateID  =@InmateID  	and
			 tblcallsBilled.ToNo =  @DNI  and  @complete =1
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			tblANIs.DivisionID= @DivisionID and 
			tblInmate.InmateID  =@InmateID  and
			 tblcallsUnBilled.ToNo = @DNI  and @uncomplete =1  			
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType

			UNION

		 SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime      ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@InmateID <> '0') 
	 Begin
		Insert   #tempCDR (PhoneID , RecordID, toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , 
Duration,CallRevenue, Descript, RecordFile  )
	
		Select  left( tblANIs.StationID,20) PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime ,(case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo,  tblcallsBilled.InmateID,  FirstName, LastName ,  
 
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,	CAST( CAST(duration as numeric(7,2))/60 as 
Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
   		from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			    tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  			
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.DivisionID= @DivisionID and 
			 tblInmate.InmateID  =@InmateID  	 and  @complete =1
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			tblANIs.DivisionID= @DivisionID and 
			tblInmate.InmateID  =@InmateID   and @uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType

			UNION

		 SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime      ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If( @DNI <> '' ) 
	 Begin
		Insert   #tempCDR ( PhoneID , RecordID, toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , 
Duration,CallRevenue, Descript, RecordFile  )
	
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime ,(case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo,  tblcallsBilled.InmateID,  FirstName, LastName ,  
 
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,	CAST( CAST(duration as numeric(7,2))/60 as 
Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
   		from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			    tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  			
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.DivisionID= @DivisionID and 
			 tblcallsBilled.ToNo =  @DNI   and  @complete =1			
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			  isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			  tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
			 tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID and  	
			tblANIs.DivisionID= @DivisionID and 
			 tblcallsUnBilled.ToNo = @DNI  and @uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType

			UNION

		 SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime      ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@callingCard <> '') 
	 Begin
		Insert   #tempCDR ( PhoneID , RecordID, toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , 
Duration,CallRevenue, Descript, RecordFile  )
	
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime ,(case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo,  tblcallsBilled.InmateID,  FirstName, LastName ,  
 
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,CAST( CAST(duration as numeric(7,2))/60 as 
Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
   		from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo  and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			    tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.DivisionID= @DivisionID and 			
			 CreditcardNo = @callingCard  and  @complete =1			
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			  tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			tblANIs.DivisionID= @DivisionID and 			
			 DebitCardNo = @callingCard  and @uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType

			UNION

		 SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime      ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1		
		
		SET ROWCOUNT @maximumRows
		
		select   RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else
	 Begin
		
		Insert   #tempCDR (PhoneID , RecordID, toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , 
Duration,CallRevenue, Descript, RecordFile  )
	
		Select  left( tblANIs.StationID,20) PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime ,(case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo,  tblcallsBilled.InmateID,  FirstName, LastName ,  
 
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,	CAST( CAST(duration as numeric(7,2))/60 as 
Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
 		  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			    tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.DivisionID= @DivisionID and  @complete =1			
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID and  	
			tblANIs.DivisionID= @DivisionID and  @uncomplete =1			
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType
			UNION

		 SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime      ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End

 End
else 
begin
	
	If(@InmateID <> '0' and  @callingCard <> ''  and  @DNI <> '' ) 
	 Begin
		Insert   #tempCDR (PhoneID ,RecordID,  toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , 
Duration,CallRevenue, Descript, RecordFile  )
	
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime , (case tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end )  DebitCardNo,  tblcallsBilled.InmateID,  FirstName, LastName ,  
 
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,	CAST( CAST(duration as numeric(7,2))/60 as 
Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
  		 from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			    tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 			
			 tblInmate.InmateID  = @InmateID and 
			 CreditcardNo = @callingCard  and
			 tblcallsBilled.ToNo =  @DNI   and  @complete =1
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			 tblInmate.InmateID  = @InmateID and 
			 DebitCardNo = @callingCard and
			 tblcallsUnBilled.ToNo =@DNI   and @uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType

			UNION

		 SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime      ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 
		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@FName <> '' and  @callingCard <> '') 
	 Begin
		Insert   #tempCDR (PhoneID ,RecordID,  toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , 
Duration,CallRevenue, Descript, RecordFile  )
	
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID, toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime , (case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end )  DebitCardNo,  tblcallsBilled.InmateID,  FirstName, LastName 
,   
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,CAST( CAST(duration as numeric(7,2))/60 as 
Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
 		  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs 
with(nolock),tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			    tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 			
			 tblInmate.FirstName  =@FName  and 
			 CreditcardNo = @callingCard  and  @complete =1			
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			 tblInmate.FirstName  =@FName  and 
			 DebitCardNo = @callingCard  and @uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType

			UNION

		 SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime      ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@FName <> '' ) 
	 Begin
		Insert   #tempCDR (PhoneID ,RecordID,  toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  , State , 
Duration,CallRevenue, Descript, RecordFile  )
	
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID, toNo,   RecordDate as  StartTime, RecordDate as ConnectDateTime , (case tblcallsBilled.Billtype 
when '07' then left(CreditcardNo,12) else '' end )  DebitCardNo,  tblcallsBilled.InmateID,  FirstName, LastName ,   
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,CAST( CAST(duration as numeric(7,2))/60 as 
Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
   		from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			    tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 			
			 tblInmate.FirstName  =@FName  and 
			 --CreditcardNo = @callingCard  and  
			@complete =1			
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as ConnectDateTime, DebitCardNo,  
tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			 tblInmate.FirstName  =@FName  and 
			---DebitCardNo = @callingCard  and 
			@uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType

			UNION

		 SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime   as StartTime, reportTime as 
ConnectDateTime   ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  StartTime, ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , 
Duration,CallRevenue, Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	
	End		-----04/25/2011 --
	Else If(@LName <> '' and  @callingCard <> '') 
	 Begin
		Insert   #tempCDR ( PhoneID ,RecordID,  toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , 
Duration,CallRevenue, Descript, RecordFile  )
	
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime , (case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end )  DebitCardNo,  tblcallsBilled.InmateID,  FirstName, LastName 
,   
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,CAST( CAST(duration as numeric(7,2))/60 as 
Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
   		from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			    tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 			
			 tblInmate.LastName  =@LName  and 
			 CreditcardNo = @callingCard  and  @complete =1			
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			 isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			 tblInmate.LastName  =@LName  and 
			 DebitCardNo = @callingCard  and @uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType

			UNION

		 SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime      ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc  

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1		
		
		SET ROWCOUNT @maximumRows
		
		select   RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@LName <> '' ) 
	 Begin
		Insert   #tempCDR (PhoneID ,RecordID,  toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , 
Duration,CallRevenue, Descript, RecordFile  )
	
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID, toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime , (case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end )  DebitCardNo,  tblcallsBilled.InmateID,  FirstName, LastName 
,   
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,	CAST( CAST(duration as numeric(7,2))/60 as 
Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
  		 from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			    tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 			
			 tblInmate.LastName  =@LName  and	@complete =1			
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			 tblInmate.LastName  =@LName  and @uncomplete =1	
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType

			UNION

		  SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime      ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	
	End		-----04/25/2011 --
	Else If(@InmateID <> '0' and @DNI <> '' ) 
	 Begin
		Insert   #tempCDR (PhoneID , RecordID,  toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , 
Duration,CallRevenue, Descript, RecordFile  )
	
		Select  left( tblANIs.StationID,20) PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime ,(case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end )  DebitCardNo ,  tblcallsBilled.InmateID,  FirstName, LastName 
,   
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,CAST( CAST(duration as numeric(7,2))/60 as 
Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
 		  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo  and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			    tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  			
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			 tblInmate.InmateID  =@InmateID  	and
			 tblcallsBilled.ToNo =@DNI   and  @complete =1			
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			tblInmate.InmateID  =@InmateID  and
			 tblcallsUnBilled.ToNo = @DNI  and @uncomplete =1  
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType

			UNION

		 SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime      ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1		
				
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@InmateID <> '0') 
	 Begin
		Insert   #tempCDR ( PhoneID ,  RecordID,toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , 
Duration,CallRevenue, Descript, RecordFile  )
	
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID, toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime , (case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo,  tblcallsBilled.InmateID,  FirstName, LastName , 
  
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,	CAST( CAST(duration as numeric(7,2))/60 as 
Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
   		from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			    tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
						 tblInmate.InmateID  =@InmateID  	 and  @complete =1
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			tblInmate.InmateID  =@InmateID   and @uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType
				
			UNION

		 SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime      ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If( @DNI <> '' ) 
	 Begin
		Insert   #tempCDR (PhoneID , RecordID, toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , 
Duration,CallRevenue, Descript, RecordFile  )
	
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime , (case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end )  DebitCardNo,  tblcallsBilled.InmateID,  FirstName, LastName 
,   
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,	CAST( CAST(duration as numeric(7,2))/60 as 
Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
 		  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromNo =  tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			    tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 			
			 tblcallsBilled.ToNo = @DNI   and  @complete =1
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID and  	
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			 tblcallsUnBilled.ToNo =@DNI   and @uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType
	
			UNION

		 SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime      ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If( @callingCard <> '') 
	 Begin
		Insert   #tempCDR ( PhoneID ,  RecordID,toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , 
Duration,CallRevenue, Descript, RecordFile  )
	
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime ,(case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo,  tblcallsBilled.InmateID,  FirstName, LastName ,  
 
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,CAST( CAST(duration as numeric(7,2))/60 as 
Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
 		  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			    tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			 CreditcardNo = @callingCard  and  @complete =1		
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			 DebitCardNo = @callingCard  and @uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType

			UNION

		 select  left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime      ,''  DebitCardNo ,  tblincidentreport.InmateID,  FirstName, LastName ,   
		'CTS'  as BillType, 'RTS' as CallType ,    'Call To Staff'      as     state     ,  '0' as Duration, 0  as  CallRevenue, '3' as Descript, 
'UnK' as RecordFile  from tblincidentreport with(nolock) , tblInmate with(nolock)  ,tblANIs with(nolock)  
			where 	ANI = tblANIs.ANINo and
			tblincidentreport.InmateID = tblInmate.InmateID and
			tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
			and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID)   and @private =1 
			Order by  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1		
		
		SET ROWCOUNT @maximumRows
		
		select   RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR   WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else
	 Begin
		
		Insert   #tempCDR ( PhoneID , RecordID, toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , 
Duration,CallRevenue, Descript, RecordFile  )
	
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID , toNo,   DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime ,(case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo,  tblcallsBilled.InmateID,  FirstName, LastName ,  
 
		tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , 'Completed' as  State,	CAST( CAST(duration as numeric(7,2))/60 as 
Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile
 		  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) 
,tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno =  tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			    tblcallsBilled.Billtype = tblBilltype.billtype and  tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			   @complete =1
			and tblcallsBilled.BillType = @BillType
			and tblcallsBilled.CallType = @CallType

			 UNION

		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as 
ConnectDateTime, DebitCardNo,  tblcallsUnbilled.InmateID,  FirstName, LastName ,   tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,'0'  as Duration,0, tblPhoneTypes.Descript as Descript , 'UnK' as 
RecordFile   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,'NA' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 									
	
			 tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID and  	
			 @uncomplete =1
			and tblcallsUnBilled.BillType = @BillType and tblcallsUnBilled.CallType = @CallType			
	
			UNION

		 SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime as StartTime,  ReportTime   as 
ConnectDateTime      ,''  DebitCardNo, tblincidentreport.InmateID, LastName ,  FirstName,   'CTS'  as BillType,
			 'RTS' as CallType ,    'Call To Staff'      as     state ,  '0' as Duration, 0 as  CallRevenue, '3' as Descript, 'UnK' as RecordFile 
			 FROM  tblincidentreport with(nolock) , tblInmate with(nolock)  	,tblANIs with(nolock)  
			 WHERE ANI = tblANIs.ANINo and tblincidentreport.InmateID = tblInmate.InmateID and
				tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
				and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  
				tblInmate.InmateID  = @InmateID  and @private =1 
			ORDER BY  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , StartTime, ConnectDateTime , CallingCard,InmateID,  Fname, LName ,  BillType, CallType  ,  State , Duration,CallRevenue, 
Descript, RecordFile    from  #tempCDR  WHERE   RecordIDs >= @startRowIndex
		
		set ROWCOUNT 0
	 End

 End

	drop table   #tempCDR
