Create FUNCTION [dbo].[f_get_requestDocID_by_formID] (@formID int, @RequestDocID tinyint)
RETURNS tinyint
AS BEGIN
    DECLARE @requestDocID_out tinyint
	set @requestDocID_out =(select RequestDocID from [dbo].[tblInmateLegalRequestDetail] where FormID = @FormID and RequestDocID = @RequestDocID) 

    RETURN @requestDocID_out
END