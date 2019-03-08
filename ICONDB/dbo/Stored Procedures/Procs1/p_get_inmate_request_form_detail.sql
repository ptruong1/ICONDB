CREATE proc [dbo].[p_get_inmate_request_form_detail] 
	@FormID int
as
begin
BEGIN TRY
	SELECT i.[FormID]
      ,i.BookingNo
	  ,i.InmateLocation
	  ,i.RequestDate
	  ,s.Descript as FormsTatusDescript
	  ,r.Descript as RequestFormType
	  ,i.ReplyName
	  ,i.ReplyDateTime
	  ,i.Request
	  ,i.Reply
	  ,i.DL
	  ,i.DOB
	  ,i.FacilityID
	  ,i.ReferTo
	FROM [dbo].[tblInmateRequestForm] i inner join tblFormstatus  s on (i.Status = s.statusID )
		 left join tblInmateRequestFormType r on (i.FormType=r.FormType)	
    where i.FormID  = @FormID ;  
END TRY
BEGIN CATCH
END CATCH;
end