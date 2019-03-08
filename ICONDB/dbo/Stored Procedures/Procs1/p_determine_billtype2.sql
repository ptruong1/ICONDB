
CREATE PROCEDURE [dbo].[p_determine_billtype2]
@ANI	char(10),
@DNI	varchar(15),
@inmateID	int,
@PIN		int,
@Billtype	char(2)  OUTPUT,
@balance	numeric(6,2)  OUTPUT,
@RecordOPT	char  OUTPUT,
@TimeLimited  smallint  OUTPUT

AS
Declare @ReasonID	smallint, @CallLimit smallint , @FreeType tinyint

SET  @RecordOPT	='Y'
SET @balance	 =0
SET   @ReasonID =0
SET  @CallLimit  =0
SET @Freetype  =0 

If ( isnumeric(@DNI) =0) 	Return -1



If( select count(*) from tblNonRecordPhones with(nolock) where phoneno = @DNI) > 0
	SET @RecordOPT ='N'
If( select count(*) from tblFreePhones with(nolock) where phoneNo =  @DNI  ) > 0
	SET @billType ='08'
select @Freetype =Freetype from tblFreeANIs  where ANI =  @ANI	
If ( @Freetype = 1)
 Begin
	if ( dbo.fn_determine_local_call (left(@ANI,6),  left(@DNI,6) ) )   = 1
		SET @billType ='08'
 End 
else  IF ( @Freetype >1)  

	SET @billType ='08'

	



Select  @balance	=isnull( balance,0) from tblprepaid with(nolock) where phoneNo = @DNI and status =1
IF(  @balance	 >1)
	SET  @Billtype	='10'
select @ReasonID= ReasonID, @CallLimit = isnull(TimeLimited ,0)  from tblblockedPhones with(nolock) where phoneNo =  @DNI  
if(@CallLimit >0) SET @TimeLimited  = @CallLimit 
If (@ReasonID > 0)
	Return  @ReasonID
else 
	Return 0
