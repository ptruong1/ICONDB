﻿CREATE PROCEDURE [dbo].[p_get_billtype_web_service_V2]
@ANI	char(10),
@DNI	varchar(16),
@PIN		varchar(12), -- ACP pass in InmateID
@facilityID	int,
@userName       varchar(23),
@Billtype	char(2) ,
@AccountNo	varchar(15),
@RecordID bigint


AS
SET nocount on ;
Declare @ReasonID	smallint , @FreeType tinyint , @phone char(10) , @dialPrefix char(3) , @DialNo varchar(13) ,@TophoneNo  varchar(12), @countryCode varchar(3), @calls tinyint, @isPrepaid tinyint , @i int;
Declare  @blockTime smallint,  @timeZone tinyint , @localtime datetime, @bookingTime datetime   , @AcessAllow  varchar(10), @firstMinute   numeric(4,2), @Balance numeric(7,2), @Duration int, @Minbilled numeric(5,2),@AgentID int,
	  @nextMinute   numeric(4,2) ,	@connectFee numeric(4,2)  ,	@Minduration 	smallint ,	@CallType   char(2) ,	@fromState	varchar(2) ,	@fromCity	varchar(10) ,@InmateID varchar(12),@FreeLimitTime smallint,
	   @toState	varchar(2) ,	@toCity		varchar(10) ,	@libCode	varchar(2) ,	@ratePlanID	varchar(7)  ,	@Surcharge	Numeric(4,2),@Increment	tinyint ,@state varchar(2) , @FreeCalls smallint, @NPA varchar(3)	;
Declare @PANNotAllow bit,  @DNIRestrict  bit, @RecordOPT char(1),@CallLimit smallint, @TimeLimited smallint ,@facDuration smallint,@acceptOpt tinyint, @Rebook tinyint, @RebookDate datetime, @custodialOpt bit;
declare @j int, @AccountStatus tinyint, @FreeCallRemain smallint;
SET @j=0;
SET   @ReasonID =0;
SET @Freetype  =0 ;
--SET @calls = -1;
SET @firstMinute  =0;
SEt 	@nextMinute  =0;
SET	@connectFee =0;
Set   @Minduration 	=1;
SET  @CallType  =  'LC';
SET @fromState	='';
SET @fromCity	 ='';
SET @toState	='';
SET @toCity		='';
SET @libCode	='XY';
SET @ratePlanID	='';
SET @Surcharge	=0;
SET @Increment	=1;
SET  @Balance  = 0 ;
SET  @duration =0;
SET @countryCode ='1';
SET @Minduration=1;
SET @i = 0 ;
SET @CallLimit =0;
SET @TimeLimited =-1;
SET @acceptOpt =1;
SET @blockTime =0;
SET @FreeCalls  =0;
SET @isPrepaid =0;
--SET @ReBook=0;
SET @FreeCallRemain =0;
SET @Minduration=1;
If( @billtype in( '08','17','','0',' ','  '))  SET  @billType ='01';


--Get facility Config

select @timeZone =isnull( timezone,0),@phone  = phone, @AgentID =AgentID, @RecordOpt = isnull(RecordOpt,'Y'), @CallLimit= MaxCallTime, @state=[State]  from tblfacility with(nolock) where facilityID =@facilityID;
Set  @localtime = dateadd(hh, @timeZone,getdate() );
SET @facDuration =  @CallLimit;


If(@billtype ='13' or @billtype = '14' or @billtype='15' or @billtype='16' )
 begin
		SET @RecordOPT='N';
		SET @AcessAllow =1;	 
		
	   Select @AcessAllow as AcessAllow ,  @RecordOPT as  RecordOpt,  @Billtype as  Billtype,  @CallLimit as  MaxDuration, @firstMinute as firstMinute   ,@nextMinute as  nextMinute ,@connectFee as connectFee  ,
				@Minduration  as Minduration ,	@CallType as CallType  ,@fromState as fromState	,@fromCity as fromCity,@toState as toState ,@toCity as toCity,@libCode as 	libCode,
				@ratePlanID as ratePlanID ,		@Surcharge	 as  Surcharge ,		@Increment	as  Increment	,@Balance  as Balance , @DNI as DNI,@AcceptOpt as AcceptOpt ;
	 
	  Return 0;
 end

if(@billtype IN ('01','10')) --- get real phone number
 begin
	if (left(@DNI,3) <> '011' )
		SET @AccountNo = @DNI;
	Else ---- for International 
	 begin
		SET @countryCode =   dbo.fn_determine_countryCode(@DNI);
		SET  @TophoneNo  = substring ( @DNI,4 + len (@countryCode) , len(@DNI));
		SET @AccountNo = @TophoneNo;
		
	 end
 end
If (( isnumeric(@DNI) =0)  or ( left(@DNI,3) <> '011'  and left(@DNI,3) <'200')  or  ( left(@DNI,3) <> '011'  and len(@DNI) <> 10   )  ) -- invalid phone number
 Begin
	If (@DNI is null or @DNI ='' )
		EXEC  p_insert_unbilled_calls4   '','',  @ANI ,@DNI,@billtype, 17,@PIN	,@PIN ,@facilityID	,@userName, '', '','', @localtime,'',@RecordID;
	else
		EXEC  p_insert_unbilled_calls4   '','',  @ANI ,@DNI,@billtype, 4,@PIN	,@PIN ,@facilityID	,@userName, '', '','', @localtime,'',@RecordID;
    SET @CallLimit =0;
	Select '-2'  as AcessAllow ,  @RecordOPT as  RecordOpt,  @Billtype as  Billtype,  @CallLimit as  MaxDuration, @firstMinute as firstMinute   ,@nextMinute as  nextMinute ,@connectFee as connectFee  ,
				@Minduration  as Minduration ,	@CallType as CallType  ,@fromState as fromState	,@fromCity as fromCity,@toState as toState ,@toCity as toCity,@libCode as 	libCode,
				@ratePlanID as ratePlanID ,		@Surcharge	 as  Surcharge ,		@Increment	as  Increment	,@Balance  as Balance , @DNI as DNI,@AcceptOpt as AcceptOpt ;
	Return -1;
 end
--- Check for PAN 
Select @InmateID = inmateID,  @PANNotAllow = PANNotAllow ,  @DNIRestrict  =DNIRestrict, @Rebook =ISNULL(Rebook,0), @RebookDate =RebookDate, @custodialOpt=custodialOpt, @FreeCallRemain = isnull(FreeCallRemain,0)   from tblInmate with(nolock)  where facilityID = @facilityID and InmateID =  @PIN;
If (@DNIRestrict =  1) 
 Begin
	If ( select count(*) from tblphones with(nolock) where  InmateID  = @InmateID  and facilityID = @facilityId and phoneno = @DNI ) = 0
	Begin
			--EXEC  p_insert_unbilled_calls2   '','',  @ANI ,@DNI,@billtype, 9,@PIN	,0 ,@facilityID	,@userName, '', '','', @localtime;
			SET @CallLimit =0;
			EXEC  p_insert_unbilled_calls4   '','',  @ANI ,@DNI,@billtype, 20,@PIN,@InmateID  ,@facilityID	,@userName, '', '','', @localtime,'',@RecordID;
			Select '-1'  as AcessAllow ,  @RecordOPT as  RecordOpt,  @Billtype as  Billtype,  @CallLimit as  MaxDuration, @firstMinute as firstMinute   ,@nextMinute as  nextMinute ,@connectFee as connectFee  ,
				@Minduration  as Minduration ,	@CallType as CallType  ,@fromState as fromState	,@fromCity as fromCity,@toState as toState ,@toCity as toCity,@libCode as 	libCode,
				@ratePlanID as ratePlanID ,		@Surcharge	 as  Surcharge ,		@Increment	as  Increment	,@Balance  as Balance , @DNI as DNI,@AcceptOpt as AcceptOpt ;
			Return -1;
	End
	
 End
-- Check Restricted PAN
If ( @PANNotAllow  =  1)
 Begin
	If ( select count(*) from tblBlockedPhonesByPIN with(nolock) where   phoneno = @DNI and facilityID = @facilityId  and  InmateID = @InmateID ) > 0
	Begin
			--EXEC  p_insert_unbilled_calls2   '','',  @ANI ,@DNI,@billtype, 9,@PIN	,0 ,@facilityID	,@userName, '', '','', @localtime;
			SET @CallLimit =0;
			EXEC  p_insert_unbilled_calls4   '','',  @ANI ,@DNI,@billtype, 9,@PIN	,@InmateID  ,@facilityID	,@userName, '', '','', @localtime,'',@RecordID;
			Select '-1'  as AcessAllow ,  @RecordOPT as  RecordOpt,  @Billtype as  Billtype,  @CallLimit as  MaxDuration, @firstMinute as firstMinute   ,@nextMinute as  nextMinute ,@connectFee as connectFee  ,
				@Minduration  as Minduration ,	@CallType as CallType  ,@fromState as fromState	,@fromCity as fromCity,@toState as toState ,@toCity as toCity,@libCode as 	libCode,
				@ratePlanID as ratePlanID ,		@Surcharge	 as  Surcharge ,		@Increment	as  Increment	,@Balance  as Balance , @DNI as DNI,@AcceptOpt as AcceptOpt ;
			Return -1;
	End
	
 End


 ---- Check for Auto Accept
If (select count(*) from tblAutoAcceptPhones with(nolock) where phoneno =@DNI) > 0
	SET @AcceptOpt =0;

-- Check Non-recorded List
If(@facilityID =801)  -- Exception for 801
  begin
		If ( select count(*) from tblNonRecordPhones with(nolock) where phoneno = @DNI and facilityID =801) > 0
			SET @RecordOPT ='N';
 end	
Else 
 begin
    IF  (( select count(*) from tblNonRecordPhones with(nolock) where phoneno = @DNI) > 0 or @facilityID = 76 ) 
		SET @RecordOPT ='N';
		
 end
-- Check for Blocked phone	
select @ReasonID= ReasonID,@blockTime = isnull(TimeLimited,0)   from tblblockedPhones with(nolock) where phoneNo =  @DNI ;

If (@ReasonID = 1 or @ReasonID = 4)
 Begin
	
	EXEC  p_insert_unbilled_calls4   '','',  @ANI ,@DNI,@billtype, 5,@PIN	,@InmateID  ,@facilityID	,@userName, '', '','', @localtime,'',@RecordID;
	SET @CallLimit =0;
	Select '-1'  as AcessAllow ,  @RecordOPT as  RecordOpt,  @Billtype as  Billtype,  @CallLimit as  MaxDuration, @firstMinute as firstMinute   ,@nextMinute as  nextMinute ,@connectFee as connectFee  ,
				@Minduration  as Minduration ,	@CallType as CallType  ,@fromState as fromState	,@fromCity as fromCity,@toState as toState ,@toCity as toCity,@libCode as 	libCode,
				@ratePlanID as ratePlanID ,		@Surcharge	 as  Surcharge ,		@Increment	as  Increment	,@Balance  as Balance , @DNI as DNI ,@AcceptOpt as AcceptOpt ;
	Return  @ReasonID;
  End
---- Check for Free assign for inmate

if(@Billtype ='19')
 begin
	If( select count(*) from tblinmate with(nolock) where FacilityId = @facilityID and InmateID = @InmateID and FreeCallRemain >0) >0
	 begin
		SET @AcessAllow =1;
	 end
	Else
	 begin
		SET @AcessAllow =-2;
	 end 
	 Select   @AcessAllow  as AcessAllow ,  @RecordOPT as RecordOpt,  @Billtype as  Billtype,  @CallLimit  as  MaxDuration, @firstMinute as firstMinute   ,@nextMinute as  nextMinute ,@connectFee as connectFee  ,
			@Minduration  as Minduration ,	@CallType as CallType  ,@fromState as fromState	,@fromCity as fromCity,@toState as toState ,@toCity as toCity,@libCode as 	libCode,
			@ratePlanID as ratePlanID ,		@Surcharge	 as  Surcharge ,		@Increment	as  Increment	,  @Balance  as Balance , @DNI as DNI ,@AcceptOpt as AcceptOpt ;
	return 0;

 end

--- Check for Free Phones	
select  @TimeLimited =  isnull(MaxCalltime,@CallLimit),@acceptOpt= isnull(acceptOpt,1) from tblFreePhones   with(nolock)   where phoneNo =  @DNI and facilityID= @facilityID; 
   
    
if(@TimeLimited >-1)
 Begin
	If(@acceptOpt =1)  
		SET @billType ='08' ;  --select @acceptOpt;
	else
		SET @billType ='17';
		
	If (@TimeLimited >0)
		begin
			SET @CallLimit = @TimeLimited;
		end
		 
	Select '1'  as AcessAllow ,  @RecordOPT as RecordOpt,  @Billtype as  Billtype,  @CallLimit  as  MaxDuration, @firstMinute as firstMinute   ,@nextMinute as  nextMinute ,@connectFee as connectFee  ,
		@Minduration  as Minduration ,	@CallType as CallType  ,@fromState as fromState	,@fromCity as fromCity,@toState as toState ,@toCity as toCity,@libCode as 	libCode,
		@ratePlanID as ratePlanID ,		@Surcharge	 as  Surcharge ,		@Increment	as  Increment	,  @Balance  as Balance , @DNI as DNI ,@AcceptOpt as AcceptOpt ;
	return 0;

 End
	
-- Check for Free booking // Modify to get limit time from free ANI 
		
		
select @Freetype =Freetype, @calls = isnull(calls,0), @FreeLimitTime = isnull(LimitTime ,@CallLimit) from tblFreeANIs with(nolock)  where facilityID=@facilityID and ANI =  @ANI	;

--- get call limit at station	    
select @CallLimit = isnull(MaxCallTime,@CallLimit)  from tblANIs with(nolock)  where facilityID=@facilityID and ANIno =  @ANI;

if(@Freetype > 0)
 begin
--select @FreeLimitTime,@calls;
	if( @calls > 0)
	 begin
		select @FreeCalls = count(*)  from tblcallsbilled with(nolock) where  facilityID = @facilityID and  InmateID = @inmateID and billType ='08';
	 end
 end

		
			
If ( @Freetype = 1)  -- free local
 Begin			
	if ( dbo.fn_determine_local_call (left(@phone,6),  left(@DNI,6) ) )  = 1 
		begin
		if (@calls =0)
			begin
				SET @billType ='08';
			end
		else 
			begin
				
			if(@custodialOpt =1 and @state in('CA','ca')) 
				SET  @calls = @calls +2;
			if(@ReBook=0)
				Begin
				if(@FreeCalls  < @calls  )							
			   		SET @billType ='08';							 
				End
			Else if(@ReBook=1 and (@facilityID=585  or @facilityID=577)) -- Customize for Jackson
				Begin
					if (  ( select count(*)  from tblcallsbilled with(nolock) where  facilityID = @facilityID and (InmateID = @inmateID )  and RecordDate >@rebookdate ) < @calls  )							
			   			SET @billType ='08';							
				End
			end
	end
 End 
Else If ( @Freetype = 2)  -- Free Intralata
 Begin
						
	if ( dbo.fn_determine_intralata_call (left(@phone,6),  left(@DNI,6) ) )  = 1 
		begin
		if (@calls =0)
			begin
				SET @billType ='08';
			end
		else 
			begin				
			if ( @FreeCalls < @calls  )
				begin
					SET @billType ='08';
				end
			end
	end
 End 
Else If ( @Freetype = 3) -- free Intersate
 Begin					

	if ( dbo.fn_determine_intraState_call (left(@phone,6),  left(@DNI,6) ) )  = 1 
		begin
		if (@calls =0)
			begin
				SET @billType ='08';
			end
		else 
			begin
				
			if ( @FreeCalls < @calls  )
					begin
						SET @billType ='08';
					end
			end
	end
 End 
Else If ( @Freetype = 4) --- Free Anywhere
 begin
	if (@calls =0 )    
		SET @billType ='08';
			     
	else 
		begin
				
		if ( @FreeCalls < @calls  )
			begin
				SET @billType ='08';
			end
		end
			
 end

If (@Billtype='08')
	SET    @CallLimit = @FreeLimitTime ;


---New Edit 3/28/2017  -- Dont use this 

--If(@FreeCallRemain >0)
-- begin
--	SET @Billtype ='08';	
--	Select @CallLimit = isnull(IniFreeCallDuration,@facDuration)  from tblFacilityPINconfig with(nolock) where facilityID = @facilityID;
-- end 


--- new edit block toll free number with collect call
If(@billtype in ('01','03','05','07'))
 begin
	SET @NPA = left(@DNI,3);
	if(@NPA in ('800','888','877','866','855','844','833','900'))
	 begin
		EXEC  p_insert_unbilled_calls4   '','',  @ANI ,@DNI,@billtype, 5,@PIN	,@InmateID  ,@facilityID	,@userName, '', '','', @localtime,'',@RecordID;
		SET @CallLimit =0;
		Select '-1'  as AcessAllow ,  @RecordOPT as  RecordOpt,  @Billtype as  Billtype,  @CallLimit as  MaxDuration, @firstMinute as firstMinute   ,@nextMinute as  nextMinute ,@connectFee as connectFee  ,
				@Minduration  as Minduration ,	@CallType as CallType  ,@fromState as fromState	,@fromCity as fromCity,@toState as toState ,@toCity as toCity,@libCode as 	libCode,
				@ratePlanID as ratePlanID ,		@Surcharge	 as  Surcharge ,		@Increment	as  Increment	,@Balance  as Balance , @DNI as DNI ,@AcceptOpt as AcceptOpt ;
		return 0;
	 end

 end 


-------------------------------------------------------------
EXEC  @i = p_calculate_Rate_Surcharge4 
			@ANI  ,
			@DNI	,
			@FacilityID	,
			@billType,
			@PIN	,
			@userName	,
			@firstMinute   OUTPUT,
			@nextMinute   OUTPUT,
			@connectFee   OUTPUT,
			@Minduration 	 OUTPUT,
			@CallType     OUTPUT,
			@fromState	 OUTPUT,
			@fromCity	 OUTPUT,
			@toState	OUTPUT,
			@toCity		 OUTPUT,
			@libCode	OUTPUT,
			@ratePlanID	OUTPUT,
			@Surcharge	 OUTPUT, 
			@Increment	OUTPUT;


If(@billtype ='07' )  
 begin
	if(@AgentID =7)
	 begin		
		select @balance = PhoneBalance, @CallLimit=AllowedMinutes from tblMaineLogs with(nolock) where PIN=@PIN and  ReferenceNo =@RecordID and APItype=1 ;
		if(@CallLimit > @facDuration)
			SET @CallLimit = @facDuration;
        
		SET @duration = floor( @balance/@firstMinute);
		If(@duration < @CallLimit and  @duration >0 )
			SET @CallLimit = @duration;
        SET @AcessAllow=1;
		Select @AcessAllow  as AcessAllow ,  @RecordOPT as  RecordOpt,  @Billtype as  Billtype, @CallLimit   as  MaxDuration, @firstMinute as firstMinute   ,@nextMinute as  nextMinute ,@connectFee as connectFee  ,
			@Minduration  as Minduration ,	@CallType as CallType  ,@fromState as fromState	,@fromCity as fromCity,@toState as toState ,@toCity as toCity,@libCode as 	libCode,
			@ratePlanID as ratePlanID ,		@Surcharge	 as  Surcharge ,		@Increment	as  Increment	,@Balance  as Balance, @DNI as DNI, @AcceptOpt as AcceptOpt ;

		return 0;
	 end			
	EXEC   @i = p_verify_Debit_account2  @accountNo, @ANI, @InmateID,@facilityID, @userName,'',@billtype,@DNI ,@balance    OUTPUT;
	if( @i =  0) -- Valid Debit
	 begin
		   
			SET   @Minbilled =  @firstMinute * @Minduration + @connectFee + @Surcharge;
			If(@balance =-1)
			 Begin
				EXEC  p_insert_unbilled_calls4   '','',  @ANI ,@DNI,@billtype, 75,@PIN	,@InmateID ,@facilityID	,@userName, '', '',@AccountNo, @localtime,@CallType,@RecordID ;
			    SET @AcessAllow= -3;
				SET @billtype ='03';
				SET @CallLimit =0;
			 End	
			Else If(@balance <@Minbilled)
			 Begin
				EXEC  p_insert_unbilled_calls4   '','',  @ANI ,@DNI,@billtype, 76,@PIN	,@InmateID ,@facilityID	,@userName, '', @Balance,@AccountNo, @localtime,@CallType,@RecordID ;
				SET @AcessAllow= -3;

			 End	
			Else
			 begin 			
				SET @isPrepaid =1;
				SET  @AcessAllow= 1;
			 end
	 end
	else -- Invalid Debit 
	 begin
		SET   @AcessAllow= -3;
		
		if(@Balance =-3)
			EXEC  p_insert_unbilled_calls4   '','',  @ANI ,@DNI,@billtype, 77,@PIN	,@InmateID ,@facilityID	,@userName, '', '',@AccountNo, @localtime,@CallType,@RecordID ;
		else
			EXEC  p_insert_unbilled_calls4   '','',  @ANI ,@DNI,@billtype, 75,@PIN	,@InmateID ,@facilityID	,@userName, '', '',@AccountNo, @localtime,@CallType,@RecordID ;

		SET @CallLimit =0;
		Select @AcessAllow  as AcessAllow ,  @RecordOPT as  RecordOpt,  @Billtype as  Billtype, @CallLimit   as  MaxDuration, @firstMinute as firstMinute   ,@nextMinute as  nextMinute ,@connectFee as connectFee  ,
			@Minduration  as Minduration ,	@CallType as CallType  ,@fromState as fromState	,@fromCity as fromCity,@toState as toState ,@toCity as toCity,@libCode as 	libCode,
			@ratePlanID as ratePlanID ,		@Surcharge	 as  Surcharge ,		@Increment	as  Increment	,@Balance  as Balance, @DNI as DNI, @AcceptOpt as AcceptOpt ;
		Return 1;
	 end

	--Should Stop Conver to prepaid;

	if(@AcessAllow <=0 or @balance <@Minbilled)  -- Convert to prepaid
	  begin
			Declare @Prepaidbalance numeric(6,2);
			SET @Prepaidbalance  = 0;
			Select @Prepaidbalance  = balance,  @isPrepaid =status   From tblPrepaid with(nolock) where  phoneNo = @DNI and status =1;
			if (@Prepaidbalance >=@Minbilled)
			 begin
					SET @billtype ='10';	
					SET @balance  =@Prepaidbalance;
			 end

	  end
	  
 end
Else If( @billType ='08' or @billType ='17' or @billType ='18')
 Begin
	SET  @AcessAllow= 1;

 end
Else 
 begin
	IF( @countryCode  in ('1','0',''))
			Select @balance = balance,  @isPrepaid =status   From tblPrepaid with(nolock) where  phoneNo = @AccountNo and status =1  --group by   balance ; 
	ELSE 
			Select @balance = balance,  @isPrepaid =status  From tblPrepaid with(nolock) where  phoneNo = @AccountNo  and status =1  AND CountryCode = @CountryCode -- group by   balance;	
	if (@balance >0)
			SET @billtype ='10';	
	Else 
	 begin
	    IF (@isPrepaid=1)
			SET @billtype ='03';
	 end	
	--SELECT 	@countryCode,	@balance, @AccountNo ;  
	
 end

EXEC  @i = p_calculate_Rate_Surcharge4 
			@ANI  ,
			@DNI	,
			@FacilityID	,
			@billType,
			@PIN	,
			@userName	,
			@firstMinute   OUTPUT,
			@nextMinute   OUTPUT,
			@connectFee   OUTPUT,
			@Minduration 	 OUTPUT,
			@CallType     OUTPUT,
			@fromState	 OUTPUT,
			@fromCity	 OUTPUT,
			@toState	OUTPUT,
			@toCity		 OUTPUT,
			@libCode	OUTPUT,
			@ratePlanID	OUTPUT,
			@Surcharge	 OUTPUT, 
			@Increment	OUTPUT;
IF(@Billtype in ('07','10'))
 Begin
	SET   @Minbilled =  @firstMinute * @Minduration + @connectFee + @Surcharge;
	If(@balance >= @Minbilled ) --- minimum balance required
	 begin
		if(@nextMinute > 0) 
			SET @duration = @Minduration + (@balance - @Minbilled ) /@nextMinute;
		else 
			SET @duration = @CallLimit ;
	 end
	else
	 begin
			SET @AcessAllow =0;
			SET  @duration = 0;
	 end
 end
if( @duration < @CallLimit and @Duration >0 )  
	SET @CallLimit = @duration;
		
EXEC @AcessAllow= p_determine_billtype_method @facilityID,@billtype , @DNI ; 

If ( @CallLimit > 0 )
 begin
	if(@billtype in ('10', '07','08','17','18') )
			SET @AcessAllow =1;
	else
	 begin
		if(select count(*) from tblOfficeANI with(nolock) where AuthNo = @DNI ) >0
			SET @AcessAllow =1;
	  end
  end
else
 Begin
	if(@isPrepaid >0)
		SET  @billtype ='05';
 end


-- select @isPrepaid,@billtype ;
--- --- Call Rate

if((@Balance <@Minbilled or  @Balance <=0) and @Billtype in ('07','10'))
	SET @AcessAllow =2;

 	
Select @AcessAllow  as AcessAllow ,  @RecordOPT as  RecordOpt,  @Billtype as  Billtype, @CallLimit   as  MaxDuration, @firstMinute as firstMinute   ,@nextMinute as  nextMinute ,@connectFee as connectFee  ,
	@Minduration  as Minduration ,	@CallType as CallType  ,@fromState as fromState	,@fromCity as fromCity,@toState as toState ,@toCity as toCity,@libCode as 	libCode,
	@ratePlanID as ratePlanID ,		@Surcharge	 as  Surcharge ,		@Increment	as  Increment	,@Balance  as Balance, @DNI as DNI, @AcceptOpt as AcceptOpt ;
Return 1;
