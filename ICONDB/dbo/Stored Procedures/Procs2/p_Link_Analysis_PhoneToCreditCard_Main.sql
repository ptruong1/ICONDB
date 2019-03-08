
CREATE PROCEDURE [dbo].[p_Link_Analysis_PhoneToCreditCard_Main]
@FacilityID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime,  -- Required 
@linkCount tinyint

 AS
Declare @temp Table (SetId tinyint, FacilityID int, PhoneID varchar(20) Null, RecordID varchar(12) Null, 
toNo varchar(16) Null, startTime datetime Null, ConnectDateTime datetime Null, CallingCard varchar(20) Null,  
InmateID varchar(12) Null, Fname varchar(25) Null, LName varchar(25) Null,  
BillType varchar(40) Null, CallType varchar(40) Null, State varchar(30) Null, Duration decimal(10,2) Null,  
CallRevenue Decimal(10, 2) Null,  Descript varchar(40) Null, RecordFile varchar(50) Null, 
RecordID2 varchar(12) Null, DOB varchar(10) Null, Sex varchar(12) Null, Race varchar(30) Null,  CallCount int, 
ShapeId varchar(2), cNum varchar(20), cPhone varchar(16))
  
Declare @CCC Table (cNum varchar(20) Null, CPhone varchar(16) Null,  CCtransCount int)
insert @CCC(cNum, cPhone,  CCtransCount)
				select cNum, cPhone, sum(1) as CCtransCount
				FROM [TecoData].[dbo].[tblBCResponse]
				where cNum not in ('', '***', '*******')
				and statusCode = '0'
				and cPhone <> ''
				--and cphone = @toNo
				group by cNum, cPhone

--select * from @CCC

insert @Temp(SetId, FacilityID, PhoneID, RecordID, toNo, startTime, ConnectDateTime, CallingCard, InmateID, 
BillType, CallType, State,  Duration , CallRevenue, Descript, RecordFile, RecordID2, Callcount, ShapeId, cNum, cPhone)  

(Select 0, c.facilityID, left( A.StationID, 20) PhoneID, RecordID,  Left(toNo, 12) As toNo,  
DATEADD(second, - duration, recordDate) as startTime,  RecordDate As ConnectDateTime,  
(case C.Billtype when '07' then left(CreditcardNo,16) else '' end ) CallingCard, 
Left(C.InmateID, 12) As InmateID,  Left(B.Descript, 40)  As  BillType,  Left(T.Descript, 40)  As CallType,  
'Completed' As  State,  CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2))  as Duration,  CallRevenue,  
Left(P.Descript, '') as Descript,  RecordFile, '' as RecordID2, 0, 0, cc.cNum, cc.cPhone  
From tblcallsBilled  C WITH(NOLOCK),  tblBilltype B WITH(NOLOCK),  tblCallType T WITH(NOLOCK) ,  
tblANIs A,  tblPhonetypes P, @CCC cc   
where  C.fromno = A.ANINo and convert (int,duration ) >5   
and C.Billtype = B.billtype and C.CallType = T.Abrev  and isnull(C.PhoneType,'3') = P.PhoneType  
and InmateID > '0' and InmateID<>'00' and InmateID<>'000' and InmateID<>'0000' and toNo <> ''  
and tono not in (select AuthNo from tblOfficeANI )  
and tono not in (select PhoneNo from tblFreePhones)  
and tono not in (select PhoneNo from tblNonRecordPhones )  
and C.FacilityID = A.FacilityID  and C.FacilityID = @FacilityID 
and tono not in (select ANINo from tblLinkAnalysys_Phone_Exceptions where C.toNo = ANINo and userName = 'ltran1') 
and (C.RecordDate between @fromDate and dateadd(d,1,@toDate))
and tono = cc.cPhone
)

--select * from @temp
 
Declare @XXX Table (toNo varchar(16) Null, cNum varchar(20) Null, CallCount int)  
insert @XXX(toNo, cNum,  CallCount)  select ToNo, cNum, sum(1) as callcount  
from @temp D  group by toNo, cNum
  
Declare @PhoneCount Table (toNo varchar(12) Null, linkcount int)  insert @PhoneCount(toNo, linkcount)  
select toNo, sum(1) as linkcount  from @XXX  group by toNo
  
Declare @Phone Table (SetId tinyint, FacilityID int, PhoneID varchar(20) Null, RecordID varchar(12) Null, 
toNo varchar(16) Null, startTime datetime Null,  ConnectDateTime datetime Null, CallingCard varchar(20) Null,  
InmateID varchar(12) Null, Fname varchar(25) Null, LName varchar(25) Null,  BillType varchar(40) Null, 
CallType varchar(40) Null, State varchar(30) Null, Duration decimal(10,2) Null,  CallRevenue Decimal(10, 2) Null,  
Descript varchar(40) Null, RecordFile varchar(50) Null, RecordID2 varchar(12) Null, DOB varchar(10) Null, 
Sex varchar(12) Null,  Race varchar(30) Null, CallCount int, linkcount int,shapeId Varchar(4), levelId tinyint, cNum varchar(20), cPhone varchar(16))

  
declare @lvl tinyint set @lvl = 1;  
insert @Phone(SetId, facilityID, PhoneID, RecordID, T.toNo, startTime,  ConnectDateTime, CallingCard, T.InmateID, 
BillType, CallType, State, Duration,  CallRevenue, Descript,  RecordFile, RecordID2, CallCount,linkcount, shapeId, levelId, cNum, cPhone)

  Select 0, facilityID, PhoneID, RecordID, T.toNo, startTime,  ConnectDateTime, CallingCard, T.InmateID, BillType, 
  CallType, State, Duration,  CallRevenue, Descript,  RecordFile, RecordID2, X.callcount,p.linkcount, P.linkcount, @lvl as levelId, X.cNum, T.toNo  
  from  @XXX X  
  inner join @temp T  on T.toNo = X.toNo and T.cNum = X.cNum  
  inner join @PhoneCount P On T.toNo = P.toNo where p.linkcount>=4 
  
  Update @Phone Set Fname = Left(FirstName, 25), LName =  Left(LastName,25),DOB =  Left(I.DOB, 10),  Sex= Left(S.Descript, 12), 
  Race= Left(R.Descript, 30)  
  From @Phone  C, tblInmate I With(NOLOCK),   tblRaces R With(NOLOCK),  tblSex S With(NOLOCK)  
  where   C.InmateId = I.InmateID And isnull(I.RaceID, 0) = R.RaceID  And C.levelId = @lvl  
  And isnull(I.Sex,'U') = S.Sex  and I.FacilityID = @facilityId 

  --Select * from @Phone
  
  Declare @temp3 Table (cNum varchar(20), toNo varchar(12),Fname varchar(25), Lname varchar(25), CallCount int, 
  LinkCount int, ShapeId int)  
  insert @temp3 (cNum, toNo ,Fname, Lname , CallCount,LinkCount, ShapeId ) 
    
  Select distinct cNum, toNo, '' Fname, '' LName, callCount, LinkCount, ShapeId  
  from @Phone  ORDER BY  ShapeId desc, toNo  
  
 -- select * from @temp3

  Declare @CCtemp Table (cNum varchar(20) Null, ccLink int)  
  insert @CCtemp(cNum, ccLink)  
  
  select cNum, sum(1)  
  from @temp3  group by cNum

  --select * from @CCtemp
    
  Declare @PhoneTemp Table (toNo varchar(12), phoneLink int)  
  
  insert @PhoneTemp (toNo, phoneLink)  
  Select  toNo, sum(1) 
  from @temp3  group by toNo

  --select * from @PhoneTemp
  
  Declare @Result Table ([SetId] tinyint, [FromShapeName] varchar(12),[ToShapeName] varchar(12), 
  [ShapeName] varchar(12), [ShapeContent] varchar(3),   CallCount smallint, linkcount int, Fname Varchar(25), 
  Lname varchar(25))  
  
  insert @result ([SetId], FromShapeName, [ToShapeName], [ShapeName] , 
  [ShapeContent],  CallCount ,linkcount, Fname , Lname) 
   
  Select distinct 0, '' cNum, toNo, '' ShapeName, '' ShapeContent,  callCount,linkcount, 
  '' Fname, (select DNI from tblWatchList   where toNo = DNI and watchById = 2) LName  
  from @Temp3  
  
  insert @result ([SetId], FromShapeName, [ToShapeName], [ShapeName] , [ShapeContent], CallCount, linkcount , Fname , Lname )  
  Select distinct 1, toNo, cNum,  '', '',linkcount, callCount, '' fname, '' Lname  
  from @Temp3  
 
  insert @result ([SetId], [FromShapeName], [ToShapeName], [ShapeName] , [ShapeContent],CallCount,  linkcount, Fname , Lname)  
  Select distinct 2, '', '', a.cNum,  
  ('C' +   cast(case 
	when cclink > 2 then 3  
  	when cclink = 1 then 1  
	when cclink = 2 then 2  
	else cclink end as varchar(1))),  
	Callcount, cclink,  fname,  Lname  
	from @Temp3 a, @cctemp b where a.cNum =b.cNum  
	
	insert @result ([SetId], [FromShapeName], [ToShapeName], [ShapeName] , [ShapeContent], CallCount,linkcount, Fname , Lname)  
	Select  distinct 2, '', '', a.toNo,  
	('P' +  cast(case 
	when phonelink > 2 then 3  
	when phonelink = 1 then 1  
	when phonelink = 2 then 2  
	else phonelink end as varchar(1))),  
	callCount, phonelink, '',  ''  
	from @temp3 a, @phonetemp b where a.toNo =b.toNo  

	--select * from @result
	
	Update @result set Fname = Left(FirstName, 25), LName =  Left(LastName,25)  
	From @result  r, tblPrepaid p WITH(NOLOCK)  
	where   p.PhoneNo = r.ShapeName  
	
	select * from @result order by SetId 