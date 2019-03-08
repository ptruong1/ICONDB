CREATE PROCEDURE [dbo].[p_determine_ANI_DNI_test]
@ANI	char(10),
@DNI	varchar(16),
@PIN		varchar(12),
@facilityID	int,
@userName       varchar(23),
@Billtype	char(2)  OUTPUT,
@RecordOPT	char  OUTPUT,
@TimeLimited  smallint  OUTPUT

AS
Declare @ReasonID	smallint, @CallLimit smallint , @FreeType tinyint , @phone char(10) , @dialPrefix char(3) , @DialNo varchar(13) ,@TophoneNo  varchar(10), @countryCode varchar(3), @calls tinyint
Declare   @timeZone tinyint , @localtime datetime, @bookingTime datetime
SET  @RecordOPT	='Y'
SET   @ReasonID =0
SET  @CallLimit  =0
SET @Freetype  =0 
SET @calls = 0

select @timeZone =isnull( timezone,0) from tblfacility with(nolock) where facilityID =@facilityID
Set  @localtime = dateadd(hh, @timeZone,getdate() )

If ( isnumeric(@DNI) =0) 
 Begin
	EXEC  p_insert_unbilled_calls2   '','',  @ANI ,@DNI,@billtype, 4,@PIN	,0 ,@facilityID	,@userName, '', '','',@localtime
	Return -1;
 end

If ( select count(*) from tblInmate where PIN = @PIN and facilityID = @facilityID and   DNIRestrict =1) > 0
 Begin
	If ( select count(*) from tblphones with(nolock) where  PIN = @PIN and facilityID = @facilityId and phoneno = @DNI ) = 0
	Begin
			EXEC  p_insert_unbilled_calls2   '','',  @ANI ,@DNI,@billtype, 9,@PIN	,0 ,@facilityID	,@userName, '', '','', @localtime
			Return -1;
	End
	
 End
If( @billtype = '08')  SET  @billType ='01'

If  (( select count(*) from tblNonRecordPhones with(nolock) where phoneno = @DNI  and facilityID = @facilityID) > 0 or @facilityID = 76 or @facilityID=278 ) 
		SET @RecordOPT ='N'
If (@Billtype <>'07')
 Begin
	if(@PIN ='00019') return 0
	
	If( select count(*) from tblFreePhones with(nolock) where phoneNo =  @DNI and facilityID= @facilityID ) > 0
	  Begin
		select  @CallLimit =  isnull(MaxCalltime,0) from tblFreePhones   with(nolock)   where phoneNo =  @DNI and facilityID= @facilityID
		if(@CallLimit >0) SET @TimeLimited  = @CallLimit 
		SET @billType ='08'
		Return 0
	  End
	select @Freetype =Freetype, @calls = isnull(calls,0) from tblFreeANIs  where ANI =  @ANI	
	If ( @Freetype = 1)
	 Begin
		
		select @phone  = phone from tblFacility where facilityID  = @facilityID
		--select dbo.fn_determine_local_call (left(@phone,6),  left(@DNI,6) )
		if ( dbo.fn_determine_local_call (left(@phone,6),  left(@DNI,6) ) )  = 1 
		 begin
		    if @calls =0
		     begin
			SET @billType ='08'
		     end
		    else 
		      begin
			--select @bookingTime = inputDate from tblInmate with(nolock) where facilityID = facilityID and PIN = @PIN
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
			--select @bookingTime = inputDate from tblInmate with(nolock) where facilityID = facilityID and PIN = @PIN
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
			--select @bookingTime = inputDate from tblInmate with(nolock) where facilityID = facilityID and PIN = @PIN
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
else
 Begin
	if (@facilityID = 27  and  left(@DNI ,3) <> '011')
	 begin
		if (select count(*) from tblNorthAmerica with(nolock)  where NPA =  left(@DNI ,3))=0 
		 begin
			EXEC  p_insert_unbilled_calls2   '','',  @ANI ,@DNI,@billtype, 4,@PIN	,0 ,@facilityID	,@userName, '', '','',@localtime
			return -1
		end
	 end
  end 
select @ReasonID= ReasonID, @CallLimit = isnull(TimeLimited ,0)  from tblblockedPhones with(nolock) where phoneNo =  @DNI 
if(@CallLimit >0) SET @TimeLimited  = @CallLimit 
If (@ReasonID > 0)
 Begin
	EXEC  p_insert_unbilled_calls2   '','',  @ANI ,@DNI,@billtype, 5,@PIN	,0 ,@facilityID	,@userName, '', '','',@localtime
	Return  @ReasonID
  End
	
else 
	Return 0
