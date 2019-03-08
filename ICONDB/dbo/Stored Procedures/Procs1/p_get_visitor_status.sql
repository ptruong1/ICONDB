-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_visitor_status]
	@AcctNo  varchar(12),
	@ApprovedStatus char(1) OUTPUT
AS
BEGIN
	select @ApprovedStatus =isnull(Approved,'P')  from [leg_Icon].[dbo].[tblVisitors] where EndUserID = @AcctNo
END

