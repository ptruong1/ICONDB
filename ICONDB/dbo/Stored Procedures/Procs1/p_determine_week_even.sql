-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_determine_week_even] 
@DATE DATETIME	
AS
BEGIN
	return (DATEPART(WEEK, @DATE)  -    DATEPART(WEEK, DATEADD(MM, DATEDIFF(MM,0,@DATE), 0))+ 1)%2;
END

