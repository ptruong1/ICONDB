-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_auto_delete_temp_schedule]
	
		
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--SET NOCOUNT ON;
	Declare	@localTime datetime	;		

    delete tblVisitEnduserScheduleTemp  
    where
     DATEADD(MINUTE ,30, RequestedTime )  < GETDATE() ;
    
END

