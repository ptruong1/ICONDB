-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_biometric_user_Reset]
@FacilityID int,
@PIN	varchar(12),
@UserStatus	tinyint 

AS
BEGIN
	SET NOCOUNT ON;
	begin
	 update leg_Icon.dbo.tblInmate
		set [BioRegister] = @UserStatus 
		where FacilityID = @FacilityID  and PIN =@PIN
		
	 end
	insert tblBioMetricresults(facilityID,InmateID,  RecordID,TransactionID, SegmentNo,BioStatus,BioScores,BioUsableTime,VerifyStatus,InputDate,Note,PIN)
				values(@FacilityID,@PIN,0,0,0, @UserStatus,0,0,@UserStatus,getdate(),'Reset User',@PIN);

END

