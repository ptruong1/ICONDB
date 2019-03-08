-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_Insert_Update_Inmate_FormConfig_11092017]
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
	
	------Kite note
		if (@UserNote <>'')
		begin
			Declare @return_value int, @nextID int, @ID int, @tblInmateNote nvarchar(32) ;
			EXEC	@return_value = p_create_nextID 'tblInmateNote', @nextID   OUTPUT
			set		@ID = @nextID	;
			INSERT INTO tblInmateNote ([NoteID],[NoteTypeID],[FacilityID] ,[InmateID], [Note], [InputDate], [UserName])
			 VALUES (@ID ,4,@FacilityId, @InmateID, @UserNote, getdate(), @UserName);
		end

