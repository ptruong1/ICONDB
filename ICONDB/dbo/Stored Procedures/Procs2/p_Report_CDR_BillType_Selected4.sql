CREATE PROCEDURE [dbo].[p_Report_CDR_BillType_Selected4]
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


	create table  #tempCDR  ([RecordIDS] [bigint] IDENTITY (1, 1) NOT NULL ,
				 PhoneID char(20),
				 RecordID numeric(12),
				 toNo varchar(16),
				 ConnectDateTime datetime,
				 CallingCard	varchar(12),
				 PIN		varchar(12),
				 Fname		varchar(25),
			 	 LName		varchar(25),
				 BillType  varchar(25),
				 State varchar(16), 
				 Duration numeric(5,2),
				 CallRevenue  numeric(5,2),
				 Descript varchar(25))


If(@phoneID <> '')
begin
	If(@PIN <> '0' and  @callingCard <> ''  and  @DNI <> '' ) 
	 Begin
		
		Insert   #tempCDR ( PhoneID, RecordID, toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript )
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID, toNo,   RecordDate as  ConnectDateTime , (case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo ,  tblcallsBilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.PIN  = tblInmate.PIN and
			 tblcallsBilled.Billtype = tblBilltype.billtype and  isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.PhoneID in ( @phoneID) and 
			 tblInmate.PIN  = @PIN and 
			 tblcallsBilled.CreditcardNo = @callingCard  and
			 tblcallsBilled.ToNo =  @DNI  and @complete =1 

			 and tblcallsBilled.billtype = @BillType

			  UNION 
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID , toNo,   RecordDate as  ConnectDateTime , DebitCardNo,  tblcallsUnbilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType  ,tblErrortype.Descript as  State,
			 '0'  as Duration,0, tblPhoneTypes.Descript as Descript  from tblcallsUnbilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) , tblErrortype  with(nolock)
		  where  tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.PIN  = tblInmate.PIN and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	
			and tblANIs.PhoneID in ( @phoneID) and
			 tblInmate.PIN  = @PIN and 
			 DebitCardNo = @callingCard and
			 tblcallsUnBilled.ToNo = @DNI  and @uncomplete =1
	
			and tblcallsUnBilled.Billtype = @BillType

			  UNION 

		 select  left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime   as ConnectDateTime   ,''  DebitCardNo, tblincidentreport.PIN, LastName ,  FirstName,   'CTS'  as BillType ,    'Call To Staff'      as     state     ,
			  '0' as Duration, 0  as  CallRevenue, '3' as Descript  from tblincidentreport with(nolock) , tblInmate with(nolock)  ,tblANIs with(nolock)
			where 	ANI = tblANIs.ANINo and
			tblincidentreport.PIN = tblInmate.Pin and
			tblincidentreport.FacilityID	= @FacilityID and tblincidentreport.InputDate  >= @FromDate  
			and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  tblInmate.PIN  = @PIN  and @private =1 
			Order by  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript    from  #tempCDR   WHERE   RecordID >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@FName <> '' and  @callingCard <> '') 
	 Begin
		Insert   #tempCDR ( PhoneID ,RecordID, toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration, CallRevenue, Descript  )
			Select  left( tblANIs.StationID,20) PhoneID , RecordID ,toNo,   RecordDate as  ConnectDateTime ,  left(tblcallsBilled.CreditCardNo,12)  DebitCardNo,  tblcallsBilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno =  tblANIs.ANINo and
			 tblcallsBilled.PIN  = tblInmate.PIN and
			   tblcallsBilled.Billtype = tblBilltype.billtype and  isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.PhoneID in ( @phoneID) and 
			 tblInmate.FirstName  =@FName  and 
			 tblcallsBilled.CreditCardNo = @callingCard and  
			@complete =1

			 and tblcallsBilled.Billtype = @BillType

			  UNION 
		
		Select  left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , toNo,   RecordDate as  ConnectDateTime , DebitCardNo,  tblcallsUnbilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType  ,tblErrortype.Descript as  State,
			 '0'  as Duration,0, tblPhoneTypes.Descript as Descript  from tblcallsUnbilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) , tblErrortype  with(nolock)
		  where  tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.PIN  = tblInmate.PIN and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and
			 tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	
			and tblANIs.PhoneID in ( @phoneID) and
			 tblInmate.FirstName  =@FName  and 
			DebitCardNo = @callingCard  and @uncomplete =1
	
			and tblcallsUnBilled.Billtype = @BillType

			  UNION 

		 select  left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime   as ConnectDateTime   ,''  DebitCardNo,  tblincidentreport.PIN, LastName ,  FirstName,   'CTS'  as BillType ,    'Call To Staff'      as     state     ,
			  '0' as Duration, 0  as  CallRevenue, '3' as Descript  from tblincidentreport with(nolock) , tblInmate with(nolock)  ,tblANIs with(nolock)
			where 	ANI = tblANIs.ANINo and
			tblincidentreport.PIN = tblInmate.Pin and
			tblincidentreport.FacilityID	= @FacilityID and tblincidentreport.InputDate  >= @FromDate  
			and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID)  and @private =1 
			Order by  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		
		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript    from  #tempCDR   WHERE   RecordID >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@LName <> '' and  @callingCard <> '') 
	 Begin
		Insert   #tempCDR ( PhoneID , RecordID,toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration, CallRevenue, Descript  )
			Select  left( tblANIs.StationID,20)  PhoneID , RecordID,toNo,   RecordDate as  ConnectDateTime ,left(tblcallsBilled.CreditCardNo,12)  DebitCardNo,  tblcallsBilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.PIN  = tblInmate.PIN and
			   tblcallsBilled.Billtype = tblBilltype.billtype and  isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.PhoneID in ( @phoneID) and 
			 tblInmate.LastName  =@LName  and 
			 tblcallsBilled.CreditcardNo = @callingCard and  @complete =1
			

			 and tblcallsBilled.Billtype = @BillType

			  UNION 
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID , toNo,   RecordDate as  ConnectDateTime , DebitCardNo,  tblcallsUnbilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType  ,tblErrortype.Descript as  State,
			 '0'  as Duration, 0, tblPhoneTypes.Descript as Descript  from tblcallsUnbilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) , tblErrortype  with(nolock)
		  where  tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.PIN  = tblInmate.PIN and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and
			 tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	
			and tblANIs.PhoneID in ( @phoneID) and
			 tblInmate.LastName  =@LName  and 
			 DebitCardNo = @callingCard  and @uncomplete =1
	
			and tblcallsUnBilled.Billtype = @BillType

			  UNION 

		 select  left( tblANIs.StationID,20) , 0 as recordID, 'CTS'  as Tono ,      ReportTime   as ConnectDateTime   ,'' DebitCardNo,  tblincidentreport.PIN, LastName ,  FirstName,   'CTS'  as BillType ,    'Call To Staff'      as     state     ,
			  '0' as Duration, 0  as  CallRevenue, '3' as Descript  from tblincidentreport with(nolock) , tblInmate with(nolock)  ,tblANIs with(nolock) 
			where 	ANI = tblANIs.ANINo and
			tblincidentreport.PIN = tblInmate.Pin and
			tblincidentreport.FacilityID	= @FacilityID and tblincidentreport.InputDate  >= @FromDate  
			and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID)  and @private =1 
			Order by  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		
		
		
		SET ROWCOUNT @maximumRows
		
		select   RecordID, PhoneID , toNo , ConnectDateTime , CallingCard, PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript    from  #tempCDR   WHERE   RecordID >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@PIN <> '0' and @DNI <> '' ) 
	 Begin
		Insert   #tempCDR ( PhoneID ,  RecordID, toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript  )
	
		Select  left( tblANIs.StationID,20) PhoneID, RecordID , toNo,   RecordDate as  ConnectDateTime ,(case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end )  DebitCardNo,  tblcallsBilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.PIN  = tblInmate.PIN and
			   tblcallsBilled.Billtype = tblBilltype.billtype and  isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.PhoneID in ( @phoneID) and 
			 tblInmate.PIN  =@PIN  	and
			 tblcallsBilled.ToNo =  @DNI  and  @complete =1

			 and tblcallsBilled.Billtype = @BillType

			  UNION 
		
		Select  left( tblANIs.StationID,20)  PhoneID, 0 as RecordID, toNo,   RecordDate as  ConnectDateTime , DebitCardNo,  tblcallsUnbilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType  ,tblErrortype.Descript as  State,
			 '0'  as Duration, 0, tblPhoneTypes.Descript as Descript  from tblcallsUnbilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) , tblErrortype  with(nolock)
		  where  tblcallsUnBilled.fromno = tblANIs.ANINo and
			 tblcallsUnBilled.PIN  = tblInmate.PIN and
			  tblcallsUnBilled.Billtype = tblBilltype.billtype and isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and
			 tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	
			and tblANIs.PhoneID in ( @phoneID) and
			tblInmate.PIN  =@PIN  and
			 tblcallsUnBilled.ToNo =  @DNI   and @uncomplete =1
			
	
			and tblcallsUnBilled.Billtype = @BillType

			  UNION 

		 select  left( tblANIs.StationID,20) , 0 as RecordID,'CTS'  as Tono ,      ReportTime   as ConnectDateTime   ,'' DebitCardNo,  tblincidentreport.PIN, LastName ,  FirstName,   'CTS'  as BillType ,    'Call To Staff'      as     state     ,
			  '0' as Duration, 0  as  CallRevenue, '3' as Descript  from tblincidentreport with(nolock) , tblInmate with(nolock)  ,tblANIs with(nolock)
			where 	ANI = tblANIs.ANINo and
			tblincidentreport.PIN = tblInmate.Pin and
			tblincidentreport.FacilityID	= @FacilityID and tblincidentreport.InputDate  >= @FromDate  
			and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and tblInmate.PIN  =@PIN    and @private =1 
			Order by  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		
				
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , ConnectDateTime , CallingCard, PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript    from  #tempCDR   WHERE   RecordID >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@PIN <> '0') 
	 Begin
		Insert   #tempCDR ( PhoneID , RecordID, toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript  )
	
		Select  left( tblANIs.StationID,20) PhoneID , RecordID ,toNo,   RecordDate as  ConnectDateTime ,left(CreditcardNo,12) DebitCardNo,  tblcallsBilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.PIN  = tblInmate.PIN and
			   tblcallsBilled.Billtype = tblBilltype.billtype and  isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.PhoneID in ( @phoneID) and 
			 tblInmate.PIN  =@PIN  	and  @complete =1

			 and tblcallsBilled.Billtype = @BillType

			  UNION 
		
		Select  left( tblANIs.StationID,20)  PhoneID, 0 as RecordID, toNo,   RecordDate as  ConnectDateTime , DebitCardNo,  tblcallsUnbilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType  ,tblErrortype.Descript as  State,
			 '0'  as Duration, 0, tblPhoneTypes.Descript as Descript  from tblcallsUnbilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) , tblErrortype  with(nolock)
		  where  tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.PIN  = tblInmate.PIN and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	
			and tblANIs.PhoneID in ( @phoneID) and
			tblInmate.PIN  =@PIN   and @uncomplete =1
				
			and tblcallsUnBilled.Billtype = @BillType

			  UNION 

		 select  left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime   as ConnectDateTime   ,'' DebitCardNo ,  tblincidentreport.PIN, LastName ,  FirstName,   'CTS'  as BillType ,    'Call To Staff'      as     state     ,
			  '0' as Duration, 0  as  CallRevenue, '3' as Descript  from tblincidentreport with(nolock) , tblInmate with(nolock)  ,tblANIs with(nolock) 
			where 	ANI = tblANIs.ANINo and
			tblincidentreport.PIN = tblInmate.Pin and
			tblincidentreport.FacilityID	= @FacilityID and tblincidentreport.InputDate  >= @FromDate  
			and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and tblInmate.PIN  =@PIN    and @private =1 
			Order by  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		
		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript    from  #tempCDR   WHERE   RecordID >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If( @DNI <> '' ) 
	 Begin
		Insert   #tempCDR (PhoneID ,  RecordID, toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript  )
	
		Select  left( tblANIs.StationID,20) PhoneID , RecordID,toNo,   RecordDate as  ConnectDateTime ,left(CreditcardNo,12) DebitCardNo,  tblcallsBilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.PIN  = tblInmate.PIN and
			   tblcallsBilled.Billtype = tblBilltype.billtype and  isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.PhoneID in ( @phoneID) and 
			 tblcallsBilled.ToNo =  @DNI   and  @complete =1
			

			 and tblcallsBilled.Billtype = @BillType

			  UNION 
		
		Select  left( tblANIs.StationID,20)  PhoneID, 0 as RecordID, toNo,   RecordDate as  ConnectDateTime , DebitCardNo,  tblcallsUnbilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType  ,tblErrortype.Descript as  State,
			 '0'  as Duration, 0, tblPhoneTypes.Descript as Descript  from tblcallsUnbilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) , tblErrortype  with(nolock)
		  where  tblcallsUnBilled.fromno = tblANIs.ANINo and
			 tblcallsUnBilled.PIN  = tblInmate.PIN and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and
			  tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			 tblANIs.PhoneID in ( @phoneID) and
			 tblcallsUnBilled.ToNo =  @DNI   and @uncomplete =1
			
	
			and tblcallsUnBilled.Billtype = @BillType

			  UNION 

		 select  left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime   as ConnectDateTime   ,''  DebitCardNo,  tblincidentreport.PIN, LastName ,  FirstName,   'CTS'  as BillType ,    'Call To Staff'      as     state     ,
			  '0' as Duration, 0  as  CallRevenue, '3' as Descript  from tblincidentreport with(nolock) , tblInmate with(nolock)  ,tblANIs with(nolock)
			where 	ANI= tblANIs.ANINo and
			tblincidentreport.PIN = tblInmate.Pin and
			tblincidentreport.FacilityID	= @FacilityID and tblincidentreport.InputDate  >= @FromDate  
			and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and tblInmate.PIN  =@PIN    and @private =1 
			Order by  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript    from  #tempCDR   WHERE   RecordID >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@LName <> '' and  @callingCard <> '') 
	 Begin
		Insert   #tempCDR ( PhoneID ,  RecordID, toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript  
)
			Select  left( tblANIs.StationID,20)  PhoneID, RecordID , toNo,   RecordDate as  ConnectDateTime ,(case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end )  DebitCardNo,  tblcallsBilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.PIN  = tblInmate.PIN and
			   tblcallsBilled.Billtype = tblBilltype.billtype and  isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.PhoneID in ( @phoneID) and 
			 
			 tblcallsBilled.CreditcardNo = @callingCard and  @complete =1
			

			 and tblcallsBilled.Billtype = @BillType

			  UNION 
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID , toNo,   RecordDate as  ConnectDateTime , DebitCardNo,  tblcallsUnbilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType  ,tblErrortype.Descript as  State,
			 '0'  as Duration, 0, tblPhoneTypes.Descript as Descript  from tblcallsUnbilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) , tblErrortype  with(nolock)
		  where  tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.PIN  = tblInmate.PIN and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and
			 tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	
			and tblANIs.PhoneID in ( @phoneID) and
			 
			 DebitCardNo = @callingCard  and @uncomplete =1
	
			and tblcallsUnBilled.Billtype = @BillType

			  UNION 

		 select  left( tblANIs.StationID,20) , 0 as RecordID,'CTS'  as Tono ,      ReportTime   as ConnectDateTime   ,'' DebitCardNo,  tblincidentreport.PIN, LastName ,  FirstName,   'CTS'  as BillType ,    'Call To Staff'      as     state     ,
			  '0' as Duration, 0  as  CallRevenue, '3' as Descript  from tblincidentreport with(nolock) , tblInmate with(nolock)  ,tblANIs with(nolock) 
			where 	ANI = tblANIs.ANINo and
			tblincidentreport.PIN = tblInmate.Pin and
			tblincidentreport.FacilityID	= @FacilityID and tblincidentreport.InputDate  >= @FromDate  
			and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID)  and @private =1 
			Order by  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		
		
		
		SET ROWCOUNT @maximumRows
		
		select   RecordID, PhoneID , toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript    from  #tempCDR   WHERE   RecordID >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else
	 Begin
		Insert   #tempCDR ( PhoneID ,RecordID,  toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript  )
	
		Select  left( tblANIs.StationID,20)  PhoneID , RecordID ,toNo,   RecordDate as  ConnectDateTime ,left(CreditcardNo,12) DebitCardNo ,  tblcallsBilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.PIN  = tblInmate.PIN and
			   tblcallsBilled.Billtype = tblBilltype.billtype and  isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.PhoneID in ( @phoneID) and 
			 @complete =1
			

			 and tblcallsBilled.Billtype = @BillType

			  UNION 
--Line 493
		
		Select  left( tblANIs.StationID,20)  PhoneID, 0 as RecordID, toNo,   RecordDate as  ConnectDateTime , DebitCardNo,  tblcallsUnbilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType  ,tblErrortype.Descript as  State,
			 '0'  as Duration, 0, tblPhoneTypes.Descript as Descript  from tblcallsUnbilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) , tblErrortype  with(nolock)
		  where  tblcallsUnBilled.fromno = tblANIs.ANINo and
			 tblcallsUnBilled.PIN  = tblInmate.PIN and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and   
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and 
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	
			and tblANIs.PhoneID in ( @phoneID) and
			 @uncomplete =1
			
	
			and tblcallsUnBilled.Billtype = @BillType

			  UNION 

		 select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime   as ConnectDateTime   ,'' DebitCardNo,  tblincidentreport.PIN, LastName ,  FirstName,   'CTS'  as BillType ,    'Call To Staff'      as     state     ,
			  '0' as Duration, 0  as  CallRevenue, '3' as Descript  from tblincidentreport with(nolock) , tblInmate with(nolock)  ,tblANIs with(nolock)
			where 	ANI = tblANIs.ANINo and
			tblincidentreport.PIN = tblInmate.Pin and
			tblincidentreport.FacilityID	= @FacilityID and tblincidentreport.InputDate  >= @FromDate    
			and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and tblInmate.PIN  =@PIN    and @private =1 
			Order by  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript    from  #tempCDR   WHERE   RecordID >= @startRowIndex
		
		set ROWCOUNT 0
	 End

 End
else If(@LocationID > 0)
begin
	If(@PIN <> '0' and  @callingCard <> ''  and  @DNI <> '' ) 
	 Begin
		Insert   #tempCDR (  PhoneID ,RecordID, toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript  )
	
		Select  left( tblANIs.StationID,20) PhoneID ,RecordID , toNo,   RecordDate as  ConnectDateTime ,left(CreditcardNo,12) DebitCardNo ,  tblcallsBilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.PIN  = tblInmate.PIN and
			   tblcallsBilled.Billtype = tblBilltype.billtype and  isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.locationID= @LocationID and 
			 tblInmate.PIN  = @PIN and 
			 CreditcardNo = @callingCard  and
			 tblcallsBilled.ToNo = @DNI  and  @complete =1

			 and tblcallsBilled.Billtype = @BillType

			  UNION 
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID  , toNo,   RecordDate as  ConnectDateTime , DebitCardNo,  tblcallsUnbilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType  ,tblErrortype.Descript as  State,
			 '0'  as Duration, 0, tblPhoneTypes.Descript as Descript  from tblcallsUnbilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) , tblErrortype  with(nolock)
		  where  tblcallsUnBilled.fromno = tblANIs.ANINo and
			 tblcallsUnBilled.PIN  = tblInmate.PIN and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			tblANIs.locationID= @LocationID and 
			 tblInmate.PIN  = @PIN and 
			DebitCardNo = @callingCard and
			 tblcallsUnBilled.ToNo = @DNI  and @uncomplete =1
	
			and tblcallsUnBilled.Billtype = @BillType

			  UNION 

		 select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime   as ConnectDateTime   ,'' DebitCardNo,  tblincidentreport.PIN, LastName ,  FirstName,   'CTS'  as BillType ,    'Call To Staff'      as     state     ,
			  '0' as Duration, 0  as  CallRevenue, '3' as Descript  from tblincidentreport with(nolock) , tblInmate with(nolock)  ,tblANIs with(nolock) 
			where 	ANI = tblANIs.ANINO and
			tblincidentreport.PIN = tblInmate.Pin and
			tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
			and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  tblInmate.PIN  = @PIN  and @private =1 
			Order by  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		
		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript    from  #tempCDR   WHERE   RecordID >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@FName <> '' and  @callingCard <> '') 
	 Begin
		Insert   #tempCDR ( PhoneID ,  RecordID, toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript  
)
	
		Select  left( tblANIs.StationID,20) PhoneID , RecordID ,toNo,   RecordDate as  ConnectDateTime ,left(tblcallsBilled.CreditCardNo,12)  DebitCardNo ,  tblcallsBilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.PIN  = tblInmate.PIN and
			   tblcallsBilled.Billtype = tblBilltype.billtype and  isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.locationID= @LocationID and 
			 tblInmate.FirstName  =@FName  and 
			 CreditcardNo = @callingCard and  @complete =1
			 and tblcallsBilled.Billtype = @BillType

 			 UNION 
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID , toNo,   RecordDate as  ConnectDateTime , DebitCardNo,  tblcallsUnbilled.PIN, LastName , FirstName,   tblBilltype.Descript  as  BillType  ,tblErrortype.Descript as  State,
			 '0'  as Duration, 0, tblPhoneTypes.Descript as Descript  from tblcallsUnbilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) , tblErrortype  with(nolock)
		  where  tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.PIN  = tblInmate.PIN and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			tblANIs.locationID= @LocationID and 
			 tblInmate.FirstName  =@FName  and 
			 DebitCardNo = @callingCard  and @uncomplete =1
	
			and tblcallsUnBilled.Billtype = @BillType

			  UNION 

		 select  left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime   as ConnectDateTime   ,'' DebitCardNo,  tblincidentreport.PIN, LastName ,  FirstName,   'CTS'  as BillType ,    'Call To Staff'      as     state     ,
			  '0' as Duration, 0  as  CallRevenue, '3' as Descript  from tblincidentreport with(nolock) , tblInmate with(nolock)  ,tblANIs with(nolock) 
			where 	ANI = tblANIs.ANINo and
			tblincidentreport.PIN = tblInmate.Pin and
			tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate   
			and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID)  and @private =1 
			Order by  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		
		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript    from  #tempCDR   WHERE   RecordID >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@LName <> '' and  @callingCard <> '') 
	 Begin
		Insert   #tempCDR ( PhoneID , RecordID, toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript  
)
	
		Select  left( tblANIs.StationID,20) PhoneID ,RecordID , toNo,   RecordDate as  ConnectDateTime ,left(CreditcardNo,12) DebitCardNo,  tblcallsBilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.PIN  = tblInmate.PIN and
			   tblcallsBilled.Billtype = tblBilltype.billtype and  isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.locationID= @LocationID and 
			 tblInmate.LastName  =@LName  and 
			 CreditcardNo = @callingCard  and  @complete =1
			

			 and tblcallsBilled.Billtype = @BillType

			  UNION 
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID , toNo,   RecordDate as  ConnectDateTime , DebitCardNo,  tblcallsUnbilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType  ,tblErrortype.Descript as  State,
			 '0'  as Duration, 0, tblPhoneTypes.Descript as Descript  from tblcallsUnbilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) , tblErrortype  with(nolock)
		  where  tblcallsUnBilled.fromno = tblANIs.ANINo and
			 tblcallsUnBilled.PIN  = tblInmate.PIN and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			tblANIs.locationID= @LocationID and 
			 tblInmate.LastName  =@LName  and 
			 DebitCardNo = @callingCard  and @uncomplete =1
	
			and tblcallsUnBilled.Billtype = @BillType

			  UNION 

		 select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime   as ConnectDateTime   ,'' DebitCardNo,  tblincidentreport.PIN, LastName ,  FirstName,   'CTS'  as BillType ,    'Call To Staff'      as     state     ,
			  '0' as Duration, 0  as  CallRevenue, '3' as Descript  from tblincidentreport with(nolock) , tblInmate with(nolock)  ,tblANIs with(nolock)
			where 	ANI = tblANIs.ANINo and
			tblincidentreport.PIN = tblInmate.Pin and
			tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate   
			and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID)  and @private =1  
			Order by  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		
		
		
		SET ROWCOUNT @maximumRows
		
		select   RecordID, PhoneID , toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript    from  #tempCDR   WHERE   RecordID >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@PIN <> '0' and @DNI <> '' ) 
	 Begin
		Insert   #tempCDR ( PhoneID ,  RecordID,toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript  )
	
		Select  left( tblANIs.StationID,20) PhoneID , RecordID ,toNo,   RecordDate as  ConnectDateTime ,left(CreditcardNo,12) DebitCardNo,  tblcallsBilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.PIN  = tblInmate.PIN and
			   tblcallsBilled.Billtype = tblBilltype.billtype and  isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.locationID= @LocationID and 
			 tblInmate.PIN  =@PIN  	and
			 tblcallsBilled.ToNo =  @DNI  and  @complete =1
			

			 and tblcallsBilled.Billtype = @BillType

			  UNION 
		
		Select  left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , toNo,   RecordDate as  ConnectDateTime , DebitCardNo ,  tblcallsUnbilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType  ,tblErrortype.Descript as  State,
			 '0'  as Duration, 0, tblPhoneTypes.Descript as Descript  from tblcallsUnbilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) , tblErrortype  with(nolock)
		  where  tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.PIN  = tblInmate.PIN and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			tblANIs.locationID= @LocationID and 
			tblInmate.PIN  =@PIN  and
			 tblcallsUnBilled.ToNo =@DNI   and @uncomplete =1
			
	
			and tblcallsUnBilled.Billtype = @BillType

			  UNION 

		 select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime   as ConnectDateTime   ,'' DebitCardNo,  tblincidentreport.PIN, LastName ,  FirstName,   'CTS'  as BillType ,    'Call To Staff'      as     state     ,
			  '0' as Duration, 0  as  CallRevenue, '3' as Descript  from tblincidentreport with(nolock) , tblInmate with(nolock)  ,tblANIs with(nolock) 
			where 	ANI = tblANIs.ANINo and
			tblincidentreport.PIN = tblInmate.Pin and
			tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate 
			and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and tblInmate.PIN  =@PIN    and @private =1 
			Order by  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		
		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript    from  #tempCDR   WHERE   RecordID >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@PIN <> '0') 
	 Begin
		Insert   #tempCDR (  PhoneID ,RecordID, toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript  )
	
		Select  left( tblANIs.StationID,20) PhoneID, RecordID , toNo,   RecordDate as  ConnectDateTime ,(case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo,  tblcallsBilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno =  tblANIs.ANINo and
			 tblcallsBilled.PIN  = tblInmate.PIN and
			   tblcallsBilled.Billtype = tblBilltype.billtype and  isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.locationID= @LocationID and 
			 tblInmate.PIN  =@PIN  	and  @complete =1
			 and tblcallsBilled.Billtype = @BillType

			  UNION 
		
		Select  left( tblANIs.StationID,20) , 0 as RecordID, toNo,   RecordDate as  ConnectDateTime , DebitCardNo,  tblcallsUnbilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType  ,tblErrortype.Descript as  State,
			 '0'  as Duration, 0, tblPhoneTypes.Descript as Descript  from tblcallsUnbilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) , tblErrortype  with(nolock)
		  where  tblcallsUnBilled.fromno = tblANIs.ANINo and
			 tblcallsUnBilled.PIN  = tblInmate.PIN and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			RecordDate >= @fromDate  and 
			convert(varchar(10), RecordDate ,101) <= @toDate  and  
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			tblANIs.locationID= @LocationID and 
			tblInmate.PIN  =@PIN   and @uncomplete =1
				
			and tblcallsUnBilled.Billtype = @BillType

			  UNION 

		 select  left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime   as ConnectDateTime   ,'' DebitCardNo,  tblincidentreport.PIN, LastName ,  FirstName,   'CTS'  as BillType ,    'Call To Staff'      as     state     ,
			  '0' as Duration, 0  as  CallRevenue, '3' as Descript  from tblincidentreport with(nolock) , tblInmate with(nolock)  ,tblANIs with(nolock) 
			where 	ANI =  tblANIs.ANINo and
			tblincidentreport.PIN = tblInmate.Pin and
			tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate 
			and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and tblInmate.PIN  =@PIN    and @private =1 
			Order by  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		
		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript    from  #tempCDR   WHERE   RecordID >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If( @DNI <> '' ) 
	 Begin
		Insert   #tempCDR ( PhoneID ,  RecordID, toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript  )
	
		Select  left( tblANIs.StationID,20)  PhoneID ,RecordID , toNo,   RecordDate as  ConnectDateTime ,left(CreditcardNo,12) DebitCardNo,  tblcallsBilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.PIN  = tblInmate.PIN and
			   tblcallsBilled.Billtype = tblBilltype.billtype and  isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.locationID= @LocationID and 
			 tblcallsBilled.ToNo =  @DNI  and  @complete =1
			
			 and tblcallsBilled.Billtype = @BillType

			  UNION 
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID  , toNo,   RecordDate as  ConnectDateTime , DebitCardNo,  tblcallsUnbilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType  ,tblErrortype.Descript as  State,
			 '0'  as Duration, 0, tblPhoneTypes.Descript as Descript  from tblcallsUnbilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) , tblErrortype  with(nolock)
		  where  tblcallsUnBilled.fromno = tblANIs.ANINo and
			 tblcallsUnBilled.PIN  = tblInmate.PIN and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID and  	
			tblANIs.locationID= @LocationID and 
			 tblcallsUnBilled.ToNo =  @DNI  and @uncomplete =1
			
			and tblcallsUnBilled.Billtype = @BillType

			  UNION 

		 select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime   as ConnectDateTime   ,'' DebitCardNo,  tblincidentreport.PIN, LastName ,  FirstName,   'CTS'  as BillType ,    'Call To Staff'      as     state     ,
			  '0' as Duration, 0  as  CallRevenue, '3' as Descript  from tblincidentreport with(nolock) , tblInmate with(nolock)  ,tblANIs with(nolock) 
			where 	ANI = tblANIs.ANINo   and
			tblincidentreport.PIN = tblInmate.Pin and
			tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate 
			and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and tblInmate.PIN  =@PIN    and @private =1 
			Order by  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript    from  #tempCDR   WHERE   RecordID >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If( @callingCard <> '') 
	 Begin
		Insert   #tempCDR (PhoneID ,  RecordID, toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript  )
	
		Select  left( tblANIs.StationID,20) PhoneID, RecordID , toNo,   RecordDate as  ConnectDateTime ,(case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo,  tblcallsBilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.PIN  = tblInmate.PIN and
			   tblcallsBilled.Billtype = tblBilltype.billtype and  isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.locationID= @LocationID and 
			
			 CreditcardNo = @callingCard  and  @complete =1
			

			 and tblcallsBilled.Billtype = @BillType

			  UNION 
----line 896
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID , toNo,   RecordDate as  ConnectDateTime , DebitCardNo,  tblcallsUnbilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType  ,tblErrortype.Descript as  State,
			 '0'  as Duration, 0, tblPhoneTypes.Descript as Descript  from tblcallsUnbilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) , tblErrortype  with(nolock)
		  where  tblcallsUnBilled.fromno = tblANIs.ANINo and
			 tblcallsUnBilled.PIN  = tblInmate.PIN and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and 
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and 
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			tblANIs.locationID= @LocationID and 
			
			 DebitCardNo = @callingCard  and @uncomplete =1
	
			and tblcallsUnBilled.Billtype = @BillType

			  UNION 

		 select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime   as ConnectDateTime   ,'' DebitCardNo,  tblincidentreport.PIN, LastName ,  FirstName,   'CTS'  as BillType ,    'Call To Staff'      as     state     ,
			  '0' as Duration, 0  as  CallRevenue, '3' as Descript  from tblincidentreport with(nolock) , tblInmate with(nolock)  ,tblANIs with(nolock)
			where 	ANI = tblANIs.ANINo and
			tblincidentreport.PIN = tblInmate.Pin and
			tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate   
			and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID)  and @private =1  
			Order by  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		
		
		
		SET ROWCOUNT @maximumRows
		
		select   RecordID, PhoneID , toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript    from  #tempCDR   WHERE   RecordID >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else
	 Begin
		Insert   #tempCDR ( PhoneID ,  RecordID, toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript  )
	
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID , toNo,   RecordDate as  ConnectDateTime ,(case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo,  tblcallsBilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.PIN  = tblInmate.PIN and
			   tblcallsBilled.Billtype = tblBilltype.billtype and  isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.locationID= @LocationID and 
			 @complete =1
			
			 and tblcallsBilled.Billtype = @BillType

			  UNION 
		
		Select  left( tblANIs.StationID,20)  PhoneID, 0 as RecordID, toNo,   RecordDate as  ConnectDateTime , DebitCardNo,  tblcallsUnbilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType  ,tblErrortype.Descript as  State,
			 '0'  as Duration, 0, tblPhoneTypes.Descript as Descript  from tblcallsUnbilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) , tblErrortype  with(nolock)
		  where  tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.PIN  = tblInmate.PIN and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and
			 tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID and  	
			tblANIs.locationID= @LocationID and 
			  @uncomplete =1
			
			and tblcallsUnBilled.Billtype = @BillType

			  UNION 

		 select  left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime   as ConnectDateTime   ,'' DebitCardNo,  tblincidentreport.PIN, LastName ,  FirstName,   'CTS'  as BillType ,    'Call To Staff'      as     state     ,
			  '0' as Duration, 0  as  CallRevenue, '3' as Descript  from tblincidentreport with(nolock) , tblInmate with(nolock)  ,tblANIs with(nolock)
			where 	ANI = tblANIs.ANINo and
			tblincidentreport.PIN = tblInmate.Pin and
			tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
			and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and tblInmate.PIN  =@PIN    and @private =1 
			Order by  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript    from  #tempCDR   WHERE   RecordID >= @startRowIndex
		
		set ROWCOUNT 0
	 End

 End
else If(@DivisionID > 0) 
begin
	If(@PIN <> '0' and  @callingCard <> ''  and  @DNI <> '' ) 
	 Begin
		Insert   #tempCDR ( PhoneID , RecordID,toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration, CallRevenue, Descript  )
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID , toNo,   RecordDate as  ConnectDateTime ,(case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo,  tblcallsBilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo  and
			 tblcallsBilled.PIN  = tblInmate.PIN and
			   tblcallsBilled.Billtype = tblBilltype.billtype and  isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.DivisionID= @DivisionID and 
			 tblInmate.PIN  = @PIN and 
			 CreditcardNo = @callingCard  and
			 tblcallsBilled.ToNo = @DNI   and  @complete =1

			 and tblcallsBilled.Billtype = @BillType

			  UNION 	
		Select  left( tblANIs.StationID,20)  PhoneID, 0 as RecordID, toNo,   RecordDate as  ConnectDateTime , DebitCardNo,  tblcallsUnbilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType  ,tblErrortype.Descript as  State,
			 '0'  as Duration, 0, tblPhoneTypes.Descript as Descript  from tblcallsUnbilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) , tblErrortype  with(nolock)
		  where  tblcallsUnBilled.fromno = tblANIs.ANINo and
			 tblcallsUnBilled.PIN  = tblInmate.PIN and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and
			 tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			tblANIs.DivisionID= @DivisionID and 
			 tblInmate.PIN  = @PIN and 
			DebitCardNo = @callingCard and
			 tblcallsUnBilled.ToNo = @DNI   and @uncomplete =1
	
			and tblcallsUnBilled.Billtype = @BillType

			  UNION 

		 select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime   as ConnectDateTime   ,'' DebitCardNo,  tblincidentreport.PIN, LastName ,  FirstName,   'CTS'  as BillType ,    'Call To Staff'      as     state     ,
			  '0' as Duration, 0  as  CallRevenue, '3' as Descript  from tblincidentreport with(nolock) , tblInmate with(nolock)  ,tblANIs with(nolock)
			where 	ANI = tblANIs.ANINo and
			tblincidentreport.PIN = tblInmate.Pin and
			tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate 
			and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  tblInmate.PIN  = @PIN  and @private =1 
			Order by  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		
		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript    from  
#tempCDR   WHERE   RecordID >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@FName <> '' and  @callingCard <> '') 
	 Begin
		Insert   #tempCDR ( PhoneID , RecordID, toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript  )
	
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID , toNo,   RecordDate as  ConnectDateTime , (case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end )  DebitCardNo,  tblcallsBilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.PIN  = tblInmate.PIN and
			   tblcallsBilled.Billtype = tblBilltype.billtype and  isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.DivisionID= @DivisionID and 
			 tblInmate.FirstName  =@FName  and 
			 CreditcardNo = @callingCard  and  @complete =1
			

			 and tblcallsBilled.Billtype = @BillType

			  UNION 
		
		Select  left( tblANIs.StationID,20)  PhoneID, 0 as RecordID, toNo,   RecordDate as  ConnectDateTime , DebitCardNo,  tblcallsUnbilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType  ,tblErrortype.Descript as  State,
			 '0'  as Duration, 0, tblPhoneTypes.Descript as Descript  from tblcallsUnbilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) , tblErrortype  with(nolock)
		  where  tblcallsUnBilled.fromno = tblANIs.ANINo and
			 tblcallsUnBilled.PIN  = tblInmate.PIN and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			tblANIs.DivisionID= @DivisionID and 
			 tblInmate.FirstName  =@FName  and 
			DebitCardNo = @callingCard  and @uncomplete =1
	
			 and tblcallsUnBilled.Billtype = @BillType

			  UNION 

		 select  left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime   as ConnectDateTime   ,''  DebitCardNo,  tblincidentreport.PIN, LastName ,  FirstName,   'CTS'  as BillType ,    'Call To Staff'      as     state     ,
			  '0' as Duration, 0  as  CallRevenue, '3' as Descript  from tblincidentreport with(nolock) , tblInmate with(nolock)  ,tblANIs with(nolock) 
			where 	ANI = tblANIs.ANINo and
			tblincidentreport.PIN = tblInmate.Pin and
			tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate 
			and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID)   and @private =1 
			Order by  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		
		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript    from  #tempCDR   WHERE   RecordID >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@LName <> '' and  @callingCard <> '') 
	 Begin
		Insert   #tempCDR ( PhoneID ,RecordID,  toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript  )
	
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID , toNo,   RecordDate as  ConnectDateTime , (case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo,  tblcallsBilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo  and
			 tblcallsBilled.PIN  = tblInmate.PIN and
			   tblcallsBilled.Billtype = tblBilltype.billtype and  isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.DivisionID= @DivisionID and 
			 tblInmate.LastName  =@LName  and 
			 CreditcardNo = @callingCard  and  @complete =1
			

			 and tblcallsBilled.Billtype = @BillType
			  UNION 
		
		Select  left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , toNo,   RecordDate as  ConnectDateTime , DebitCardNo,  tblcallsUnbilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType  ,tblErrortype.Descript as  State,
			 '0'  as Duration, 0, tblPhoneTypes.Descript as Descript  from tblcallsUnbilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) , tblErrortype  with(nolock)
		  where  tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.PIN  = tblInmate.PIN and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			tblANIs.DivisionID= @DivisionID and 
			 tblInmate.LastName  =@LName  and 
			 DebitCardNo = @callingCard  and @uncomplete =1
	
			and tblcallsUnBilled.Billtype = @BillType

			  UNION 

		 select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime   as ConnectDateTime   ,''  DebitCardNo,  tblincidentreport.PIN, LastName ,  FirstName,   'CTS'  as BillType ,    'Call To Staff'      as     state     ,
			  '0' as Duration, 0  as  CallRevenue, '3' as Descript  from tblincidentreport with(nolock) , tblInmate with(nolock)  ,tblANIs with(nolock) 
			where 	ANI = tblANIs.ANINo and
			tblincidentreport.PIN = tblInmate.Pin and
			tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate 
			and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID)   and @private =1 
			Order by  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		
		
		
		SET ROWCOUNT @maximumRows
		
		select   RecordID, PhoneID , toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript    from  #tempCDR   WHERE   RecordID >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@PIN <> '0' and @DNI <> '' ) 
	 Begin
		Insert   #tempCDR ( PhoneID , RecordID, toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript  )
	
		Select  left( tblANIs.StationID,20) PhoneID, RecordID , toNo,   RecordDate as  ConnectDateTime ,(case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo,  tblcallsBilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.PIN  = tblInmate.PIN and
			   tblcallsBilled.Billtype = tblBilltype.billtype and  isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.DivisionID= @DivisionID and 
			 tblInmate.PIN  =@PIN  	and
			 tblcallsBilled.ToNo =  @DNI  and  @complete =1
			

			 and tblcallsBilled.Billtype = @BillType

			  UNION 
		
		Select  left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , toNo,   RecordDate as  ConnectDateTime , DebitCardNo,  tblcallsUnbilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType  ,tblErrortype.Descript as  State,
			 '0'  as Duration, 0, tblPhoneTypes.Descript as Descript  from tblcallsUnbilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) , tblErrortype  with(nolock)
		  where  tblcallsUnBilled.fromno = tblANIs.ANINo and
			 tblcallsUnBilled.PIN  = tblInmate.PIN and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			tblANIs.DivisionID= @DivisionID and 
			tblInmate.PIN  =@PIN  and
			 tblcallsUnBilled.ToNo = @DNI  and @uncomplete =1  
			
	
			 and tblcallsUnBilled.Billtype = @BillType

			  UNION 

		 select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime   as ConnectDateTime   ,'' DebitCardNo,  tblincidentreport.PIN, LastName ,  FirstName,   'CTS'  as BillType ,    'Call To Staff'      as     state     ,
			  '0' as Duration, 0  as  CallRevenue, '3' as Descript  from tblincidentreport with(nolock) , tblInmate with(nolock)  ,tblANIs with(nolock) 
			where 	ANI = tblANIs.ANINo and
			tblincidentreport.PIN = tblInmate.Pin and
			tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
			and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and tblInmate.PIN  =@PIN    and @private =1 
			Order by  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		
		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript    from  #tempCDR   WHERE   RecordID >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@PIN <> '0') 
	 Begin
		Insert   #tempCDR (PhoneID , RecordID, toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript  )
	
		Select  left( tblANIs.StationID,20) PhoneID, RecordID , toNo,   RecordDate as  ConnectDateTime ,(case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo,  tblcallsBilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.PIN  = tblInmate.PIN and
			   tblcallsBilled.Billtype = tblBilltype.billtype and  isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.DivisionID= @DivisionID and 
			 tblInmate.PIN  =@PIN  	 and  @complete =1
			 and tblcallsBilled.Billtype = @BillType

			  UNION 
		
		Select  left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , toNo,   RecordDate as  ConnectDateTime , DebitCardNo,  tblcallsUnbilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType  ,tblErrortype.Descript as  State,
			 '0'  as Duration, 0, tblPhoneTypes.Descript as Descript  from tblcallsUnbilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) , tblErrortype  with(nolock)
		  where  tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.PIN  = tblInmate.PIN and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			tblANIs.DivisionID= @DivisionID and 
			tblInmate.PIN  =@PIN   and @uncomplete =1
				
			 and tblcallsUnBilled.Billtype = @BillType

			  UNION 

		 select  left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime   as ConnectDateTime   ,''  DebitCardNo,  tblincidentreport.PIN, LastName ,  FirstName,   'CTS'  as BillType ,    'Call To Staff'      as     state     ,
			  '0' as Duration, 0  as  CallRevenue, '3' as Descript  from tblincidentreport with(nolock) , tblInmate with(nolock)  ,tblANIs with(nolock) 
			where 	ANI = tblANIs.ANINo and
			tblincidentreport.PIN = tblInmate.Pin and
			tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate 
			and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and tblInmate.PIN  =@PIN   and @private =1 
			Order by  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		
		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript    from  #tempCDR   WHERE   RecordID >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If( @DNI <> '' ) 
	 Begin
		Insert   #tempCDR ( PhoneID , RecordID, toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript  )
	
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID , toNo,   RecordDate as  ConnectDateTime ,(case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo,  tblcallsBilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.PIN  = tblInmate.PIN and
			   tblcallsBilled.Billtype = tblBilltype.billtype and  isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.DivisionID= @DivisionID and 
			 tblcallsBilled.ToNo =  @DNI   and  @complete =1
			

			 and tblcallsBilled.Billtype = @BillType

			  UNION 
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID , toNo,   RecordDate as  ConnectDateTime , DebitCardNo,  tblcallsUnbilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType  ,tblErrortype.Descript as  State,
			 '0'  as Duration, 0, tblPhoneTypes.Descript as Descript  from tblcallsUnbilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) , tblErrortype  with(nolock)
		  where  tblcallsUnBilled.fromno = tblANIs.ANINo and
			 tblcallsUnBilled.PIN  = tblInmate.PIN and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and
			  tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
			 tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID and  	
			tblANIs.DivisionID= @DivisionID and 
			 tblcallsUnBilled.ToNo = @DNI  and @uncomplete =1
			
			and  tblcallsUnBilled.Billtype = @BillType

			  UNION 

		 select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID  , 'CTS'  as Tono ,      ReportTime   as ConnectDateTime   ,'' DebitCardNo,  tblincidentreport.PIN, LastName ,  FirstName,   'CTS'  as BillType ,    'Call To Staff'      as     state     ,
			  '0' as Duration, 0  as  CallRevenue, '3' as Descript  from tblincidentreport with(nolock) , tblInmate with(nolock)  ,tblANIs with(nolock) 
			where 	ANI = tblANIs.ANINo and
			tblincidentreport.PIN = tblInmate.Pin and
			tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate 
			and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and tblInmate.PIN  =@PIN    and @private =1 
			Order by  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		
		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript    from  #tempCDR   WHERE   RecordID >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@callingCard <> '') 
	 Begin
		Insert   #tempCDR ( PhoneID , RecordID, toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript  )
	
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID , toNo,   RecordDate as  ConnectDateTime ,(case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo,  tblcallsBilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo  and
			 tblcallsBilled.PIN  = tblInmate.PIN and
			   tblcallsBilled.Billtype = tblBilltype.billtype and  isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.DivisionID= @DivisionID and 
			
			 CreditcardNo = @callingCard  and  @complete =1
			

			 and tblcallsBilled.Billtype = @BillType

			  UNION 
		
		Select  left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , toNo,   RecordDate as  ConnectDateTime , DebitCardNo,  tblcallsUnbilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType  ,tblErrortype.Descript as  State,
			 '0'  as Duration, 0, tblPhoneTypes.Descript as Descript  from tblcallsUnbilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) , tblErrortype  with(nolock)
		  where  tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.PIN  = tblInmate.PIN and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and
			  tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			tblANIs.DivisionID= @DivisionID and 
			
			 DebitCardNo = @callingCard  and @uncomplete =1
	
			and  tblcallsUnBilled.Billtype = @BillType

			  UNION 

		 select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime   as ConnectDateTime   ,''  DebitCardNo,  tblincidentreport.PIN, LastName ,  FirstName,   'CTS'  as BillType ,    'Call To Staff'      as     state     ,
			  '0' as Duration, 0  as  CallRevenue, '3' as Descript  from tblincidentreport with(nolock) , tblInmate with(nolock)  ,tblANIs with(nolock) 
			where 	ANI = tblANIs.ANINo and
			tblincidentreport.PIN = tblInmate.Pin and
			tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate 
			and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID)   and @private =1 
			Order by  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		
		
		
		SET ROWCOUNT @maximumRows
		
		select   RecordID, PhoneID , toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript    from  #tempCDR   WHERE   RecordID >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else
	 Begin
		
		Insert   #tempCDR (PhoneID , RecordID, toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript  )
	
		Select  left( tblANIs.StationID,20) PhoneID, RecordID , toNo,   RecordDate as  ConnectDateTime ,(case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo,  tblcallsBilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.PIN  = tblInmate.PIN and
			   tblcallsBilled.Billtype = tblBilltype.billtype and  isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			tblANIs.DivisionID= @DivisionID and 
			 @complete =1
			

			 and tblcallsBilled.Billtype = @BillType

			  UNION 
		
		Select  left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , toNo,   RecordDate as  ConnectDateTime , DebitCardNo,  tblcallsUnbilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType  ,tblErrortype.Descript as  State,
			 '0'  as Duration, 0, tblPhoneTypes.Descript as Descript  from tblcallsUnbilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) , tblErrortype  with(nolock)
		  where  tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.PIN  = tblInmate.PIN and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and
			 tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID and  	
			tblANIs.DivisionID= @DivisionID and 
			 @uncomplete =1
			
	
			and tblcallsUnBilled.Billtype = @BillType

			  UNION 

		 select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime   as ConnectDateTime   ,'' DebitCardNo,  tblincidentreport.PIN, LastName ,  FirstName,   'CTS'  as BillType ,    'Call To Staff'      as     state     ,
			  '0' as Duration, 0  as  CallRevenue, '3' as Descript  from tblincidentreport with(nolock) , tblInmate with(nolock)  ,tblANIs with(nolock)
			where 	ANI = tblANIs.ANINo and
			tblincidentreport.PIN = tblInmate.Pin and
			tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate 
			and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and tblInmate.PIN  =@PIN    and @private =1 
			Order by  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		
		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript    from  #tempCDR   WHERE   RecordID >= @startRowIndex
		
		set ROWCOUNT 0
	 End

 End
else 
begin
	
	If(@PIN <> '0' and  @callingCard <> ''  and  @DNI <> '' ) 
	 Begin
		Insert   #tempCDR (PhoneID ,RecordID,  toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript  )
	
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID , toNo,   RecordDate as  ConnectDateTime , (case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end )  DebitCardNo,  tblcallsBilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.PIN  = tblInmate.PIN and
			   tblcallsBilled.Billtype = tblBilltype.billtype and  isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			
			 tblInmate.PIN  = @PIN and 
			 CreditcardNo = @callingCard  and
			 tblcallsBilled.ToNo =  @DNI   and  @complete =1

			 and tblcallsBilled.Billtype = @BillType

			  UNION 
		
		Select  left( tblANIs.StationID,20)  PhoneID, 0 as RecordID, toNo,   RecordDate as  ConnectDateTime , DebitCardNo,  tblcallsUnbilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType  ,tblErrortype.Descript as  State,
			 '0'  as Duration, 0, tblPhoneTypes.Descript as Descript  from tblcallsUnbilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) , tblErrortype  with(nolock)
		  where  tblcallsUnBilled.fromno = tblANIs.ANINo and
			 tblcallsUnBilled.PIN  = tblInmate.PIN and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			 tblInmate.PIN  = @PIN and 
			 DebitCardNo = @callingCard and
			 tblcallsUnBilled.ToNo =@DNI   and @uncomplete =1
	
			and tblcallsUnBilled.Billtype = @BillType

			  UNION 

		 select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime   as ConnectDateTime   ,''  DebitCardNo,  tblincidentreport.PIN, LastName ,  FirstName,   'CTS'  as BillType ,    'Call To Staff'      as     state     ,
			  '0' as Duration, 0  as  CallRevenue, '3' as Descript  from tblincidentreport with(nolock) , tblInmate with(nolock)  ,tblANIs with(nolock)
			where 	ANI=  tblANIs.ANINo and
			tblincidentreport.PIN = tblInmate.Pin and
			tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate 
			and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and  tblInmate.PIN  = @PIN  and @private =1 
			Order by  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		
		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript    from  #tempCDR   WHERE   RecordID >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@FName <> '' and  @callingCard <> '') 
	 Begin
		Insert   #tempCDR (PhoneID ,RecordID,  toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript  )
	
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID, toNo,   RecordDate as  ConnectDateTime , (case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end )  DebitCardNo,  tblcallsBilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.PIN  = tblInmate.PIN and
			   tblcallsBilled.Billtype = tblBilltype.billtype and  isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			
			 tblInmate.FirstName  =@FName  and 
			 CreditcardNo = @callingCard  and  @complete =1
			

			 and tblcallsBilled.Billtype = @BillType

			  UNION 
--Line 1551
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID , toNo,   RecordDate as  ConnectDateTime , DebitCardNo,  tblcallsUnbilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType  ,tblErrortype.Descript as  State,
			 '0'  as Duration, 0, tblPhoneTypes.Descript as Descript  from tblcallsUnbilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , tblErrortype  with(nolock)
		  where  tblcallsUnBilled.fromno = tblANIs.ANINo and
			 tblcallsUnBilled.PIN  = tblInmate.PIN and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			 tblInmate.FirstName  =@FName  and 
			 DebitCardNo = @callingCard  and @uncomplete =1
	
			and tblcallsUnBilled.Billtype = @BillType

			  UNION 

		 select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime   as ConnectDateTime   ,'' DebitCardNo,  tblincidentreport.PIN, LastName ,  FirstName,   'CTS'  as BillType ,    'Call To Staff'      as     state     ,
			  '0' as Duration, 0  as  CallRevenue, '3' as Descript  from tblincidentreport with(nolock) , tblInmate with(nolock)  ,tblANIs with(nolock)
			where 	ANI = tblANIs.ANINo and
			tblincidentreport.PIN = tblInmate.Pin and
			tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate 
			and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID)   and @private =1 
			Order by  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		
		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript    from  #tempCDR   WHERE   RecordID >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@LName <> '' and  @callingCard <> '') 
	 Begin
		Insert   #tempCDR ( PhoneID ,RecordID,  toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript  
)
	
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID , toNo,   RecordDate as  ConnectDateTime , (case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end )  DebitCardNo,  tblcallsBilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.PIN  = tblInmate.PIN and
			   tblcallsBilled.Billtype = tblBilltype.billtype and  isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			
			 tblInmate.LastName  =@LName  and 
			 CreditcardNo = @callingCard  and  @complete =1
			

			 and tblcallsBilled.Billtype = @BillType

			  UNION 
		
		Select  left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , toNo,   RecordDate as  ConnectDateTime , DebitCardNo,  tblcallsUnbilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType  ,tblErrortype.Descript as  State,
			 '0'  as Duration, 0, tblPhoneTypes.Descript as Descript  from tblcallsUnbilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) , tblErrortype  with(nolock)
		  where  tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.PIN  = tblInmate.PIN and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and
	(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			 tblInmate.LastName  =@LName  and 
			 DebitCardNo = @callingCard  and @uncomplete =1
	
			and tblcallsUnBilled.Billtype = @BillType

			  UNION 

		 select  left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime   as ConnectDateTime   ,''  DebitCardNo ,  tblincidentreport.PIN, LastName ,  FirstName,   'CTS'  as BillType ,    'Call To Staff'      as     state     ,
			  '0' as Duration, 0  as  CallRevenue, '3' as Descript  from tblincidentreport with(nolock) , tblInmate with(nolock)  ,tblANIs 
			where 	ANI = tblANIs.ANINo and
			tblincidentreport.PIN = tblInmate.Pin and
			tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
			and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID)   and @private =1 
			Order by  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		
		
		
		SET ROWCOUNT @maximumRows
		
		select   RecordID, PhoneID , toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript    from  #tempCDR   WHERE   RecordID >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@PIN <> '0' and @DNI <> '' ) 
	 Begin
		Insert   #tempCDR (PhoneID , RecordID,  toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript  )
	
		Select  left( tblANIs.StationID,20) PhoneID, RecordID , toNo,   RecordDate as  ConnectDateTime ,(case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end )  DebitCardNo ,  tblcallsBilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo  and
			 tblcallsBilled.PIN  = tblInmate.PIN and
			   tblcallsBilled.Billtype = tblBilltype.billtype and  isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			 tblInmate.PIN  =@PIN  	and
			 tblcallsBilled.ToNo =@DNI   and  @complete =1
			

			 and tblcallsBilled.Billtype = @BillType		

			  UNION 
		
		Select  left( tblANIs.StationID,20) ,0 as RecordID, toNo,   RecordDate as  ConnectDateTime , DebitCardNo,  tblcallsUnbilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType  ,tblErrortype.Descript as  State,
			 '0'  as Duration, 0, tblPhoneTypes.Descript as Descript  from tblcallsUnbilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) , tblErrortype  with(nolock)
		  where  tblcallsUnBilled.fromno = tblANIs.ANINo and
			 tblcallsUnBilled.PIN  = tblInmate.PIN and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			tblInmate.PIN  =@PIN  and
			 tblcallsUnBilled.ToNo = @DNI  and @uncomplete =1  
			
			and tblcallsUnBilled.Billtype = @BillType

			  UNION 

		 select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime   as ConnectDateTime   ,''  DebitCardNo,  tblincidentreport.PIN, LastName ,  FirstName,   'CTS'  as BillType ,    'Call To Staff'      as     state     ,
			  '0' as Duration, 0  as  CallRevenue, '3' as Descript  from tblincidentreport with(nolock) , tblInmate with(nolock)  ,tblANIs with(nolock) 
			where 	ANI = tblANIs.ANINo and
			tblincidentreport.PIN = tblInmate.Pin and
			tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate 
			and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and tblInmate.PIN  =@PIN    and @private =1 
			Order by  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
				
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript    from  #tempCDR   WHERE   RecordID >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If(@PIN <> '0') 
	 Begin
		Insert   #tempCDR ( PhoneID ,  RecordID,toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript  )
	
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID, toNo,   RecordDate as  ConnectDateTime , (case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo,  tblcallsBilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.PIN  = tblInmate.PIN and
			   tblcallsBilled.Billtype = tblBilltype.billtype and  isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
						 tblInmate.PIN  =@PIN  	 and  @complete =1
			 and tblcallsBilled.Billtype = @BillType

			  UNION 
		
		Select  left( tblANIs.StationID,20) , 0 as RecordID, toNo,   RecordDate as  ConnectDateTime , DebitCardNo,  tblcallsUnbilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType  ,tblErrortype.Descript as  State,
			 '0'  as Duration, 0, tblPhoneTypes.Descript as Descript  from tblcallsUnbilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) , tblErrortype  with(nolock)
		  where  tblcallsUnBilled.fromno = tblANIs.ANINo and
			 tblcallsUnBilled.PIN  = tblInmate.PIN and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			tblInmate.PIN  =@PIN   and @uncomplete =1
				
			and tblcallsUnBilled.Billtype = @BillType

			  UNION 

		 select  left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime   as ConnectDateTime   ,''  DebitCardNo,  tblincidentreport.PIN, LastName ,  FirstName,   'CTS'  as BillType ,    'Call To Staff'      as     state     ,
			  '0' as Duration, 0  as  CallRevenue, '3' as Descript  from tblincidentreport with(nolock) , tblInmate with(nolock)  ,tblANIs with(nolock) 
			where 	ANI=  tblANIs.ANINo and
			tblincidentreport.PIN = tblInmate.Pin and
			tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
			and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and tblInmate.PIN  =@PIN   and @private =1 
			Order by  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		
		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript    from  #tempCDR   WHERE   RecordID >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If( @DNI <> '' ) 
	 Begin
		Insert   #tempCDR (PhoneID , RecordID, toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript  )
	
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID , toNo,   RecordDate as  ConnectDateTime , (case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end )  DebitCardNo,  tblcallsBilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromNo =  tblANIs.ANINo and
			 tblcallsBilled.PIN  = tblInmate.PIN and
			   tblcallsBilled.Billtype = tblBilltype.billtype and  isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			
			 tblcallsBilled.ToNo = @DNI   and  @complete =1
			

			 and tblcallsBilled.Billtype = @BillType

			  UNION 
		
		Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID , toNo,   RecordDate as  ConnectDateTime , DebitCardNo,  tblcallsUnbilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType  ,tblErrortype.Descript as  State,
			 '0'  as Duration, 0, tblPhoneTypes.Descript as Descript  from tblcallsUnbilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) , tblErrortype  with(nolock)
		  where  tblcallsUnBilled.fromno = tblANIs.ANINo and
			 tblcallsUnBilled.PIN  = tblInmate.PIN and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID and  	
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
			 tblcallsUnBilled.ToNo =@DNI   and @uncomplete =1
			
	
			and tblcallsUnBilled.Billtype = @BillType

			  UNION 

		 select  left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime   as ConnectDateTime   ,'' DebitCardNo,  tblincidentreport.PIN, LastName ,  FirstName,   'CTS'  as BillType ,    'Call To Staff'      as     state     ,
			  '0' as Duration, 0  as  CallRevenue, '3' as Descript  from tblincidentreport with(nolock) , tblInmate with(nolock)  ,tblANIs with(nolock) 
			where 	ANI = tblANIs.ANINo and
			tblincidentreport.PIN = tblInmate.Pin and
			tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate 
			and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and tblInmate.PIN  =@PIN    and @private =1 
			Order by  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		
		
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript    from  #tempCDR   WHERE   RecordID >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else If( @callingCard <> '') 
	 Begin
		Insert   #tempCDR ( PhoneID ,  RecordID,toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript  )
	
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID , toNo,   RecordDate as  ConnectDateTime ,(case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo,  tblcallsBilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.PIN  = tblInmate.PIN and
			   tblcallsBilled.Billtype = tblBilltype.billtype and  isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			 CreditcardNo = @callingCard  and  @complete =1
			

			 and tblcallsBilled.Billtype = @BillType

			  UNION 
		
		Select  left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , toNo,   RecordDate as  ConnectDateTime , DebitCardNo,  tblcallsUnbilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType  ,tblErrortype.Descript as  State,
			 '0'  as Duration,0, tblPhoneTypes.Descript as Descript    from tblcallsUnbilled with(nolock)  ,  tblBilltype with(nolock) 
,tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , tblErrortype  with(nolock)
		  where  tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.PIN  = tblInmate.PIN and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
	(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID  	and
			 DebitCardNo = @callingCard  and @uncomplete =1
	
			and tblcallsUnBilled.Billtype = @BillType

			  UNION 

		 select  left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime   as ConnectDateTime   ,''  DebitCardNo ,  tblincidentreport.PIN, LastName ,  FirstName,   'CTS'  as BillType ,    'Call To Staff'      as     state     ,
			  '0' as Duration, 0  as  CallRevenue, '3' as Descript  from tblincidentreport with(nolock) , tblInmate with(nolock)  ,tblANIs with(nolock)
			where 	ANI = tblANIs.ANINo and
			tblincidentreport.PIN = tblInmate.Pin and
			tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate  
			and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID)   and @private =1 
			Order by  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		
		
		
		SET ROWCOUNT @maximumRows
		
		select   RecordID, PhoneID , toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript    from  #tempCDR   WHERE   RecordID >= @startRowIndex
		
		set ROWCOUNT 0
	 End
	Else
	 Begin
		
		Insert   #tempCDR ( PhoneID , RecordID, toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript  )
	
		Select  left( tblANIs.StationID,20)  PhoneID, RecordID , toNo,   RecordDate as  ConnectDateTime ,(case   tblcallsBilled.Billtype when '07' then left(CreditcardNo,12) else '' end ) DebitCardNo,  tblcallsBilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType , 'Completed' as  State,
			CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) 
		  where  tblcallsBilled.fromno =  tblANIs.ANINo and
			 tblcallsBilled.PIN  = tblInmate.PIN and
			   tblcallsBilled.Billtype = tblBilltype.billtype and  isnull(tblcallsBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsBilled.FacilityID = @FacilityID   and 
			   @complete =1
			 and tblcallsBilled.Billtype = @BillType

			  UNION 
		Select  left( tblANIs.StationID,20) , 0 as RecordID, toNo,   RecordDate as  ConnectDateTime , DebitCardNo,  tblcallsUnbilled.PIN, LastName ,  FirstName,   tblBilltype.Descript  as  BillType  ,tblErrortype.Descript as  State,
			 '0'  as Duration, 0, tblPhoneTypes.Descript as Descript  from tblcallsUnbilled with(nolock)  ,  tblBilltype with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), tblPhonetypes with(nolock) , tblErrortype  with(nolock)
		  where  tblcallsUnBilled.fromno = tblANIs.ANINo  and
			 tblcallsUnBilled.PIN  = tblInmate.PIN and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and isnull(tblcallsUnBilled.PhoneType,'3') = tblPhoneTypes.Phonetype and   
			 tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and
	(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			 tblcallsUnBilled.FacilityID = @FacilityID and  	
			 @uncomplete =1
			
	
			and tblcallsUnBilled.Billtype = @BillType

			  UNION 

		 select  left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , 'CTS'  as Tono ,      ReportTime   as ConnectDateTime   ,''  DebitCardNo ,  tblincidentreport.PIN, LastName ,  FirstName,   'CTS'  as BillType ,    'Call To Staff'      as     state     ,
			  '0' as Duration, 0  as  CallRevenue, '3' as Descript  from tblincidentreport with(nolock) , tblInmate with(nolock)  ,tblANIs with(nolock) 
			where 	ANI = tblANIs.ANINo and
			tblincidentreport.PIN = tblInmate.Pin and
			tblincidentreport.FacilityID = @FacilityID and tblincidentreport.InputDate  >= @FromDate   
			and  convert(varchar(10), tblincidentreport.InputDate  ,101)  <= @toDate and tblANIs.PhoneID in ( @phoneID) and tblInmate.PIN  =@PIN    and @private =1 
			Order by  ConnectDateTime Desc 

		select @totalRecord = count(*) from   #tempCDR
		
		SET NOCOUNT OFF
		
		SET @startRowIndex = @startRowIndex + 1
		
		SET ROWCOUNT @maximumRows
		
		select  RecordID, PhoneID , toNo , ConnectDateTime , CallingCard,PIN,  Fname, LName ,  BillType  ,  State , Duration,CallRevenue, Descript    from  #tempCDR   WHERE   RecordID >= @startRowIndex
		
		set ROWCOUNT 0
	 End

 End

	drop table   #tempCDR
