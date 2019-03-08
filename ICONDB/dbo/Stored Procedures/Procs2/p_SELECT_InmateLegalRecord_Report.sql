-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_SELECT_InmateLegalRecord_Report]
(
	@InmateID varchar(12),
	@FacilityId int,
	@Status int
)
AS
	SET NOCOUNT ON;
SET @InmateID	 = rtrim(ltrim(@InmateID))
Declare @ID int
	set @ID = (Select Template from [leg_Icon].[dbo].[tblFacilityForms] where facilityID = @facilityID);
	--If @facilityid in (2, 558, 574, 578, 585, 684, 691) 
	--   set @ID = 0
	--else
	--	set @ID = 796
	--;
IF (@Status < 0)
Begin	
	IF (@InmateID <> '')
	Begin
		SELECT distinct  R.FormID
           ,R.FacilityID
      ,R.InmateID
	  ,[CourtCert]
	  ,LastName as LastName
	  ,FirstName as FirstName
	  ,MidName as Initial
	  ,[RequestDate]
	  ,[NextCourtDate]
	  ,[AgencyID] 
	  --,'Local or Other' as localOrothers
	  ,[Sentence] as Sentenced
	  ,[LawyerRepresent]
	  ,[LawyerType]
      ,[CAcriminal]
      ,[CAcivil]
      ,[FEDcriminal]
      ,[FEDcivil]
      ,[OtherState]
      ,[Administrative]
      ,ICE
      ,[OtherCase]
      --,[AgencyID] as 'Public, court, Private'
      ,[RecordDate]
      ,[ReceivedDate]
      ,[ReceivedBy]
      ,F.Descript
      ,(Select Template from [leg_Icon].[dbo].[tblFacilityForms] where facilityID = @facilityID) as Template
	  ,R.Status

		  FROM [leg_Icon].[dbo].[tblInmateLegalRequest] R
		   inner join [leg_Icon].[dbo].[tblInmate] I on R.FacilityId = I.FacilityID and R.InmateID = I.InmateID
		   left join [leg_Icon].[dbo].[tblFormstatus] F on R.Status = F.statusID and F.FacilityFormId = @ID 
	WHERE 
			  R.FacilityId = @FacilityId and
			  R.InmateID = @InmateID and I.Status =1
			  order by R.FormID desc;
	End
	Else
	Begin
		SELECT distinct  R.FormID
           ,R.FacilityID
      ,R.InmateID
	  ,[CourtCert]
	  ,LastName as LastName
	  ,FirstName as FirstName
	  ,MidName as Initial
	  ,[RequestDate]
	  ,[NextCourtDate]
	  ,[AgencyID] 
	  --,'Local or Other' as localOrothers
	  ,[Sentence] as Sentenced
	  ,[LawyerRepresent]
	  ,[LawyerType]
      ,[CAcriminal]
      ,[CAcivil]
      ,[FEDcriminal]
      ,[FEDcivil]
      ,[OtherState]
      ,[Administrative]
      ,ICE
      ,[OtherCase]
      --,[AgencyID] as 'Public, court, Private'
      ,[RecordDate]
      ,[ReceivedDate]
      ,[ReceivedBy]
      ,F.Descript
      ,(Select Template from [leg_Icon].[dbo].[tblFacilityForms] where facilityID = @facilityID) as Template
	  ,R.Status

		  FROM [leg_Icon].[dbo].[tblInmateLegalRequest] R
		   inner join [leg_Icon].[dbo].[tblInmate] I on R.FacilityId = I.FacilityID and R.InmateID = I.InmateID
		   left join [leg_Icon].[dbo].[tblFormstatus] F on R.Status = F.statusID and F.FacilityFormId = @ID
	WHERE 
			  R.FacilityId = @FacilityId   and I.Status =1
			  order by FormID desc ;
	End
end
Else ---Status > 0
Begin	
	IF (@InmateID <> '')
	Begin
			SELECT distinct  R.FormID
           ,R.FacilityID
      ,R.InmateID
	  ,[CourtCert]
	  ,LastName as LastName
	  ,FirstName as FirstName
	  ,MidName as Initial
	  ,[RequestDate]
	  ,[NextCourtDate]
	  ,[AgencyID] 
	  --,'Local or Other' as localOrothers
	  ,[Sentence] as Sentenced
	  ,[LawyerRepresent]
	  ,[LawyerType]
      ,[CAcriminal]
      ,[CAcivil]
      ,[FEDcriminal]
      ,[FEDcivil]
      ,[OtherState]
      ,[Administrative]
      ,ICE
      ,[OtherCase]
      --,[AgencyID] as 'Public, court, Private'
      ,[RecordDate]
      ,[ReceivedDate]
      ,[ReceivedBy]
      ,F.Descript
      ,(Select Template from [leg_Icon].[dbo].[tblFacilityForms] where facilityID = @facilityID) as Template
	  ,R.Status

		  FROM [leg_Icon].[dbo].[tblInmateLegalRequest] R
		   inner join [leg_Icon].[dbo].[tblInmate] I on R.FacilityId = I.FacilityID and R.InmateID = I.InmateID
		   left join [leg_Icon].[dbo].[tblFormstatus] F on R.Status = F.statusID and F.FacilityFormId = @ID
	WHERE 
				  R.FacilityId = @FacilityId and
				  R.InmateID = @InmateID and
				  R.Status = @Status  and I.Status =1
				  order by FormID desc;
		End
	Else
		Begin
			SELECT distinct  R.FormID
           ,R.FacilityID
      ,R.InmateID
	  ,[CourtCert]
	  ,LastName as LastName
	  ,FirstName as FirstName
	  ,MidName as Initial
	  ,[RequestDate]
	  ,[NextCourtDate]
	  ,[AgencyID] 
	  --,'Local or Other' as localOrothers
	  ,[Sentence] as Sentenced
	  ,[LawyerRepresent]
	  ,[LawyerType]
      ,[CAcriminal]
      ,[CAcivil]
      ,[FEDcriminal]
      ,[FEDcivil]
      ,[OtherState]
      ,[Administrative]
      ,ICE
      ,[OtherCase]
      --,[AgencyID] as 'Public, court, Private'
      ,[RecordDate]
      ,[ReceivedDate]
      ,[ReceivedBy]
      ,F.Descript
      ,(Select Template from [leg_Icon].[dbo].[tblFacilityForms] where facilityID = @facilityID) as Template
	  ,R.Status

		  FROM [leg_Icon].[dbo].[tblInmateLegalRequest] R
		   inner join [leg_Icon].[dbo].[tblInmate] I on R.FacilityId = I.FacilityID and R.InmateID = I.InmateID
		   left join [leg_Icon].[dbo].[tblFormstatus] F on R.Status = F.statusID and F.FacilityFormId = @ID
	WHERE 
				  R.FacilityId = @FacilityId and
				  R.Status = @Status and I.Status =1
				  order by FormID desc;
		End
end
