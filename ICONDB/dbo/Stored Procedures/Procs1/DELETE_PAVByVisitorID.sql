-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DELETE_PAVByVisitorID]
(
	@VisitorID int
)
AS
	SET NOCOUNT OFF;
DELETE FROM [tblVisitorInmate] 
WHERE (VisitorID=@VisitorID)

