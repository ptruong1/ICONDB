
CREATE PROCEDURE [dbo].[p_insert_unbilled_calls]
@calldate	char(6),
@calltime	char(6),
@fromno  char(10),
@tono	    varchar(16),
@billtype	char(2),
@errorType	tinyint,
@PIN		varchar(12),
@inmateID	bigint,
@facilityID	int,
@HostName	varchar(16),
@responseCode	 varchar(3),
@projectCode	char(6)
 AS

if(@billtype = '01' and @responseCode='399')
	SET @errorType=11
else if  (@billtype = '01' and @responseCode='262')
	SET @errorType=12
Insert tblCallsUnbilled (calldate,projectcode,calltime, fromno,     tono , billtype, errorType, PIN ,InmateID ,   FacilityID , HostName ,ResponseCode )
values(@calldate,@projectcode,@calltime, @fromno  ,@tono	,@billtype	,@errorType	,@PIN		,@inmateID	,@facilityID	,@HostName	,@responseCode	)
