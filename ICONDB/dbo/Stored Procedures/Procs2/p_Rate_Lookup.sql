
CREATE PROCEDURE [dbo].[p_Rate_Lookup]
@FacilityID	int
 AS

Declare @RateID	varchar(7)
Select @RateID	  = RateplanID from tblFacility with(nolock) where FacilityID = @FacilityID
select distinct tbldaycode.Descript DayAndTime,  tblrateplanDetail.Description CallType,CollectCallFee as ConnectFee , FirstMin ,AddlMin  from   
tblrateplanDetail  with(nolock), tbldaycode with(nolock)   where tblrateplanDetail.DayCode =tbldaycode.daycode and  rateID = @RateID  AND  Mileagecode ='9999'

