﻿-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_SELECT_InmateRequestForm_814]
(
	@InmateID varchar(12),
	@FacilityId int,
	@FormID int
)
AS
	SET NOCOUNT ON;
SELECT distinct  [FormID]
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
	  ,D.InmateKiteReceiveEmail
  FROM [tblInmateRequestForm] R,
   [tblInmate] I, [tblFacility] F, [tblTimeZone] T, tblFacilityForms D
				
WHERE I.FacilityId = R.FacilityID and I.InmateID = R.InmateID and
	R.FacilityID = F.FacilityID and F.timeZone = T.ZoneCode and
R.InmateID = @InmateID and R.FormID = @FormID AND  R.FacilityId = @FacilityId  and I.Status =1
and R.facilityId = D.FacilityId;
