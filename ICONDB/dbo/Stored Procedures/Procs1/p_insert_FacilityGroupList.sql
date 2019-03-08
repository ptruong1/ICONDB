
CREATE PROCEDURE [dbo].[p_insert_FacilityGroupList]
(
	
           @AgentId int
           ,@GroupName varchar(50)
		   ,@GroupId int output
)
AS
	SET NOCOUNT OFF;

Declare @UserAction varchar(200);
Declare  @return_value int, @nextID int, @ID int, @tblFacilityGroups nvarchar(32) ;
   EXEC   @return_value = p_create_nextID 'tblFacilityGroups', @nextID   OUTPUT
    set           @ID = @nextID ; 	
	
 INSERT INTO [dbo].[tblFacilityGroups]
           ([GroupId]
           ,[AgentId]
           ,[GroupName]
           ,[inputdate]
           )
     VALUES
           (@ID
           ,@AgentId
           ,@GroupName
           ,getdate()
           )
 set @GroupId = @ID

