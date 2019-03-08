
CREATE PROCEDURE [dbo].[p_Link_Analysis_CreditCardToPhone_Main_Test]
@FacilityID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime,  -- Required 
@linkCount tinyint

 AS
Declare @temp Table (SetId tinyint, FacilityID int, PhoneID varchar(20) Null, RecordID varchar(12) Null, toNo varchar(16) Null, 
startTime datetime Null,  ConnectDateTime datetime Null, CallingCard varchar(20) Null,  InmateID varchar(12) Null, Fname varchar(25) Null, 
LName varchar(25) Null,  BillType varchar(40) Null, CallType varchar(40) Null, State varchar(30) Null, Duration decimal(10,2) Null,  
CallRevenue Decimal(10, 2) Null,  Descript varchar(40) Null, RecordFile varchar(50) Null, RecordID2 varchar(12) Null, DOB varchar(10) Null, 
Sex varchar(12) Null, Race varchar(30) Null,  CallCount int, ShapeId varchar(2), cNum varchar(20), cPhone varchar(16))  

Declare @CCC Table (cNum varchar(20) Null, CPhone varchar(16) Null)
insert @CCC(cNum, cPhone)
				select cNum, cPhone
				FROM [TecoData].[dbo].[tblBCResponse]
				where cNum not in ('', '***', '*******')
				and statusCode = '0'
				and cPhone <> ''
				--and cnum = '***9454'
				group by cNum, cPhone;

 --select * from  @CCC order by CPhone;

 WITH CTE AS(
   SELECT [cNum], [cPhone],
       RN = ROW_NUMBER()OVER(PARTITION BY cPhone ORDER BY cPhone)
   FROM @CCC
)
DELETE FROM CTE WHERE RN > 1;

--select * from  @CCC order by  CPhone

insert @Temp(SetId, FacilityID, PhoneID, RecordID, toNo, startTime, ConnectDateTime, CallingCard, InmateID, BillType, CallType, State,  
Duration , CallRevenue, Descript, RecordFile, RecordID2, Callcount, ShapeId, cNum, cPhone)  

(Select 0, c.facilityID, left( A.StationID, 20) PhoneID, RecordID,  Left(toNo, 12) As toNo,  DATEADD(second, - duration, recordDate) as startTime,  
RecordDate As ConnectDateTime,  (case C.Billtype when '07' then left(CreditcardNo,16) else '' end ) CallingCard, 
Left(C.InmateID, 12) As InmateID,  Left(B.Descript, 40)  As  BillType,  Left(T.Descript, 40)  As CallType,  'Completed' As  State,  
CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2))  as Duration,  CallRevenue,  Left(P.Descript, '') as Descript,  RecordFile, 
'' as RecordID2, 0, 0, cc.cNum, cc.cPhone
 
From tblcallsBilled  C WITH(NOLOCK),  tblBilltype B WITH(NOLOCK),  
tblCallType T WITH(NOLOCK) ,  tblANIs A,  tblPhonetypes P, @CCC cc  
where  C.fromno = A.ANINo and convert (int,duration ) >5   
and C.Billtype = B.billtype and C.CallType = T.Abrev  and isnull(C.PhoneType,'3') = P.PhoneType  
and InmateID > '0' and InmateID<>'00' and InmateID<>'000' and InmateID<>'0000' and toNo <> ''  
and tono not in (select AuthNo from tblOfficeANI )  
and tono not in (select PhoneNo from tblFreePhones)  
and tono not in (select PhoneNo from tblNonRecordPhones )  
and tono not in (select ANINo from tblLinkAnalysys_Phone_Exceptions )

and tono = cc.cPhone
  
and C.FacilityID = A.FacilityID  and C.FacilityID = @facilityId 
and (C.RecordDate between @fromDate and dateadd(d,1,@toDate))) 

-- select * from @temp order by cNum, RecordId

Declare @XXX Table (cNum varchar(20) Null, cPhone varchar(16) Null, CallCount int)  
insert @XXX(cNum, cPhone,  CallCount)  
select cNum, cPhone, sum(1) as callcount  
from @temp D  group by cNum, cPhone

 -- select * from @XXX  order by cPhone
 
Declare @CCCount Table (cNum varchar(20) Null, linkcount int)  
insert @CCCount(cNum, linkcount)  select cNum, sum(1) as linkcount  
from @XXX  group by cNum 

--select * from @CCCount

Declare @Phone Table (SetId tinyint, FacilityID int, PhoneID varchar(20) Null, RecordID varchar(12) Null, toNo varchar(16) Null, 
startTime datetime Null,  ConnectDateTime datetime Null, CallingCard varchar(20) Null,  InmateID varchar(12) Null, Fname varchar(25) Null, 
LName varchar(25) Null,  BillType varchar(40) Null, CallType varchar(40) Null, State varchar(30) Null, Duration decimal(10,2) Null,  
CallRevenue Decimal(10, 2) Null,  Descript varchar(40) Null, RecordFile varchar(50) Null, 
RecordID2 varchar(12) Null, DOB varchar(10) Null, Sex varchar(12) Null,  Race varchar(30) Null, CallCount int, 
linkcount int,shapeId Varchar(4), levelId tinyint, cNum varchar(20), cPhone varchar(16))  

declare @lvl tinyint set @lvl = 1;  

insert @Phone(SetId, facilityID, PhoneID, RecordID, T.toNo, startTime,  ConnectDateTime, CallingCard, T.InmateID, BillType, CallType, 
State, Duration,  CallRevenue, Descript,  RecordFile, RecordID2, CallCount, linkcount, shapeId, levelId, cNum, cPhone)  

Select 0, facilityID, PhoneID, RecordID, T.toNo, startTime,  ConnectDateTime, CallingCard, T.InmateID, BillType, CallType, State, 
Duration,  CallRevenue, Descript,  RecordFile, RecordID2, X.callcount,p.linkcount, P.linkcount, @lvl as levelId, T.cNum, T.cPhone  
from  @XXX X  
inner join @temp T  on T.cNum = X.cNum and T.cPhone = X.cPhone  
inner join @CCCount P On T.cNum = P.cNum where p.linkcount>=@linkCount

Update @Phone Set Fname = Left(FirstName, 25), 
LName =  Left(LastName,25),DOB =  Left(I.DOB, 10),  Sex= Left(S.Descript, 12), Race= Left(R.Descript, 30)  
From @Phone  C, tblInmate I With(NOLOCK),   tblRaces R With(NOLOCK),  tblSex S With(NOLOCK)  
where   C.InmateId = I.InmateID And isnull(I.RaceID, 0) = R.RaceID  And C.levelId = @lvl  
And isnull(I.Sex,'U') = S.Sex  and I.FacilityID = @facilityId 

-- select * from @phone order by cNum, cPhone, recordId

Declare @temp3 Table (cNum varchar(20), cPhone varchar(16),Fname varchar(25), Lname varchar(25), CallCount int, LinkCount int, ShapeId int)  

insert @temp3 (cNum, cPhone ,Fname, Lname , CallCount,LinkCount, ShapeId )  
Select distinct cNum, cPhone, Fname, LName, callCount, LinkCount, ShapeId  
from @Phone  ORDER BY  ShapeId desc, cPhone  

-- select * from @temp3 order by cNum, cPhone

Declare @CCCtemp Table (cNum varchar(20) Null, CCClink int, CCCtotalCall int)
  
insert @CCCtemp(cNum, CCClink, CCCtotalCall)  
select cNum, sum(1) as CCClink, sum(callcount) as CCCtotalCall
from @XXX  group by cNum  

 --select * from @CCCtemp

Declare @phoneTemp Table (cPhone varchar(16), Phonelink int, PhonetotalCall int)  
insert @phoneTemp (cPhone ,PhoneLink, PhonetotalCall )  
Select  cPhone, sum(1) as Phonelink, sum(CallCount) as PhonetotalCall
from @XXX  group by cPhone

-- Select * from @phoneTemp

Declare @Result Table ([SetId] tinyint, [FromShapeName] varchar(12),[ToShapeName] varchar(12), [ShapeName] varchar(12), [ShapeContent] varchar(3),   
CallCount smallint, linkcount int, Fname Varchar(25), Lname varchar(25))  

insert @result ([SetId], FromShapeName, [ToShapeName], [ShapeName] , [ShapeContent],  CallCount ,linkcount, Fname , Lname)  
Select distinct 0, a.cNum, '' cPhone, '' ShapeName, '' ShapeContent, b.CCCtotalCall, linkcount, '' Fname, 
(select DNI from tblWatchList where cPhone = DNI and watchById = 2) LName  
from @Temp3 a, @CCCtemp b where a.cNum =b.cNum  

insert @result ([SetId], FromShapeName, [ToShapeName], [ShapeName] , [ShapeContent], CallCount, linkcount , Fname , Lname )  
Select distinct 1, cNum, cPhone,  '', '',linkcount, callCount, '' fname, '' Lname  
from @Temp3  

insert @result ([SetId], [FromShapeName], [ToShapeName], [ShapeName] , [ShapeContent], Callcount,  linkcount, Fname , Lname)  
Select distinct 2, '', '', a.cNum,  
('C' +   cast(case 
when CCClink > 2 then 3  when CCClink = 1 then 1  
when CCClink = 2 then 2  
else CCClink end as varchar(1))), 
b.CCCtotalCall, CCClink,  fname,  Lname  
from @Temp3 a, @CCCtemp b where a.cNum =b.cNum 

insert @result ([SetId], [FromShapeName], [ToShapeName], [ShapeName] , [ShapeContent], CallCount,linkcount, Fname , Lname)  
Select  distinct 2, '', '', a.cPhone,  
('P' +  cast(case 
when Phonelink > 2 then 3  
when Phonelink = 1 then 1  
when Phonelink = 2 then 2  
else Phonelink end as varchar(1))) as ShapeContent,  
--(select callCount from @Temp4 a where a.cPhone = b.cPhone), 
b.Phonetotalcall, Phonelink, '',  ''  
from @temp3 a, @Phonetemp b where a.cphone =b.cPhone
 
Update @result set Fname = Left(FirstName, 25), LName =  Left(LastName,25) From @result  r, tblPrepaid p WITH(NOLOCK)  
where   p.PhoneNo = r.ShapeName  

select * from @result order by SetId
