
CREATE PROCEDURE [dbo].[p_Check_AttorneyNo]
(	
		@facilityId char(10),
		@Phone char(10)
	
)
AS
	SET NOCOUNT OFF; 

	DECLARE @count4 int;
	SELECT @count4 = COUNT(PhoneNo) FROM [tblNonRecordPhones] WHERE (tblNonRecordPhones.PhoneNo = @Phone) and tblNonRecordPhones.facilityId = @facilityId
	IF @count4 > 0 --check to see if DNI is Attorney Phone or nonrecordable, can not monitor Attorney No
		RETURN -1;
	ELSE
	BEGIN
	   	RETURN 0;
	END
	
