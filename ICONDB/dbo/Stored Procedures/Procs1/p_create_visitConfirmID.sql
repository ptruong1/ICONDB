-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_create_visitConfirmID]
@visitConfirmID  int  output

 AS
Declare @currentID  int
SET  @currentID = 0
Begin tran
	Select  @currentID = confirmID From tblvisitConfirmID 
	SET  @visitConfirmID =  @currentID + 1
	Update tblvisitConfirmID    SET  confirmID =@visitConfirmID
	
Commit tran

