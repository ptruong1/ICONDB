-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_determine_Oxfordbiometric_user_V1]
@FacilityID int,
@PIN		varchar(12),
@UserID		varchar(16),
@BioStatus	tinyint OUTPUT,
@RemainEnrollments	tinyint OUTPUT

AS
BEGIN
	SET NOCOUNT ON;
	Declare @bioRegister tinyint;
	SET @BioStatus = 3;
	SET @RemainEnrollments = 9;
		
	 if (select COUNT(*) from tblInmate with(nolock) where FacilityID =@FacilityID and PIN=@PIN and status = 1)  >0
		select @BioStatus = isnull(BioRegister,0) from tblInmate with(nolock) where FacilityID =@FacilityID and PIN=@PIN and status = 1 ;
		select @RemainEnrollments = isnull(RemainEnrollments,0) from tblBioMetricProfileOxfordVerification with(nolock) where UserID =@UserID ;
    	
END

