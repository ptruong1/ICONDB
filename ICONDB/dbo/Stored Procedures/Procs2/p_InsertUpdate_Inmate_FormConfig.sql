-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_InsertUpdate_Inmate_FormConfig]
(@FacilityID int
           ,@InmateID varchar(12)
           ,@FormType tinyint
           ,@PerDay tinyint
           ,@PerWeek tinyint
           ,@PerMonth tinyint
           ,@UserName varchar(25)
           ,@UserNote varchar(150))
AS
	SET NOCOUNT ON;
	if (select count(*) FROM [leg_Icon].[dbo].[tblFormInmateConfig] C WHERE C.InmateID = @InmateID AND  C.FacilityId = @FacilityId and C.FormType = @FormType) > 0
	begin
	UPDATE [dbo].[tblFormInmateConfig]
   SET 
      [PerDay] = @PerDay
      ,[PerWeek] = @PerWeek
      ,[PerMonth] = @PerMonth
      ,[ModifyDate] = getDate()
      ,[UserName] = @UserName
      ,[UserNote] = @UserNote
					
		WHERE InmateID = @InmateID AND  FacilityId = @FacilityId and FormType = @FormType
	end
	Else
	begin
	INSERT INTO [dbo].[tblFormInmateConfig]
           ([FacilityID]
           ,[InmateID]
           ,[FormType]
           ,[PerDay]
           ,[PerWeek]
           ,[PerMonth]
           ,[InputDate]
           ,[UserName]
           ,[UserNote])
     VALUES
           (@FacilityID
           ,@InmateID
           ,@FormType
           ,@PerDay
           ,@PerWeek
           ,@PerMonth
           ,getDate()
           ,@UserName
           ,@UserNote)
	end
  

