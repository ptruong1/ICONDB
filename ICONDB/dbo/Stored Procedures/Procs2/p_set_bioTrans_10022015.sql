-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_set_bioTrans_10022015]
	@userID	varchar(16),
	@TransID varchar(16),
	@Result varchar(50),
	@transType	int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    Insert leg_Icon.dbo.tblbioMetricTrans
    (UserID,transID,Results,RecordDate,transType) 
    values(@userID,@transID,@Result,getdate(),@transType)
END

