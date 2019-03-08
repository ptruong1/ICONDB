




CREATE PROCEDURE [dbo].[UPDATE_InmateLegalRecord_Detail_796]
(
	@formID int,
	@RequestDocID int,
	@SendDocType int,
	@Pages int,
	@SendDocDescipt varchar(200)
	
)
AS
	
SET NOCOUNT OFF;
UPDATE [dbo].[tblInmateLegalRequestDetail]
   
 SET   [SendDocType] = @SendDocType
      ,[SendDocDescipt] = @SendDocDescipt
      ,[Pages] = @Pages
 WHERE formID = @FormID 
 and RequestDocID = @RequestDocID

 ;



