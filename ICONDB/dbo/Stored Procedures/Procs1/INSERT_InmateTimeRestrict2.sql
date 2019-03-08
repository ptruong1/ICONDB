
CREATE PROCEDURE [dbo].[INSERT_InmateTimeRestrict2]
(
	@PIN char(12),
	@days tinyint,
	@hours bigint,
	@userName varchar(20),
	@modifydate smalldatetime,
	@FacilityID int
)
AS
	SET NOCOUNT OFF;
Update tblInmate Set   DateTimeRestrict = 1 where PIN = @PIN and FacilityID = @facilityID
IF @days in (SELECT days FROM tblPintimecall  WHERE PIN = @PIN  AND days = @days AND FacilityID = @facilityID)
	BEGIN
		UPDATE tblPintimecall  SET [hours] = @hours, [userName] = @userName, [modifydate] = @modifydate WHERE ((PIN = @PIN) AND ([days] = @days)  AND FacilityID = @facilityID);
		RETURN;
	END
ELSE
	BEGIN
		INSERT INTO tblPintimecall   ([PIN], [days], [hours], [userName], [modifydate], [FacilityID])  VALUES (@PIN, @days, @hours, @userName, @modifydate, @FacilityID);
		RETURN;
	END
