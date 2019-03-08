CREATE PROCEDURE [dbo].[p_determine_ANI_DNI_RecordID]
@RecordID bigint,
@ANI	char(10),
@DNI	varchar(16),
@PIN		varchar(12),
@facilityID	int,
@userName       varchar(23),
@Billtype	char(2)  OUTPUT,
@RecordOPT	char  OUTPUT,
@TimeLimited  smallint  OUTPUT

AS
SET NOCOUNT ON
Declare @ReasonID	smallint, @CallLimit smallint , @FreeType tinyint , @phone char(10) , @dialPrefix char(3) , @DialNo varchar(13) ,@TophoneNo  varchar(10), @countryCode varchar(3), @calls tinyint
Declare   @timeZone tinyint , @localtime datetime, @bookingTime datetime, @PANNotAllow bit,  @DNIRestrict  bit, @acceptOpt tinyint, @RequestID tinyint, @ErrorType tinyint,@Rebook tinyint, @RebookDate datetime
Declare  @custodialOpt tinyint, @state char(2)
SET  @RecordOPT	='Y'
SET   @ReasonID =0
SET  @CallLimit  =0
SET @Freetype  =0 
SET @calls = 0
SET @custodialOpt =0
select @timeZone =isnull( timezone,0),@TimeLimited  = isnull(MaxCallTime,15),@phone  = phone, @state=[state] from tblfacility with(nolock) where facilityID =@facilityID
Set  @localtime = dateadd(hh, @timeZone,getdate() )

If ( isnumeric(@DNI) =0) 
 Begin
	EXEC  p_insert_unbilled_calls4   '','',  @ANI ,@DNI,@billtype, 4,@PIN	,0 ,@facilityID	,@userName, '', '','',@localtime, '',@RecordID
	Return -1;
 end
IF(@Billtype >'12')
 begin
	Return 0
 end
Select  @PANNotAllow = PANNotAllow ,  @DNIRestrict  =DNIRestrict, @Rebook =ISNULL(Rebook,0), @RebookDate =RebookDate, @custodialOpt=custodialOpt  from tblInmate with(nolock)  where facilityID = @facilityID and PIN =  @PIN
If (@DNIRestrict =  1)
 Begin
	If ( select count(*) from tblphones with(nolock) where  PIN = @PIN and facilityID = @facilityId and phoneno = @DNI ) = 0
	Begin
			EXEC  p_insert_unbilled_calls4   '','',  @ANI ,@DNI,@billtype, 9,@PIN	,0 ,@facilityID	,@userName, '', '','', @localtime,'',@RecordID
			Return -1;
	End
	
 End

If ( @PANNotAllow  =  1)
 Begin
	If ( select count(*) from tblBlockedPhonesByPIN with(nolock) where   phoneno = @DNI and facilityID = @facilityId  and  PIN = @PIN ) = 1
	Begin
			EXEC  p_insert_unbilled_calls4   '','',  @ANI ,@DNI,@billtype, 9,@PIN	,0 ,@facilityID	,@userName, '', '','', @localtime ,'',@RecordID
			Return -1;
	End
	
 End

If( @billtype = '08')  SET  @billType ='01'

If  (( select count(*) from tblNonRecordPhones with(nolock) where phoneno = @DNI  and facilityID = @facilityID) > 0 or @facilityID = 76 or @facilityID=278 ) 
		SET @RecordOPT ='N'
If (@Billtype <>'07')
 Begin
	if(@PIN ='00019') return 0
	
	If( select count(*) from tblFreePhones with(nolock) where phoneNo =  @DNI and facilityID= @facilityID ) > 0
	  Begin
		select  @CallLimit =  isnull(MaxCalltime,0) ,@acceptOpt= isnull(acceptOpt,1)from tblFreePhones   with(nolock)   where phoneNo =  @DNI and facilityID= @facilityID
		if(@CallLimit >0) SET @TimeLimited  = @CallLimit 
		If (@acceptOpt =1)
			SET @billType ='08'
		else 
			SET @billType ='17'
		Return 0
	  End
 end
	
else
 Begin
	if (@facilityID = 27  and  left(@DNI ,3) <> '011')
	  begin
		--if (select count(*) from tblNorthAmerica with(nolock)  where NPA =  left(@DNI ,3))=0 
		-- begin
			EXEC  p_insert_unbilled_calls4   '','',  @ANI ,@DNI,@billtype, 4,@PIN	,0 ,@facilityID	,@userName, '', '','',@localtime,'',@RecordID
			return -1
		--end
	  end
  end 

