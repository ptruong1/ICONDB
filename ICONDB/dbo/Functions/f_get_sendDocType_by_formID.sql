CREATE FUNCTION [dbo].[f_get_sendDocType_by_formID] (@formID int, @RequestDocID tinyint)
RETURNS varchar(50)
AS BEGIN
    DECLARE @sendDocType varchar(50)

	set @sendDocType =(select d.Descript from [dbo].[tblInmateLegalRequestDetail] i join tblLegalDocType d
					   on i.SendDocType = d.DocTypeID
					   where FormID = @FormID and RequestDocID = @RequestDocID) 

    RETURN @sendDocType
END