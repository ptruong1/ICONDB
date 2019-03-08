﻿-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_Delete_BlockPhone_11212017]
(
	@PhoneNo char(10),
	@FacilityID int,
	@GroupID int,
	@UserName varchar(25),
	@UserIP varchar(25)
	
)
AS
	SET NOCOUNT OFF;
	Declare @UserAction  varchar(100),@ActTime datetime;
EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ; 
	
	DELETE FROM [tblBlockedPhones] WHERE (([PhoneNo] = @PhoneNo) AND ([GroupID] = @GroupID))
	SET  @UserAction =  'Delete Block phone: ' + @PhoneNo  ;
		EXEC  INSERT_ActivityLogs3	@FacilityID ,15,@ActTime ,0,@UserName ,@UserIP, @PhoneNo ,@UserAction ; 

