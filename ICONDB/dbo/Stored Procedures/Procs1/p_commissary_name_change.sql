
CREATE PROCEDURE [dbo].[p_commissary_name_change]
@RequestID varchar(22),
@ClientType	varchar(16),  -- not use
@SystemID	varchar(12)	,			--ClientID
@SystemTag varchar(12),  -- facilityID	int,
@Vendor	varchar(12), --Swandons
@ResidentIdentifier	varchar(12),-- InmateID	Varchar(12),
@PIN		varchar(12),
@NewFirstName varchar(25),
@NewLastName	 varchar(25),
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
if(@Replystatus ='0')
 begin
	if(@FacilityID =784)
	 Begin
		SET @ResidentIdentifier = left(@ResidentIdentifier,len(@ResidentIdentifier)-4);
	 end
	if(select count (*) from tblinmate with(nolock) where facilityID = @FacilityID and InmateID =@ResidentIdentifier) =0
	 begin
		if(@FacilityID not in (702,786))		 --- Exception for Colusa facilityID =702
			SET @PIN = @ResidentIdentifier  + @PIN;
		
		Insert tblinmate(FacilityId , InmateID , Status , FirstName , LastName , PIN , inputdate, InmateNote)
					values(@FacilityID ,@ResidentIdentifier , 1,@NewFirstName , @NewLastName ,@PIN, getdate(), @PIN)
	 end
	 else
	  begin
		update tblinmate set FirstName =@NewFirstName, LastName = @NewLastName  , modifyDate = getdate() where facilityID = @facilityID and inmateID = @ResidentIdentifier;
	  end
 end
 EXEC p_API_call  @RequestID ,@ClientType	,@SystemID	,@SystemTag ,@Vendor	,@ResidentIdentifier	,@PIN		,@IPaddress ,4,'0'
if(@@ERROR =0)
		select @Replystatus as ReplyStatus,
		@RequestID as RequestID,
		@ClientType as ClientType,  -- not use
		@SystemID	as SystemID	,			--ClientID
		@SystemTag as SystemTag,  -- facilityID	int,
		@Vendor	as Vendor, --Swandons
		@ResidentIdentifier	as ResidentIdentifier,-- InmateID	Varchar(12),
		@PIN		as PIN,
		@NewFirstName as NewFirstName,
		@NewLastName as NewLastName,
		@TimeStamp  as [TimeStamp]  ;

else
		select '99'  as ReplyStatus,
		@RequestID as RequestID,
		@ClientType as ClientType,  -- not use
		@SystemID	as SystemID	,			--ClientID
		@SystemTag as SystemTag,  -- facilityID	int,
		@Vendor	as Vendor, --Swandons
		@ResidentIdentifier	as ResidentIdentifier,-- InmateID	Varchar(12),
		@PIN		as PIN,
		@NewFirstName as NewFirstName,
		@NewLastName as NewLastName,
		@TimeStamp  as [TimeStamp] ;
 						
 


