-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SELECT_MedicalKiteRecords]
(
	@InmateID varchar(12),
	@FacilityId int,
	@Status int
)
AS
	SET NOCOUNT ON;
SET @InmateID	 = rtrim(ltrim(@InmateID))

--- Modify on 12/9/2016 for inmate statu acitive only

IF (@Status < 0)
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
      
		  FROM [leg_Icon].[dbo].[tblMedicalKiteForm] R
		   inner join [leg_Icon].[dbo].[tblInmate] I on R.FacilityId = I.FacilityID and R.InmateID = I.InmateID
			inner join [leg_Icon].[dbo].[tblFormstatus] F on R.Status = F.statusID
				
		WHERE 
			  R.FacilityId = @FacilityId and
			  R.InmateID = @InmateID and
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
		  FROM [leg_Icon].[dbo].[tblMedicalKiteForm] R
		   inner join [leg_Icon].[dbo].[tblInmate] I on R.FacilityId = I.FacilityID and R.InmateID = I.InmateID
			inner join [leg_Icon].[dbo].[tblFormstatus] F on R.Status = F.statusID
				
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
      
		  FROM [leg_Icon].[dbo].[tblMedicalKiteForm] R
		   inner join [leg_Icon].[dbo].[tblInmate] I on R.FacilityId = I.FacilityID and R.InmateID = I.InmateID
			inner join [leg_Icon].[dbo].[tblFormstatus] F on R.Status = F.statusID
				
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
		  FROM [leg_Icon].[dbo].[tblMedicalKiteForm] R
		   inner join [leg_Icon].[dbo].[tblInmate] I on R.FacilityId = I.FacilityID and R.InmateID = I.InmateID
			inner join [leg_Icon].[dbo].[tblFormstatus] F on R.Status = F.statusID
				
		WHERE 
			  R.FacilityId = @FacilityId and
			  R.Status = @Status and
			  I.Status=1
			  order by FormID desc;
		End
End
