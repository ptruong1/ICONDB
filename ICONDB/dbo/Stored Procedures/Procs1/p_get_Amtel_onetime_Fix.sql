-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_Amtel_onetime_Fix]
AS
BEGIN
	select a.FacilityID, PIN , InmateID, RecordID ,b.FTPfolderName,Fromno, callType , billtype,tono, Dateadd(second, -duration, recordDate) as start_date_time,  Ceiling( Duration/60.0) As Duration,CallRevenue,
       CreditCardNo , Ceiling(AcDuration/60.0)  as offHoodDuration, RecordFile from tblCallsbilled a, tblFacilityOption b where a.FacilityID =b.FacilityID and  AgentID =102 and RecordDate > '3/13/2018' and RecordDate  < '2018-03-22 11:34:14.607' order by RecordDate

	
		
END

