CREATE PROCEDURE [dbo].[p_get_billtype_webservice]
@ANI	char(10),
@DNI	varchar(16),
@PIN		varchar(12),
@facilityID	int,
@userName       varchar(23),
@Billtype	char(2) ,
@AccountNo	varchar(15)


AS
SET nocount on
Declare @ReasonID	smallint , @FreeType tinyint , @phone char(10) , @dialPrefix char(3) , @DialNo varchar(13) ,@TophoneNo  varchar(10), @countryCode varchar(3), @calls tinyint, @isPrepaid tinyint , @i int
Declare   @timeZone tinyint , @localtime datetime, @bookingTime datetime   ,@RecordOPT	char  , @AcessAllow  varchar(10), @firstMinute   numeric(4,2), @Balance numeric(5,2), @Duration int, @Minbilled numeric(5,2),
	  @nextMinute   numeric(4,2) ,	@connectFee numeric(4,2)  ,	@Minduration 	smallint ,	@CallType   char(2) ,	@fromState	varchar(2) ,	@fromCity	varchar(10) , @defaultDuration smallint,
	   @toState	varchar(2) ,	@toCity		varchar(10) ,	@libCode	varchar(2) ,	@ratePlanID	varchar(7)  ,	@Surcharge	Numeric(4,2),@Increment	tinyint	,@CallLimit smallint
SET  @RecordOPT	='Y'
SET   @ReasonID =0
SET @Freetype  =0 
SET @calls = 0
SET @firstMinute  =0
SEt 	@nextMinute  =0
SET	@connectFee =0
Set   @Minduration 	=1
SET  @CallType  =  'LC'
SET @fromState	=''
SET @fromCity	 =''
SET @toState	=''
SET @toCity		=''
SET @libCode	='XY'
SET @ratePlanID	=''
SET @Surcharge	=0
SET @Increment	=1
SET  @Balance  =0
SET  @duration =0
SET @countryCode ='1'
SET @i = 0 
select @timeZone =isnull( timezone,0), @CallLimit =isnull( MaxCallTime,15)  from tblfacility with(nolock) where facilityID =@facilityID
Set  @localtime = dateadd(hh, @timeZone,getdate() )
SET @defaultDuration =  @CallLimit
if(@billtype ='01')
 begin
	if (left(@DNI,3) <> '011' )
		SET @AccountNo = @DNI
	Else
	 begin
		SET @countryCode =   dbo.fn_determine_countryCode(@DNI)
		SET  @TophoneNo  = substring ( @DNI,4 + len (@countryCode) , len(@DNI))
		SET @AccountNo = @TophoneNo
	 end
 end
If (( isnumeric(@DNI) =0)  or ( left(@DNI,3) <> '011'  and left(@DNI,3) <'200')  or  ( left(@DNI,3) <> '011'  and len(@DNI) <> 10   )  )
 Begin
	EXEC  p_insert_unbilled_calls2   '','',  @ANI ,@DNI,@billtype, 4,@PIN	,0 ,@facilityID	,@userName, '', '','',@localtime
	Select '-2'  as AcessAllow ,  @RecordOPT as  RecordOpt,  @Billtype as  Billtype,  @CallLimit as  MaxDuration, @firstMinute as firstMinute   ,@nextMinute as  nextMinute ,@connectFee as connectFee  ,
				@Minduration  as Minduration ,	@CallType as CallType  ,@fromState as fromState	,@fromCity as fromCity,@toState as toState ,@toCity as toCity,@libCode as 	libCode,
				@ratePlanID as ratePlanID ,		@Surcharge	 as  Surcharge ,		@Increment	as  Increment	,@Balance  as Balance
	Return -1
 end

If ( select count(*) from tblInmate where PIN = @PIN and facilityID = @facilityID and   DNIRestrict =1) > 0
 Begin
	If ( select count(*) from tblphones with(nolock) where  PIN = @PIN and facilityID = @facilityId and phoneno = @DNI ) = 0
	Begin
			EXEC  p_insert_unbilled_calls2   '','',  @ANI ,@DNI,@billtype, 9,@PIN	,0 ,@facilityID	,@userName, '', '','', @localtime
			Select '-1'  as AcessAllow ,  @RecordOPT as  RecordOpt,  @Billtype as  Billtype,  @CallLimit as  MaxDuration, @firstMinute as firstMinute   ,@nextMinute as  nextMinute ,@connectFee as connectFee  ,
				@Minduration  as Minduration ,	@CallType as CallType  ,@fromState as fromState	,@fromCity as fromCity,@toState as toState ,@toCity as toCity,@libCode as 	libCode,
				@ratePlanID as ratePlanID ,		@Surcharge	 as  Surcharge ,		@Increment	as  Increment	,@Balance  as Balance
			Return -1
	End
	
 End
If( @billtype = '08')  SET  @billType ='01'

If  (( select count(*) from tblNonRecordPhones with(nolock) where phoneno = @DNI) > 0 or @facilityID = 76 ) 
		SET @RecordOPT ='N'
select @ReasonID= ReasonID, @CallLimit = isnull(TimeLimited ,0)  from tblblockedPhones with(nolock) where phoneNo =  @DNI 

If (@ReasonID > 0)
 Begin
	EXEC  p_insert_unbilled_calls2   '','',  @ANI ,@DNI,@billtype, 5,@PIN	,0 ,@facilityID	,@userName, '', '','',@localtime
	Select '-1'  as AcessAllow ,  @RecordOPT as  RecordOpt,  @Billtype as  Billtype,  @CallLimit as  MaxDuration, @firstMinute as firstMinute   ,@nextMinute as  nextMinute ,@connectFee as connectFee  ,
				@Minduration  as Minduration ,	@CallType as CallType  ,@fromState as fromState	,@fromCity as fromCity,@toState as toState ,@toCity as toCity,@libCode as 	libCode,
				@ratePlanID as ratePlanID ,		@Surcharge	 as  Surcharge ,		@Increment	as  Increment	,@Balance  as Balance
	Return  @ReasonID
  End
else
 Begin
	SET @duration = @CallLimit
	
	If( select count(*) from tblFreePhones with(nolock) where phoneNo =  @DNI  and facilityID = @facilityID  ) > 0
	  Begin
		SET @billType ='08'
	  End
	Else
	 begin
		select @Freetype =Freetype, @calls = isnull(calls,0) from tblFreeANIs  where ANI =  @ANI	
		If ( @Freetype = 1)
		 Begin
			
			select @phone  = phone from tblFacility where facilityID  = @facilityID
			
			if ( dbo.fn_determine_local_call (left(@phone,6),  left(@DNI,6) ) )  = 1 
			 begin
			    if @calls =0
			     begin
				SET @billType ='08'
			     end
			    else 
			      begin
				
			      	if (  ( select count(*)  from tblcallsbilled with(nolock) where  facilityID = @facilityID and PIN= @PIN and  billtype ='08') < @calls  )
				 begin
				   	SET @billType ='08'
				 end
			      end
			end
		 End 
		Else If ( @Freetype = 2)
		 Begin
			
			select @phone  = phone from tblFacility where facilityID  = @facilityID
			
			if ( dbo.fn_determine_intralata_call (left(@phone,6),  left(@DNI,6) ) )  = 1 
			 begin
			    if @calls =0
			     begin
				SET @billType ='08'
			     end
			    else 
			      begin
				
			      	if (  ( select count(*)  from tblcallsbilled with(nolock) where  facilityID = @facilityID and PIN= @PIN and  billtype ='08') < @calls  )
				 begin
				   	SET @billType ='08'
				 end
			      end
			end
		 End 
		Else If ( @Freetype = 3)
		 Begin
			
			select @phone  = phone from tblFacility where facilityID  = @facilityID
			
			if ( dbo.fn_determine_intraState_call (left(@phone,6),  left(@DNI,6) ) )  = 1 
			 begin
			    if @calls =0
			     begin
				SET @billType ='08'
			     end
			    else 
			      begin
				
			      	if (  ( select count(*)  from tblcallsbilled with(nolock) where  facilityID = @facilityID and PIN= @PIN and  billtype ='08') < @calls  )
				 begin
				   	SET @billType ='08'
				 end
			      end
			end
		 End 
		Else If ( @Freetype = 4)
		 begin
			 if @calls =0     
				SET @billType ='08'
			     
			  else 
			      begin
				
			      	if (  ( select count(*)  from tblcallsbilled with(nolock) where  facilityID = @facilityID and PIN= @PIN and  billtype ='08') < @calls  )
				 begin
				   	SET @billType ='08'
				 end
			      end
			
		 end
	 End
	If( @billType ='08')
	 Begin
		Select '1'  as AcessAllow ,  @RecordOPT as RecordOpt,  @Billtype as  Billtype,  @CallLimit as  MaxDuration, @firstMinute as firstMinute   ,@nextMinute as  nextMinute ,@connectFee as connectFee  ,
			@Minduration  as Minduration ,	@CallType as CallType  ,@fromState as fromState	,@fromCity as fromCity,@toState as toState ,@toCity as toCity,@libCode as 	libCode,
			@ratePlanID as ratePlanID ,		@Surcharge	 as  Surcharge ,		@Increment	as  Increment	,  @Balance  as Balance
		return 0
	 end
	Else
	 begin
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
			@Increment	OUTPUT
		if( @i =-1)
		  begin
			EXEC  p_insert_unbilled_calls2   '','',  @ANI ,@DNI,@billtype, 4,@PIN	,0 ,@facilityID	,@userName, '', '','',@localtime
			Select '-2'  as AcessAllow ,  @RecordOPT as  RecordOpt,  @Billtype as  Billtype,  @CallLimit as  MaxDuration, @firstMinute as firstMinute   ,@nextMinute as  nextMinute ,@connectFee as connectFee  ,
						@Minduration  as Minduration ,	@CallType as CallType  ,@fromState as fromState	,@fromCity as fromCity,@toState as toState ,@toCity as toCity,@libCode as 	libCode,
						@ratePlanID as ratePlanID ,		@Surcharge	 as  Surcharge ,		@Increment	as  Increment	,@Balance  as Balance
			Return -1
		  end
		
		If(@billtype ='07' )  
		 begin
			
			EXEC   @i = p_verify_Debit_account2  @accountNo, @ANI, @PIN,@facilityID, @userName,'',@billtype,@DNI ,@balance    OUTPUT
			if( @i =  0)
			 begin
				SET @isPrepaid =1
			 end
			 else 
			  begin
				Select '-3'  as AcessAllow ,  @RecordOPT as  RecordOpt,  @Billtype as  Billtype,  @CallLimit as  MaxDuration, @firstMinute as firstMinute   ,@nextMinute as  nextMinute ,@connectFee as connectFee  ,
						@Minduration  as Minduration ,	@CallType as CallType  ,@fromState as fromState	,@fromCity as fromCity,@toState as toState ,@toCity as toCity,@libCode as 	libCode,
						@ratePlanID as ratePlanID ,		@Surcharge	 as  Surcharge ,		@Increment	as  Increment	,@Balance  as Balance
				Return -1
			  end
		 end
		Else 
		 begin
			IF( @countryCode ='1')
			 	 Select @balance = balance,  @isPrepaid =count(*)   From tblPrepaid with(nolock) where  phoneNo = @AccountNo and status =1  group by   balance  --and facilityID = @facilityID
			ELSE    
				Select @balance = balance,  @isPrepaid =count(*)   From tblPrepaid with(nolock) where  phoneNo = @AccountNo  and status =1  AND CountryCode = @CountryCode group by   balance
			  if (@balance >0)  
			    begin
				SET  @billtype ='10'
				
			    end
		 end
		SET   @Minbilled =  @firstMinute * @Minduration + @connectFee + @Surcharge
		If(@balance >= @Minbilled )
			  begin
				if(@nextMinute > 0) 
					SET @duration = @Minduration + (@balance - @Minbilled ) /@nextMinute
				else SET @duration = @CallLimit
			  end
		else
		  begin
			if( @isPrepaid >0)  SET    @CallLimit =0
		  end
		if( @duration < @CallLimit )  SET @CallLimit = @duration
		
		If ( @CallLimit > 0 )
		 begin
			if(@billtype ='10'  or @billtype ='07'  )
			 begin
				Select '1'  as AcessAllow ,  @RecordOPT as  RecordOpt,  @Billtype as  Billtype,  @CallLimit as  MaxDuration, @firstMinute as firstMinute   ,@nextMinute as  nextMinute ,@connectFee as connectFee  ,
					@Minduration  as Minduration ,	@CallType as CallType  ,@fromState as fromState	,@fromCity as fromCity,@toState as toState ,@toCity as toCity,@libCode as 	libCode,
					@ratePlanID as ratePlanID ,		@Surcharge	 as  Surcharge ,		@Increment	as  Increment	,@Balance  as Balance
					Return 0
			end
			else
			 begin
				if (left(@DNI,3) <> '011' )
				 begin
					if(select count(*) from tblOfficeANI where AuthNo = @DNI ) = 0
					  begin
						Select '0'  as AcessAllow ,  @RecordOPT as  RecordOpt,  @Billtype as  Billtype,  @CallLimit as  MaxDuration, @firstMinute as firstMinute   ,@nextMinute as  nextMinute ,@connectFee as connectFee  ,
							@Minduration  as Minduration ,	@CallType as CallType  ,@fromState as fromState	,@fromCity as fromCity,@toState as toState ,@toCity as toCity,@libCode as 	libCode,
							@ratePlanID as ratePlanID ,		@Surcharge	 as  Surcharge ,		@Increment	as  Increment	,@Balance  as Balance
						Return 1
					  end
					else
					  begin
						Select '1'  as AcessAllow ,  @RecordOPT as  RecordOpt,  @Billtype as  Billtype,  @CallLimit as  MaxDuration, @firstMinute as firstMinute   ,@nextMinute as  nextMinute ,@connectFee as connectFee  ,
							@Minduration  as Minduration ,	@CallType as CallType  ,@fromState as fromState	,@fromCity as fromCity,@toState as toState ,@toCity as toCity,@libCode as 	libCode,
							@ratePlanID as ratePlanID ,		@Surcharge	 as  Surcharge ,		@Increment	as  Increment	,@Balance  as Balance
						Return 1
					  end
				 end
					
				else
				 begin
					Select '-1'  as AcessAllow ,  @RecordOPT as  RecordOpt,  @Billtype as  Billtype,  @CallLimit as  MaxDuration, @firstMinute as firstMinute   ,@nextMinute as  nextMinute ,@connectFee as connectFee  ,
						@Minduration  as Minduration ,	@CallType as CallType  ,@fromState as fromState	,@fromCity as fromCity,@toState as toState ,@toCity as toCity,@libCode as 	libCode,
						@ratePlanID as ratePlanID ,		@Surcharge	 as  Surcharge ,		@Increment	as  Increment	,@Balance  as Balance
					return -1
				 end
			end
		 end
		else
		 begin
			if(@isPrepaid >0) SET  @billtype ='03'
			Select '0'  as AcessAllow ,  @RecordOPT as  RecordOpt,  @Billtype as  Billtype,  @defaultDuration  as  MaxDuration, @firstMinute as firstMinute   ,@nextMinute as  nextMinute ,@connectFee as connectFee  ,
				@Minduration  as Minduration ,	@CallType as CallType  ,@fromState as fromState	,@fromCity as fromCity,@toState as toState ,@toCity as toCity,@libCode as 	libCode,
				@ratePlanID as ratePlanID ,		@Surcharge	 as  Surcharge ,		@Increment	as  Increment	,@Balance  as Balance
			Return 1
		 end
	end
 End
