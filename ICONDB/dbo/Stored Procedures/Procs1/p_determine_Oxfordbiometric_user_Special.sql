-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_determine_Oxfordbiometric_user_Special]
@FacilityID int,
@PIN		varchar(12),
@BioStatus	int OUTPUT


AS
BEGIN
	SET NOCOUNT ON;
	Declare @bioRegister tinyint;
	SET @BioStatus = 3;
			
	 if (select COUNT(*) from tblInmate with(nolock) where FacilityID =@FacilityID and PIN=@PIN and status = 1)  >0
		select @BioStatus = isnull(BioRegister,0) from tblInmate with(nolock) where FacilityID =@FacilityID and PIN=@PIN and Status = 1;
		
    
END

