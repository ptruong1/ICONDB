-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_document_byFormId]
(
	
	@FormId int

)
AS
	SET NOCOUNT ON;

	SELECT [FormID]
      ,[RequestDocID]
      ,[RequestDoc]
      ,isnull(SendDocType,0) as SendDocType
      ,Isnull(SendDocDescipt,'') as SendDocDescipt
      ,isNull(Pages,0) as Pages
  FROM [leg_Icon].[dbo].[tblInmateLegalRequestDetail]
  where formId = @FormId 
  order by [RequestDocID]

--Declare @t table ([FormID] int,[RequestDocID] int ,[Document] varchar(200),[SendDocType] tinyint,[Pages] int);
--   insert @t
--	Select [FormID],[RequestDocID],[RequestDoc],[SendDocType],0
--	  FROM [leg_Icon].[dbo].[tblInmateLegalRequestDetail] where formId = @FormId
--	  order by requestDocID
--   insert @t
--	Select [FormID],[RequestDocID],[SendDocType],[SendDocDescipt],[Pages]
--	  FROM [leg_Icon].[dbo].[tblInmateLegalRequestDetail] where formId = @FormId
--	  order by requestDocID

--   select * from @t
