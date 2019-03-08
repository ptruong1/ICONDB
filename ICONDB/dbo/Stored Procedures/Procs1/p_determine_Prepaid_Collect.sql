
CREATE PROCEDURE [dbo].[p_determine_Prepaid_Collect]
@DNI	varchar(16),
@PIN		varchar(12),
@facilityID	int,
@Billtype	char(2)  OUTPUT,
@balance	numeric(6,2)  OUTPUT,
@firstName	varchar(30)	OUTPUT,
@lastName	varchar(30)  OUTPUT

AS
Declare @ReasonID	smallint, @CallLimit smallint , @FreeType tinyint , @phone char(10) , @dialPrefix char(3) , @DialNo varchar(13) ,@TophoneNo  varchar(10), @countryCode varchar(3)
SET @balance	 =-1
SET   @ReasonID =0
SET  @CallLimit  =0
SET @Freetype  =0 

If( @billtype = '08')  SET  @billType ='01'

SET @dialPrefix = Left(@DNI,3)

If ( @billType ='01')
 Begin

	If (@dialPrefix <> '011')
	 Begin
	
		
			
			Select  @balance	=isnull( balance,0), @firstName= FirstName   ,@lastName=              LastName from tblprepaid with(nolock) where phoneNo = @DNI and status =1
			IF(  @balance	 > 0)
				SET  @Billtype	='10'
			else
				SET  @Billtype	='01'
		 
	 End
	Else
	 Begin
		
		SET @countryCode =   dbo.fn_determine_countryCode(@DNI)
		
		SET  @TophoneNo  = substring ( @DNI,4 + len (@countryCode) , len(@DNI))
		SET  @DialNo = substring ( @DNI,4  , len(@DNI))
	
			
		Select  @balance	=isnull( balance,0) from tblprepaid with(nolock) where phoneNo = @TophoneNo  and status =1   and countryCode = @countryCode
		IF(  @balance	 > 0)
				SET  @Billtype	='10'
		else
				SET  @Billtype	='01'
		
	 End
 End

