
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <11/30/2011>
-- Description:	<get database flatform>
-- =============================================
CREATE FUNCTION [dbo].[fn_determine_flatform]
(
	@facilityID	int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @flatform int
	SET @flatform =1

	-- Add the T-SQL statements to compute the return value here
	SELECT  @flatform = isnull(flatform,1) FROM [Leg_ICON].dbo.tblfacility with(nolock) where FacilityID =@facilityID

	-- Return the result of the function
	RETURN @flatform 

END

