
Create PROCEDURE [dbo].[p_Update_User_SecondFactor]
(
	@UserId varchar(25),
	@SecondFactor bit
	)
AS
UPDATE [dbo].[tblUserprofiles]
   SET 
      [SecondFactor] = @SecondFactor
 WHERE userID = @UserID
 