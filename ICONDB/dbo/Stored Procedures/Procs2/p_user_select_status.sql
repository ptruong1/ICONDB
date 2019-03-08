
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_user_select_status]

AS
BEGIN
	SET NOCOUNT ON;
	select  statusID , Descrip from  tblstatus order by statusID ;
	

END


