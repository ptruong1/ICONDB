-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_SELECT_InmateKite_Report_V1]
(
	@InmateID varchar(12),
	@FacilityId int,
	@Status int,
	@FromDate datetime,
	@ToDate datetime
)
AS
	SET NOCOUNT ON;
SET @InmateID	 = rtrim(ltrim(@InmateID))
Declare @ID int
	set @ID = (Select Template from [leg_Icon].[dbo].[tblFacilityForms] where facilityID = @facilityID);
	
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

		  FROM [leg_Icon].[dbo].[tblInmateRequestForm] R
		   inner join [leg_Icon].[dbo].[tblInmate] I on R.FacilityId = I.FacilityID and R.InmateID = I.InmateID
		   left join [leg_Icon].[dbo].[tblFormstatus] F on R.Status = F.statusID and F.FacilityFormId = @ID
				
		WHERE 
			  R.FacilityId = @FacilityId and
			  R.InmateID = @InmateID and 
			  --I.Status =1 and
			  (RequestDate between @fromDate and dateadd(d,1,@todate) )
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

		  FROM [leg_Icon].[dbo].[tblInmateRequestForm] R
		   inner join [leg_Icon].[dbo].[tblInmate] I on R.FacilityId = I.FacilityID and R.InmateID = I.InmateID
		   left join [leg_Icon].[dbo].[tblFormstatus] F on R.Status = F.statusID and F.FacilityFormId = @ID
   			
		WHERE 
			  R.FacilityId = @FacilityId   and 
			  --I.Status =1 and
			  (RequestDate between @fromDate and dateadd(d,1,@todate) )
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

			  FROM [leg_Icon].[dbo].[tblInmateRequestForm] R
			   inner join [leg_Icon].[dbo].[tblInmate] I on R.FacilityId = I.FacilityID and R.InmateID = I.InmateID
				left join [leg_Icon].[dbo].[tblFormstatus] F on R.Status = F.statusID and F.FacilityFormId = @ID
				
			WHERE 
				  R.FacilityId = @FacilityId and
				  R.InmateID = @InmateID and
				  R.Status = @Status  and 
				  --I.Status =1 and
				  (RequestDate between @fromDate and dateadd(d,1,@todate) )
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

			  FROM [leg_Icon].[dbo].[tblInmateRequestForm] R
			   inner join [leg_Icon].[dbo].[tblInmate] I on R.FacilityId = I.FacilityID and R.InmateID = I.InmateID
				left join [leg_Icon].[dbo].[tblFormstatus] F on R.Status = F.statusID and F.FacilityFormId = @ID
				
			WHERE 
				  R.FacilityId = @FacilityId and
				  R.Status = @Status and 
				  --I.Status =1 and
				  (RequestDate between @fromDate and dateadd(d,1,@todate) )
				  order by FormID desc;
		End
end
