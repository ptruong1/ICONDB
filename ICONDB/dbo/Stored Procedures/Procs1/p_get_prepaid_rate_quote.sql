﻿
CREATE PROCEDURE [dbo].[p_get_prepaid_rate_quote]
@AccountNo	varchar(11) , -- phone number
@FacilityID	int,
@PurchaseAmount	numeric(7,2),
@ConnectFee		numeric(7,2) output, 
@RatePerMin		numeric(7,2) output, 
@MinuteCredit		numeric(7,2) output


AS

SET  @ConnectFee  =3.99 ;
SET @RatePerMin =0.99 ;
SET @MinuteCredit =0.99;


Declare  @ANI_NPA char(3), @ANI_NXX char(3) , @mileage int , @toState varchar(2), @fromState varchar(2), @fromLata varchar(4) , @toLata varchar(4), @fromCity varchar(10), @toCity varchar(10), @calltype tinyint, @MaxCallTime smallint;
Declare   @DNI_NPA char(3), @DNI_NXX char(3),@DNI_Horizontal  int , @DNI_vertical  int ,  @ANI_Horizontal  int , @ANI_vertical  int, @ANI char(10),  @ANI_pointID varchar(2) ,@DNI_pointID varchar(2), @rateplanID varchar(5);
Declare @pointID	varchar(2), @TotalSurcharge  numeric(4,2) , @libCode varchar(2), @CLEC_type  varchar(2), @surchargeID varchar(5);
Declare @CountryCode varchar(3), @countryID int;
Select @ANI = phone, @rateplanID = rateplanID, @MaxCallTime =   MaxCallTime,@surchargeID=surchargeID from tblFacility with(nolock) where facilityID = @FacilityID	;
SET @ANI_NPA  =LEFT(@ANI,3);
SET  @ANI_NXX = SUBSTRING(@ANI,4,3);

SET @DNI_NPA = LEFT(@AccountNo,3) ;
SET  @DNI_NXX = SUBSTRING(@AccountNo	,4,3);
SET @toState ='';
SET @fromState ='';
SET  @TotalSurcharge  =0;
SET @countryID=203;
--Select @rateplanID


select @Countrycode, @countryID from tblprepaid with(nolock) where PhoneNo =@AccountNo ;
 
if (@Countrycode in ('1','0') or @countryID=203)

Begin

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

			
	SET  @Mileage = SQRT( (SQUARE (@ANI_Horizontal -   @DNI_Horizontal )  + SQUARE  (@ANI_vertical - @DNI_vertical )) / 10);

	If ( (dbo.fn_determine_local_call ( left(@ANI,6), left(@accountNo,6) )  = 1 and  @Mileage  <21)  Or  (dbo.fn_determine_local_call ( left(@ANI,6), left(@accountNo,6) )  = 1  and  (@facilityID = 27 or @facilityID =74)))
	 Begin
		If (@fromState <> @toState ) 
		  Begin
			SET  @calltype =0;
			 SET  @pointID ='1';
			SET @CLEC_type  ='ST';
		  end
		Else
		  Begin
			SET @calltype =3;
			SET   @pointID =  @fromstate ;
			SET @CLEC_type  ='LC';
		  End
	 End
	Else
	 Begin
		If (@fromState <> @toState ) 
		  Begin
			SET  @calltype =0;
			 SET  @pointID ='1';
			 SET @CLEC_type  ='ST';
		  end
		Else
		 Begin
			If (@fromLata = @toLata )  	
			 Begin
		  		SET   @calltype =1;
		   		SET @CLEC_type  ='AL';
			 End
	 		Else
 			 Begin
		 		SET   @calltype =2;
				SET @CLEC_type  ='RL';
			 end
			SET   @pointID =  @fromstate ;
		 End
	 End

end

else
begin
	SET @CLEC_type  ='IN';
    SELECT @rateplanID= rateplanID from tblfacility where FacilityID =@FacilityID ;
    SELECT @Countrycode=code from tblCountryCode where CountryID= @countryID;
    select  @ConnectFee		=  ConnectFee, @RatePerMin	=firstMinute   from tblIntlRate 
			where  RateID =@rateplanID and CountryCode =  @Countrycode;
	if(@ConnectFee=0)
		 select  @ConnectFee		=  ConnectFee, @RatePerMin	=firstMinute   from tblIntlRate 
			where  RateID ='J9' and CountryCode =  @Countrycode;
end
	
select  @ConnectFee		=  ConnectFee, @RatePerMin	=NextMin  from  tblPrepaidRate with(nolock)  where  RateplanID = @rateplanID and Calltype =@calltype  ;

If (@ConnectFee =3.99) 
 	select  @ConnectFee	=  ACPCreditCardFee, @RatePerMin	=AddlMin  from  tblRateplanDetail  with(nolock)  where  RateID = @rateplanID and (type =@calltype  or Type='0')   and pointID = @pointID  and (daycode= 0 or DayCode =2);


EXEC  p_calculate_Surcharge_Fee   @surchargeID,@CLEC_type,  @fromState	,  @TotalSurcharge   OUTPUT , @libCode	OUTPUT;

SET   @ConnectFee	 =  @ConnectFee	 +  @TotalSurcharge ;

If ( @RatePerMin =0)  
Begin
	SET  @MinuteCredit = Floor(@PurchaseAmount/ @ConnectFee ) * @MaxCallTime ;
	
End 
Else 
 Begin
	SET @MinuteCredit	=  (@PurchaseAmount	-  @ConnectFee	)  /  @RatePerMin;
 End
