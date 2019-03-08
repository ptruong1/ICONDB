
CREATE PROCEDURE [dbo].[p_get_rate_quote_fees]
@AccountNo	char(10) , -- phone number
@FacilityID	int,
@ConnectFee		numeric(7,2) OUTPUT ,
@RatePerMin		numeric(7,2) OUTPUT ,
@CLEC_type		varchar(20)  OUTPUT 


AS
SET NOCOUNT ON
Declare @SetUpFee numeric(7,2) ,@ReplenishFee	numeric(7,2), @FacilityName	varchar(150) ,@state char(2)
Declare  @ANI_NPA char(3), @ANI_NXX char(3) , @mileage int , @toState varchar(2), @fromState varchar(2), @fromLata varchar(4) , @toLata varchar(4), @fromCity varchar(10), @toCity varchar(10), @calltype tinyint, @MaxCallTime smallint
Declare   @DNI_NPA char(3), @DNI_NXX char(3),@DNI_Horizontal  int , @DNI_vertical  int ,  @ANI_Horizontal  int , @ANI_vertical  int, @ANI char(10),  @ANI_pointID varchar(2) ,@DNI_pointID varchar(2), @rateplanID varchar(5)
Declare @pointID	varchar(2), @TotalSurcharge  numeric(4,2) , @libCode varchar(2), @LECCall char(2), @billStateFee numeric(4,2), @RegulatoryFee numeric(4,2), @AdminFee numeric(4,2) , @MobileFee numeric(4,2)
Select @ANI = phone, @rateplanID = rateplanID, @MaxCallTime =   MaxCallTime,@FacilityName= location,@state=[state]  from tblFacility with(nolock) where facilityID = @FacilityID	
SET  @ConnectFee  =3.99;
SET @RatePerMin =0.99;
SET @ReplenishFee =5.95;
SET @SetUpFee = 5.95;
SET @ANI_NPA  =LEFT(@ANI,3)
SET  @ANI_NXX = SUBSTRING(@ANI,4,3);

SET @DNI_NPA = LEFT(@AccountNo,3) ;
SET  @DNI_NXX = SUBSTRING(@AccountNo	,4,3);
SET @toState ='';
SET @fromState ='';
SET  @TotalSurcharge  =0;

SELECT  top 1  @DNI_Horizontal  =CONVERT( numeric(8,2),[Major H]), @DNI_vertical  =CONVERT( numeric(8,2), [Major V]) ,  @DNI_pointID = [point ID] ,
		 @tostate = state, @tolata = [Lata], @toCity = [place Name]
			    From tblTPM with(NOLOCK)   WHERE NPA =  @DNI_NPA AND NXX = @DNI_NXX	;
If( @toState ='')
Begin
		SELECT  top 1  @DNI_Horizontal  =CONVERT( numeric(8,2),[Major H]), @DNI_vertical  =CONVERT( numeric(8,2), [Major V]) ,  @DNI_pointID = [point ID] ,
		 @tostate = state, @tolata = [Lata], @toCity = [place Name]
			    From tblTPM with(NOLOCK)   WHERE NPA =  @DNI_NPA ;
end

 SELECT top 1  @ANI_Horizontal  =CONVERT ( numeric(8,2),[Major H]), @ANI_vertical  =CONVERT( numeric(8,2), [Major V] ),  @ANI_pointID = [point ID] , 
			  @fromstate = state, @Fromlata = [Lata], @fromCity = [place Name]
			   From tblTPM with(NOLOCK)   WHERE NPA =  @ANI_NPA AND NXX = @ANI_NXX ;

If( @fromState ='') 
begin
		SELECT top 1  @ANI_Horizontal  =CONVERT ( numeric(8,2),[Major H]), @ANI_vertical  =CONVERT( numeric(8,2), [Major V] ),  @ANI_pointID = [point ID] , 
			  @fromstate = state, @Fromlata = [Lata], @fromCity = [place Name]
			   From tblTPM with(NOLOCK)   WHERE NPA =  @ANI_NPA;
End

		
SET  @Mileage = SQRT( (SQUARE (@ANI_Horizontal -   @DNI_Horizontal )  + SQUARE  (@ANI_vertical - @DNI_vertical )) / 10)

If ( (dbo.fn_determine_local_call ( left(@ANI,6), left(@accountNo,6) )  = 1 and  @Mileage  <21)  Or  (dbo.fn_determine_local_call ( left(@ANI,6), left(@accountNo,6) )  = 1  and  (@facilityID = 27 or @facilityID =74)))
 Begin
	If (@fromState <> @toState ) 
	  Begin
		SET  @calltype =0
		 SET  @pointID ='1'
		SET @CLEC_type  ='Inter-State'
		SET @LECCall ='ST'
	  end
	Else
	  Begin
		SET @calltype =3
		SET   @pointID =  @fromstate 
		SET @CLEC_type  ='Local'
		SET @LECCall ='LC'
	  End
 End
Else
 Begin
	If (@fromState <> @toState ) 
	  Begin
		SET  @calltype =0
		 SET  @pointID ='1'
		 SET @CLEC_type  ='Inter-State'
		 SET @LECCall ='ST'
	  end
	Else
	 Begin
		If (@fromLata = @toLata )  	
		 Begin
		  	SET   @calltype =1
		   	SET @CLEC_type  ='Intra-Lata'
		   	SET @LECCall ='RL'
		 End
	 	Else
 		 Begin
		 	SET   @calltype =2
			SET @CLEC_type  ='Inter-Lata'
			SET @LECCall ='AL'
		 end
		SET   @pointID =  @fromstate 
	 End
 End

--select  @pointID, @calltype  , @rateplanID
	
select  @ConnectFee		=  ConnectFee, @RatePerMin	=NextMin  from  tblPrepaidRate with(nolock)  where  RateplanID = @rateplanID and Calltype =@calltype  

If (@ConnectFee =3.99) 
 	select  @ConnectFee	=  ACPCreditCardFee, @RatePerMin	=AddlMin  from  tblRateplanDetail  with(nolock)  where  RateID = @rateplanID and (type =@calltype  or Type='0')   and pointID = @pointID  and (daycode= 0 or DayCode =2)


EXEC  p_calculate_Surcharge_Fee   @rateplanID,@LECCall,  @fromState	,  @TotalSurcharge   OUTPUT , @libCode	OUTPUT

SET   @ConnectFee	 =  @ConnectFee	 +  @TotalSurcharge 

/*

SELECT @SetUpFee = FeeAmount FROM leg_Icon.dbo.tblFees where facilityID = @facilityID and feeDetailID =1
SELECT @ReplenishFee= FeeAmount FROM leg_Icon.dbo.tblFees where facilityID = @facilityID and feeDetailID =5

select  'Connect Fee'  as  FeeName , @ConnectFee as  FeeAmount , @CLEC_type as FeeDiscript
UNION All
select  'Per Minute Charge' ,   @RatePerMin	 as  FeeAmount , @CLEC_type as CallType

UNION All

*/
if(select COUNT(*) from  leg_Icon.dbo.tblFees  F , leg_Icon.dbo.tblFeesdetail  D  where F.feeDetailID = D.feeDetailID and   (facilityID =  @facilityID)  and F.FeeAmount >0) =0
	select  D.FeeType , FeeAmount,  Descript from  leg_Icon.dbo.tblFees  F , leg_Icon.dbo.tblFeesdetail  D  where F.feeDetailID = D.feeDetailID and   (facilityID =  @facilityID)  and F.FeeAmount >0 and  F.feeDetailID =5
else
	select  D.FeeType , FeeAmount,  Descript from  leg_Icon.dbo.tblFees  F , leg_Icon.dbo.tblFeesdetail  D  where F.feeDetailID = D.feeDetailID and   (facilityID = 0)  and F.FeeAmount >0 and  F.feeDetailID =5
