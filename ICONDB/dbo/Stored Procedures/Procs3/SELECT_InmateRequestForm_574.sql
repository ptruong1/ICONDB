﻿-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SELECT_InmateRequestForm_574]
(
	@InmateID varchar(12),
	@FacilityId int,
	@FormID int
)
AS
	SET NOCOUNT ON;

SELECT distinct  R.FormID
      ,R.FacilityID
      ,R.InmateID
      ,[BookingNo]
      ,[InmateLocation]
      ,[RequestDate]
      ,[Request]
      ,isnull(Reply,'') as Reply
      ,isnull(ReplyName,'') as ReplyName
      ,isnull(ReplyDateTime,GETDATE()) as ReplyDateTime
      ,R.Status
      ,(FirstName + ' ' + LastName) as Name
      ,T.AMT as TimeZone
	  ,FormType
	  ,isnull(Property,'') as Property
      ,isnull(AcceptName, '') as AcceptName
  FROM [leg_Icon].[dbo].[tblInmateRequestForm] R,
   [leg_Icon].[dbo].[tblInmate] I, [leg_Icon].[dbo].[tblFacility] F, [leg_Icon].[dbo].[tblTimeZone] T
   left join [leg_Icon].[dbo].[tblInmateProperty] P on P.formID = @formID
				
WHERE I.FacilityId = R.FacilityID and I.InmateID = R.InmateID and
	R.FacilityID = F.FacilityID and F.timeZone = T.ZoneCode and
R.InmateID = @InmateID and R.FormID = @FormID AND  R.FacilityId = @FacilityId  and I.Status =1;
