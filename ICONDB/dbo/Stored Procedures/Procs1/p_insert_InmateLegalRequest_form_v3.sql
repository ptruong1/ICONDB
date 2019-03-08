CREATE proc [dbo].[p_insert_InmateLegalRequest_form_v3]
           @FacilityID int,
           @InmateID varchar(12),
		   @BookingNo varchar(15),
		   @HousingUnit varchar(20),
		   @AgencyID tinyint,
		   @OtherAgency varchar(50),
           @Sentence bit,
           @LawyerRepresent bit,
           @LawyerType tinyint,
           @CAcriminal bit,
           @CAcivil bit,
           @FEDcriminal bit,
           @FEDcivil bit,
           @ICE bit,
           @Administrative bit,
           @OtherState varchar(50),
           @OtherCase varchar(50),
		   @CourtCert bit,
           @NextCourtDate datetime,
		   @RequestDoc1 varchar(200),
		   @RequestDoc2 varchar(200),
		   @RequestDoc3 varchar(200),
		   @RequestDoc4 varchar(200),
		   @RequestDoc5 varchar(200)
as
begin
SET NOCOUNT ON;
Declare @RequestDate datetime, @LocationID int, @timeZone tinyint,@FormID  int, @Status tinyint, @RequestDocID tinyint, @FacilityFormID int;
--SET @FormID =0;
SET @Status=1;
SET @timeZone =0;
SET @FacilityFormID =1;
SET @timeZone = (select timeZone from tblfacility where FacilityID =@FacilityID ); 
SET @RequestDate = dateadd(hour,@timeZone, GETDATE()); 

BEGIN TRY
	--set @FormID = IDENT_CURRENT ('[dbo].[tblInmateLegalRequest]')
	Declare  @return_value int, @nextID int, @ID int, @tblInmateLegalRequest nvarchar(32) ;
	EXEC   @return_value = p_create_nextID 'tblInmateLegalRequest', @nextID   OUTPUT
    set           @FormID = @nextID ; 
	--if(@FacilityID=796) set @status=20
	Select @FacilityFormID = isnull(legaltemplate,1) from  tblFacilityForms where FacilityID = @FacilityID ;

	Select @status = statusID from tblFormstatus with(nolock) where FacilityFormID= @FacilityFormID and Descript='Submitted';
	
	INSERT INTO [Leg_ICON].[dbo].[tblInmateLegalRequest]
			   (FormID
			   ,[Status]
			   ,[FacilityID]
			   ,[InmateID]
			   ,[BookingNo]
				,[HousingUnit]
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
			   ,[RequestDate],
			   [CourtCert]
			   )
		 VALUES
			   (@FormID,
				@Status,
				@FacilityID, 
				@InmateID,
				@BookingNo,
				@HousingUnit,
				@AgencyID,
				@OtherAgency,
				@Sentence,
				@LawyerRepresent,
				@LawyerType,
				@CAcriminal,
				@CAcivil,
				@FEDcriminal,
				@FEDcivil,
				@ICE, 
				@Administrative,
				@OtherState,
				@OtherCase,
				@NextCourtDate,
				@RequestDate,
				@CourtCert
				)
				--------------------------------------------------
			  set @RequestDocID=0;
			  if len(@RequestDoc1)>0  
			  begin
				set @RequestDocID = @RequestDocID +1;
				exec [dbo].p_insert_InmateLegalRequest_detail @FormID, @RequestDocID, @RequestDoc1
			  end 
			  if len(@RequestDoc2)>0  
			  begin
				set @RequestDocID = @RequestDocID +1;
				exec [dbo].p_insert_InmateLegalRequest_detail @FormID, @RequestDocID, @RequestDoc2
			  end 
			  if len(@RequestDoc3)>0  
			  begin
				set @RequestDocID = @RequestDocID +1;
				exec [dbo].p_insert_InmateLegalRequest_detail @FormID, @RequestDocID, @RequestDoc3
			  end 
			  if len(@RequestDoc4)>0  
			  begin
				set @RequestDocID = @RequestDocID +1;
				exec [dbo].p_insert_InmateLegalRequest_detail @FormID, @RequestDocID, @RequestDoc4
			  end 
			  if len(@RequestDoc5)>0  
			  begin
				set @RequestDocID = @RequestDocID +1;
				exec [dbo].p_insert_InmateLegalRequest_detail @FormID, @RequestDocID, @RequestDoc5
			  end 
				--------------------------------------------------------
	--=================================================================================
	SELECT G.[FormID]
      ,G.[Status] as [StatusID]   
	  , F.Descript as [Status]
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
print'error'
END CATCH;

end