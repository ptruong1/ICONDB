-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_determine_biometric_user_status]
@FacilityID int,
@PIN		varchar(12),
@VerifyScore	smallint,
@UsableTime     numeric(7,4),
@BioStatus		varchar(10),
@TransID	int,
@UserStatus char(1) output
AS
BEGIN
	SET NOCOUNT ON;
	Declare  @ScoreRq smallint, @InmateID varchar(12);
	SET @UserStatus ='0';
	SET @ScoreRq =30;

	select @ScoreRq = score from tblfacilitybiometric with(nolock) where FacilityID = @FacilityID;

    if((@VerifyScore >  @ScoreRq or @BioStatus='NewUser') and @UsableTime >0)
	 begin
		SET  @UserStatus ='1';
	 end
	insert tblBioMetricresults(facilityID,InmateID,  RecordID,TransactionID, SegmentNo,BioStatus,BioScores,BioUsableTime,VerifyStatus,InputDate,Note,PIN)
				values(@FacilityID,@PIN,0,@TransID,1, @BioStatus,@VerifyScore,@UsableTime,@UserStatus,getdate(),'Verify From ACP',@PIN);
	
END



