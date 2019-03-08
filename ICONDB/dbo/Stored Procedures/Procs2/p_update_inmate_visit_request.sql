-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_inmate_visit_request]
@RequestID int,
@RequestStatus tinyint  -- 2: Accept ; 3: Deny
AS
BEGIN
	
	SET NOCOUNT ON;

	Update  tblvisitRequest SET RequestStatus =@RequestStatus, ReplyDate = getdate() where RequestID = @RequestID ;
	
END

