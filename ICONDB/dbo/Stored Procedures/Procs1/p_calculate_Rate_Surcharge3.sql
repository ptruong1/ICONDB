﻿CREATE PROCEDURE [dbo].[p_calculate_Rate_Surcharge3]
@ANI  varchar(10),
@DNI	varchar(20),
@trunk  varchar(6),
@FacilityID	int,
@billType char(2)	,
@PIN	varchar(12),
@userName	varchar(23),
@firstMinute   numeric(6,4)  OUTPUT,
@nextMinute   numeric(6,4)  OUTPUT,
@connectFee numeric(6,4)  OUTPUT,
@duration 	smallint OUTPUT,
@CLEC_callType   char(2)  OUTPUT,
@indicator19	char(1)  OUTPUT,
@fromState	char(2) OUTPUT,
@fromCity	varchar(10) OUTPUT,
@toState	char(2) OUTPUT,
@toCity		varchar(10) OUTPUT,
@fromLata	varchar(3) OUTPUT,
@toLata	varchar(3) OUTPUT,
@libCode	varchar(2) OUTPUT,
@ratePlanID	varchar(7)  OUTPUT,
@PIP		Numeric(6,4) OUTPUT, -- this is total surcharges
@Increment	tinyint	OUTPUT

 AS
SET NOCOUNT ON
Declare  @ANI_NPA char(3), @ANI_NXX char(3), @dayCode tinyint, @MinuteDuration smallint, @MinuteDurationInt  smallint, @ANI_lata  char(3), @DNI_lata char(3), @lataType char(1) ,@phone char(10);
Declare   @DNI_NPA char(3), @DNI_NXX char(3),  @ANI_pointID char(1),  @DNI_pointID char(1),@pointID varchar(2), @propType char(1), @IntlRate varchar(5),@timeZone tinyint;
Declare   @ANI_Horizontal   numeric(8,2), @ANI_vertical  numeric(8,2),  @DNI_Horizontal   numeric(8,2), @DNI_vertical  numeric(8,2) ,  @Mileage INT, @i int, @localTime datetime;
Declare  @IntCall  int, @countryCode  varchar(4), @configID varchar(4) ,@authcode  varchar(10), @PromptLang	tinyint , @isGU  tinyint, @stateFeeOpt  bit , @SurchargeID varchar(5);
Declare   @NSF	numeric(4,2), 	@PSC		numeric(4,2), 	@NIF		numeric(4,2), @BDF	numeric(4,2), @A4250	numeric(4,2), @pif numeric(4,2), @subAgentID	varchar(5), @AgentID int , @ReasonID int;
SET @subAgentID ='';
SET @firstMinute   =0;
SET @nextMinute   =0;
SET @connectFee = 0;
SET @pip = 0 ;
SET @duration = 0;
SET @MinuteDuration = 1;
SET @MinuteDurationInt  = 1;
SET  @IntCall  = 0;
SET @libCode ='';
SET @ratePlanID =  '9999';
SET  @trunk = ltrim( rtrim(@trunk));
SET @DNI = ltrim(rtrim(@DNI));
SET @DNI_NPA = LEFT(@DNI,3) ;
SET  @DNI_NXX = SUBSTRING(@DNI	,4,3);
SET  @pip =0;
SET @fromState = '';
SET @tostate = '';
SET @fromCity = '';
SET  @lataType = '0';
SET @configID = ''
SET @trunk = isnull(@trunk,'')		;
SET @Increment =1;
SET @IntlRate = '';
Set @ReasonID =0;
SET @timeZone =0 ;
SET @dayCode =2;
/*
Select   @ReasonID = ReasonID from  tblblockedPhones  with(nolock) where phoneNo =  @DNI 

if  @ReasonID = 1 
 begin
	EXEC  p_insert_unbilled_calls1   '','',  @ANI ,@DNI,@billtype, 4,@PIN	,0 ,@facilityID	,@userName, '', '',''
 	 Return -2
 end

If (@billType ='01')
 Begin
	  If  ( @ReasonID = 2)  	
	   begin
		EXEC  p_insert_unbilled_calls1   '','',  @ANI ,@DNI,@billtype, 4,@PIN	,0 ,@facilityID	,@userName, '', '',''
 		 Return -2
 	   end
	--exec  @i =  p_billed_threshold  @DNI 
	--if ( @i =-1)  Return -2
 end

*/

If (@billType = '04')   SET @billType = '01';

SELECT @phone= phone,  @ratePlanID  =   RATEPLANID , @AgentID = AgentID, @SurchargeID =  SurchargeID,  @fromCity = City,   @fromstate = state , @libCode = librarycode,@timeZone= timeZone  FROM  tblFacility With(nolock)  WHERE  facilityID =@facilityID;
if(@phone <>'')  SET @ANI = @phone;
SET @ANI_NPA  =LEFT(@ANI,3);
SET  @ANI_NXX = SUBSTRING(@ANI,4,3);
SET @localTime = dateadd(hh,@timezone,getdate());
--select @localTime
exec [dbo].[p_determine_daycode_by_Local] @localTime , @daycode  OUTPUT ;
--select  @daycode

if(@facilityID =1 or  @facilityID=0 or @AgentID=1144 )
 begin
	 SELECT top 1  @ANI_Horizontal  =CONVERT ( numeric(8,2),[Major H]), @ANI_vertical  =CONVERT( numeric(8,2), [Major V] ),  @ANI_pointID = [point ID] ,  @Fromlata = [Lata],
			  @fromstate = state,  @fromCity = [place Name]
			   From tblTPM with(NOLOCK)   WHERE NPA =  @ANI_NPA AND NXX = @ANI_NXX ;
	SET @phone= @ANI;
 end
if( len(@DNI)=10 and  @DNI_NPA <>'011')
  Begin
	
	If ( right(@DNI, 7)='5551212') 
		 begin
			EXEC  p_insert_unbilled_calls1   '','',  @ANI ,@DNI,@billtype, 8,@PIN	,0 ,@facilityID	,@userName, '', '','';
 			 Return -1;
 	  	 end
	SELECT  @DNI_Horizontal  =CONVERT( numeric(8,2),[Major H]), @DNI_vertical  =CONVERT( numeric(8,2), [Major V]) ,  @DNI_pointID = [point ID] ,
			 @tostate = state, @tolata = [Lata], @toCity = [place Name]
				    From tblTPM with(NOLOCK)   WHERE NPA =  @DNI_NPA AND NXX = @DNI_NXX;	
	 SELECT top 1  @ANI_Horizontal  =CONVERT ( numeric(8,2),[Major H]), @ANI_vertical  =CONVERT( numeric(8,2), [Major V] ),  @ANI_pointID = [point ID] ,  @Fromlata = [Lata]
				 -- @fromstate = state,  @fromCity = [place Name]
				   From tblTPM with(NOLOCK)   WHERE NPA =  @ANI_NPA AND NXX = @ANI_NXX ;
			
	If ( @tostate = ''  or   @tostate  is null  ) 
	 begin
		SELECT top 1  @DNI_Horizontal  =CONVERT( numeric(8,2),[Major H]), @DNI_vertical  =CONVERT( numeric(8,2), [Major V]) ,  @DNI_pointID = [point ID] ,
			 @tostate = state, @tolata = [Lata], @toCity = [place Name]  From tblTPM with(NOLOCK)   WHERE NPA =  @DNI_NPA ;
		If ( @tostate = ''  or   @tostate  is null) 
		 begin
			EXEC  p_insert_unbilled_calls1   '','',  @ANI ,@DNI,@billtype, 8,@PIN	,0 ,@facilityID	,@userName, '', '','';
 			 Return -1;
 	  	 end
	  End
		
	--SELECT  @ratePlanID  =   RATEPLANID , @AgentID = AgentID, @SurchargeID =  SurchargeID,  @fromCity = City,   @fromstate = state , @libCode = librarycode  FROM  tblFacility With(nolock)  WHERE  facilityID =@facilityID
	
	
	SET  @Mileage = SQRT( (SQUARE (@ANI_Horizontal -   @DNI_Horizontal )  + SQUARE  (@ANI_vertical - @DNI_vertical )) / 10);
	--select  @Mileage
	If ( @fromState = @Tostate)  
	  Begin
		If(@fromlata = @tolata)  
		  Begin
			SET @indicator19 ='5';
			If (( dbo.fn_determine_local_call ( left(@ANI,6), left(@DNI,6) )  = 1 and  @Mileage  <21)  Or  (dbo.fn_determine_local_call  ( left(@ANI,6), left(@DNI,6) )  = 1  and  (@facilityID = 27 or @facilityID =74 or @facilityID =350)))
			   Begin
				SET @lataType = '3';
		                           SET @CLEC_callType = 'LC';
				
			  End
			else
			  Begin
				SET @lataType = '1'
		                           SET @CLEC_callType = 'AL'
				
			  End
				
	               End 
		ELSE
		  Begin	
			SET @lataType = '2';
			SET @CLEC_callType = 'RL';
			SET @indicator19 ='2';
		  End
		If( @DNI = '4252998218')
		  Begin
			SET @lataType = '3';
		              SET @CLEC_callType = 'LC';
			 SET @indicator19 ='5';
		  End 
	  End
	else
	  Begin
		SET @lataType = '0'
		If ( select count(*) from tblstates  with(nolock) where  statecode = @Tostate and country = 'CAN') =  0
		  Begin
			SET @CLEC_callType = 'ST';
			SELECT  @Mileage = mileageCode  FROM tblMileageCode with(NOLOCK)  WHERE   state =  'US'  AND  lowR<= @Mileage AND   highR >= @Mileage;

		  End 
		else 
		  Begin
			SET @CLEC_callType = 'CA';
			SET @Mileage = 9999;
		  End
		SET @indicator19 ='2' ;
			
	  end
	
	If(@Mileage = 0)  SET @Mileage = 10;
	
	EXEC p_determine_PointID 	@ANI_pointID ,		@fromState	,@toState	,@isGU		,@DNI_pointID  ,@pointID  	  OUTPUT	;
	

	If   (left(@phone,6)  =  '218729'    and  dbo.fn_determine_local_call ( left(@ANI,6), left(@DNI,6) )  = 1 )  
	  Begin
			SET @lataType = '3';
		              SET @CLEC_callType = 'LC';
			 SET @indicator19 ='5';
			SET @pointID = 'MN';
	  End 
	
	If( @pointID =  '3') 
	  Begin
		SET @CLEC_callType ='IN'	;
		SET @indicator19 ='0';
	  End
	
	
	
	If(@billtype ='07' )
	  Begin
		if(@CLEC_callType ='IN')
			SET @lataType ='4';
		select  @firstMinute= firstMin , @NextMinute = NextMin, @connectFee= ConnectFee, @PiP= SurchargeFee, @increment= increment,  @duration= MinMinute  from tblDebitrate  with(nolock)  where RatePlanID = @rateplanID  and Calltype = @lataType;
		If(@firstMinute =0 and @NextMinute =0 and  @connectFee =0 )  
		 Begin
			EXEC	p_get_rate_Detail2  	@ratePlanID	Output,	@Mileage	,@PointID	,@lataType ,@billType	, @dayCode,	@firstMinute	   OUTPUT,@NextMinute	   OUTPUT,@connectFee	    OUTPUT,@Minuteduration    OUTPUT, @Increment OUTPUT;
			EXEC  p_calculate_Surcharge_Fee  @SurchargeID, @CLEC_calltype,  @fromState	,  @PiP		Output , @libCode	OUTPUT;
			SET @duration =  @MinuteDuration;
		 End 
		If(@firstMinute =0 and @NextMinute =0 and @connectFee =0 )  
		 Begin
			SET @firstMinute = 1.25;
			SET @NextMinute = 1.25;
			SET  @connectFee =2;
		 End
 	  End
	else If(@billtype ='10' )
	 Begin
		select  @firstMinute= firstMin , @NextMinute = NextMin, @connectFee= ConnectFee, @PiP= SurchargeFee, @increment= increment,  @duration= MinMinute  from tblPrepaidRate  with(nolock)  where RatePlanID = @rateplanID  and Calltype = @lataType;
		If(@firstMinute =0 and @NextMinute =0 and  @connectFee =0 )  
		 Begin
			EXEC	p_get_rate_Detail2  	@ratePlanID	Output,	@Mileage	,@PointID	,@lataType ,@billType	, @dayCode,	@firstMinute	   OUTPUT,@NextMinute	   OUTPUT,@connectFee	    OUTPUT,@Minuteduration    OUTPUT, @Increment OUTPUT;
			EXEC  p_calculate_Surcharge_Fee  @SurchargeID, @CLEC_calltype,  @fromState	,  @PiP		Output , @libCode	OUTPUT;
			SET @duration =  @MinuteDuration;
		 End 
		If(@firstMinute =0 and @NextMinute =0 and  @connectFee =0 )  
		 Begin
			SET @firstMinute = 1.25;
			SET @NextMinute = 1.25;
			SET  @connectFee =2;
		 End
	 End
	Else
	  Begin
	
		EXEC	p_get_rate_Detail2  	@ratePlanID	Output,	@Mileage	,@PointID	,@lataType ,@billType	, @dayCode,	@firstMinute	   OUTPUT,@NextMinute	   OUTPUT,@connectFee	    OUTPUT,@Minuteduration    OUTPUT, @Increment OUTPUT;
		EXEC  p_calculate_Surcharge_Fee  @SurchargeID, @CLEC_calltype,  @fromState	,  @PiP		Output , @libCode	OUTPUT;
		SET @duration =  @MinuteDuration;
	  End
		
 end

Else   
 
 Begin
	SET @CLEC_callType = 'IN'
	If(@billtype ='07' )
	  Begin
		select  @firstMinute= firstMin , @NextMinute = NextMin, @connectFee= ConnectFee, @PiP= SurchargeFee, @increment= increment,  @duration= MinMinute  from tblDebitrate  with(nolock)  where RatePlanID = @rateplanID  and Calltype ='9';
		If(@firstMinute =0 and @NextMinute =0 and  @connectFee =0 )  
		 Begin
			EXEC p_get_Intl_rate  @rateplanID, @DNI, @ConnectFee	  OUTPUT,@FirstMinute	  OUTPUT,@NextMinute  OUTPUT,@toState   OUTPUT,@toCity	  Output;
		 End 
		If(@firstMinute =0 and @NextMinute =0 and @connectFee =0 )  
		 Begin
			SET @firstMinute = 1.25;
			SET @NextMinute = 1.25;
			SET  @connectFee =2;
		 End
 	  End
	else If(@billtype ='10'  )
	 begin
		EXEC p_get_Intl_rate  @rateplanID, @DNI, @ConnectFee	  OUTPUT,@FirstMinute	  OUTPUT,@NextMinute  OUTPUT,@toState   OUTPUT,@toCity	  Output;
	  end
	else
	 begin
		EXEC  p_insert_unbilled_calls1   '','',  @ANI ,@DNI,@billtype, 8,@PIN	,0 ,@facilityID	,@userName, '', '','';
 		 Return -1;
  	  end
 End




If(@firstMinute = 0 and   @nextMinute =0 and  @connectFee=0) 
 Begin
	
	             SET @firstMinute =1.15;
		SET  @nextMinute = 1.15;
		SET @connectFee = 5.99;
		SET @ratePlanID = '9999';
		SET  @duration = 3;
	
	  
  End

return @@error;
