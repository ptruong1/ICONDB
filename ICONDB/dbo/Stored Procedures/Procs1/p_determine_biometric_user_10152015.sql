-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_determine_biometric_user_10152015]
@FacilityID int,
@PIN		varchar(12),
@BioStatus	tinyint OUTPUT,
@ScoreRq int OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	Declare @bioRegister tinyint;
	SET @BioStatus = 3;
	SET @ScoreRq = 0;
	
	 if (select COUNT(*) from tblInmate with(nolock) where FacilityID =@FacilityID and PIN=@PIN)  >0
		select @BioStatus = isnull(BioRegister,0) from tblInmate with(nolock) where FacilityID =@FacilityID and PIN=@PIN ;

     select @ScoreRq = score from tblfacilitybiometric with(nolock) where FacilityID = @FacilityID
	 
	

END

