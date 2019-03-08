
CREATE PROCEDURE [dbo].[p_commissary_refund_account]
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

declare  @AccountNo varchar(12),@FacilityID int, @balance as numeric(6,2), @balance_v varchar(10);

declare @Replystatus varchar(2);
if (isnumeric(@SystemTag) =0)
 SET @Replystatus='3'; 
else
begin
SET @FacilityID = cast(@SystemTag  as int);
SET @AccountNo='0' ;
SET @Replystatus ='0';
SET @Replystatus= dbo.fn_verify_commissary_client(@ClientType,@FacilityID,@SystemID) ;
end
SET  @balance = 0;
if(@Replystatus='0')
 begin
	if(@FacilityID =784)
	 Begin
		SET @ResidentIdentifier = left(@ResidentIdentifier,len(@ResidentIdentifier)-4);
	 end
	Select @balance = balance, @AccountNo = AccountNo from tbldebit where facilityID = @facilityID and inmateID = @ResidentIdentifier;
	If(@FacilityID = 784)
		update tbldebit set status = 4 , modifyDate = getdate(), username=@Vendor, Note='Release'  where facilityID = @facilityID and inmateID = @ResidentIdentifier;
	else
		update tbldebit set status = 4 , modifyDate = getdate(), username=@Vendor,Balance=0, Note='Release and Refund'  where facilityID = @facilityID and inmateID = @ResidentIdentifier;

	update tblinmate set status =2  , modifyDate = getdate(),InmateNote='Release and Refund' , username=@Vendor  where facilityID = @facilityID and inmateID = @ResidentIdentifier and pin = @PIN;
	Declare  @return_value int, @nextID int, @ID int, @tblAdjustment nvarchar(32) ;
	EXEC   @return_value = p_create_nextID 'tblAdjustment', @nextID   OUTPUT
             set           @ID = @nextID ;    										 
		insert tblAdjustment (AdjID, AdjTypeID, AccountNo  ,LastBalance ,  AdjAmount  ,Descript, AdjustDate ,  UserName ,   status)	
						 values(@ID,9,@AccountNo, 	@balance,	@balance,'Refund Commissary',	GETDATE(), 	@AccountNo,1)		;

	--insert tblAdjustment (AdjTypeID,AccountNo, LastBalance ,AdjAmount ,Descript ,AdjustDate ,UserName ,status )
	--		values(7,@accountNo,@balance,@balance,'Refund Commissary',GETDATE(), @SystemID ,1);

 end

SET  @balance_v = Cast(@balance as varchar(10));
EXEC p_API_call  @RequestID ,@ClientType	,@SystemID	,@SystemTag ,@Vendor	,@ResidentIdentifier	,@PIN		,@IPaddress ,6,  @balance_v
if(@@ERROR =0)
		select @Replystatus as ReplyStatus,
		@RequestID as RequestID,
		@ClientType as ClientType,  -- not use
		@SystemID	as SystemID	,			--ClientID
		@SystemTag as SystemTag,  -- facilityID	int,
		@Vendor	as Vendor, --Swandons
		@ResidentIdentifier	as ResidentIdentifier,-- InmateID	Varchar(12),
		@PIN		as PIN,
		@balance as Amount,
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
		@balance as Amount,
		@TimeStamp  as [TimeStamp] ;
 						
 
