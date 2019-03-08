-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DELETE_VisitorMembers]
(

	@VisitorID int
)
AS
	SET NOCOUNT OFF;
	
	DELETE FROM [tblVisitorMembers] WHERE ([VisitorID] = @VisitorID)


