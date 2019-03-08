
CREATE PROCEDURE [dbo].[p_commissary_inmateID_change]
@RequestID varchar(22),
@ClientType	varchar(16),  -- not use
@SystemID	varchar(12)	,			--ClientID
@SystemTag varchar(12),  -- facilityID	int,
@Vendor	varchar(12), --Swandons
@ResidentIdentifier	varchar(12),-- InmateID	Varchar(12),
@NewResidentIdentifier	varchar(12),-- InmateID	Varchar(12),
@PIN		varchar(12),
@TimeStamp  varchar(30),
@IPaddress varchar(16)
AS

declare @FacilityID int;

declare @Replystatus varchar(3);
if (isnumeric(@SystemTag) =0)
	SET @Replystatus='3'; 
else
begin
	SET @FacilityID = cast(@SystemTag  as int);
	SET @Replystatus ='0';
	SET @Replystatus= dbo.fn_verify_commissary_client(@ClientType,@FacilityID,@SystemID) ;
end 
if(@Replystatus='0')
 begin
	if(@FacilityID =784)
	 Begin
		SET @ResidentIdentifier = left(@ResidentIdentifier,len(@ResidentIdentifier)-4);
	 end
	if(select count (*) from tblinmate with(nolock) where facilityID = @FacilityID and InmateID =@ResidentIdentifier and Pin= @PIN) =1
	 begin
	    update tbldebit set InmateID =  @NewResidentIdentifier ,modifyDate = getdate() , Note = 'InmateID change from:' + @ResidentIdentifier+ ' to:' + @NewResidentIdentifier where facilityID = @facilityID and inmateID = @ResidentIdentifier ;
		if(@@ERROR =0)	
			update tblinmate set InmateID= @NewResidentIdentifier , modifyDate = getdate() where facilityID = @facilityID and inmateID = @ResidentIdentifier and Pin= @PIN;
		
	 end
	 else
	  begin
		SET @Replystatus='5';
		--Insert tblinmate(FacilityId , InmateID , Status , FirstName , LastName , PIN , inputdate)
		--		values(@FacilityID ,@NewResidentIdentifier , 1,'NA' , 'NA', @PIn,getdate())
	  end
 end
  EXEC p_API_call  @RequestID ,@ClientType	,@SystemID	,@SystemTag ,@Vendor	,@NewResidentIdentifier	,@PIN		,@IPaddress ,4,'0'
if(@@ERROR =0)
		select @Replystatus as ReplyStatus,
		@RequestID as RequestID,
		@ClientType as ClientType,  -- not use
		@SystemID	as SystemID	,			--ClientID
		@SystemTag as SystemTag,  -- facilityID	int,
		@Vendor	as Vendor, --Swandons
		@ResidentIdentifier	as ResidentIdentifier,-- InmateID	Varchar(12),
		@NewResidentIdentifier	as NewResidentIdentifier,-- InmateID	Varchar(12),
		@PIN		as PIN,
		@TimeStamp  as [TimeStamp]  ;

else
		select '99'  as ReplyStatus,
		@RequestID as RequestID,
		@ClientType as ClientType,  -- not use
		@SystemID	as SystemID	,			--ClientID
		@SystemTag as SystemTag,  -- facilityID	int,
		@Vendor	as Vendor, --Swandons
		@ResidentIdentifier	as ResidentIdentifier,-- InmateID	Varchar(12),
		@NewResidentIdentifier	as NewResidentIdentifier,-- InmateID	Varchar(12),
		@PIN		as PIN,
		@TimeStamp  as [TimeStamp] ;
 						
 


