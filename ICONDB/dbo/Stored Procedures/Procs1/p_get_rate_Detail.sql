

CREATE PROCEDURE [dbo].[p_get_rate_Detail]
@RatePlanID	varchar(7)  Output,
@Mileage	int,
@PointID	varchar(2),
@type	char(1),
@billType	varchar(2),
@firstMinute	numeric(4,2)  OUTPUT,
@NextMinute	numeric(4,2)  OUTPUT,
@connectFee	numeric(4,2)   OUTPUT,
@Minuteduration	smallint		 OUTPUT,
@Increment	tinyint  OUTPUT
 AS
SET NOCOUNT ON
SET @firstMinute	=0
SET @NextMinute	=0
SEt  @connectFee	=0
SET @Minuteduration	=1

Declare    @rateClassType	smallint  

SET @rateClassType  =2

--select  @PointID,  @type , @Mileage ,@billType, @RatePlanID, @rateClassType

IF(@pointID = '2'  Or  @pointID = '3'  )
  Begin
	 if(@billType = '01') --- Collect Call
		SELECT   @firstMinute  = [FirstMin]  ,  @nextMinute = AddlMin   ,

		@connectFee =  [ACPCollectCallFee] ,   @MinuteDuration = MinDuration  , @Increment=  MinIncrement 
		FROM   tblRatePlanDetail   with(nolock)
			 WHERE rateID =  'J9'   and PointID =@PointID
              else if(@billType = '10')  ---Prepaid friend and Family
		SELECT  @firstMinute  =  [FirstMin]  , @nextMinute = AddlMin ,
			  @connectFee =  [ACPDebitFee],  @MinuteDuration= MinDuration , @Increment = MinIncrement 
			FROM   tblRatePlanDetail  with(nolock)
			 WHERE rateID =   'J9'   and PointID =@PointID			
	else if(@billtype = '00'   ) --Calling Card
	 
	 	SELECT  @firstMinute = [FirstMin]  ,@nextMinute = AddlMin ,
		 @connectFee = ACPCallingCardFee ,  @MinuteDuration = MinDuration , @Increment = MinIncrement 
			 FROM  tblRatePlanDetail  with(nolock)
			 WHERE rateID =  'J9'   and PointID =@PointID
	
	else if(@billtype = '03' or @billtype = '05' ) -- Credit Card
		SELECT  @firstMinute  =  [FirstMin]  , @nextMinute = AddlMin ,
			  @connectFee =  [ACPCreditCardFee],  @MinuteDuration= MinDuration , @Increment = MinIncrement 
			FROM   tblRatePlanDetail  with(nolock)
			 WHERE rateID =   'J9'   and PointID =@PointID		
	
	
  End

Else
  Begin

	
		 if(@billType = '01') --- Collect Call
			SELECT   @firstMinute  = [FirstMin]  ,  @nextMinute = AddlMin   ,
			@connectFee =  [ACPCollectCallFee] ,   @MinuteDuration = MinDuration , @Increment  =MinIncrement 
			FROM  tblRatePlanDetail   with(nolock)
				 WHERE rateID =  @ratePlanID AND
					   pointID = 	@pointID  And
					    (type = @type  or type ='0')
		 else if(@billType = '10') --- ---Prepaid friend and Family
			SELECT   @firstMinute  = [FirstMin]  ,  @nextMinute = AddlMin   ,
			@connectFee =  [ACPDebitFee] ,   @MinuteDuration = MinDuration , @Increment  =MinIncrement 
			FROM  tblRatePlanDetail   with(nolock)
				 WHERE rateID =  @ratePlanID AND
					   pointID = 	@pointID  And
					    (type = @type  or type ='0')
		else if(@billtype = '00'   ) --Calling Card
		 
		 	SELECT  @firstMinute = [FirstMin]  ,@nextMinute = AddlMin ,
			 @connectFee = ACPCallingCardFee ,  @MinuteDuration = MinDuration , @Increment=  MinIncrement 
				 FROM   tblRatePlanDetail   with(nolock)
				 WHERE rateID =  @ratePlanID AND
					   pointID = 	@pointID  And
					    (type = @type  or type ='0') 
		
		else if(@billtype = '03' or @billtype = '05' ) -- Credit Card
			SELECT  @firstMinute  =  [FirstMin]  , @nextMinute = AddlMin ,
				  @connectFee =  [ACPCreditCardFee],  @MinuteDuration= MinDuration , @Increment = MinIncrement 
				FROM   tblRatePlanDetail  with(nolock)
				 WHERE rateID =  @ratePlanID AND
					   pointID = 	@pointID  And
					    (type = @type  or type ='0')
		
	
  End

If((@firstMinute = 0 and   @nextMinute =0 and  @connectFee=0) Or  @RatePlanID = '9999') 
 begin
	--set @RatePlanID = '9999'
	if(@billType = '01') --- Collect Call
	   Begin
		SELECT   @firstMinute  = [FirstMin]  ,  @nextMinute = AddlMin   ,
		@connectFee =  [ACPCollectCallFee] ,   @MinuteDuration = MinDuration , @Increment = MinIncrement 
		FROM   tblRatePlanDetail  with(nolock)
			  WHERE rateID =  @ratePlanID   and   mileageCode = @Mileage  and  PointID = @PointID  AND  (type = @type  or type ='0')
		If(@firstMinute = 0 )
			SELECT   @firstMinute  = [FirstMin]  ,  @nextMinute = AddlMin   ,
			@connectFee =  [ACPCollectCallFee] ,   @MinuteDuration = MinDuration , @Increment=  MinIncrement 
			FROM   tblRatePlanDetail  with(nolock)
			 WHERE rateID =  @ratePlanID  and PointID = @PointID
		If(@firstMinute = 0 )
			 SELECT   @firstMinute  = [FirstMin]  ,  @nextMinute = AddlMin   ,
			@connectFee =  [ACPCollectCallFee] ,   @MinuteDuration = MinDuration , @Increment = MinIncrement 
			FROM   tblRatePlanDetail  with(nolock) 
			 WHERE rateID =  @ratePlanID  and PointID = '1'
	   End
	
	else if(@billtype = '10'   ) ---Prepaid friend and Family
	   Begin
		SELECT  @firstMinute = [FirstMin]  ,@nextMinute = AddlMin ,
		 @connectFee =ACPDebitFee ,  @MinuteDuration = MinDuration , @Increment = MinIncrement 
			 FROM   tblRatePlanDetail  with(nolock)
			  WHERE rateID =  @ratePlanID   and   mileageCode = @Mileage  and  PointID = @PointID  AND  (type = @type  or type ='0')
		If(@firstMinute = 0 )
			 SELECT  @firstMinute = [FirstMin]  ,@nextMinute = AddlMin ,
			 @connectFee = ACPDebitFee ,  @MinuteDuration = MinDuration , @Increment = MinIncrement 
			 FROM   tblRatePlanDetail  with(nolock)   
			 WHERE rateID =  @ratePlanID  and PointID = @PointID
		If(@firstMinute = 0 )
		 	SELECT  @firstMinute = [FirstMin]  ,@nextMinute = AddlMin ,
			 @connectFee =ACPDebitFee ,  @MinuteDuration = MinDuration , @Increment = MinIncrement 
				 FROM   tblRatePlanDetail  with(nolock)
				 WHERE rateID =  @ratePlanID  and PointID = '1'
	   End
	else if(@billtype = '00'   ) --Calling Card
	   Begin
		SELECT  @firstMinute = [FirstMin]  ,@nextMinute = AddlMin ,
		 @connectFee = ACPCallingCardFee ,  @MinuteDuration = MinDuration , @Increment = MinIncrement 
			 FROM   tblRatePlanDetail  with(nolock)
			  WHERE rateID =  @ratePlanID   and   mileageCode = @Mileage  and  PointID = @PointID  AND  (type = @type  or type ='0')
		If(@firstMinute = 0 )
			 SELECT  @firstMinute = [FirstMin]  ,@nextMinute = AddlMin ,
			 @connectFee = ACPCallingCardFee ,  @MinuteDuration = MinDuration , @Increment = MinIncrement 
			 FROM   tblRatePlanDetail  with(nolock)   
			 WHERE rateID =  @ratePlanID  and PointID = @PointID
		If(@firstMinute = 0 )
		 	SELECT  @firstMinute = [FirstMin]  ,@nextMinute = AddlMin ,
			 @connectFee = ACPCallingCardFee ,  @MinuteDuration = MinDuration , @Increment = MinIncrement 
				 FROM   tblRatePlanDetail  with(nolock)
				 WHERE rateID =  @ratePlanID  and PointID = '1'
	   End
	else if(@billtype = '03' or @billtype = '05' ) -- Credit Card
	  Begin
		SELECT  @firstMinute  =  [FirstMin]  , @nextMinute = AddlMin ,
			  @connectFee =  [ACPCreditCardFee],  @MinuteDuration= MinDuration , @Increment=  MinIncrement 
			FROM   tblRatePlanDetail  with(nolock)
			 WHERE rateID =  @ratePlanID   and   mileageCode = @Mileage  and  PointID = @PointID  AND  (type = @type  or type ='0')
		If(@firstMinute = 0 )
			SELECT  @firstMinute  =  [FirstMin]  , @nextMinute = AddlMin ,
			  @connectFee =  [ACPCreditCardFee],  @MinuteDuration= MinDuration , @Increment =MinIncrement 
			 FROM   tblRatePlanDetail  with(nolock)
			 WHERE rateID =  @ratePlanID  and PointID = @PointID
		If(@firstMinute = 0 )
			SELECT  @firstMinute  =  [FirstMin]  , @nextMinute = AddlMin ,
			  @connectFee =  [ACPCreditCardFee],  @MinuteDuration= MinDuration , @Increment = MinIncrement 
			 FROM   tblRatePlanDetail  with(nolock)  
			WHERE rateID =  @ratePlanID  and PointID = '1'
	 End
END

