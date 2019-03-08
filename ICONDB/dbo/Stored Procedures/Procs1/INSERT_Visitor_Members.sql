

CREATE PROCEDURE [dbo].[INSERT_Visitor_Members]
(
	@LastName  varchar(25) ,
	@FirstName  varchar(25) ,
	@RelationshipID  tinyint,
	@VisitorID int
)
AS
	SET NOCOUNT OFF;
	
	INSERT INTO [leg_Icon].[dbo].[tblVisitorMembers]
           (LastName
           ,FirstName
           ,RelationshipID
            ,InputDate
			,VisitorID)
     VALUES
           (@LastName
           ,@FirstName
           ,@RelationshipID
           ,GETDATE()
		   ,@VisitorID)
	
     Return 0;

