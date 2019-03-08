-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SELECT_InmateRequestRecords_05162017]
(
	@InmateID varchar(12),
	@FacilityId int,
	@Status int
)
AS
	SET NOCOUNT ON;
SET @InmateID	 = rtrim(ltrim(@InmateID))
IF (@Status < 0)
Begin	
	IF (@InmateID <> '')
	Begin
		SELECT distinct  [FormID]
			  ,R.FacilityID
			  ,R.InmateID
			  ,[BookingNo]
			  ,[InmateLocation]
			  ,[RequestDate]
			  ,[Request]
			  ,[Reply]
			  ,[ReplyName]
			  ,[ReplyDateTime]
			  ,R.Status
			  ,F.Descript
			  ,(FirstName + ' ' + LastName) as Name
			  ,(Select Template from [leg_Icon].[dbo].[tblFacilityForms] where facilityID = @facilityID) as Template
			  ,isnull(FormType,0) as FormType
			  ,isnull(R.DOB,'') as DOB
			  ,isnull(R.DL,'') as DL
			  ,isnull(OfficerID,0) as OfficerID
		  FROM [leg_Icon].[dbo].[tblInmateRequestForm] R
		   inner join [leg_Icon].[dbo].[tblInmate] I on R.FacilityId = I.FacilityID and R.InmateID = I.InmateID
		   inner join [leg_Icon].[dbo].[tblFormstatus] F on R.Status = F.statusID 
				
		WHERE 
			  R.FacilityId = @FacilityId and
			  R.InmateID = @InmateID and I.Status =1
			  order by FormID desc;
	End
	Else
	Begin
		SELECT distinct  [FormID]
			  ,R.FacilityID
			  ,R.InmateID
			  ,[BookingNo]
			  ,[InmateLocation]
			  ,[RequestDate]
			  ,[Request]
			  ,[Reply]
			  ,[ReplyName]
			  ,[ReplyDateTime]
			  ,R.Status
			  ,F.Descript
			  ,(FirstName + ' ' + LastName) as Name
			,(Select Template from [leg_Icon].[dbo].[tblFacilityForms] where facilityID = @facilityID) as Template
			,isnull(FormType,0) as FormType
			,isnull(R.DOB,'') as DOB
			  ,isnull(R.DL,'') as DL
			  ,isnull(OfficerID,0) as OfficerID
		  FROM [leg_Icon].[dbo].[tblInmateRequestForm] R
		   inner join [leg_Icon].[dbo].[tblInmate] I on R.FacilityId = I.FacilityID and R.InmateID = I.InmateID
		   inner join [leg_Icon].[dbo].[tblFormstatus] F on R.Status = F.statusID
   			
		WHERE 
			  R.FacilityId = @FacilityId   and I.Status =1
			  order by FormID desc ;
	End
end
Else ---Status > 0
Begin	
	IF (@InmateID <> '')
	Begin
			SELECT distinct [FormID]
				  ,R.FacilityID
				  ,R.InmateID
				  ,[BookingNo]
				  ,[InmateLocation]
				  ,[RequestDate]
				  ,[Request]
				  ,[Reply]
				  ,[ReplyName]
				  ,[ReplyDateTime]
				  ,R.Status
				  ,F.Descript
				  ,(FirstName + ' ' + LastName) as Name
				,(Select Template from [leg_Icon].[dbo].[tblFacilityForms] where facilityID = @facilityID) as Template
				,isnull(FormType,0) as FormType
				,isnull(R.DOB,'') as DOB
			  ,isnull(R.DL,'') as DL
			  ,isnull(OfficerID,0) as OfficerID
			  FROM [leg_Icon].[dbo].[tblInmateRequestForm] R
			   inner join [leg_Icon].[dbo].[tblInmate] I on R.FacilityId = I.FacilityID and R.InmateID = I.InmateID
				inner join [leg_Icon].[dbo].[tblFormstatus] F on R.Status = F.statusID
				
			WHERE 
				  R.FacilityId = @FacilityId and
				  R.InmateID = @InmateID and
				  R.Status = @Status  and I.Status =1
				  order by FormID desc;
		End
	Else
		Begin
			SELECT distinct [FormID]
				  ,R.FacilityID
				  ,R.InmateID
				  ,[BookingNo]
				  ,[InmateLocation]
				  ,[RequestDate]
				  ,[Request]
				  ,[Reply]
				  ,[ReplyName]
				  ,[ReplyDateTime]
				  ,R.Status
				  ,F.Descript
				  ,(FirstName + ' ' + LastName) as Name
				,(Select Template from [leg_Icon].[dbo].[tblFacilityForms] where facilityID = @facilityID) as Template
			,isnull(FormType,0) as FormType
			,isnull(R.DOB,'') as DOB
			  ,isnull(R.DL,'') as DL
			  ,isnull(OfficerID,0) as OfficerID
			  FROM [leg_Icon].[dbo].[tblInmateRequestForm] R
			   inner join [leg_Icon].[dbo].[tblInmate] I on R.FacilityId = I.FacilityID and R.InmateID = I.InmateID
				inner join [leg_Icon].[dbo].[tblFormstatus] F on R.Status = F.statusID
				
			WHERE 
				  R.FacilityId = @FacilityId and
				  R.Status = @Status and I.Status =1
				  order by FormID desc;
		End
end
