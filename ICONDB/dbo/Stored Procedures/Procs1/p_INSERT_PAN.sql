

CREATE PROCEDURE [dbo].[p_INSERT_PAN]
(
	@InmateID varchar(12),
	@PAN varchar(15),
	@PIN varchar(12),
	@LastName varchar(25),
	@FirstName varchar(25),
	@Address varchar(50),
	@City varchar(20),
	@State char(2),
	@RelationshipID tinyint,
	@AlertToPhone char(10),
	@AlertToCell varchar(25),
	@AlertToEmail varchar(25),
	@ZipCode varchar(10),
	@facilityID	int,
	@UserName varchar(25)

)
AS
	SET NOCOUNT OFF;
	DECLARE @PANCount int;
SELECT @PANCount = DNILimit FROM tblInmate WHERE InmateID = @InmateID  and PIN = @PIN and facilityID = @facilityID	 ;
Declare  @WhatEdit varchar(200) ,@ActTime datetime;
IF @PANCount <= (SELECT COUNT(*) FROM tblPHones WHERE InmateID = @InmateID and facilityID = @facilityID)  --- # of phones over limit
	RETURN -2;
IF (SELECT count(phoneNo) FROM tblPhones WHERE InmateID = @InmateID and facilityID = @facilityID and phoneNo = @PAN ) >0  -- exist 
	RETURN -1 ;
ELSE
	BEGIN
	    Declare  @return_value int, @nextID int, @ID int, @tblPhones nvarchar(32) ;
        EXEC   @return_value = p_create_nextID 'tblPhones', @nextID   OUTPUT
        set           @ID = @nextID ; 
        select @ID;
		INSERT INTO [tblPhones] ([RecordID] ,[phoneNo], [InmateID], [PIN], [LastName], [FirstName], [Address], [City], [State], [RelationshipID], [AlertToPhone], [AlertToCell], [AlertToEmail], [ZipCode], FacilityID,InputBy) 
			VALUES (@ID, @PAN, @InmateID, @PIN, @LastName, @FirstName, @Address, @City, @State, @RelationshipID, @AlertToPhone, @AlertToCell, @AlertToEmail, @ZipCode, @facilityID,@UserName);
		
		if (SELECT count(phoneNo) FROM tblPhones WHERE InmateID = @InmateID and facilityID = @facilityID) = (SELECT DNILimit  FROM tblInmate WHERE FacilityID = @FacilityId  and InmateID = @InmateID) 
		begin 
			UPDATE [dbo].[tblInmate]
			SET  [DNIRestrict] = 1
			WHERE (InmateID = @InmateId AND [FacilityId] = @FacilityId) ;
		end
		
		EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ;
			
		SET @WhatEdit = 'Insert New PAN:' +  @PAN;
		
		EXEC  INSERT_ActivityLogs3	@FacilityID ,10,@ActTime  ,0,@UserName ,'',	@InmateID,@WhatEdit
		
		RETURN @@error;
	END
