
CREATE PROCEDURE [dbo].[p_Link_Annalysis]
@FacilityID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime  -- Required 

 AS
Declare @temp Table (FacilityID int, PhoneID varchar(20) Null, RecordID varchar(12) Null, toNo varchar(16) Null, startTime datetime Null, 
ConnectDateTime datetime Null, CallingCard varchar(20) Null,  InmateID varchar(12) Null, Fname varchar(25) Null, LName varchar(25) Null, 
BillType varchar(40) Null, CallType varchar(40) Null, State varchar(30) Null, Duration decimal(10,2) Null,  CallRevenue Decimal(10, 2) Null, 
Descript varchar(40) Null, RecordFile varchar(50) Null, RecordID2 varchar(12) Null, DOB varchar(10) Null, Sex varchar(12) Null, Race varchar(30) Null, CallCount int, ShapeId tinyint)

Declare @temp1 Table (InmateID varchar(12) Null, toNo varchar(16) Null,  CallCount int)    

insert @Temp(FacilityID, PhoneID, RecordID, toNo, startTime, ConnectDateTime, CallingCard, InmateID, BillType, CallType, State, 
Duration , CallRevenue, Descript, RecordFile, RecordID2) 

(Select c.facilityID, left( A.StationID, 20) PhoneID, RecordID,  Left(toNo, 12) As toNo,  
DATEADD(second, - duration, recordDate) as startTime,  RecordDate As ConnectDateTime,  
(case C.Billtype when '07' then left(CreditcardNo,16) else '' end ) CallingCard, Left(C.InmateID, 12) As InmateID,  Left(B.Descript, 40)  As  BillType,  
Left(T.Descript, 40)  As CallType,  'Completed' As  State,  CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2))  as Duration,  
CallRevenue,  Left(P.Descript, '') as Descript,  RecordFile, 
(select recordID from leg_Icon.dbo.tblRecordingTransMatch M where C.RecordID = M.RecordID ) as RecordID2
  

From [leg_Icon].[dbo].tblcallsBilled  C WITH(NOLOCK),  [leg_Icon].[dbo].tblBilltype B WITH(NOLOCK),  
[leg_Icon].[dbo].tblCallType T WITH(NOLOCK) ,  [leg_Icon].[dbo].tblANIs A,  [leg_Icon].[dbo].tblPhonetypes P 
where  C.fromno = A.ANINo and convert (int,duration ) >5 
and C.Billtype = B.billtype and C.CallType = T.Abrev 
and isnull(C.PhoneType,'3') = P.PhoneType 
and C.FacilityID = A.FacilityID  and C.FacilityID = 352 
and (C.RecordDate between @fromDate and dateadd(d,1,@toDate))) 
  

insert @temp1(InmateID, toNo,  CallCount) 

select inmateID, toNo, sum(1) as callcount
from @temp D

group by inmateID, toNo

--select * from @temp1

Update @temp set Fname = Left(FirstName, 25), LName =  Left(LastName,25),DOB =  Left(I.DOB, 10), Sex= Left(S.Descript, 12), Race= Left(R.Descript, 30),

callCount = (select top 1 callcount from @temp1 where C.InmateID = inmateID and C.toNo = toNo and C.inmateID <> '0'),
shapeId = (
	case when (select top 1 callcount from @temp1 where C.InmateID = inmateID and C.toNo = toNo and C.inmateID <> '0') > 3 then 4 
	when (select top 1 callcount from @temp1 where C.InmateID = inmateID and C.toNo = toNo and C.inmateID <> '0') = 1 then 1 
	when (select top 1 callcount from @temp1 where C.InmateID = inmateID and C.toNo = toNo and C.inmateID <> '0') = 2 then 2
	when (select top 1 callcount from @temp1 where C.InmateID = inmateID and C.toNo = toNo and C.inmateID <> '0') = 3 then 3
	when (select top 1 callcount from @temp1 where C.InmateID = inmateID and C.toNo = toNo and C.inmateID <> '0') is null then 1
	else callcount end)


From @temp  C, [leg_Icon].[dbo].tblInmate I WITH(NOLOCK),   [leg_Icon].[dbo].tblRaces R WITH(NOLOCK),  
[leg_Icon].[dbo].tblSex S WITH(NOLOCK)
where   C.InmateID = I.InmateID And isnull(I.RaceID, 0) = R.RaceID 
And isnull(I.Sex,'U') = S.Sex  and I.FacilityID = 352 

Select PhoneID, RecordID, toNo, startTime, ConnectDateTime, CallingCard, InmateID, Fname, LName, BillType, CallType, State, 
Duration , CallRevenue, Descript, RecordFile, RecordID2, DOB, Sex, Race, callCount, ShapeId


from @Temp

ORDER BY  inmateID, toNo 



