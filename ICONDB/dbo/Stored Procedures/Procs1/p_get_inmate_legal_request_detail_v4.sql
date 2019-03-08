CREATE proc [dbo].[p_get_inmate_legal_request_detail_v4] 
	@FormID int
as
begin
BEGIN TRY
	SELECT G.[FormID]
      ,G.[Status] as [StatusID]   
	  ,F.Descript as [Status]
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
	  , dbo.f_get_requestDocID_by_formID (@FormID , 1) as requestDocID1
	  , dbo.f_get_requestDoc_by_formID (@FormID , 1) as RequestDoc1
	  , dbo.f_get_sendDocType_by_formID (@FormID , 1) as SendDocType1
	  , dbo.f_get_sendDocDescipt_by_formID (@FormID , 1) as SendDocDescipt1
	  , dbo.f_get_pages_by_formID (@FormID , 1) as Spages1
	  , dbo.f_get_requestDocID_by_formID (@FormID , 2) as requestDocID2
	  , dbo.f_get_requestDoc_by_formID (@FormID , 2) as RequestDoc2
	  , dbo.f_get_sendDocType_by_formID (@FormID , 2) as SendDocType2
	  , dbo.f_get_sendDocDescipt_by_formID (@FormID , 2) as SendDocDescipt2
	  , dbo.f_get_pages_by_formID (@FormID , 2) as Spages2
	  , dbo.f_get_requestDocID_by_formID (@FormID , 3) as requestDocID3
	  , dbo.f_get_requestDoc_by_formID (@FormID , 3) as RequestDoc3
	  , dbo.f_get_sendDocType_by_formID (@FormID , 3) as SendDocType3
	  , dbo.f_get_sendDocDescipt_by_formID (@FormID , 3) as SendDocDescipt3
	  , dbo.f_get_pages_by_formID (@FormID , 3) as Spages3
	  , dbo.f_get_requestDocID_by_formID (@FormID , 4) as requestDocID4
	  , dbo.f_get_requestDoc_by_formID (@FormID , 4) as RequestDoc4
	  , dbo.f_get_sendDocType_by_formID (@FormID , 4) as SendDocType4
	  , dbo.f_get_sendDocDescipt_by_formID (@FormID , 4) as SendDocDescipt4
	  , dbo.f_get_pages_by_formID (@FormID , 4) as Spages4
	  , dbo.f_get_requestDocID_by_formID (@FormID , 5) as requestDocID5
	  , dbo.f_get_requestDoc_by_formID (@FormID , 5) as RequestDoc5
	  , dbo.f_get_sendDocType_by_formID (@FormID , 5) as SendDocType5
	  , dbo.f_get_sendDocDescipt_by_formID (@FormID , 4) as SendDocDescipt5
	  , dbo.f_get_pages_by_formID (@FormID , 5) as Spages5
	FROM [dbo].[tblInmateLegalRequest] G inner join tblInmate  I on (G.FacilityID = I.FacilityId and G.InmateID =I.InmateID )
    Inner join tblFormstatus F on (G.Status = F.statusID)
    where G.FormID  = @FormID ;  
END TRY
BEGIN CATCH

END CATCH;
end