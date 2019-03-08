
CREATE PROCEDURE [dbo].[p_get_InmateInfo_Visit_Com_Web_service]
@PIN  varchar(12),
@facilityID	int 

 AS

SET NOcount on;
Declare @VisitsAmount	smallint ,@ComAmount   numeric(10,2),@Location	varchar(30) ,@ReleaseDate varchar(12), @BookingDate datetime , @timezone smallint, @InmateStatus tinyint,
		@COURT 	varchar(30) ,@ApperanceDate  varchar(12)  ,@BailAmount numeric(10,2),@courtdate varchar(16), @Charge varchar(30), @InmateID varchar(12),@BookingNo varchar(20),
		@Allcharges varchar(150), @Bail varchar(12), @ChargeDescript varchar(300), @BailAmountPercharge varchar(10), @AllChargeDescript varchar(2000), @AllBailPercharge varchar(300) ;
SET @VisitsAmount	 =-1;
SET @ComAmount  =0 ;
SET @Location	 ='';
SET @COURT ='';
SET @BailAmount=0;
SET @ReleaseDate ='';
SET @ApperanceDate ='';
SET @Allcharges ='';
SET @Bail ='';
SET  @AllChargeDescript='';
SET  @AllBailPercharge ='';
SET @InmateStatus = 0;


Select @InmateStatus = [status], @InmateID = InmateID,  @BookingDate  = inputdate  from tblInmate with(nolock) where FacilityId= @facilityID  and (InmateID = @PIN  or PIN=@PIN) ;
--select  @InmateStatus ;
if(@InmateStatus =1)
 Begin
	SELECT @VisitsAmount=  VisitNo  ,   @ComAmount=  ComBalance ,@Location=  AtLocation,@ReleaseDate= ReleaseDate    from tblInmateUpdate with(nolock)   
														where   FacilityID= @facilityID and (InmateID =  @InmateID ) ;       
	
	SELECT @BookingNo = bookingNo from 		tblInmateBookInfo   with(nolock) 	where  FacilityID= @facilityID and  ( InmateID = @InmateID)  order by BookingNO desc										                  
	SELECT    @COURT 	=isnull(COURT,''),  @courtdate   = ApperanceDate  From  tblInmateBookInfo   with(nolock)  
			where  FacilityID= @facilityID and  ( InmateID = @InmateID)  AND   len(ApperanceDate) >=10 and BookingNo= @BookingNo;
	
	select   @BailAmount	=  sum(BAILAMOUNT)	   From  tblInmateBookInfo with(nolock)   where  facilityID= @facilityID and    InmateID = @InmateID and BookingNO =@BookingNo ;--and BailOUT ='Y';
	
	select @timezone = timezone from tblfacility with(nolock) where  facilityID = @facilityId;
	SET @BookingDate  = dateadd(hour,-@timezone, @BookingDate);
	if(isdate(@ReleaseDate) =0)
		SET @ReleaseDate='';
	if(isdate(@courtdate) =0)
		SET @courtdate='';
	if(	@BailAmount >0)
		SET @Bail = CAST (@BailAmount as varchar(12));
	select @BookingNo;
	DECLARE charge_cursor CURSOR FOR SELECT ChargeCode, rtrim(ChargeDescript), Sum(CAST(BAILAMOUNT as Numeric(10,2)))  FROM tblInmateBookInfo with(nolock) 
			 where FacilityID= @facilityID and   (InmateID = @InmateID) and rtrim(ChargeCode) <> '' and ChargeCode is not null and BookingNo= @BookingNo
			Group by ChargeDescript, ChargeCode;
	OPEN charge_cursor;
	
	FETCH NEXT FROM charge_cursor into  @Charge ,  @ChargeDescript, @BailAmountPercharge;

	WHILE @@FETCH_STATUS = 0
	BEGIN   
	   SET @Allcharges = @Allcharges + @Charge ;
	   if(@Charge = @ChargeDescript)
			select @ChargeDescript = ADescript from tblarrestcode with(nolock) where facilityid = @facilityID and Acode=@Charge ; 
	   SET  @AllChargeDescript =@AllChargeDescript + @ChargeDescript;
	   SET @AllBailPercharge = @AllBailPercharge + @BailAmountPercharge ;
	   FETCH NEXT FROM charge_cursor into  @Charge ,  @ChargeDescript, @BailAmountPercharge;
	   if (@@FETCH_STATUS = 0)
		begin
		 SET @Allcharges = @Allcharges + '_' ;
		 SET  @AllChargeDescript =@AllChargeDescript + '_';
		 SET @AllBailPercharge = @AllBailPercharge + '_' ;
		end
	END

	CLOSE charge_cursor;
	DEALLOCATE charge_cursor;
 End

If(@facilityID=747)
 begin
	SET @Location = replace (@Location,'TUOLUMNE','CELL');
	--SET @Location = 'Inmate at '+ @Location;
 end

Select  @VisitsAmount as VisitRemain, @ComAmount as ComBalance , @Location as AtLocation, @ReleaseDate as ReleaseDate, @COURT AS COURT,  @courtdate AS ApperanceDate,@Bail as BailAmount, @Allcharges as Charges, @AllChargeDescript as ChargeDescript, @AllBailPercharge as BailPerCharge, (convert(varchar(10), @bookingDate,101) + ' ' + convert(varchar(5),@bookingDate,108)) as BookingDate, @InmateStatus as InmateStatus;


