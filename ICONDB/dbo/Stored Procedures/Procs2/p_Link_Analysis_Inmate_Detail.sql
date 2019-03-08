
CREATE PROCEDURE [dbo].[p_Link_Analysis_Inmate_Detail]
@FacilityID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime,  -- Required 
@InmateId varchar(12),
@Count tinyint

 AS
Declare @temp Table (FacilityID int, PhoneID varchar(20) Null, RecordID varchar(12) Null, toNo varchar(16) Null, startTime datetime Null, 
ConnectDateTime datetime Null, CallingCard varchar(20) Null,  InmateID varchar(12) Null, Fname varchar(25) Null, LName varchar(25) Null, 
BillType varchar(40) Null, CallType varchar(40) Null, State varchar(30) Null, Duration decimal(10,2) Null,  CallRevenue Decimal(10, 2) Null, 
Descript varchar(40) Null, RecordFile varchar(50) Null, RecordID2 varchar(12) Null, DOB varchar(10) Null, Sex varchar(12) Null, 
Race varchar(30) Null, CallCount int, shapeId Varchar(4), levelId tinyint)

Declare @Phone Table (FacilityID int, PhoneID varchar(20) Null, RecordID varchar(12) Null, toNo varchar(16) Null, startTime datetime Null, 
ConnectDateTime datetime Null, CallingCard varchar(20) Null,  InmateID varchar(12) Null, Fname varchar(25) Null, LName varchar(25) Null, 
BillType varchar(40) Null, CallType varchar(40) Null, State varchar(30) Null, Duration decimal(10,2) Null,  CallRevenue Decimal(10, 2) Null, 
Descript varchar(40) Null, RecordFile varchar(50) Null, RecordID2 varchar(12) Null, DOB varchar(10) Null, Sex varchar(12) Null, 
Race varchar(30) Null, CallCount int, shapeId Varchar(4), levelId tinyint)


insert @Temp(FacilityID, PhoneID, RecordID, toNo, startTime, ConnectDateTime, CallingCard, InmateID, BillType, CallType, State, 
Duration , CallRevenue, Descript, RecordFile, RecordID2, CallCount, ShapeId, levelId) 

(Select c.facilityID, left( A.StationID, 20) PhoneID, RecordID,  Left(toNo, 12) As toNo,  
DATEADD(second, - duration, recordDate) as startTime,  RecordDate As ConnectDateTime,  
(case C.Billtype when '07' then left(CreditcardNo,16) else '' end ) CallingCard, Left(C.InmateID, 12) As InmateID,  Left(B.Descript, 40)  As  BillType,  
Left(T.Descript, 40)  As CallType,  'Completed' As  State,  CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2))  as Duration,  
CallRevenue,  Left(P.Descript, '') as Descript,  RecordFile, 
'' as RecordID2, 0, 0, 1

From tblcallsBilled  C WITH(NOLOCK),  tblBilltype B WITH(NOLOCK),  
tblCallType T WITH(NOLOCK) ,  tblANIs A,  tblPhonetypes P 
where  C.fromno = A.ANINo and convert (int,duration ) >5 
and C.Billtype = B.billtype and C.CallType = T.Abrev 
--and C.CallType not in ('NA')
and isnull(C.PhoneType,'3') = P.PhoneType 
and C.FacilityID = A.FacilityID  and C.FacilityID = @facilityId 
and (C.RecordDate between @fromDate and dateadd(d,1,@toDate)) 
and inmateID <> '000' and inmateID <> '0'
and tono not in (select AuthNo from tblOfficeANI )
and tono not in (select PhoneNo from tblFreePhones )
)

--select * from @temp

Declare @XXX Table (InmateID varchar(12) Null, toNo varchar(16) Null,  CallCount int)
--Declare @PhoneCount Table (toNo varchar(16) Null,  CallCount int)
Declare @InmateCount Table (InmateId varchar(16) Null,  CallCount int)



Declare 
@Continue tinyint, @lvl int, @root tinyint 
set @root = 1
set @lvl = 0
set @Continue = 1 

WHILE @Continue = 1
BEGIN

	if (@root = 1)
	begin
		insert @XXX(InmateId, toNo,  CallCount)
			select InmateId, tono, sum(1) as callcount
			from @temp
			where InmateId = @InmateId
			group by InmateID, toNo
		--select * from  @XXX
		set @root = 0
		insert @InmateCount(InmateId, CallCount)
			select InmateId, sum(1) as callcount from @XXX group by InmateId;
			--select * from  @InmateCount
	end
	else
	begin
		delete from @XXX;
		insert @XXX(InmateId, toNo,  CallCount)
			select InmateId, tono, sum(1) as callcount
			from @Temp D
			where D.InmateId in (select top 1 InmateId from @Phone where levelId = @lvl)
			and not exists (select InmateId, ToNo from @phone where D.toNo = toNo and D.InmateId = InmateId)
			group by InmateId, toNo;

		insert @InmateCount(InmateId, CallCount)
			select InmateId, sum(1) as callcount from @XXX group by InmateId;
			--select * from  @InmateCount
	end;
	
	if (select count(*) from @XXX) > 0 
	begin
	set @lvl = @lvl + 1;
	insert @Phone(facilityID, PhoneID, RecordID, T.toNo, startTime,  ConnectDateTime, CallingCard, T.InmateID, BillType, CallType, State, Duration,  
		CallRevenue, Descript,  RecordFile, RecordID2, CallCount, shapeId, levelId)

		Select facilityID, PhoneID, RecordID, T.toNo, startTime,  ConnectDateTime, CallingCard, T.InmateID, BillType, CallType, State, Duration,  
		CallRevenue, Descript,  RecordFile, RecordID2, 1, 1, @lvl as levelId
		 from  @temp T
		 inner join @XXX X
			on T.toNo = X.toNo and T.InmateId = X.InmateId
			and (select top 1 callcount from @InmateCount where  T.InmateId = InmateId ) > @Count
			--and not exists (select ToNo, InmateId from @phone where T.toNo = toNo and T.InmateId = InmateId);

		

		Update @Phone set Fname = Left(FirstName, 25), LName =  Left(LastName,25),DOB =  Left(I.DOB, 10), Sex= Left(S.Descript, 12), Race= Left(R.Descript, 30),
			callCount = (select Count(*) from @Phone P where C.toNo = P.toNo  and C.InmateID = P.inmateID and P.levelId = @lvl group by P.toNo, P.InmateId ),
			shapeId = (select top 1 callcount from @InmateCount where  C.InmateId = InmateId )
			From @Phone  C, tblInmate I WITH(NOLOCK),   tblRaces R WITH(NOLOCK),  
			tblSex S WITH(NOLOCK)
			where   C.InmateId = I.InmateID And isnull(I.RaceID, 0) = R.RaceID 
			And isnull(I.Sex,'U') = S.Sex  and I.FacilityID = @facilityId 
			And C.levelId = @lvl;

	end
	else
	begin
		set @Continue = 0
		break;
	end;

	print @lvl;

	------- Level1 done
	--- Debug here
		--set @Continue = 0;
		--break;

	------- Level2 Start
	Delete from @XXX

		insert @XXX(InmateId, toNo,  CallCount)
			select InmateId, tono, sum(1) as callcount
			from @Temp D
			where D.inmateId in (select top 1 inmateId from @Phone where levelId = @lvl)
			and not exists (select ToNo, InmateId from @phone where D.toNo = toNo and D.InmateId = InmateId)
			group by InmateID, toNo;

		--select * from @XXX
		--order by InmateId, toNo
		
		insert @InmateCount(InmateId, CallCount)
			select InmateId, sum(1) as callcount from @XXX group by InmateId;

		--select * from @inmateCount
	
	if (select count(*) from @XXX) > 0 		
	begin
	set @lvl = @lvl + 1;

	insert @Phone(facilityID, PhoneID, RecordID, toNo, startTime,  ConnectDateTime, CallingCard, InmateID, BillType, CallType, State, Duration,  
		CallRevenue, Descript,  RecordFile, RecordID2, CallCount, shapeId, levelId)

		Select facilityID, PhoneID, RecordID, T.toNo, startTime,  ConnectDateTime, CallingCard, T.InmateID, BillType, CallType, State, Duration,  
		CallRevenue, Descript,  RecordFile, RecordID2, 1, 1, @lvl as levelId
		 from  @temp T
		 inner join @XXX X
			on T.toNo = X.toNo and T.InmateId = X.InmateId
			and (select top 1 callcount from @InmateCount I where  T.InmateId = I.InmateId ) > @Count
			--and not exists (select ToNo, InmateId from @phone where T.toNo = toNo and T.InmateId = InmateId);


			Update @Phone set Fname = Left(FirstName, 25), LName =  Left(LastName,25),DOB =  Left(I.DOB, 10), Sex= Left(S.Descript, 12), Race= Left(R.Descript, 30),
			callCount = (select Count(*) from @Phone P where C.toNo = P.toNo  and C.InmateID = P.inmateID and P.levelId = @lvl group by P.InmateId, P.toNo ),
			shapeId = (select top 1 callcount from @InmateCount where  C.InmateId = InmateId )
			From @Phone  C, tblInmate I WITH(NOLOCK),   tblRaces R WITH(NOLOCK),  
			tblSex S WITH(NOLOCK)
			where   C.InmateID = I.InmateID And isnull(I.RaceID, 0) = R.RaceID 
			And isnull(I.Sex,'U') = S.Sex  and I.FacilityID = @facilityId 
			And C.levelId = @lvl;

	end
	else
	begin
		set @Continue = 0
		break;
	end;

	print @lvl;
	
	--if @lvl = 6
	-- set @Continue = 0;
END;

--select * from @Phone order by InmateId, toNo

PRINT 'Done WHILE LOOP on TechOnTheNet.com';

Declare @temp3 Table (InmateID varchar(12), toNo varchar(12), CallCount int, ShapeId int, 
Fname varchar(25), Lname varchar(25), RecordId varchar(12), ConnectDateTime datetime, RecordFile varchar(20),  Duration decimal(10,2) Null)

insert @temp3 (InmateID, toNo ,CallCount, ShapeId, Fname, Lname, RecordId, ConnectDateTime, RecordFile, duration )
Select distinct InmateId, toNo, callCount, ShapeId, Fname, LName, '' RecordId, '' ConnectDateTime, '' RecordFile, 0 duration
from @Phone
where ShapeId > @Count
ORDER BY  ShapeId desc, toNo

--select * from @Temp3

Declare @Result Table ([SetId] tinyint, [FromShapeName] varchar(12),[ToShapeName] varchar(12), [ShapeName] varchar(12), [ShapeContent] varchar(3),
Fname varchar(25), Lname varchar(25), RecordId varchar(12), ConnectDateTime datetime, RecordFile varchar(20),  Duration decimal(10,2) Null)

--select * from @Phone

---Connections
insert @result ([SetId], FromShapeName, [ToShapeName], [ShapeName] , [ShapeContent], Fname, Lname, RecordId, ConnectDateTime, RecordFile, duration )
Select distinct 1, InmateId, toNo, '', '', '' Fname, '' LName, '' RecordId, '' ConnectDateTime, '' RecordFile, 0 duration
from @Temp3
order by InmateId, toNo

---Shapes for InmateId
insert @result ([SetId], [FromShapeName], [ToShapeName], [ShapeName], [ShapeContent], Fname, Lname, RecordId, ConnectDateTime, RecordFile, duration)
Select distinct 2, '', '', InmateID, 
			('I' + 
			cast(case when ShapeId > 3 then 4 
			when ShapeId = 1 then 1 
			when ShapeId = 2 then 2
			when ShapeId = 3 then 3
		else ShapeId end as varchar(1))),
		  Fname, LName, '' RecordId, '' ConnectDateTime, '' RecordFile, 0 duration
		
	from @Temp3
			--order by InmateId

 --- Shapes for Phones
 insert @result ([SetId], [FromShapeName], [ToShapeName], [ShapeName] , [ShapeContent], Fname, Lname, RecordId, ConnectDateTime, RecordFile, duration)
Select  distinct 2, '', '', toNo,
('P' + 
		cast(case when CallCount > 3 then 4 
			when CallCount = 1 then 1 
			when CallCount = 2 then 2
			when CallCount = 3 then 3
		else CallCount end as varchar(1))),
		'' Fname, '' LName, '' RecordId, '' ConnectDateTime, '' RecordFile, 0 duration
			from @temp3
			--order by toNo

insert @result ([SetId], [FromShapeName], [ToShapeName], [ShapeName] , [ShapeContent], Fname, Lname, RecordId, ConnectDateTime, RecordFile, duration)
Select  distinct 3, InmateId, toNo, '' ShapeName,
('P' + 
		cast(case when CallCount > 3 then 4 
			when CallCount = 1 then 1 
			when CallCount = 2 then 2
			when CallCount = 3 then 3
		else CallCount end as varchar(1))),
		 Fname,  LName, '' RecordId, '' ConnectDateTime, '' RecordFile, 0 duration
			from @temp3
			order by toNo

insert @result ([SetId], [FromShapeName], [ToShapeName], [ShapeName] , [ShapeContent], Fname, Lname, RecordId, ConnectDateTime, RecordFile, duration)
Select  4, InmateId, toNo, '' ShapeName,
('P' + 
		cast(case when CallCount > 3 then 4 
			when CallCount = 1 then 1 
			when CallCount = 2 then 2
			when CallCount = 3 then 3
		else CallCount end as varchar(1))),
		 Fname,  LName,  RecordId,  ConnectDateTime,  RecordFile, duration
			from @Phone
			order by toNo

--- Final Table




select * from @result


