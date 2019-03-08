-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_set_bioTrans]
	@userID	varchar(16),
	@Result varchar(50),
	@transType	int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    Insert leg_Icon_dev.dbo.tblbioMetricTrans values(@userID,@Result,getdate(),@transType)
END

