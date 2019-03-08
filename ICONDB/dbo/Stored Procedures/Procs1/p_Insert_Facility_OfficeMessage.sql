

CREATE PROCEDURE [dbo].[p_Insert_Facility_OfficeMessage]
(
	@FacilityID int
           ,@Message varchar(500)
           ,@PostBy varchar(25)
           ,@ModifyBy varchar(25)
           ,@PostDate datetime
           ,@ModifyDate datetime
           ,@FromDate datetime
           ,@ToDate datetime
)
AS
	SET NOCOUNT OFF;
Declare  @return_value int, @nextID int, @ID int, @tblFacilityOfficeMessage nvarchar(32) ;
 EXEC   @return_value = p_create_nextID 'tblFacilityOfficeMessage', @nextID   OUTPUT
    set           @ID = @nextID ; 
INSERT INTO [leg_Icon].[dbo].[tblFacilityOfficeMessage]
           ([MessageID]
           ,[FacilityID]
           ,[Message]
           ,[PostBy]
           ,[ModifyBy]
           ,[PostDate]
           ,[ModifyDate]
           ,[FromDate]
           ,[ToDate])
     VALUES
           (@ID
           ,@FacilityID
           ,@Message
           ,@PostBy
           ,@ModifyBy
           ,@PostDate
           ,@ModifyDate
           ,@FromDate
           ,@ToDate)
