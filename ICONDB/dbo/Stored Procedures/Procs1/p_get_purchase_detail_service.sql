
CREATE PROCEDURE [dbo].[p_get_purchase_detail_service]
@AccountNo	char(12) , -- phone number
@FacilityID	int,
@paymenttypeID	smallint,
@PurchaseAmount	numeric(7,2),
@SetupFee		numeric(7,2) output, 
@ProcessingFee	numeric(7,2) output, 
@tax			numeric(7,2) output

AS
Declare  @FeePercent  numeric(4,2) ,  @FeeAmount  numeric(4,2)
SET  @SetupFee =0
SET  @ProcessingFee =0
SET @tax =0
SET @FeePercent = 0.04 
SET   @FeeAmount  = 0

Declare  @ANI_NPA char(3), @ANI_NXX char(3) , @mileage int , @toState char(2), @fromState char(2), @fromLata varchar(4) , @toLata varchar(4), @fromCity varchar(10), @toCity varchar(10), @calltype tinyint, @MaxCallTime smallint
Declare   @DNI_NPA char(3), @DNI_NXX char(3),@DNI_Horizontal  int , @DNI_vertical  int ,  @ANI_Horizontal  int , @ANI_vertical  int, @ANI char(10),  @ANI_pointID varchar(2) ,@DNI_pointID varchar(2), @rateplanID varchar(5)
Declare @pointID	varchar(2)
Select @ANI = phone, @rateplanID = rateplanID, @MaxCallTime =   MaxCallTime from tblFacilityService with(nolock) where facilityID = @FacilityID	
SET @ANI_NPA  =LEFT(@ANI,3)
SET  @ANI_NXX = SUBSTRING(@ANI,4,3)

SET @DNI_NPA = LEFT(@AccountNo,3) 
SET  @DNI_NXX = SUBSTRING(@AccountNo	,4,3)


SELECT  top 1  @DNI_Horizontal  =CONVERT( numeric(8,2),[Major H]), @DNI_vertical  =CONVERT( numeric(8,2), [Major V]) ,  @DNI_pointID = [point ID] ,
		 @tostate = state, @tolata = [Lata], @toCity = [place Name]
			    From tblTPM with(NOLOCK)   WHERE NPA =  @DNI_NPA AND NXX = @DNI_NXX	
 SELECT top 1  @ANI_Horizontal  =CONVERT ( numeric(8,2),[Major H]), @ANI_vertical  =CONVERT( numeric(8,2), [Major V] ),  @ANI_pointID = [point ID] , 
			  @fromstate = state, @Fromlata = [Lata], @fromCity = [place Name]
			   From tblTPM with(NOLOCK)   WHERE NPA =  @ANI_NPA AND NXX = @ANI_NXX 
	
		
SET  @Mileage = SQRT( (SQUARE (@ANI_Horizontal -   @DNI_Horizontal )  + SQUARE  (@ANI_vertical - @DNI_vertical )) / 10)

If (dbo.fn_determine_local_call ( left(@ANI,6), left(@accountNo,6) )  = 1 )
 Begin
	If (@fromState <> @toState ) 
	  Begin
		SET  @calltype =0
		 SET  @pointID ='1'
	  end
	Else
	  Begin
		SET @calltype =3
		SET   @pointID =  @fromstate 
	  End
 End
Else
 Begin
	If (@fromState <> @toState ) 
	  Begin
		SET  @calltype =0
		 SET  @pointID ='1'
	  end
	Else
	 Begin
		If (@fromLata = @toLata )  SET   @calltype =1
	 	Else SET   @calltype =2
		SET   @pointID =  @fromstate 
	 End
 End


If(select count (*) from tblpurchaseService with(nolock) where AccountNo = @AccountNo ) =0
 Begin
	SET  @SetupFee =5.95;
	Select  @SetupFee  = ( FeeAmount  +  FeePercent  * @PurchaseAmount )  from  tblFeesService with(nolock)  where   FacilityID = @facilityID and   FeeDetailID =1
 End

	SELECT  @FeeAmount  = FeeAmount , @FeePercent =  FeePercent  from  tblFeesService with(nolock)  where   FacilityID = @facilityID and   FeeDetailID =3  
	SET  @ProcessingFee	  =  @FeeAmount  +  (@FeePercent  * @PurchaseAmount )
	

Select  @tax	  = ( FeeAmount  +  FeePercent  * @PurchaseAmount )  from tblFeesService with(nolock)  where   FacilityID = @facilityID and   FeeDetailID =4  And calltype = @calltype

