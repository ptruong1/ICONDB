CREATE PROCEDURE [dbo].[p_Report_CDR10_Test]
@FacilityID	int,
@divisionID	int,
@locationID	int,
@phoneID	varchar(10),
@InmateID		varchar(12),
@FName	varchar(25),
@LName varchar(25),
@callingCard	varchar(12),
@DNI		varchar(16),
@complete	tinyint,
@uncomplete	tinyint,
@private	tinyint,
@billtype	varchar(2),
@callType       varchar(2),
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime ,
@startRowIndex int,
 @maximumRows int,
@totalRecord	int  OUTPUT
 AS

DECLARE @first_id int, @startRow int
DECLARE  @SqlText NVarchar(Max),
@ParamDefinition NVarchar(4000)
	
SET NOCOUNT ON

SET  @phoneID = isnull( @phoneID,'')
SET @phoneID = rtrim(@phoneID)
Set @SqlText = ''

Set @sqlText = @sqlText + 'Select  left( tblANIs.StationID,20)  PhoneID, RecordID, toNo, DATEADD(second, - duration, recordDate) as startTime, RecordDate as  
ConnectDateTime, (case tblcallsBilled.Billtype when ''07'' then left(CreditcardNo,12) else '''' end ) CallingCard ,  tblcallsBilled.InmateID,  FirstName as Fname, LastName as LName
, tblBilltype.Descript  as  BillType, tblCallType.Descript  as  CallType , ''Completed'' as  State,CAST( CAST(duration as numeric(7,2))/60 as 
Numeric(9,2)) as Duration, CallRevenue, tblPhoneTypes.Descript as Descript , RecordFile, DOB, tblSex.Descript as Sex, tblRaces.Descript as Race
		   from tblcallsBilled with(nolock), tblBilltype with(nolock), tblCallType with(nolock) ,tblInmate with(nolock) ,tblANIs with(nolock), 
tblPhonetypes with(nolock), tblRaces with(nolock), tblSex with(nolock)
		  where  tblcallsBilled.fromno = tblANIs.ANINo and
			 tblcallsBilled.InmateID  = tblInmate.InmateID and
			 tblcallsBilled.Billtype = tblBilltype.billtype and  
			 tblcallsBilled.CallType = tblCalltype.Abrev and  
			isnull(tblcallsBilled.PhoneType,''3'') = tblPhoneTypes.PhoneType and 
			 tblcallsBilled.FacilityID = tblInmate.FacilityID and 
			 tblcallsBilled.FacilityID = tblANIs.FacilityID and
			 isnull(tblInmate.RaceID, 0) = tblRaces.RaceID  and isnull(tblInmate.Sex,''U'') = tblSex.Sex 
			 and tblcallsBilled.FacilityID = @FacilityID and @complete = 1 '
			
			 If (@PhoneID <> '')
				Set @SqlText = @SqlText + 'and tblANIs.PhoneID = @phoneID '
			 If (@InmateID <> '')
				Set @SqlText = @SqlText + 'and tblInmate.InmateID = @InmateID '	
			 If (@callingCard <> '')
				Set @SqlText = @SqlText + 'and tblcallsBilled.CreditcardNo = @callingCard '
			 If (@DNI <> '')
				Set @SqlText = @SqlText + 'and tblcallsBilled.ToNo = @DNI '
			 If (@billtype <> '-1')
				Set @SqlText = @SqlText + 'and tblcallsBilled.BillType = @BillType '
			 If (@Calltype <> '-1')
				Set @SqlText = @SqlText + 'and tblcallsBilled.CallType = @CallType '
			 If (@divisionID > 0)
				Set @SqlText = @SqlText + 'and tblANIs.DivisionID= @DivisionID '
			 If (@LocationID > 0)
				Set @SqlText = @SqlText + 'and tblANIs.locationID= @LocationID '
			 If (@FName <> '')
				Set @SqlText = @SqlText + 'and tblInmate.FirstName  =@FName '
			 If (@LName <> '')
				Set @SqlText = @SqlText + 'and tblInmate.LastName  =@LName '
				 
			Set @SqlText = @SqlText + 'and (RecordDate between @fromDate and dateadd(d,1,@todate) ) '
if (@uncomplete = 1)
	Begin			 
			Set @SqlText = @SqlText + ' UNION '
		
Set @SqlText = @SqlText + 'Select  left( tblANIs.StationID,20) PhoneID, 0 as RecordID, toNo, RecordDate as StartTime, RecordDate as ConnectDateTime, DebitCardNo as CallingCard,  
tblcallsUnbilled.InmateID,  FirstName as FName, LastName as LName, tblBilltype.Descript  as  BillType,
			tblCallType.Descript  as CallType,tblErrortype.Descript as  State,0 as Duration,0, tblPhoneTypes.Descript as Descript , ''UnK'' as 
RecordFile, DOB, tblSex.Descript as Sex, tblRaces.Descript as Race   
		from tblcallsUnbilled with(nolock), tblBilltype with(nolock), tblInmate with(nolock) ,tblANIs with(nolock) ,tblPhonetypes with(nolock) , 
tblErrortype  with(nolock) , tblCallType with(nolock), tblRaces with(nolock), tblSex with(nolock)
		 where   isnull( tblcallsUnBilled.CallType ,''NA'' )= tblCalltype.Abrev and 
			tblcallsUnBilled.fromno =  tblANIs.ANINo and
			 tblcallsUnBilled.InmateID  = tblInmate.InmateID and
			   tblcallsUnBilled.Billtype = tblBilltype.billtype and   
			 isnull(tblcallsUnBilled.PhoneType,''3'') = tblPhoneTypes.PhoneType and  
			tblcallsUnBilled.FacilityID  = tblANIs.FacilityID and
			tblcallsUnBilled.FacilityID  = tblInmate.FacilityID and
	 		 tblcallsUnBilled.errorType     = tblerrortype.ErrorType and 
	 		 isnull(tblInmate.RaceID, 0) = tblRaces.RaceID  and isnull(tblInmate.Sex,''U'') = tblSex.Sex and
	 		 tblcallsUnBilled.FacilityID = @FacilityID and @Uncomplete = 1 '
	 		
	 		 If (@PhoneID <> '')
				Set @SqlText = @SqlText + 'and tblANIs.PhoneID = @phoneID '
			 If (@InmateID <> '')
				Set @SqlText = @SqlText + 'and tblInmate.InmateID  = @InmateID '
			 If (@callingCard <> '')
				Set @SqlText = @SqlText + 'and tblcallsUnBilled.DebitCardNo = @callingCard '
			 If (@DNI <> '')
				Set @SqlText = @SqlText + 'and tblcallsUnBilled.ToNo =  @DNI '
			 If (@billtype <> '-1')
				Set @SqlText = @SqlText + 'and tblcallsUnBilled.BillType  =  @BillType '
			 If (@Calltype <> '-1')
				Set @SqlText = @SqlText + 'and tblcallsUnBilled.CallType  =  @CallType '
			 If (@divisionID > 0)
				Set @SqlText = @SqlText + 'and tblANIs.DivisionID= @DivisionID '
			 If (@LocationID > 0)
				Set @SqlText = @SqlText + 'and tblANIs.locationID= @LocationID '
			 If (@FName <> '')
				Set @SqlText = @SqlText + 'and tblInmate.FirstName  =@FName '
			 If (@LName <> '')
				Set @SqlText = @SqlText + 'and tblInmate.LastName  =@LName '
				
			Set @SqlText = @SqlText + 'and (RecordDate between @fromDate and dateadd(d,1,@todate) ) '
 End	
if (@Private = 1)
	Begin
			Set @SqlText = @SqlText + ' UNION '
			
			

Set @SqlText= @SqlText + 'SELECT   left( tblANIs.StationID,20)  PhoneID, 0 as RecordID , ''CTS'' as Tono , ReportTime as StartTime, ReportTime as ConnectDateTime,
'''' as CallingCard, tblincidentreport.InmateID, FirstName as FName, LastName as LName, ''CTS'' as BillType, ''RTS'' as CallType , ''Call To Staff'' as state , 0 as Duration, 
0 as  CallRevenue, ''3'' as Descript, ''UnK'' as RecordFile, DOB, tblSex.Descript as Sex, tblRaces.Descript as Race 
			 FROM  tblincidentreport with(nolock), tblInmate with(nolock), tblANIs with(nolock), tblRaces with(nolock), tblSex with(nolock)  
			 WHERE ANI = tblANIs.ANINo and 
			 tblincidentreport.InmateID = tblInmate.InmateID and
			 isnull(tblInmate.RaceID, 0) = tblRaces.RaceID  and 
			 isnull(tblInmate.Sex,''U'') = tblSex.Sex and
				tblincidentreport.FacilityID = @FacilityID and @private = 1 '
				
				If (@PhoneID <> '')
					Set @SqlText = @SqlText + 'and tblANIs.PhoneID = @phoneID '
				If (@InmateID <> '')
					Set @SqlText = @SqlText + 'and tblInmate.InmateID  = @InmateID ' 
					
				Set @SqlText = @SqlText + 'and (tblincidentreport.InputDate  >= @FromDate '
				Set @SqlText = @SqlText +  'and convert(varchar(10), tblincidentreport.InputDate,101)  <= @toDate ) '
							
				Set @SqlText = @SqlText + ' ORDER BY  ConnectDateTime Desc ' 
			
	End


set @ParamDefinition = '@FacilityID	int,
@divisionID	int,
@locationID	int,
@phoneID	varchar(10),
@InmateID		varchar(12),
@FName	varchar(25),
@LName varchar(25),
@callingCard	varchar(12),
@DNI		varchar(16),
@complete	tinyint,
@uncomplete	tinyint,
@private	tinyint,
@billtype	varchar(2),
@callType       varchar(2),
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime ,
@startRowIndex int,
 @maximumRows int,
@totalRecord	int  OUTPUT'

Execute sp_Executesql @SQLText,
@ParamDefinition,
@FacilityID,
@divisionID	,
@locationID,
@phoneID	,
@InmateID		,
@FName	,
@LName ,
@callingCard	,
@DNI	,
@complete	,
@uncomplete,
@private	,
@billtype	,
@callType  ,
@fromDate	,  -- Required 
@toDate	,
@startRowIndex,
 @maximumRows,
@totalRecord OUTPUT

If @@ERROR <> 0 goto ErrorHandler
ErrorHandler:
Return(@@Error)

