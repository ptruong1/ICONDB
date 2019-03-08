CREATE PROCEDURE [dbo].[p_Report_CDR8_temp]
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



	 Begin
	
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
	end
