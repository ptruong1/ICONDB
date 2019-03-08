
CREATE PROCEDURE [dbo].[p_commissary_close_account]
@RequestID varchar(22),
@ClientType	varchar(16),  -- not use
@SystemID	varchar(12)	,			--ClientID
@SystemTag varchar(12),  -- facilityID	int,
@Vendor	varchar(12), --Swandons
@ResidentIdentifier	varchar(12),-- InmateID	Varchar(12),
@PIN		varchar(12),
@TimeStamp  varchar(30),
@IPaddress varchar(16)
AS

declare @FacilityID int,@Replystatus varchar(2), @InmateStatus tinyint, @balance numeric(6,2), @Amount as varchar(10);
SET @InmateStatus =0;
SET @balance =0;
if (isnumeric(@SystemTag) =0)
	SET @Replystatus='3'; 
else
begin
	SET @Replystatus ='0';
	SET @FacilityID = cast(@SystemTag  as int);
	SET @Replystatus= dbo.fn_verify_commissary_client(@ClientType,@FacilityID,@SystemID) ;
end

if(@FacilityID =784)
 Begin
	SET @ResidentIdentifier = left(@ResidentIdentifier,len(@ResidentIdentifier)-4);
 end

select @InmateStatus = status from  tblinmate with(nolock) where facilityID = @FacilityID and InmateID =@ResidentIdentifier ;
Select   @balance  = balance from tbldebit with(nolock) where facilityID = @facilityID and inmateID = @ResidentIdentifier;
SET @Amount = cast(@balance as varchar(10));
if(@Replystatus ='0')
 begin
    if(@InmateStatus =1 )
	 begin
		update tbldebit set status = 2  , modifyDate = getdate(), username=@Vendor,Note= 'Close by Inmate:' + Cast(balance as varchar(10))   where facilityID = @facilityID and inmateID = @ResidentIdentifier and status=1;
		update tblinmate set status =2  , modifyDate = getdate(),InmateNote='Close Account' , username=@Vendor  where facilityID = @facilityID and inmateID = @ResidentIdentifier and pin =@pin;
	 end
	else
		SET @Replystatus ='7' ;

 end
 --- log

EXEC p_API_call  @RequestID ,@ClientType	,@SystemID	,@SystemTag ,@Vendor	,@ResidentIdentifier	,@PIN		,@IPaddress ,5,@Amount  ;
if(@@ERROR =0)
		select @Replystatus as ReplyStatus,
		@RequestID as RequestID,
		@ClientType as ClientType,  -- not use
		@SystemID	as SystemID	,			--ClientID
		@SystemTag as SystemTag,  -- facilityID	int,
		@Vendor	as Vendor, --Swandons
		@ResidentIdentifier	as ResidentIdentifier,-- InmateID	Varchar(12),
		@PIN		as PIN,
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
		@TimeStamp  as [TimeStamp] ;
 						
 


