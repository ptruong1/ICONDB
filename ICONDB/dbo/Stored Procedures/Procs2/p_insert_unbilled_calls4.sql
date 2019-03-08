CREATE PROCEDURE [dbo].[p_insert_unbilled_calls4]
@calldate	char(6),
@calltime	char(6),
@fromno  char(10),
@tono	    varchar(16),
@billtype	char(2),
@errorType	tinyint,
@PIN		VARCHAR(12),
@inmateID	VARCHAR(12),
@facilityID	int,
@HostName	varchar(16),
@responseCode	 varchar(3),
@projectCode	char(6),
@DebitCardNo	varchar(12),
@RecordDate	datetime ,
@CallType	varchar(2),
@RecordID	bigint
AS

SET NOCOUNT ON;
if(@billtype = '01' and @responseCode='399')
	SET @errorType=11;
else if  (@billtype = '01' and @responseCode='262')
	SET @errorType=12;
else if  (@billtype = '' or @billtype is null)
	SET @billtype ='09';
if  (@CallType = '' or @CallType is null)	
	SET @CallType ='NA';
	
	
Insert tblCallsUnbilled (calldate,projectcode,calltime, fromno,     tono , billtype, errorType, PIN ,InmateID ,   FacilityID , HostName ,ResponseCode, DebitCardNo, recordDate ,Calltype , RecordID)
values(@calldate,@projectcode,@calltime, @fromno  ,@tono	,@billtype	,@errorType	,@PIN		,@inmateID	,@facilityID	,@HostName	,@responseCode,@DebitCardNo,@RecordDate,@Calltype,@RecordID);

if(@PIN <> '0' and @errorType not in(10,21) )
	Delete tblinmateOncall where   (pin =@PIN or pin=@inmateID)  and facilityID = @FacilityID;
