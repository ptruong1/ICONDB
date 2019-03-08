-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_check_inmate_oncall_status]
	@referenceNo	bigint, 
	@status tinyint OUTPUT
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @Error int;
	set  @status  =0;
	set @Error =0;
	select @status = apitype, @Error =Error_ID from tblMaineLogs where ReferenceNo = @referenceNo  order by log_ID;
	If(@Error =0)
		return 0;
	If (@error >= 113)
	 begin
		SET  @status =2;
		return 0;
	 end

END

