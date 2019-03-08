
CREATE PROCEDURE [dbo].[p_commissary_update_inmate_location]
@RequestID varchar(22),
@ClientType	varchar(16),  -- not use
@SystemID	varchar(12)	,			--ClientID
@SystemTag varchar(12),  -- facilityID	int,
@Vendor	varchar(12), --Swandons
@ResidentIdentifier	varchar(12),-- InmateID	Varchar(12),
@PIN		varchar(12),
@ResidentSite	varchar(10),
@Location1		varchar(8),
@Location2		varchar(8),
@Location3		varchar(8),
@Location4		varchar(8),
@TimeStamp  varchar(30),
@IPaddress varchar(16)
AS

declare  @FacilityID int;

declare @Replystatus varchar(2);
if (isnumeric(@SystemTag) =0)
	SET @Replystatus='3'; 
else
begin
	SET @FacilityID = cast(@SystemTag  as int);
	SET @Replystatus ='0';
	SET @Replystatus= dbo.fn_verify_commissary_client(@ClientType,@FacilityID,@SystemID) ;
end
--- Will Inmateplement 
if (@Replystatus = '0')
	update tblinmate set  InmateNote='Update Location:' + @Location1 +',' + @Location2, [Status]=1, modifyDate = getdate() where facilityID = @facilityID and inmateID = @ResidentIdentifier;

EXEC p_API_call  @RequestID ,@ClientType	,@SystemID	,@SystemTag ,@Vendor	,@ResidentIdentifier	,@PIN		,@IPaddress ,3,'0'

if(@@ERROR =0)
		select @Replystatus as ReplyStatus,
		@RequestID as RequestID,
		@ClientType as ClientType,  -- not use
		@SystemID	as SystemID	,			--ClientID
		@SystemTag as SystemTag,  -- facilityID	int,
		@Vendor	as Vendor, --Swandons
		@ResidentIdentifier	as ResidentIdentifier,-- InmateID	Varchar(12),
		@PIN		as PIN,
		--@ResidentSite	as ResidentSite,
		@Location1		as Location1,
		@Location2		as Location2,
		@Location3		as Location3,
		@Location4		as Location4,
		@TimeStamp  as [TimeStamp]  ;

else
		select '99' as ReplyStatus,
		@RequestID as RequestID,
		@ClientType as ClientType,  -- not use
		@SystemID	as SystemID	,			--ClientID
		@SystemTag as SystemTag,  -- facilityID	int,
		@Vendor	as Vendor, --Swandons
		@ResidentIdentifier	as ResidentIdentifier,-- InmateID	Varchar(12),
		@PIN		as PIN,
		--@ResidentSite	as ResidentSite,
		@Location1		as Location1,
		@Location2		as Location2,
		@Location3		as Location3,
		@Location4		as Location4,
		@TimeStamp  as [TimeStamp] ;
 						
 


