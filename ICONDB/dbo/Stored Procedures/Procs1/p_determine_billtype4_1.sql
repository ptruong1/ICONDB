
CREATE PROCEDURE [dbo].[p_determine_billtype4_1]
@ANI	char(10),
@DNI	varchar(15) OUTPUT,
@inmateID	varchar(12),
@PIN		varchar(12),
@facilityID	int,
@userName       varchar(23),
@Billtype	char(2)  OUTPUT,
@balance	numeric(6,2)  OUTPUT,
@RecordOPT	char  OUTPUT,
@TimeLimited  smallint  OUTPUT

AS
Declare @ReasonID	smallint, @CallLimit smallint , @FreeType tinyint , @phone char(10) 

SET  @RecordOPT	='Y'
SET @balance	 =-1
SET   @ReasonID =0
SET  @CallLimit  =0
SET @Freetype  =0 

If( @billtype = '08')  SET  @billType ='01'

If ( isnumeric(@DNI) =0) 
 Begin
	EXEC  p_insert_unbilled_calls1   '','',  @ANI ,@DNI,@billtype, 4,@PIN	,0 ,@facilityID	,@userName, '', '',''
	Return -1
 end
If  (@PIN > 0)
 Begin
	
	If (select count(*) From tblInmate with(nolock) where PIN =  @PIN AND DNIRestrict = 1)  >0
	 Begin
		If ( select count(*) from tblphones with(nolock) where  PIN = @PIN  and phoneno = @DNI ) = 0
		Return -1
	 End
 End
If  (( select count(*) from tblNonRecordPhones with(nolock) where phoneno = @DNI) > 0 or @facilityID = 76 ) 
		SET @RecordOPT ='N'
If (@Billtype <>'07')
 Begin

	
	If( select count(*) from tblFreePhones with(nolock) where phoneNo =  @DNI  ) > 0
	  Begin
		Select  @DNI  = AuthCode from tblFreePhones with(nolock)  where  phoneNo =  @DNI
		SET @billType ='08'
		Return 0
	  End
	select @Freetype =Freetype from tblFreeANIs  where ANI =  @ANI	
	If ( @Freetype = 1)
	 Begin
		select @phone  = phone from tblFacility where facilityID  = @facilityID
		if ( dbo.fn_determine_local_call (left(@phone,6),  left(@DNI,6) ) )   = 1
			SET @billType ='08'
	 End 
	else  IF ( @Freetype >1)  
	
		SET @billType ='08'
	
	
	Select  @balance	=isnull( balance,0) from tblprepaid with(nolock) where phoneNo = @DNI and status =1
	IF(  @balance	 >=0)
		SET  @Billtype	='10'
 End
select @ReasonID= ReasonID, @CallLimit = isnull(TimeLimited ,0)  from tblblockedPhones with(nolock) where phoneNo =  @DNI -- and facilityID = @facilityID
if(@CallLimit >0) SET @TimeLimited  = @CallLimit 
If (@ReasonID > 0)
 Begin
	EXEC  p_insert_unbilled_calls1   '','',  @ANI ,@DNI,@billtype, 4,@PIN	,0 ,@facilityID	,@userName, '', '',''
	Return  @ReasonID
  End
	
else 
	Return 0
