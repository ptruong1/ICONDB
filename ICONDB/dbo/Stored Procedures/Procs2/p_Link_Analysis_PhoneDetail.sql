
CREATE PROCEDURE [dbo].[p_Link_Analysis_PhoneDetail]
@FacilityID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime,  -- Required 
@toNo varchar(12),
@UsrName varchar(25),
@userIP  varchar(16)

--@Count tinyint

 AS
 Declare @temp Table (FacilityID int, PhoneID varchar(20) Null, RecordID varchar(12) Null, fromNo varchar(16) Null, toNo varchar(16) Null, startTime datetime Null, 
ConnectDateTime datetime Null, CallingCard varchar(20) Null,  InmateID varchar(12) Null, Fname varchar(25) Null, LName varchar(25) Null, 
BillType varchar(40) Null, CallType varchar(40) Null, State varchar(30) Null, Duration decimal(10,2) Null,  CallRevenue Decimal(10, 2) Null, 
Descript varchar(40) Null, RecordFile varchar(50) Null, RecordID2 varchar(12) Null, DOB varchar(10) Null, Sex varchar(12) Null, 
Race varchar(30) Null, CallCount int, shapeId Varchar(4), levelId tinyint)

Declare @Phone Table (FacilityID int, PhoneID varchar(20) Null, RecordID varchar(12) Null, fromNo varchar(16) Null, toNo varchar(16) Null, startTime datetime Null, 
ConnectDateTime datetime Null, CallingCard varchar(20) Null,  InmateID varchar(12) Null, Fname varchar(25) Null, LName varchar(25) Null, 
BillType varchar(40) Null, CallType varchar(40) Null, State varchar(30) Null, Duration decimal(10,2) Null,  CallRevenue Decimal(10, 2) Null, 
Descript varchar(40) Null, RecordFile varchar(50) Null, RecordID2 varchar(12) Null, DOB varchar(10) Null, Sex varchar(12) Null, 
Race varchar(30) Null, CallCount int,LinkCount int, shapeId Varchar(4), levelId tinyint)


insert @Temp(FacilityID, PhoneID, RecordID, fromNo, toNo, startTime, ConnectDateTime, CallingCard, InmateID, BillType, CallType, State, 
Duration , CallRevenue, Descript, RecordFile, RecordID2, CallCount, ShapeId, levelId) 

(Select c.facilityID, left( A.StationID, 20) PhoneID, RecordID,  fromNo, Left(toNo, 12) As toNo,  
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
and tono not in (select ANINo from tblLinkAnalysys_Phone_Exceptions where C.toNo = ANINo and userName = @usrName )
)

--select * from @temp
Declare 
@Continue tinyint, @lvl int, @root tinyint 
set @root = 1
set @lvl = 0
set @Continue = 1 

Declare @XXX Table (InmateID varchar(12) Null, toNo varchar(16) Null,  CallCount int)
Declare @YYY Table (InmateID varchar(12) Null, toNo varchar(16) Null,  CallCount int)
Declare @PhoneCount Table (toNo varchar(16) Null,  LinkCount int)
Declare @InmateCount Table (InmateId varchar(16) Null,  CallCount int)

insert @XXX(toNo, InmateID,  CallCount)
				select tono, inmateID, sum(1) as callcount
				from @temp
				where toNo = @toNo
				group by toNo, InmateID

				--select * from  @XXX

insert @PhoneCount(toNo, LinkCount)
			select tono, sum(1) as LinkCount from @XXX group by toNo;

begin
		set @lvl = @lvl + 1;
		insert @Phone(facilityID, PhoneID, RecordID, fromNo, T.toNo, startTime,  ConnectDateTime, CallingCard, T.InmateID, BillType, CallType, State, Duration,  
			CallRevenue, Descript,  RecordFile, RecordID2, CallCount,LinkCount, shapeId, levelId)

			Select facilityID, PhoneID, RecordID, fromNo, T.toNo, startTime,  ConnectDateTime, CallingCard, T.InmateID, BillType, CallType, State, Duration,  
			CallRevenue, Descript,  RecordFile, RecordID2, 1,1,1, @lvl as levelId
			 from  @temp T
			 inner join @XXX X
				on T.toNo = X.toNo and T.InmateId = X.InmateId
				--left join @PhoneCount p on p.toNo = T.toNo
				--and (select top 1 LinkCount from @PhoneCount where  T.toNo = toNo ) > @Count
				--and not exists (select ToNo, InmateId from @phone where T.toNo = toNo and T.InmateId = InmateId);

			

			Update @Phone set Fname = Left(FirstName, 25), LName =  Left(LastName,25),DOB =  Left(I.DOB, 10), Sex= Left(S.Descript, 12), Race= Left(R.Descript, 30),
				callCount = (select Count(*) from @Phone P where C.toNo = P.toNo  and C.InmateID = P.inmateID and P.levelId = @lvl group by P.toNo, P.InmateId ),
				shapeId = (select top 1 LinkCount from @PhoneCount where  C.toNo = toNo ),
				LinkCount = (select top 1 LinkCount from @PhoneCount where  C.toNo = toNo )
				From @Phone  C, tblInmate I WITH(NOLOCK),   tblRaces R WITH(NOLOCK),  
				tblSex S WITH(NOLOCK)
				where   C.InmateId = I.InmateID And isnull(I.RaceID, 0) = R.RaceID 
				And isnull(I.Sex,'U') = S.Sex  and I.FacilityID = @facilityId 
				And C.levelId = @lvl;

				--select * from @phone
	end;

	-- Level 1 done

	--- Level loop

WHILE @Continue = 1
BEGIN

	Delete from @XXX

		insert @XXX(toNo, InmateID,  CallCount)
			select tono, inmateID, sum(1) as callcount
			from @Temp D
			where D.inmateId in (select top 1 inmateId from @Phone where levelId = @lvl)
			and not exists (select ToNo, InmateId from @phone where D.toNo = toNo and D.InmateId = InmateId)
			group by InmateID, toNo;

		--Select * from @XXX

		insert @InmateCount(InmateId, CallCount)
			select InmateId, sum(1) as callcount from @XXX group by InmateId;

	if (select count(*) from @XXX) > 0 
	begin
		set @lvl = @lvl + 1;
		insert @Phone(facilityID, PhoneID, RecordID, fromNo, T.toNo, startTime,  ConnectDateTime, CallingCard, T.InmateID, BillType, CallType, State, Duration,  
			CallRevenue, Descript,  RecordFile, RecordID2, CallCount,LinkCount, shapeId, levelId)

			Select facilityID, PhoneID, RecordID, fromNo, T.toNo, startTime,  ConnectDateTime, CallingCard, T.InmateID, BillType, CallType, State, Duration,  
			CallRevenue, Descript,  RecordFile, RecordID2, 1,1,1, @lvl as levelId
			 from  @temp T
			 inner join @XXX X
				on T.toNo = X.toNo and T.InmateId = X.InmateId
				--left join @PhoneCount p on p.toNo = T.toNo
				--and (select top 1 LinkCount from @PhoneCount where  T.toNo = toNo ) > @Count
				--and not exists (select ToNo, InmateId from @phone where T.toNo = toNo and T.InmateId = InmateId);

			

			Update @Phone set Fname = Left(FirstName, 25), LName =  Left(LastName,25),DOB =  Left(I.DOB, 10), Sex= Left(S.Descript, 12), Race= Left(R.Descript, 30),
				callCount = (select Count(*) from @Phone P where C.toNo = P.toNo  and C.InmateID = P.inmateID and P.levelId = @lvl group by P.toNo, P.InmateId ),
				shapeId = (select top 1 LinkCount from @InmateCount where  C.InmateId = InmateId ),
				LinkCount = (select top 1 LinkCount from @InmateCount where  C.InmateId = InmateId  )
				From @Phone  C, tblInmate I WITH(NOLOCK),   tblRaces R WITH(NOLOCK),  
				tblSex S WITH(NOLOCK)
				where   C.InmateId = I.InmateID And isnull(I.RaceID, 0) = R.RaceID 
				And isnull(I.Sex,'U') = S.Sex  and I.FacilityID = @facilityId 
				And C.levelId = @lvl;

				--select * from @phone
	end
	else
		begin
			set @Continue = 0
			break;
		end;

	print @lvl;

	Delete from @XXX

		insert @XXX(toNo, InmateID,  CallCount)
			select tono, inmateID, sum(1) as callcount
			from @Temp D
			where D.toNo in (select top 1 toNo from @Phone where levelId = @lvl)
			and not exists (select ToNo, InmateId from @phone where D.toNo = toNo and D.InmateId = InmateId)
			group by toNo, InmateId;

		--Select * from @XXX

		insert @PhoneCount(toNo, LinkCount)
			select toNo, sum(1) as callcount from @XXX group by toNo;

	if (select count(*) from @XXX) > 0 		
	begin
	set @lvl = @lvl + 1;
	insert @Phone(facilityID, PhoneID, RecordID, fromNo, toNo, startTime,  ConnectDateTime, CallingCard, InmateID, BillType, CallType, State, Duration,  
		CallRevenue, Descript,  RecordFile, RecordID2, CallCount, linkcount,shapeId, levelId)

		Select facilityID, PhoneID, RecordID, fromNo, T.toNo, startTime,  ConnectDateTime, CallingCard, T.InmateID, BillType, CallType, State, Duration,  
		CallRevenue, Descript,  RecordFile, RecordID2, 1,1, 1, @lvl as levelId
		 from  @temp T
		 inner join @XXX X
			on T.toNo = X.toNo and T.InmateId = X.InmateId
			--left join @PhoneCount p on p.toNo = T.toNo
			--and (select top 1 callcount from @InmateCount I where  T.InmateId = I.InmateId ) > @Count
			--and not exists (select ToNo, InmateId from @phone where T.toNo = toNo and T.InmateId = InmateId);


			Update @Phone set Fname = Left(FirstName, 25), LName =  Left(LastName,25),DOB =  Left(I.DOB, 10), Sex= Left(S.Descript, 12), Race= Left(R.Descript, 30),
			callCount = (select Count(*) from @Phone P where C.toNo = P.toNo  and C.InmateID = P.inmateID and P.levelId = @lvl group by P.InmateId, P.toNo ),
			shapeId = (select top 1 callcount from @PhoneCount where  C.toNo = toNo )
			--LinkCount = (select top 1 callcount from @InmateCount where  C.InmateId = InmateId )
			From @Phone  C, tblInmate I WITH(NOLOCK),   tblRaces R WITH(NOLOCK),  
			tblSex S WITH(NOLOCK)
			where   C.InmateID = I.InmateID And isnull(I.RaceID, 0) = R.RaceID 
			And isnull(I.Sex,'U') = S.Sex  and I.FacilityID = @facilityId 
			And C.levelId = @lvl;

			--select * from @Phone
	end
	else
	begin
		set @Continue = 0
		break;
	end;

	print @lvl;

	END -- while

	--select * from @Phone

	PRINT 'Done WHILE LOOP on TechOnTheNet.com';

Declare @temp3 Table (InmateID varchar(12), toNo varchar(12), Fname varchar(25), Lname varchar(25), CallCount int, LinkCount int, ShapeId int)
	insert @temp3 (InmateID,  toNo , Fname, Lname , CallCount,LinkCount, ShapeId)
	Select distinct InmateId,  toNo, Fname, LName, callCount, LinkCount, ShapeId
	from @Phone
	ORDER BY  ShapeId desc, toNo

	--select * from @temp3  where toNo =5595482800

Declare @inmatetemp Table (InmateID varchar(12) Null, inmatecount int,totalcount int)
insert @inmatetemp(InmateID, inmatecount, totalcount) 
select InmateID, sum(1) as inmatecount, SUM(CallCount)
from @temp3
group by InmateID

Declare @temp4 Table (toNo varchar(12),CallCount int, LinkCount int)
	insert @temp4 (toNo , CallCount,LinkCount )
	Select distinct toNo, sum(1), linkcount
	from @Phone
	group by toNo, linkcount,ShapeId

	--select * from @temp4

Declare @Phonetemp Table (toNo varchar(12) Null, Phcount int,totalcount int)
insert @Phonetemp(toNo, Phcount, totalcount) 
select toNo, sum(1) as Phcount, SUM(CallCount)
from @temp3
group by toNo

--select * from @Phonetemp

Declare @Result Table ([SetId] tinyint, [FromShapeName] varchar(12),[ToShapeName] varchar(12), [ShapeName] varchar(12), [ShapeContent] varchar(3),
FromNo varchar(12), Fname varchar(25), Lname varchar(25), RecordId varchar(12), ConnectDateTime datetime, RecordFile varchar(20),  Duration decimal(10,2) Null,  CallCount smallint, linkcount int, TransRecordId varchar(12))

---Connections
insert @result ([SetId], FromShapeName, [ToShapeName], [ShapeName] , [ShapeContent], fromNo, Fname, Lname, RecordId, ConnectDateTime, RecordFile, duration, CallCount, linkcount,TransRecordId )
Select distinct 1, toNo, InmateID, '', '', '' fromNo, '' Fname, '' LName, '' RecordId, '' ConnectDateTime, '' RecordFile, 0 duration, CallCount, LinkCount,''
from @Temp3

insert @result ([SetId], [FromShapeName], [ToShapeName], [ShapeName], [ShapeContent], fromNo, Fname, Lname, RecordId, ConnectDateTime, RecordFile, duration,CallCount, linkcount,TransRecordId)
Select distinct 2, '', '', a.InmateID, 
			('I' + 
			cast(case when inmatecount > 2 then 3
			when inmatecount = 1 then 1 
			when inmatecount = 2 then 2
			else inmatecount end as varchar(1))),
		  '', Fname, LName, '' RecordId, '' ConnectDateTime, '' RecordFile, 0 duration, totalcount,inmatecount,''
		
	from @Temp3 a, @inmatetemp b where a.InmateID =b.InmateID
			--order by InmateId

 --- Shapes for Phones
 insert @result ([SetId], [FromShapeName], [ToShapeName], [ShapeName] , [ShapeContent], FromNo, Fname, Lname, RecordId, ConnectDateTime, 
 RecordFile, duration,CallCount,linkcount, TransRecordId)

Select  distinct 2, '', '', a.toNo,
('P' + 
		cast(case when Phcount > 2 then 3
			when Phcount = 1 then 1 
			when Phcount = 2 then 2
			else Phcount end as varchar(1))),
		'' fromNo, '' Fname, '' LName, '' RecordId, '' ConnectDateTime, '' RecordFile, 0 duration, (select callCount from @Temp4 a where a.toNo = b.toNo), Phcount,''
			from @temp3 b, @Phonetemp a
			where a.toNo = b.toNo
			


insert @result ([SetId], [FromShapeName], [ToShapeName], [ShapeName] , [ShapeContent], FromNo, Fname, Lname, RecordId, ConnectDateTime, RecordFile, duration, CallCount, linkcount,TransRecordId)
Select  4, InmateId, toNo, '' ShapeName,
('P' + 
		cast(case when CallCount > 2 then 3
			when CallCount = 1 then 1 
			when CallCount = 2 then 2
			else CallCount end as varchar(1))),
		 fromNo, Fname,  LName,  RecordId,  ConnectDateTime,  RecordFile, duration,CallCount, linkcount,
		 (select isnull(recordID, '') from leg_Icon.dbo.tblRecordingTransMatch M where P.RecordID = M.RecordID )
			from @Phone P
			order by toNo
Update @result set Fname = Left(FirstName, 25), 
					LName =  Left(LastName,25), TransRecordId= M.RecordID
			From @result  r, tblPrepaid p WITH(NOLOCK),tblRecordingTransMatch M
			where   p.PhoneNo = r.ShapeName and M.RecordID=r.RecordId

declare  @UserAction varchar(100), @ActTime datetime      
EXEC [p_get_facility_time] @FacilityID ,@ActTime OUTPUT ;
SET  @UserAction =  'View Link Analysis Phone Detail from number: ' + @toNo;
EXEC  INSERT_ActivityLogs3	@FacilityID ,46,@ActTime ,0,@UsrName ,@userIP, @toNo,@UserAction ; 

select * from @Result
 order by SetId, linkcount desc


