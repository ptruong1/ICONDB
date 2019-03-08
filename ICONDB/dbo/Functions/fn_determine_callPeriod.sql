
CREATE FUNCTION [dbo].[fn_determine_callPeriod] 
(@RecordDate datetime,
@connectTime  varchar(6))  
RETURNS char(1)
 AS
Begin  
Declare   @HH smallint,  @callPeriod char(1)

IF( datepart(dw ,@RecordDate) = 1 OR datepart(dw ,@RecordDate) = 7 )   
	SET @callPeriod = '3'
ELSE
  Begin
	SET  @HH = CAST( Left(@connectTime,2 ) AS smallint)
	If( @HH >6 AND @HH < 18 )  
		SET  @callPeriod = '1'
	ELSE IF (@HH >18  and  @HH < 22) 
		SET @callPeriod = '2'
	ELSE   
		SET @callPeriod = '3'
  End

Return @callPeriod
END


