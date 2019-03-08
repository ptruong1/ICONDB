
CREATE PROCEDURE [dbo].[p_update_InmateLegalRequest_form_V1]
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

    Return @@error;
END
