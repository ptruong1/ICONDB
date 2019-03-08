

CREATE PROCEDURE [dbo].[UPDATE_LocationByLocationID]
(
	@DivisionID int,
	@Descript varchar(50),
	@DayTimeRestrict bit,
	@PINrequired bit,
	@UserName varchar(25),
	@LocationID int
)
AS
	SET NOCOUNT OFF;
--if @DayTimeRestrict  is null set @DayTimeRestrict  =0
--if  @PINrequired is null set @PINrequired = 0

UPDATE [tblFacilityLocation] SET [Descript] = @Descript, [DayTimeRestrict] = @DayTimeRestrict, [PINrequired] = @PINrequired, [UserName] = @UserName, [ModifyDate] = getdate() WHERE (([LocationID] = @LocationID));

