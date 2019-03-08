-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_determineIndicator19] 
(@fromState char(2),
@toState    char(2))
	
Returns varchar(1)
AS
BEGIN
		
			
		
		If ( @fromState	 =   @toState ) 
		 			
			return   '5'
		
		Else
			return  '2'

 return   '8'

END

