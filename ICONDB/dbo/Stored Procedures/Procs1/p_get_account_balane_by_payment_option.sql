-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_account_balane_by_payment_option]
	@PaymentType tinyint, -- 1 :Inmate Debit   ; 2 Family Prepaid 
	@FacilityID int,
	@inmateID varchar(12),
	@PrepaidPhoneNo varchar(12),
	@Balance smallmoney OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--- Will implement more later 
	SET NOCOUNT ON;
    SET @Balance = 0;
    if(@PaymentType =1)
	 Begin
		select @Balance = balance from tblDebit a with(nolock), tblinmate b with(nolock)
			where a.inmateID = b.inmateID and
				  a.FacilityID = b.FacilityId and
				  b.FacilityId = @FacilityID and
				  b.InmateID = @inmateID ;
	 end
	else
	 begin
		select @balance = balance from tblprepaid with(nolock) where phoneno = @PrepaidPhoneNo and facilityID = @FacilityID ;
	 end
		

END

