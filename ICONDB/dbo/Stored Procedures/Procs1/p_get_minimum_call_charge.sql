
CREATE PROCEDURE [dbo].[p_get_minimum_call_charge]
@DNI  varchar(12),
@billType char(2),
@MinCallCharge smallmoney OUTPUT

AS
SET NOCOUNT ON;
Declare  @ANI_NPA char(3), @ANI_NXX char(3),@dayCode tinyint,  @MinuteDuration smallint, @MinuteDurationInt  smallint, @ANI_lata  char(3), @DNI_lata char(3), @lataType char(1) ,@phone char(10);
Declare   @DNI_NPA char(3), @DNI_NXX char(3),  @ANI_pointID char(1),  @DNI_pointID char(1),@pointID varchar(2), @propType char(1), @IntlRate varchar(5),@timeZone tinyint, @localTime datetime;
Declare   @ANI_Horizontal   numeric(8,2), @ANI_vertical  numeric(8,2),  @DNI_Horizontal   numeric(8,2), @DNI_vertical  numeric(8,2) ,  @Mileage INT, @i int , @fromLata char(3), @toLata char(3);
Declare  @IntCall  int, @countryCode  varchar(4), @configID varchar(4) ,@authcode  varchar(10), @PromptLang	tinyint , @isGU  tinyint, @stateFeeOpt  bit , @SurchargeID varchar(5);
Declare   @NSF	numeric(4,2), 	@PSC		numeric(4,2), 	@NIF		numeric(4,2), @BDF	numeric(4,2), @A4250	numeric(4,2), @pif numeric(4,2), @subAgentID	varchar(5), @AgentID int , @ReasonID int;
Declare @ANI_NPANXX char(6), @DNI_NPANXX char(6), @IsLocal smallint, @facilityID int;
Declare @firstMinute   numeric(4,2) ,@nextMinute   numeric(4,2)  ,@connectFee numeric(4,2) ,@duration 	smallint,@CallType   char(2) ,
@fromState	char(2),@fromCity	varchar(10) ,@toState	char(2),@toCity		varchar(10) ,@libCode	varchar(2) ,@ratePlanID	varchar(7) ,@PIP		Numeric(4,2),@Increment	tinyint;
SET @subAgentID ='';
SET @firstMinute   =0;
SET @nextMinute   =0;
SET @connectFee = 0;
SET @pip = 0 ;
SET @duration = 1;
SET @MinuteDuration = 1;
SET @MinuteDurationInt  = 1;
SET  @IntCall  = 0;
SET @libCode ='';
SET @ratePlanID =  '9999';
SET @DNI = ltrim(rtrim(@DNI));
SET @DNI_NPA = LEFT(@DNI,3) ;
SET  @DNI_NXX = SUBSTRING(@DNI	,4,3);
SET @DNI_NPANXX = LEFT(@DNI,6);
SET  @pip =0;
SET @fromState = '';
SET @tostate = '';
SET @fromCity = '';
SET  @lataType = '0';
SET @Increment =1;
SET @IntlRate = '';
Set @ReasonID =0;
SET @dayCode =2;
SET @timeZone =0;
SET @facilityID =1;

select @facilityID = facilityID,@countryCode=CountryCode from tblprepaid with(nolock) where PhoneNo = @DNI;

SELECT @phone= phone,  @ratePlanID  =   RATEPLANID , @AgentID = AgentID, @SurchargeID =  SurchargeID,  @fromCity = City,   @fromstate = state , @libCode = librarycode, @timeZone=timeZone  
	FROM  tblFacility With(nolock)  WHERE  facilityID =@facilityID;


SET @localTime = dateadd(hh,@timezone,getdate());


 SET @ANI_NPA  =LEFT(@phone,3);;
 SET  @ANI_NXX = SUBSTRING(@phone,4,3)
 SELECT top 1  @ANI_Horizontal  =CONVERT ( numeric(8,2),[Major H]), @ANI_vertical  =CONVERT( numeric(8,2), [Major V] ),  @ANI_pointID = [point ID] ,  @Fromlata = [Lata],
		  @fromstate = [state],  @fromCity = [place Name]
		   From tblTPM with(NOLOCK)   WHERE NPA =  @ANI_NPA AND NXX = @ANI_NXX ;

if(@ANI_pointID is null )
 begin
	SELECT top 1  @ANI_Horizontal  =CONVERT ( numeric(8,2),[Major H]), @ANI_vertical  =CONVERT( numeric(8,2), [Major V] ),  @ANI_pointID = [point ID] ,  @Fromlata = [Lata],
		  @fromstate = [state],  @fromCity = [place Name]
		   From tblTPM with(NOLOCK)   WHERE NPA =  @ANI_NPA;
	--select @ANI_NPA, @ANI_NXX, @ANI_pointID, @DNI_pointID	
 end
		
SET @ANI_NPANXX = LEFT(@phone,6);
exec [dbo].[p_determine_daycode_by_Local] @localTime , @daycode  OUTPUT ;
if( @countryCode in ('0','1',''))
  Begin
	
	SELECT  @DNI_Horizontal  =CONVERT( numeric(8,2),[Major H]), @DNI_vertical  =CONVERT( numeric(8,2), [Major V]) ,  @DNI_pointID = [point ID] ,
			 @tostate = state, @tolata = [Lata], @toCity = [place Name]
				    From tblTPM with(NOLOCK)   WHERE NPA =  @DNI_NPA AND NXX = @DNI_NXX	;
	 SELECT top 1  @ANI_Horizontal  =CONVERT ( numeric(8,2),[Major H]), @ANI_vertical  =CONVERT( numeric(8,2), [Major V] ),  @ANI_pointID = [point ID] ,  @Fromlata = [Lata]
				 -- @fromstate = state,  @fromCity = [place Name]
				   From tblTPM with(NOLOCK)   WHERE NPA =  @ANI_NPA AND NXX = @ANI_NXX ;
		
	If ( @tostate = ''  or   @tostate  is null) 
	 begin
		SELECT top 1  @DNI_Horizontal  =CONVERT( numeric(8,2),[Major H]), @DNI_vertical  =CONVERT( numeric(8,2), [Major V]) ,  @DNI_pointID = [point ID] ,
			 @tostate = state, @tolata = [Lata], @toCity = [place Name]  From tblTPM with(NOLOCK)   WHERE NPA =  @DNI_NPA ;
	  End
		
	
	SET  @Mileage = SQRT( (SQUARE (@ANI_Horizontal -   @DNI_Horizontal )  + SQUARE  (@ANI_vertical - @DNI_vertical )) / 10);
	--select  @Mileage
	SET @IsLocal =dbo.fn_determine_local_call ( @ANI_NPANXX, @DNI_NPANXX );
	If ( @fromState = @Tostate)  
	  Begin
		If(@fromlata = @tolata)  
		  Begin
			--SET @indicator19 ='5'
			If ( (@IsLocal  = 1 and  @Mileage  <21)  Or  (@IsLocal  = 1  and  (@facilityID = 614  or @facilityID =350)))
			   Begin
				 SET @lataType = '3';
		         SET @CallType = 'LC';
				
			  End
			else
			  Begin
				SET @lataType = '1';
		         SET @CallType = 'AL';
				
			  End
				
	      End 
		ELSE
		  Begin	
			If  (@IsLocal  = 1 and @facilityID = 614)
			 Begin
				 SET @lataType = '3';
		         SET @CallType = 'LC';
				
			  End
			else
			 begin
				SET @lataType = '2';
				SET @CallType = 'RL';
			 end
			--SET @indicator19 ='2'
		  End
	  End
	else
	  Begin
		SET @lataType = '0'
		If ( select count(*) from tblstates  with(nolock) where  statecode = @Tostate and country = 'CAN') =  0
		  Begin
			SET @CallType = 'ST';
			SELECT  @Mileage = mileageCode  FROM tblMileageCode with(NOLOCK)  WHERE   state =  'US'  AND  lowR<= @Mileage AND   highR >= @Mileage;

		  End 
		else 
		  Begin
			SET @CallType = 'CA';
			SET @Mileage = 9999;
		  End
		--SET @indicator19 ='2'
			
	  end
	If  ( @ANI_NPA  =  '218'   and  @IsLocal  = 1  )  
	  Begin
			SET @lataType = '3';
		    SET @CallType = 'LC';
	  End 
	If(@Mileage = 0)  SET @Mileage = 10;
	 
	
	EXEC p_determine_PointID 	@ANI_pointID ,		@fromState	,@toState	,@isGU		,@DNI_pointID  ,@pointID  	  OUTPUT;	

	if(@CallType = 'LC') SET @pointID  =@fromState;
		
	
	If( @pointID =  '3') 
	  Begin
		SET @CallType ='IN'	;	--SET @indicator19 ='0'
	  End
	
	
	
	If(@billtype ='07' )
	  Begin
		select  @firstMinute= firstMin , @NextMinute = NextMin, @connectFee= ConnectFee, @PiP= SurchargeFee, @increment= increment,  @duration= MinMinute  
			from tblDebitrate  with(nolock)  where (RatePlanID = @rateplanID )  and Calltype = @lataType;
		If(@firstMinute =0 and @NextMinute =0 and  @connectFee =0 )  
		 Begin
			EXEC	p_get_rate_Detail2  	@ratePlanID	Output,	@Mileage	,@PointID	,@lataType ,@billType	,@dayCode,	@firstMinute	   OUTPUT,@NextMinute	   OUTPUT,@connectFee	    OUTPUT,@Minuteduration    OUTPUT, @Increment OUTPUT;
			EXEC  p_calculate_Surcharge_Fee  @SurchargeID, @Calltype,  @fromState	,  @PiP		Output , @libCode	OUTPUT;
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
		select  @firstMinute= firstMin , @NextMinute = NextMin, @connectFee= ConnectFee, @PiP= SurchargeFee, @increment= increment,  @duration= MinMinute  
			from tblPrepaidRate  with(nolock)  where RatePlanID = @rateplanID  and Calltype = @lataType;
		If(@firstMinute =0 and @NextMinute =0 and  @connectFee =0 )  
		 Begin
			EXEC	p_get_rate_Detail2  	@ratePlanID	Output,	@Mileage	,@PointID	,@lataType ,@billType	,@dayCode,	@firstMinute	   OUTPUT,@NextMinute	   OUTPUT,@connectFee	    OUTPUT,@Minuteduration    OUTPUT, @Increment OUTPUT;
			EXEC  p_calculate_Surcharge_Fee  @SurchargeID, @Calltype,  @fromState	,  @PiP		Output , @libCode	OUTPUT;
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
	
		EXEC	p_get_rate_Detail2  	@ratePlanID	Output,	@Mileage	,@PointID	,@lataType ,@billType	,@dayCode,	@firstMinute	   OUTPUT,@NextMinute	   OUTPUT,@connectFee	    OUTPUT,@Minuteduration    OUTPUT, @Increment OUTPUT;
		EXEC  p_calculate_Surcharge_Fee  @SurchargeID, @Calltype,  @fromState	,  @PiP		Output , @libCode	OUTPUT;
		SET @duration =  @MinuteDuration;
	  End
		
 end

Else   
 
 Begin
	SET @CallType = 'IN'
	If(@billtype ='07' )
	  Begin
		select  @firstMinute= firstMin , @NextMinute = NextMin, @connectFee= ConnectFee, @PiP= SurchargeFee, @increment= increment,  @duration= MinMinute  
			from tblDebitrate  with(nolock)  where RatePlanID = @rateplanID  and Calltype ='9';
		If(@firstMinute =0 and @NextMinute =0 and  @connectFee =0 )  
		 Begin
			EXEC p_get_Intl_rate  @rateplanID, @DNI, @ConnectFee	  OUTPUT,@FirstMinute	  OUTPUT,@NextMinute  OUTPUT,@toState   OUTPUT,@toCity	  Output;
		 End 
		If(@firstMinute =0 and @NextMinute =0 and @connectFee =0 )  
		 Begin
			SET @firstMinute = 0.99;
			SET @NextMinute = 0.99;
			SET  @connectFee =4.99;
		 End
 	  End
	
	EXEC p_get_Intl_rate  @rateplanID, @DNI, @ConnectFee	  OUTPUT,@FirstMinute	  OUTPUT,@NextMinute  OUTPUT,@toState   OUTPUT,@toCity	  Output;
	  
	

 End




If(@firstMinute = 0 and   @nextMinute =0 and  @connectFee=0) 
 Begin
	
	    SET @firstMinute =1.15;
		SET  @nextMinute = 1.15;
		SET @connectFee = 5.99;
		SET @ratePlanID = '9999';
		SET  @duration = 3;
	
	  
  End
SET @MinCallCharge = @PIP + @connectFee + @firstMinute + 4* @nextMinute ;

if(@MinCallCharge <=15)
	SET @MinCallCharge = 15;
else if(@MinCallCharge >15 and @MinCallCharge <20 )
	SET  @MinCallCharge = 20;
else
	SET  @MinCallCharge = 25;	
return @@error;
