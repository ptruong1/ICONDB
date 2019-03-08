
CREATE FUNCTION [dbo].[fn_determine_crazy_week] 
(@Scheduledate datetime
)  
RETURNS smallint
AS
	
Begin  
	Declare @i smallint;
	SET @i=  datediff(day,'11/6/2016',@Scheduledate)/7 %2 ;

	if(@i=1)
		return 0;
	return 1;
END


