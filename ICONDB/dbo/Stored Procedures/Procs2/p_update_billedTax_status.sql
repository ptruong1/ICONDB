-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_billedTax_status]
@referenceNo varchar(15)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Update leg_Icon.dbo.tblTaxesBilled set Billedstatus =1 where referenceNo = @referenceNo AND DATEDIFF (DAY,BilledDate,getdate())=0 ; 
END

