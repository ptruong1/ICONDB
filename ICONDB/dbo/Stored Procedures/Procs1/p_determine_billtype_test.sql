
CREATE PROCEDURE [dbo].[p_determine_billtype_test]
@ANI	char(10),
@DNI	varchar(16),
@inmateID	int,
@PIN		int,
@facilityID	int,
@userName       varchar(23),
@Billtype	char(2)  OUTPUT,
@balance	numeric(6,2)  OUTPUT,
@RecordOPT	char  OUTPUT,
@TimeLimited  smallint  OUTPUT

AS
Declare @ReasonID	smallint, @CallLimit smallint , @FreeType tinyint , @phone char(10) , @dialPrefix char(3) , @DialNo varchar(13) ,@TophoneNo  varchar(10), @countryCode varchar(3)

SET  @RecordOPT	='Y'
SET @balance	 =-1
SET   @ReasonID =0
SET  @CallLimit  =0
SET @Freetype  =0 
If ( isnumeric(@DNI) =0) 
 Begin
	EXEC  p_insert_unbilled_calls1   '','',  @ANI ,@DNI,@billtype, 4,@PIN	,0 ,@facilityID	,@userName, '', '',''
	Return -1
 end
If( @billtype = '08')  SET  @billType ='01'

SET @dialPrefix = Left(@DNI,3)

If (@dialPrefix <> '011')
 Begin


	If  (( select count(*) from tblNonRecordPhones with(nolock) where phoneno = @DNI) > 0 or @facilityID = 76 ) 
			SET @RecordOPT ='N'
	If (@Billtype <>'07')
	 Begin
	
		
		If( select count(*) from tblFreePhones with(nolock) where phoneNo =  @DNI  ) > 0
		  Begin
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
 End
Else
 Begin
	
	SET @countryCode =   dbo.fn_determine_countryCode(@DNI)
	
	SET  @TophoneNo  = substring ( @DNI,4 + len (@countryCode) , len(@DNI))
	SET  @DialNo = substring ( @DNI,4  , len(@DNI))

	If (@Billtype <>'07')
	 Begin
		
		
		Select  @balance	=isnull( balance,0) from tblprepaid with(nolock) where phoneNo = @TophoneNo  and status =1   and countryCode = @countryCode
		IF(  @balance	 >=0)
			SET  @Billtype	='10'
		else
			return 1
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
 End

