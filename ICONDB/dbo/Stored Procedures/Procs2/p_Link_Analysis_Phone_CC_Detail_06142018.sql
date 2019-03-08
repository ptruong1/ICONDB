
Create PROCEDURE [dbo].[p_Link_Analysis_Phone_CC_Detail_06142018]
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
Race varchar(30) Null, CallCount int, shapeId Varchar(4), levelId tinyint, cNum varchar(20), cPhone varchar(16))

Declare @Phone Table (FacilityID int, PhoneID varchar(20) Null, RecordID varchar(12) Null, fromNo varchar(16) Null, toNo varchar(16) Null, startTime datetime Null, 
ConnectDateTime datetime Null, CallingCard varchar(20) Null,  InmateID varchar(12) Null, Fname varchar(25) Null, LName varchar(25) Null, 
BillType varchar(40) Null, CallType varchar(40) Null, State varchar(30) Null, Duration decimal(10,2) Null,  CallRevenue Decimal(10, 2) Null, 
Descript varchar(40) Null, RecordFile varchar(50) Null, RecordID2 varchar(12) Null, DOB varchar(10) Null, Sex varchar(12) Null, 
Race varchar(30) Null, CallCount int,LinkCount int, shapeId Varchar(4), levelId tinyint, cNum varchar(20), cPhone varchar(16))

Declare @CCC Table (cNum varchar(20) Null, CPhone varchar(16) Null,  CCtransCount int)
insert @CCC(cNum, cPhone,  CCtransCount)
				select cNum, cPhone, sum(1) as CCtransCount
				FROM [TecoData].[dbo].[tblBCResponse]
				where cNum not in ('', '***', '*******')
				and statusCode = '0'
				and cPhone <> ''
				group by cNum, cPhone

insert @Temp(FacilityID, PhoneID, RecordID, fromNo, toNo, startTime, ConnectDateTime, CallingCard, InmateID, BillType, CallType, State, 
Duration , CallRevenue, Descript, RecordFile, RecordID2, CallCount, ShapeId, levelId, cNum, cPhone ) 

(Select c.facilityID, left( A.StationID, 20) PhoneID, RecordID,  fromNo, Left(toNo, 12) As toNo,  
DATEADD(second, - duration, recordDate) as startTime,  RecordDate As ConnectDateTime,  
(case C.Billtype when '07' then left(CreditcardNo,16) else '' end ) CallingCard, Left(C.InmateID, 12) As InmateID,  Left(B.Descript, 40)  As  BillType,  
Left(T.Descript, 40)  As CallType,  'Completed' As  State,  CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2))  as Duration,  
CallRevenue,  Left(P.Descript, '') as Descript,  RecordFile, 
'' as RecordID2, 0, 0, 1, cc.cNum, cc.cPhone

From tblcallsBilled  C WITH(NOLOCK),  tblBilltype B WITH(NOLOCK),  
tblCallType T WITH(NOLOCK) ,  tblANIs A,  tblPhonetypes P, @CCC cc 
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
and tono = cc.cPhone
and toNo = @toNo
)

--select * from @temp
Declare 
@Continue tinyint, @lvl int, @root tinyint 
set @root = 1
set @lvl = 0
set @Continue = 1 

Declare @XXX Table (cNum varchar(18) Null, toNo varchar(16) Null,  CallCount int)
Declare @YYY Table (InmateID varchar(12) Null, toNo varchar(16) Null,  CallCount int)
Declare @PhoneCount Table (toNo varchar(16) Null,  LinkCount int)
Declare @CCCount Table (cNum varchar(16) Null,  CallCount int)

insert @XXX(toNo, cNum,  CallCount)
				select tono, cNum, sum(1) as callcount
				from @Temp
				where toNo = @toNo
				group by toNo, cNum

				--select * from  @XXX

insert @PhoneCount(toNo, LinkCount)
			select tono, sum(1) as LinkCount from @XXX group by toNo;

begin
		set @lvl = @lvl + 1;
		insert @Phone(facilityID, PhoneID, RecordID, fromNo, T.toNo, startTime,  ConnectDateTime, CallingCard, T.InmateID, BillType, CallType, State, Duration,  
			CallRevenue, Descript,  RecordFile, RecordID2, CallCount,LinkCount, shapeId, levelId, cNum, cPhone)

			Select facilityID, PhoneID, RecordID, fromNo, T.toNo, startTime,  ConnectDateTime, CallingCard, T.InmateID, BillType, CallType, State, Duration,  
			CallRevenue, Descript,  RecordFile, RecordID2, 1,1,1, @lvl as levelId, t.cNum, cPhone
			 from  @temp T
			 inner join @XXX X
				on T.toNo = X.toNo and T.cNum = X.cNum
				--left join @PhoneCount p on p.toNo = T.toNo
				--and (select top 1 LinkCount from @PhoneCount where  T.toNo = toNo ) > @Count
				--and not exists (select ToNo, InmateId from @phone where T.toNo = toNo and T.InmateId = InmateId);

			

			Update @Phone set Fname = Left(FirstName, 25), LName =  Left(LastName,25),DOB =  Left(I.DOB, 10), Sex= Left(S.Descript, 12), Race= Left(R.Descript, 30),
				callCount = (select callCount from @XXX P where C.toNo = P.toNo  and C.cNum = P.cNum ),
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

		insert @XXX(toNo, cNum,  CallCount)
			select tono, cNum, sum(1) as callcount
			from @Temp D
			where D.cNum in (select top 1 cNum from @Phone where levelId = @lvl)
			and not exists (select ToNo, InmateId from @phone where D.toNo = toNo and D.cNum = cNum)
			group by cNum, toNo;

		--Select * from @XXX

		insert @CCCount(cNum, CallCount)
			select cNum, sum(1) as callcount from @XXX group by cNum;

	if (select count(*) from @XXX) > 0 
	begin
		set @lvl = @lvl + 1;
		insert @Phone(facilityID, PhoneID, RecordID, fromNo, T.toNo, startTime,  ConnectDateTime, CallingCard, T.InmateID, BillType, CallType, State, Duration,  
			CallRevenue, Descript,  RecordFile, RecordID2, CallCount,LinkCount, shapeId, levelId, cNum, cPhone)

			Select facilityID, PhoneID, RecordID, fromNo, T.toNo, startTime,  ConnectDateTime, CallingCard, T.InmateID, BillType, CallType, State, Duration,  
			CallRevenue, Descript,  RecordFile, RecordID2, 1,1,1, @lvl as levelId, T.cNum, cPhone
			 from  @temp T
			 inner join @XXX X
				on T.toNo = X.toNo and T.cNum = X.cNum
				--left join @PhoneCount p on p.toNo = T.toNo
				--and (select top 1 LinkCount from @PhoneCount where  T.toNo = toNo ) > @Count
				--and not exists (select ToNo, InmateId from @phone where T.toNo = toNo and T.InmateId = InmateId);

			

			Update @Phone set Fname = Left(FirstName, 25), LName =  Left(LastName,25),DOB =  Left(I.DOB, 10), Sex= Left(S.Descript, 12), Race= Left(R.Descript, 30),
				callCount = (select callCount from @XXX P where C.toNo = P.toNo  and C.cNum = P.cNum ),
				shapeId = (select top 1 LinkCount from @CCCount where  C.cNum = cNum ),
				LinkCount = (select top 1 LinkCount from @CCCount where  C.cNum = cNum  )
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

		insert @XXX(toNo, cNum,  CallCount)
			select tono, cNum, sum(1) as callcount
			from @Temp D
			where D.toNo in (select top 1 toNo from @Phone where levelId = @lvl)
			and not exists (select ToNo, cNum from @phone where D.toNo = toNo and D.cNum = cNum)
			group by toNo, cNum;

		--Select * from @XXX

		insert @PhoneCount(toNo, LinkCount)
			select toNo, sum(1) as callcount from @XXX group by toNo;

	if (select count(*) from @XXX) > 0 		
	begin
	set @lvl = @lvl + 1;
	insert @Phone(facilityID, PhoneID, RecordID, fromNo, toNo, startTime,  ConnectDateTime, CallingCard, InmateID, BillType, CallType, State, Duration,  
		CallRevenue, Descript,  RecordFile, RecordID2, CallCount, linkcount,shapeId, levelId, cNum, cPhone)

		Select facilityID, PhoneID, RecordID, fromNo, T.toNo, startTime,  ConnectDateTime, CallingCard, T.InmateID, BillType, CallType, State, Duration,  
		CallRevenue, Descript,  RecordFile, RecordID2, 1,1, 1, @lvl as levelId, T.cNum, cPhone
		 from  @temp T
		 inner join @XXX X
			on T.toNo = X.toNo and T.cNum = X.cNum
			--left join @PhoneCount p on p.toNo = T.toNo
			--and (select top 1 callcount from @InmateCount I where  T.InmateId = I.InmateId ) > @Count
			--and not exists (select ToNo, InmateId from @phone where T.toNo = toNo and T.InmateId = InmateId);


			Update @Phone set Fname = Left(FirstName, 25), LName =  Left(LastName,25),DOB =  Left(I.DOB, 10), Sex= Left(S.Descript, 12), Race= Left(R.Descript, 30),
			callCount = (select callCount from @XXX P where C.toNo = P.toNo  and C.cNum = P.cNum ),
			shapeId = (select top 1 callcount from @PhoneCount where  C.toNo = toNo )
			--LinkCount = (select top 1 callcount from @InmateCount where  C.InmateId = InmateId )
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

	END -- while

	--select distinct cNum from @Phone
	--order by cNum

	PRINT 'Done WHILE LOOP on TechOnTheNet.com';

Declare @temp3 Table (cNum varchar(12), toNo varchar(12), InmateId varchar(16), Fname varchar(25), Lname varchar(25), CallCount int, LinkCount int, ShapeId int, VFname varchar(25), VLname varchar(25))
	insert @temp3 (cNum,  toNo , InmateId, Fname, Lname , CallCount,LinkCount, ShapeId, VFname, VLname)

	--Select distinct cNum,  toNo, InmateId, Fname, LName, callCount, LinkCount, ShapeId, '' VFname, '' VLname
	Select distinct cNum,  toNo, '' InmateId, '' Fname, '' LName, callCount, LinkCount, ShapeId, '' VFname, '' VLname
	from @Phone
	ORDER BY  ShapeId desc, toNo

	--select * from @temp3  

Declare @cctemp Table (cNum varchar(12) Null, cccount int,totalcount int)
insert @cctemp(cnum, cccount, totalcount) 
select cNum, sum(1) as cccount, SUM(CallCount)
from @temp3
group by cNum

Declare @Phonetemp Table (toNo varchar(12) Null, Phcount int,totalcount int)
insert @Phonetemp(toNo, Phcount, totalcount) 
select toNo, sum(1) as Phcount, SUM(CallCount)
from @temp3
group by toNo

--select * from @Phonetemp

Declare @Result Table ([SetId] tinyint, [FromShapeName] varchar(12),[ToShapeName] varchar(12), [ShapeName] varchar(12), [ShapeContent] varchar(3),
FromNo varchar(12), Fname varchar(25), Lname varchar(25), RecordId varchar(12), ConnectDateTime datetime, RecordFile varchar(20),  
Duration decimal(10,2) Null,  CallCount smallint, linkcount int, TransRecordId varchar(12), cNum varchar(20), VFname varchar(25), VLname varchar(25),
[InmateId] varchar(12))

---Connections
insert @result ([SetId], FromShapeName, [ToShapeName], [ShapeName] , [ShapeContent], fromNo, Fname, Lname, RecordId, ConnectDateTime, RecordFile, 
duration, CallCount, linkcount,TransRecordId, cNum, Vfname, VLname, InmateId )
Select distinct 1, toNo, cNum, '', '', '' fromNo, '' Fname, '' LName, '' RecordId, '' ConnectDateTime, '' RecordFile, 0 duration, CallCount, LinkCount,'', 
'' cNum, '' Vfname, '' VLname, '' InmateId
from @Temp3

insert @result ([SetId], [FromShapeName], [ToShapeName], [ShapeName], [ShapeContent], fromNo, Fname, Lname, RecordId, ConnectDateTime, RecordFile, 
duration,CallCount, linkcount,TransRecordId, cNum, Vfname, VLname, InmateId)
Select distinct 2, '', toNo, a.cNum, 
			('C' + 
			cast(case when cccount > 2 then 3
			when cccount = 1 then 1 
			when cccount = 2 then 2
			else cccount end as varchar(1))),
		  '', Fname, LName, '' RecordId, '' ConnectDateTime, '' RecordFile, 0 duration, totalcount, cccount, '', '' cNum, '' Vfname, '' VLname, '' InmateId
		
	from @Temp3 a, @cctemp b where a.cNum =b.cNum
			--order by InmateId

 --- Shapes for Phones
 insert @result ([SetId], [FromShapeName], [ToShapeName], [ShapeName] , [ShapeContent], FromNo, Fname, Lname, RecordId, ConnectDateTime, 
 RecordFile, duration,CallCount,linkcount, TransRecordId, cNum, Vfname, VLname, InmateId)

Select  distinct 2, '', '', a.toNo,
('P' + 
		cast(case when Phcount > 2 then 3
			when Phcount = 1 then 1 
			when Phcount = 2 then 2
			else Phcount end as varchar(1))),
		'' fromNo, '' Fname, '' LName, '' RecordId, '' ConnectDateTime, '' RecordFile, 0 duration, callCount, 
		Phcount,'', '' cNum, '' Vfname, '' VLname, '' InmateId
			from @temp3 b, @Phonetemp a
			where a.toNo = b.toNo
			


insert @result ([SetId], [FromShapeName], [ToShapeName], [ShapeName] , [ShapeContent], FromNo, Fname, Lname, RecordId, ConnectDateTime, RecordFile, 
duration, CallCount, linkcount,TransRecordId, cNum, Vfname, VLname, InmateId)
Select  distinct 4, '' InmateId, T.toNo, '' ShapeName,
('P' + 
		cast(case when T.CallCount > 2 then 3
			when T.CallCount = 1 then 1 
			when T.CallCount = 2 then 2
			else T.CallCount end as varchar(1))),
		 '' fromNo, T.Fname,  T.LName,  '' RecordId,  '' ConnectDateTime,  '' RecordFile, 0 duration, T.CallCount, T.linkcount,
		 '' RecordId, T.cNum, '' Vfname, '' VLname, InmateId
			from @Temp3 T
			--inner join @Phone P on T.cNum = (select top 1 cNum from @Phone X where T.cNum = X.cNum) 
			order by toNo

	Update @result set TransRecordId = M.RecordID
			From @result r, tblRecordingTransMatch M
			where    M.RecordID=r.RecordId and SetId = 4

		Update @result set VFname = isnull(Left(CCFirstName, 25),''), VLName =  isnull(Left(CCLastName,25),'') 
		From @result  r, tblPrepaidPayments p WITH(NOLOCK)
		where   p.AccountNo = toShapeName 
		and SetId = 4 
		Update @result set Fname = isnull(Left(CCFirstName, 25),''), LName =  isnull(Left(CCLastName,25),'') From @result  r, tblPrepaidPayments p WITH(NOLOCK)  
		where   p.AccountNo = r.ToShapeName 
		and SetId = 2 and ShapeContent like 'C%' 

		Update @result set Fname = Left(FirstName, 25), LName =  Left(LastName,25) From @result  r, tblPrepaid p WITH(NOLOCK)  
		where   p.PhoneNo = r.ShapeName 
		and SetId = 2 and ShapeContent like 'P%' 

declare  @UserAction varchar(100), @ActTime datetime      
EXEC [p_get_facility_time] @FacilityID ,@ActTime OUTPUT ;
SET  @UserAction =  'View Link Analysis Phone Detail from number: ' + @toNo;
EXEC  INSERT_ActivityLogs3	@FacilityID ,46,@ActTime ,0,@UsrName ,@userIP, @toNo,@UserAction ; 

select *, (select DNI from tblWatchList where [ToShapeName] = DNI and watchById = 2 and SetId = 4) watchPhone 
from @Result
 order by SetId, linkcount desc

