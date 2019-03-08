CREATE PROCEDURE [dbo].[INSERT_Glendale_Inmate]
@facilityID int,
@PIN	varchar(12),
@firstName	varchar(25),
@lastName	varchar(25),
@status		int
AS

	set @PIN = ltrim(rtrim(@PIN))
	set @firstName	 = ltrim(@firstName)
	SET @lastName = ltrim(@lastName)

	If (select count(*) from  tblInmate  where  PIN = @PIN and FacilityID =   @facilityID) =  0
 	  Begin
		INSERT tblInmate(InmateID   ,    LastName       ,     FirstName   ,  Status, DNIRestrict, DateTimeRestrict,    DNILimit ,FacilityId,   PIN,inputdate    )
			Values( @PIN,@lastName, @FirstName,@status, 0,0,0, @facilityID,  @PIN,getdate())

	  End
	else
	If @status=2
	Begin
		UPDATE tblInmate SET  status = @status , modifyDate = getdate()  where  PIN = @PIN and FacilityID = @facilityID
	 End
