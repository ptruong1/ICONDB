CREATE FUNCTION [dbo].[f_get_pages_by_formID] (@formID int, @RequestDocID tinyint)
RETURNS smallint
AS BEGIN
    DECLARE @pages smallint

	set @pages =(select Pages from [dbo].[tblInmateLegalRequestDetail] where FormID = @FormID and RequestDocID = @RequestDocID) 

    RETURN @pages
END