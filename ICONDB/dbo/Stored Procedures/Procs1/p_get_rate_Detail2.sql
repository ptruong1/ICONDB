

CREATE PROCEDURE [dbo].[p_get_rate_Detail2]
@RatePlanID	varchar(7)  Output,
@Mileage	int,
@PointID	varchar(2),
@type	char(1),
@billType	varchar(2),
@daycode tinyint,
@firstMinute	numeric(4,2)  OUTPUT,
@NextMinute	numeric(4,2)  OUTPUT,
@connectFee	numeric(4,2)   OUTPUT,
@Minuteduration	smallint		 OUTPUT,
@Increment	tinyint  OUTPUT
 AS
SET NOCOUNT ON;
SET @firstMinute	=0;
SET @NextMinute	=0;
SEt  @connectFee	=0;
SET @Minuteduration	=1;

Declare    @rateClassType	smallint   ;

 if(@billType = '01') --- Collect Call
	SELECT   @firstMinute  = [FirstMin]  ,  @nextMinute = AddlMin   ,	@connectFee =  [ACPCollectCallFee] ,   @MinuteDuration = MinDuration , @Increment  =MinIncrement 
		FROM  tblRatePlanDetail   with(nolock)
			 WHERE rateID =  @ratePlanID AND
				(  mileageCode = @Mileage ) AND
				(daycode = 0 or daycode = @daycode) and 
				 pointID = 	@pointID  And
				 (type = @type  or type ='0');
 else if(@billType = '10'   Or  @billType = '07' ) --- ---Prepaid friend and Family
	SELECT   @firstMinute  = [FirstMin]  ,  @nextMinute = AddlMin   ,	@connectFee =  isnull([ACPDebitFee],0) ,   @MinuteDuration = isnull(MinDuration,1) , @Increment  =isnull(MinIncrement,1)
	FROM  tblRatePlanDetail   with(nolock)
		 WHERE rateID =  @ratePlanID AND
			   (  mileageCode = @Mileage ) AND
			   (daycode = 0 or daycode = @daycode) and 
			   pointID = 	@pointID  And
			    (type = @type  or type ='0');
else if(@billtype = '00'   ) --Calling Card
 
 	SELECT  @firstMinute = [FirstMin]  ,@nextMinute = AddlMin ,	 @connectFee = isnull(ACPCallingCardFee,0) ,  @MinuteDuration = MinDuration , @Increment=  MinIncrement 
		 FROM   tblRatePlanDetail   with(nolock)
		 WHERE rateID =  @ratePlanID AND
			   ( mileageCode = @Mileage ) AND
			    (daycode = 0 or daycode = @daycode) and 
			   pointID = 	@pointID  And
			    (type = @type  or type ='0') ;

else if(@billtype = '03' or @billtype = '05' ) -- Credit Card
	SELECT  @firstMinute  =  [FirstMin]  , @nextMinute = AddlMin ,  @connectFee = ISNULL( [ACPCreditCardFee],0),  @MinuteDuration= MinDuration , @Increment = MinIncrement 
		FROM   tblRatePlanDetail  with(nolock)
		 WHERE rateID =  @ratePlanID AND
			   ( mileageCode = @Mileage ) AND
			    (daycode = 0 or daycode = @daycode) and 
			   pointID = 	@pointID  And
			    (type = @type  or type ='0');
If(@firstMinute = 0 and   @nextMinute =0 and  @connectFee=0) 
 begin
		
	 if(@billType = '01') --- Collect Call
		SELECT   @firstMinute  = [FirstMin]  ,  @nextMinute = AddlMin ,@connectFee =  [ACPCollectCallFee] ,   @MinuteDuration = MinDuration , @Increment  =MinIncrement 
		FROM  tblRatePlanDetail   with(nolock)
			 WHERE rateID =  @ratePlanID AND
				  (daycode = 0 or daycode = @daycode) and 
				   pointID = 	@pointID  And
				    (type = @type  or type ='0');
	 else if(@billType = '10'  Or  @billType = '07' ) --- ---Prepaid friend and Family
		SELECT   @firstMinute  = [FirstMin]  ,  @nextMinute = AddlMin   ,
		@connectFee = ISNULL( [ACPDebitFee],0) ,   @MinuteDuration = MinDuration , @Increment  =MinIncrement 
		FROM  tblRatePlanDetail   with(nolock)
			 WHERE rateID =  @ratePlanID AND				
				   (daycode = 0 or daycode = @daycode) and 
				   pointID = 	@pointID  And
				    (type = @type  or type ='0');
	else if(@billtype = '00'   ) --Calling Card
	 
	 	SELECT  @firstMinute = [FirstMin]  ,@nextMinute = AddlMin ,	 @connectFee = ACPCallingCardFee ,  @MinuteDuration = MinDuration , @Increment=  MinIncrement 
			 FROM   tblRatePlanDetail   with(nolock)
			 WHERE rateID =  @ratePlanID AND				
				    (daycode = 0 or daycode = @daycode) and 
				   pointID = 	@pointID  And
				    (type = @type  or type ='0');
	
	else if(@billtype = '03' or @billtype = '05' ) -- Credit Card
		SELECT  @firstMinute  =  [FirstMin]  , @nextMinute = AddlMin ,  @connectFee =  [ACPCreditCardFee],  @MinuteDuration= MinDuration , @Increment = MinIncrement 
			FROM   tblRatePlanDetail  with(nolock)
			 WHERE rateID =  @ratePlanID AND				
				    (daycode = 0 or daycode = @daycode) and 
				   pointID = 	@pointID  And
				    (type = @type  or type ='0');
  End 


If(@firstMinute = 0 and   @nextMinute =0 and  @connectFee=0) 
  Begin
	 if(@billType = '01') --- Collect Call
		SELECT   @firstMinute  = [FirstMin]  ,  @nextMinute = AddlMin   ,	@connectFee =  [ACPCollectCallFee] ,   @MinuteDuration = MinDuration  , @Increment=  MinIncrement 
		FROM   tblRatePlanDetail   with(nolock)
			 WHERE rateID =  'J9'   and PointID =@PointID;
     else if(@billType = '10'  Or  @billType = '07' ) ---Prepaid friend and Family
		SELECT  @firstMinute  =  [FirstMin]  , @nextMinute = AddlMin ,  @connectFee =  [ACPDebitFee],  @MinuteDuration= MinDuration , @Increment = MinIncrement 
			FROM   tblRatePlanDetail  with(nolock)
			 WHERE rateID =   'J9'   and PointID =@PointID;		
	else if(@billtype = '00'   ) --Calling Card
	 
	 	SELECT  @firstMinute = [FirstMin]  ,@nextMinute = AddlMin ,	 @connectFee = ACPCallingCardFee ,  @MinuteDuration = MinDuration , @Increment = MinIncrement 
			 FROM  tblRatePlanDetail  with(nolock)
			 WHERE rateID =  'J9'   and PointID =@PointID;
	
	else if(@billtype = '03' or @billtype = '05' ) -- Credit Card
		SELECT  @firstMinute  =  [FirstMin]  , @nextMinute = AddlMin ,  @connectFee =  [ACPCreditCardFee],  @MinuteDuration= MinDuration , @Increment = MinIncrement 
			FROM   tblRatePlanDetail  with(nolock)
			 WHERE rateID =   'J9'   and PointID =@PointID	;	
	
  End

