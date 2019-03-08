create proc p_insert_InmateLegalRequest_detail
			   @FormID int,
			   @RequestDocID tinyint,
			   @RequestDoc varchar(200)
As
Begin
	BEGIN TRY
		INSERT INTO [dbo].[tblInmateLegalRequestDetail]
				   ([FormID]
				   ,[RequestDocID]
				   ,[RequestDoc]
				   )
			 VALUES
				   (@FormID,
					@RequestDocID,
					@RequestDoc)
	END TRY
BEGIN CATCH
END CATCH;
End