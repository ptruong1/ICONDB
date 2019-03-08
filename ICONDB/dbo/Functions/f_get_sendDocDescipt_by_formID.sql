Create FUNCTION [dbo].[f_get_sendDocDescipt_by_formID] (@formID int, @RequestDocID tinyint)
RETURNS VARCHAR(250)
AS BEGIN
    DECLARE @sendDocDescipt VARCHAR(200)

	set @sendDocDescipt =(select SendDocDescipt from [dbo].[tblInmateLegalRequestDetail] where FormID = @FormID and RequestDocID = @RequestDocID) 

    RETURN @sendDocDescipt
END