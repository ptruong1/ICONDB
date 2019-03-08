CREATE PROCEDURE [dbo].[p_insert_fail_authorized]
@calldate	char(6),
@connectTime	char(6),
@fromno  char(10),
@tono	    varchar(16),
@billtype	char(2),
@errorType	tinyint,
@PIN		VARCHAR(12),
@inmateID	VARCHAR(12),
@facilityID	int,
@UserName	varchar(16),
@CallType	varchar(2),
@RecordID	bigint
 AS
Declare @flatform tinyint, @RecordDate	datetime ,@timeZone tinyint,@localtime datetime;
SET  @flatform =1;
SET @timeZone =0;
select @timeZone =isnull( timezone,0),  @flatForm = isnull(flatform,1)  from tblfacility with(nolock) where facilityID =@facilityID;
Set  @localtime = dateadd(hh, @timeZone,getdate() );
SET @RecordDate = @localtime;

IF(@errorType >0)
		EXEC    [p_insert_unbilled_calls4]
				@calldate	,
				@connectTime	,
				@fromno  ,
				@tono	    ,
				@billtype	,
				@errorType	,
				@PIN		,
				@inmateID	,
				@facilityID	,
				@UserName	,
				''	 ,
				''	,
				''	,
				@RecordDate	,
				@CallType	,
				@RecordID	;
else
		UPDATE tblInmate set BioRegister = 1 where FacilityId= @facilityID and PIN=@pin;
 
