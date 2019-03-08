-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_insert_officer_checkIn_record] 
	@FacilityID int,
	@ANI	    char(10),
	@BadgeID	int,
	@RecordName	varchar(25),
	@RecordDate datetime,
	@ServerIP	varchar(17)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare  @return_value int, @nextID int, @ID int, @tblOfficerCheckIn nvarchar(32) ;
    EXEC   @return_value = p_create_nextID 'tblOfficerCheckIn', @nextID   OUTPUT
    set           @ID = @nextID ; 
	insert tblOfficerCheckIn(RecordID ,facilityID, ANI , BadgeID ,RecordDate,RecordName,CheckInStatus,serverIP)
			Values (@ID, @FacilityID,@ANI,@BadgeID,@RecordDate ,@RecordName,1,@ServerIP );

	if(@@ERROR =0)
		Select 'Success' as CheckIn, Convert (varchar(8),@RecordDate,112) as foderDate;
	else
		Select 'Fail' as CheckIn, Convert (varchar(8),@RecordDate,112) as foderDate;

   
END
