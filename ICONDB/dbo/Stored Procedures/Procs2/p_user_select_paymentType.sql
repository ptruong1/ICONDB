-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_user_select_paymentType]
AS
BEGIN
	
  SET NOCOUNT ON;

   SELECT paymentTypeID, Descript from tblpaymentType where paymentTypeID in (1,4,5) order by paymentTypeID;
END

