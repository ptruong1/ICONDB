
CREATE PROCEDURE [dbo].[p_Get_Inmate_Call_Daily]
@FacilityID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime  -- Required 

 AS
Declare @temp Table (FacilityID int, PhoneID varchar(20) Null, RecordID varchar(12) Null, toNo varchar(16) Null, startTime datetime Null, 
ConnectDateTime datetime Null, CallingCard varchar(20) Null,  InmateID varchar(12) Null, Fname varchar(25) Null, LName varchar(25) Null, 
BillType varchar(40) Null, CallType varchar(40) Null, State varchar(30) Null, Duration decimal(10,2) Null,  CallRevenue Decimal(10, 2) Null, 
Descript varchar(40) Null, RecordFile varchar(50) Null, RecordID2 varchar(12) Null, DOB varchar(10) Null, Sex varchar(12) Null, Race varchar(30) Null)    

insert @Temp(FacilityID, PhoneID, RecordID, toNo, startTime, ConnectDateTime, CallingCard, InmateID, BillType, CallType, State, Duration , 
CallRevenue, Descript, RecordFile, RecordID2) (Select c.facilityID, left( A.StationID, 20) PhoneID, RecordID,  Left(toNo, 12) As toNo,  
DATEADD(second, - duration, recordDate) as startTime,  RecordDate As ConnectDateTime,  
(case C.Billtype when '07' then left(CreditcardNo,16) else '' end ) CallingCard, Left(C.InmateID, 12) As InmateID,  Left(B.Descript, 40)  As  BillType,  
Left(T.Descript, 40)  As CallType,  'Completed' As  State,  CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2))  as Duration,  
CallRevenue,  Left(P.Descript, '') as Descript,  RecordFile, 
(select recordID from leg_Icon.dbo.tblRecordingTransMatch M where C.RecordID = M.RecordID ) as RecordID2  
From [leg_Icon].[dbo].tblcallsBilled  C WITH(NOLOCK),  [leg_Icon].[dbo].tblBilltype B WITH(NOLOCK),  
[leg_Icon].[dbo].tblCallType T WITH(NOLOCK) ,  [leg_Icon].[dbo].tblANIs A,  [leg_Icon].[dbo].tblPhonetypes P
 where  C.fromno = A.ANINo and convert (int,duration ) >5 
 and C.Billtype = B.billtype and C.CallType = T.Abrev 
 and isnull(C.PhoneType,'3') = P.PhoneType and C.FacilityID = A.FacilityID  
 and C.FacilityID = @facilityId and (C.RecordDate between @fromDate and dateadd(d,1,@todate))) 
 
 Update @temp set Fname = Left(FirstName, 25), LName =  Left(LastName,25),DOB =  Left(I.DOB, 10), Sex= Left(S.Descript, 12), Race= Left(R.Descript, 30)
 From @temp  C, [leg_Icon].[dbo].tblInmate I WITH(NOLOCK),   [leg_Icon].[dbo].tblRaces R WITH(NOLOCK),  [leg_Icon].[dbo].tblSex S WITH(NOLOCK)
 where   C.InmateID = I.InmateID And isnull(I.RaceID, 0) = R.RaceID And isnull(I.Sex,'U') = S.Sex  
 and I.FacilityID = @facilityId 
 
 insert @Temp(FacilityID, PhoneID, RecordID, toNo, startTime, ConnectDateTime, CallingCard, InmateID, BillType, CallType, State, 
 Duration , CallRevenue, Descript, RecordFile, RecordID2) (Select c.facilityID, left( A.StationID, 20) PhoneID, RecordID,  Left(toNo, 12) As toNo,  
 DATEADD(second, - duration, recordDate) as startTime,  RecordDate As ConnectDateTime,  
 (case C.Billtype when '07' then left(CreditcardNo,16) else '' end ) CallingCard, Left(C.InmateID, 12) As InmateID,  
 Left(B.Descript, 40)  As  BillType,  Left(T.Descript, 40)  As CallType,  'Completed' As  State,  
 CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2))  as Duration,  CallRevenue,  Left(P.Descript, '') as Descript,  
 RecordFile, (select recordID from leg_Icon.dbo.tblRecordingTransMatch M  where C.RecordID = M.RecordID ) as RecordID2  
 From [leg_Icon].[dbo].tblcallsBilledArchive  C WITH(NOLOCK),  [leg_Icon].[dbo].tblBilltype B WITH(NOLOCK),  
 [leg_Icon].[dbo].tblCallType T WITH(NOLOCK) ,  [leg_Icon].[dbo].tblANIs A,  [leg_Icon].[dbo].tblPhonetypes P 
 
 where  C.fromno = A.ANINo and convert (int,duration ) >5 and C.Billtype = B.billtype and C.CallType = T.Abrev 
 and isnull(C.PhoneType,'3') = P.PhoneType and C.FacilityID = A.FacilityID  and C.FacilityID = 786 
 and (C.RecordDate between @fromDate and dateadd(d,1,@toDate))) 
 
 Update @temp set Fname = Left(FirstName, 25), LName =  Left(LastName,25),DOB =  Left(I.DOB, 10), Sex= Left(S.Descript, 12), 
 Race= Left(R.Descript, 30)
 From @temp  C, [leg_Icon].[dbo].tblInmate I WITH(NOLOCK),   [leg_Icon].[dbo].tblRaces R WITH(NOLOCK),  [leg_Icon].[dbo].tblSex S WITH(NOLOCK)
 
 where   C.InmateID = I.InmateID And isnull(I.RaceID, 0) = R.RaceID And isnull(I.Sex,'U') = S.Sex  and I.FacilityID = 786
 
 Select PhoneID, RecordID, toNo, startTime, ConnectDateTime, CallingCard, InmateID, Fname, LName, BillType, CallType, State, 
 Duration , CallRevenue, Descript, RecordFile, RecordID2, DOB, Sex, Race  from @Temp  ORDER BY  ConnectDateTime Desc


