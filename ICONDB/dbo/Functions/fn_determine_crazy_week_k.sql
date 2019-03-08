
CREATE FUNCTION [dbo].[fn_determine_crazy_week_k] 
(@Scheduledate datetime
)  
RETURNS smallint
AS
	
Begin  
	Declare @i smallint;
	SET @i=  datediff(day,'4/30/2017',@Scheduledate)/7 %2 ;

	if(@i=1)
		return 0;
	return 1;
END


