-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SELECT_InmateRequestRecords_V1]
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
	 
		  FROM [leg_Icon].[dbo].[tblInmateRequestForm] R
		   inner join [leg_Icon].[dbo].[tblInmate] I on R.FacilityId = I.FacilityID and R.InmateID = I.InmateID
		   inner join [leg_Icon].[dbo].[tblFormstatus] F on R.Status = F.statusID 
				
		WHERE 
			  R.FacilityId = @FacilityId and
			  R.InmateID = @InmateID 
			  --and I.Status =1
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
      
		  FROM [leg_Icon].[dbo].[tblInmateRequestForm] R
		   inner join [leg_Icon].[dbo].[tblInmate] I on R.FacilityId = I.FacilityID and R.InmateID = I.InmateID
		   inner join [leg_Icon].[dbo].[tblFormstatus] F on R.Status = F.statusID
   			
		WHERE 
			  R.FacilityId = @FacilityId   
			  --and I.Status =1
			  order by FormID desc ;
	End
end
Else ---Status > 0
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
	 
			  FROM [leg_Icon].[dbo].[tblInmateRequestForm] R
			   inner join [leg_Icon].[dbo].[tblInmate] I on R.FacilityId = I.FacilityID and R.InmateID = I.InmateID
				inner join [leg_Icon].[dbo].[tblFormstatus] F on R.Status = F.statusID
				
			WHERE 
				  R.FacilityId = @FacilityId and
				  R.InmateID = @InmateID and
				  R.Status = @Status  
				  --and I.Status =1
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
      
			  FROM [leg_Icon].[dbo].[tblInmateRequestForm] R
			   inner join [leg_Icon].[dbo].[tblInmate] I on R.FacilityId = I.FacilityID and R.InmateID = I.InmateID
				inner join [leg_Icon].[dbo].[tblFormstatus] F on R.Status = F.statusID
				
			WHERE 
				  R.FacilityId = @FacilityId and
				  R.Status = @Status 
				  --and I.Status =1
				  order by FormID desc;
		End
end
