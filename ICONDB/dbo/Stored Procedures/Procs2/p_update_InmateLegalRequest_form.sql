CREATE PROCEDURE [dbo].[p_update_InmateLegalRequest_form]
			@FacilityID  int,
            @FormID int,
            @Status tinyint           
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	SET NOCOUNT ON;

	Declare @RequestDate datetime, @LocationID int, @timeZone tinyint;
	SET @timeZone =0;
	--SET @timeZone = (select timeZone from tblfacility where FacilityID =@FacilityID ); 
	--SET @RequestDate = dateadd(hour,@timeZone, GETDATE()); 
	--SET @RequestTime = dateadd(hour,@timeZone, GETDATE());
	update[leg_Icon].[dbo].[tblInmateLegalRequest] set Status = @Status  where FormID = @FormID  ;
    
	SELECT G.[FormID]
      ,G.[Status] as [StatusID]   
      ,G.[FacilityID]
	  ,G.[InmateID],(I.FirstName + ' ' + I.LastName) as InmateName 
      ,[AgencyID]
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

    Return @@error;
END
