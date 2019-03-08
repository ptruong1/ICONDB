CREATE FUNCTION dbo.f_get_requestDoc_by_formID (@formID int, @RequestDocID tinyint)
RETURNS VARCHAR(250)
AS BEGIN
    DECLARE @requestDoc VARCHAR(200)

	set @requestDoc =(select RequestDoc from [dbo].[tblInmateLegalRequestDetail] where FormID = @FormID and RequestDocID = @RequestDocID) 

    RETURN @requestDoc
END