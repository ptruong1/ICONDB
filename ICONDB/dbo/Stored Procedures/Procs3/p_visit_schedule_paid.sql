-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_visit_schedule_paid]
@AccountNo	varchar(12),
@confirmID	int,
@Amount		numeric(5,2)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   Update tblprepaid set balance= balance - @Amount, modifyDate = getdate() where phoneno = @AccountNo
   INSERT tblVisitPaid (ConfirmID, AccountNo,  Amount ,  Status, ConfirmDate)
			values(@confirmID, @AccountNo, @Amount	,1,getdate())
END

