﻿-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_SELECT_MedicalKite_Report]
(
	@InmateID varchar(12),
	@FacilityId int,
	@Status int
)
AS
	SET NOCOUNT ON;
SET @InmateID	 = rtrim(ltrim(@InmateID))
Declare @ID int
	set @ID = (Select Template from [leg_Icon].[dbo].[tblFacilityForms] where facilityID = @facilityID)
	--If @facilityid in (2, 558, 574, 578, 585, 684, 691) 
	--   set @ID = 0
	--else
	--	set @ID = 796
	--;
IF (@Status < 0)
Begin
	IF (@InmateID <> '')
		Begin
		SELECT distinct [FormID]
			  ,R.FacilityID
			  ,R.InmateID
			  ,[BookingNo]
			  ,[AliasName]
			  ,R.DOB
			  ,[RequestDate]
			  ,[InmateLocation]
			  ,[Dental]
			  ,[HIV]
			  ,[Medical]
			  ,[Psychiatric]
			  ,[DescriptOfProblem]
			  ,[LengthOfProblem]
			  ,[InmateSignature]
			  ,[Response]
			  ,[ReviewedBy]
			  ,[ReviewedDate]
			  ,[StaffNote]
			  ,[NoteBy]
			  ,[NoteDate]
			  ,R.Status
			  ,F.Descript
			  ,[MDClinic]
			  ,[Nurse]
			  ,[ChartReview]
			  ,[MentalHealth]
			  ,(FirstName + ' ' + LastName) as Name
				,(Select Template from [leg_Icon].[dbo].[tblFacilityForms] where facilityID = @facilityID) as Template
			--,FormType

		  FROM [leg_Icon].[dbo].[tblMedicalKiteForm] R
		   inner join [leg_Icon].[dbo].[tblInmate] I on R.FacilityId = I.FacilityID and R.InmateID = I.InmateID
			left join [leg_Icon].[dbo].[tblFormstatus] F on R.Status = F.statusID and F.FacilityFormId = @ID
				
		WHERE 
			  R.FacilityId = @FacilityId and
			  R.InmateID = @InmateID and
			  I.Status=1
			  order by FormID desc;
		End
	  Else
		Begin
		SELECT distinct  [FormID]
			  ,R.FacilityID
			  ,R.InmateID
			  ,[BookingNo]
			  ,[AliasName]
			  ,R.DOB
			  ,[RequestDate]
			  ,[InmateLocation]
			  ,[Dental]
			  ,[HIV]
			  ,[Medical]
			  ,[Psychiatric]
			  ,[DescriptOfProblem]
			  ,[LengthOfProblem]
			  ,[InmateSignature]
			  ,[Response]
			  ,[ReviewedBy]
			  ,[ReviewedDate]
			  ,[StaffNote]
			  ,[NoteBy]
			  ,[NoteDate]
			  ,R.Status
			  ,F.Descript
			  ,[MDClinic]
			  ,[Nurse]
			  ,[ChartReview]
			  ,[MentalHealth]
			  ,(FirstName + ' ' + LastName) as Name
			  ,(Select Template from [leg_Icon].[dbo].[tblFacilityForms] where facilityID = @facilityID) as Template
		  FROM [leg_Icon].[dbo].[tblMedicalKiteForm] R
		   inner join [leg_Icon].[dbo].[tblInmate] I on R.FacilityId = I.FacilityID and R.InmateID = I.InmateID
			left join [leg_Icon].[dbo].[tblFormstatus] F on R.Status = F.statusID and F.FacilityFormId = @ID
				
		WHERE 
			  R.FacilityId = @FacilityId  and I.Status=1
			  order by FormID desc;
		End
End
Else --Status > 0
Begin
	IF (@InmateID <> '')
		Begin
		SELECT  [FormID]
			  ,R.FacilityID
			  ,R.InmateID
			  ,[BookingNo]
			  ,[AliasName]
			  ,R.DOB
			  ,[RequestDate]
			  ,[InmateLocation]
			  ,[Dental]
			  ,[HIV]
			  ,[Medical]
			  ,[Psychiatric]
			  ,[DescriptOfProblem]
			  ,[LengthOfProblem]
			  ,[InmateSignature]
			  ,[Response]
			  ,[ReviewedBy]
			  ,[ReviewedDate]
			  ,[StaffNote]
			  ,[NoteBy]
			  ,[NoteDate]
			  ,R.Status
			  ,F.Descript
			  ,[MDClinic]
			  ,[Nurse]
			  ,[ChartReview]
			  ,[MentalHealth]
			  ,(FirstName + ' ' + LastName) as Name
				,(Select Template from [leg_Icon].[dbo].[tblFacilityForms] where facilityID = @facilityID) as Template
		  FROM [leg_Icon].[dbo].[tblMedicalKiteForm] R
		   inner join [leg_Icon].[dbo].[tblInmate] I on R.FacilityId = I.FacilityID and R.InmateID = I.InmateID
			left join [leg_Icon].[dbo].[tblFormstatus] F on R.Status = F.statusID and F.FacilityFormId = @ID
				
		WHERE 
			  R.FacilityId = @FacilityId and
			  R.InmateID = @InmateID and
			  R.Status = @Status and
			  I.Status=1
			  order by FormID desc;
		End
	  Else
		Begin
		SELECT  [FormID]
			  ,R.FacilityID
			  ,R.InmateID
			  ,[BookingNo]
			  ,[AliasName]
			  ,R.DOB
			  ,[RequestDate]
			  ,[InmateLocation]
			  ,[Dental]
			  ,[HIV]
			  ,[Medical]
			  ,[Psychiatric]
			  ,[DescriptOfProblem]
			  ,[LengthOfProblem]
			  ,[InmateSignature]
			  ,[Response]
			  ,[ReviewedBy]
			  ,[ReviewedDate]
			  ,[StaffNote]
			  ,[NoteBy]
			  ,[NoteDate]
			  ,R.Status
			  ,F.Descript
			  ,[MDClinic]
			  ,[Nurse]
			  ,[ChartReview]
			  ,[MentalHealth]
			  ,(FirstName + ' ' + LastName) as Name
			  ,(Select Template from [leg_Icon].[dbo].[tblFacilityForms] where facilityID = @facilityID) as Template
		  FROM [leg_Icon].[dbo].[tblMedicalKiteForm] R
		   inner join [leg_Icon].[dbo].[tblInmate] I on R.FacilityId = I.FacilityID and R.InmateID = I.InmateID
			left join [leg_Icon].[dbo].[tblFormstatus] F on R.Status = F.statusID and F.FacilityFormId = @ID
				
		WHERE 
			  R.FacilityId = @FacilityId and
			  R.Status = @Status and
			  I.Status=1
			  order by FormID desc;
		End
End
