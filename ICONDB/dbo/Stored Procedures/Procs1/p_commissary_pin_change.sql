
CREATE PROCEDURE [dbo].[p_commissary_pin_change]
@RequestID varchar(22),
@ClientType	varchar(16),  -- not use
@SystemID	varchar(12)	,			--ClientID
@SystemTag varchar(12),  -- facilityID	int,
@Vendor	varchar(12), --Swandons
@ResidentIdentifier	varchar(12),-- InmateID	Varchar(12),
@NewPIN		varchar(12),
@TimeStamp  varchar(30),
@IPaddress varchar(16)
AS

SET NOCOUNT ON;
declare @FacilityID int,  @commPIN varchar(12);

declare @Replystatus varchar(2);
if (isnumeric(@SystemTag) =0)
	SET @Replystatus='3'; 
else
begin
	SET @FacilityID = cast(@SystemTag  as int);
	SET @Replystatus ='0';
	SET @Replystatus= dbo.fn_verify_commissary_client(@ClientType,@FacilityID,@SystemID) ;
	set @commPIN = @NewPIN ;
end
if(@Replystatus='0')
 begin
	if(@FacilityID =784)
	 Begin
		SET @ResidentIdentifier = left(@ResidentIdentifier,len(@ResidentIdentifier)-4);
	 end
	if(select count (*) from tblinmate with(nolock) where facilityID = @FacilityID and InmateID =@ResidentIdentifier) =0
	 begin
		SET @Replystatus ='5';
		--Insert tblinmate(FacilityId , InmateID , Status , FirstName , LastName , PIN , inputdate)
		--		values(@FacilityID ,@ResidentIdentifier , 1,'NA' , 'NA', @NewPIn,getdate())
	 end
	 else
	  begin
		if(@FacilityID not in (702,784,786,1,756))		 --- Exception for Colusa facilityID =702
			SET @NewPIN = @ResidentIdentifier  + @NewPIN;
		--else
			--SET @NewPIN = @ResidentIdentifier ;
		 update tblinmate set PIN =  @NewPIN, InmateNote='Update New PIN:' +  @commPIN , [Status]=1, modifyDate = getdate() where facilityID = @facilityID and inmateID = @ResidentIdentifier;
	  end
 end

 EXEC p_API_call  @RequestID ,@ClientType	,@SystemID	,@SystemTag ,@Vendor	,@ResidentIdentifier	,@newPIN		,@IPaddress ,4,'0'

if(@@ERROR =0)
		select @Replystatus as ReplyStatus,
		@RequestID as RequestID,
		@ClientType as ClientType,  -- not use
		@SystemID	as SystemID	,			--ClientID
		@SystemTag as SystemTag,  -- facilityID	int,
		@Vendor	as Vendor, --Swandons
		@ResidentIdentifier	as ResidentIdentifier,-- InmateID	Varchar(12),
		@NewPIN		as PIN,
		@TimeStamp  as [TimeStamp]  ;

else
		select '99'  as ReplyStatus,
		@RequestID as RequestID,
		@ClientType as ClientType,  -- not use
		@SystemID	as SystemID	,			--ClientID
		@SystemTag as SystemTag,  -- facilityID	int,
		@Vendor	as Vendor, --Swandons
		@ResidentIdentifier	as ResidentIdentifier,-- InmateID	Varchar(12),
		@NewPIN		as PIN,
		@TimeStamp  as [TimeStamp] ;
 						
 


