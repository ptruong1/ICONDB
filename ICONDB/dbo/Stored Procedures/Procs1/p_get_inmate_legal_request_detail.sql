CREATE proc p_get_inmate_legal_request_detail 
	@FormID int
as
begin
BEGIN TRY
	SELECT G.[FormID]
      ,G.[Status] as [StatusID]   
      ,G.[FacilityID]
	  ,G.[InmateID]
	  ,I.LastName
	  ,I.FirstName 
	  ,I.MidName 
	  ,G.BookingNo
	  ,G.HousingUnit
      ,[AgencyID]
	  ,OtherAgency
      ,[Sentence]
      ,[LawyerRepresent]
      ,[LawyerType]
      ,[CAcriminal]
      ,[CAcivil]
      ,[FEDcriminal]
      ,[FEDcivil]
      ,[ICE]
      ,[Administrative]
      ,[OtherState]
      ,[OtherCase]
      ,[NextCourtDate]
      ,[RequestDate]
      ,[RecordDate]
      ,[ReceivedDate]
      ,[ReceivedBy]
      ,[SendDate]
      ,[SendBy]
      ,[TrackingNo]
      ,[IDX]
      ,[CourtCert]
	  , dbo.f_get_requestDoc_by_formID (@FormID , 1) as RequestDoc1
	  , dbo.f_get_requestDoc_by_formID (@FormID , 2) as RequestDoc2
	  , dbo.f_get_requestDoc_by_formID (@FormID , 3) as RequestDoc3
	  , dbo.f_get_requestDoc_by_formID (@FormID , 4) as RequestDoc4
	  , dbo.f_get_requestDoc_by_formID (@FormID , 5) as RequestDoc5
	FROM [dbo].[tblInmateLegalRequest] G inner join tblInmate  I on (G.FacilityID = I.FacilityId and G.InmateID =I.InmateID )
    Inner join tblFormstatus F on (G.Status = F.statusID)
    where G.FormID  = @FormID ;  
END TRY
BEGIN CATCH

END CATCH;
end