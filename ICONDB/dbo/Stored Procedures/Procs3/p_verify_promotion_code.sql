-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_verify_promotion_code]
@FacilityID	int,
@PromoteCode	varchar(10),
@productType	tinyint,
@AccountNo		varchar(10),
@DiscountPercent decimal(4,2) OUTPUT, 
@DiscountAmount  smallmoney  OUTPUT, 
@CodeStatus tinyint OUTPUT  -- 0 : invalid Code; 1 valid; 2 had used
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET @DiscountPercent =0;
	SET @DiscountAmount =0;
	SET @CodeStatus =0;
	Declare @currentTime datetime;
	SET @currentTime = getdate();
	select  @DiscountPercent = isnull(DiscountPercent,0) ,  @DiscountAmount= isnull(DiscountAmount,0) ,@CodeStatus  = isnull([status],1) from tblPromotion with(nolock)
			where FacilityID = @FacilityID and PromoteCode = @PromoteCode  and ProductType = @productType and StartDate <@currentTime and EndDate > @currentTime;
   
	if(@CodeStatus =1)
	 begin
		if (select count(*) from tblPromotionUsed where AccountNo = @AccountNo and PromoteCodeUsed= @PromoteCode ) > 0
			SET @CodeStatus =2;
	 end
   
END

