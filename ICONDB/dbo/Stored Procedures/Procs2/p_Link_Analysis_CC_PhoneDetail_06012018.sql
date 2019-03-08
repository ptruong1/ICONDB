
CREATE PROCEDURE [dbo].[p_Link_Analysis_CC_PhoneDetail_06012018]
@FacilityID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime,  -- Required 
@cNum varchar(20),
@UsrName varchar(25),
@userIP  varchar(16)

--@Count tinyint

 AS
  Declare @temp Table (FacilityID int, PhoneID varchar(20) Null, RecordID varchar(12) Null, fromNo varchar(16) Null, toNo varchar(16) Null, startTime datetime Null, 
ConnectDateTime datetime Null, CallingCard varchar(20) Null,  InmateID varchar(12) Null, Fname varchar(25) Null, LName varchar(25) Null, 
BillType varchar(40) Null, CallType varchar(40) Null, State varchar(30) Null, Duration decimal(10,2) Null,  CallRevenue Decimal(10, 2) Null, 
Descript varchar(40) Null, RecordFile varchar(50) Null, RecordID2 varchar(12) Null, DOB varchar(10) Null, Sex varchar(12) Null, 
Race varchar(30) Null, CallCount int, shapeId Varchar(4), levelId tinyint, cNum varchar(20), cPhone varchar(16), Language smallint)

Declare @Phone Table (FacilityID int, PhoneID varchar(20) Null, RecordID varchar(12) Null, fromNo varchar(16) Null, toNo varchar(16) Null, startTime datetime Null, 
ConnectDateTime datetime Null, CallingCard varchar(20) Null,  InmateID varchar(12) Null, Fname varchar(25) Null, LName varchar(25) Null, 
BillType varchar(40) Null, CallType varchar(40) Null, State varchar(30) Null, Duration decimal(10,2) Null,  CallRevenue Decimal(10, 2) Null, 
Descript varchar(40) Null, RecordFile varchar(50) Null, RecordID2 varchar(12) Null, DOB varchar(10) Null, Sex varchar(12) Null, 
Race varchar(30) Null, CallCount int,LinkCount int, shapeId Varchar(4), levelId tinyint, cNum varchar(20), cPhone varchar(16), Language smallint)

Declare @CCC Table (cNum varchar(20) Null, CPhone varchar(16) Null,  CCtransCount int)
insert @CCC(cNum, cPhone,  CCtransCount)
				select distinct cNum, cPhone, sum(1) as CCtransCount
				FROM [TecoData].[dbo].[tblBCResponse]
				where cNum not in ('', '***', '*******')
				and statusCode = '0'
				and cPhone <> ''
				and cNum = @cNum
				group by cNum, cPhone

				--select * from @CCC

insert @Temp(FacilityID, PhoneID, RecordID, fromNo, toNo, startTime, ConnectDateTime, CallingCard, InmateID, BillType, CallType, State, 
Duration , CallRevenue, Descript, RecordFile, RecordID2, CallCount, ShapeId, levelId, cNum, cPhone, Language ) 

(Select c.facilityID, left( A.StationID, 20) PhoneID, RecordID,  fromNo, Left(toNo, 12) As toNo,  
DATEADD(second, duration, recordDate) as startTime,  DATEADD(second, duration, recordDate) As ConnectDateTime,  
(case C.Billtype when '07' then left(CreditcardNo,16) else '' end ) CallingCard, Left(C.InmateID, 12) As InmateID,  Left(B.Descript, 40)  As  BillType,  
Left(T.Descript, 40)  As CallType,  'Completed' As  State,  duration,  
CallRevenue,  Left(P.Descript, '') as Descript,  RecordFile, 
'' as RecordID2, 0, 0, 1, cc.cNum, cc.cPhone, isnull(userlanguage, 1) as Language

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
and cNum = @cNum
and toNo in (select cphone from @CCC)
)

--select * from @temp order by recordId

Declare 
@Continue tinyint, @lvl int, @root tinyint 
set @root = 1
set @lvl = 0
set @Continue = 1 

Declare @XXX Table (cNum varchar(18) Null, toNo varchar(16) Null,  CallCount int)


insert @XXX(cNum, toNo, CallCount)
				select cNum, tono, sum(1) as callcount
				from @Temp
				group by toNo, cNum

begin
		set @lvl = @lvl + 1;
		insert @Phone(facilityID, PhoneID, RecordID, fromNo, T.toNo, startTime,  ConnectDateTime, CallingCard, T.InmateID, BillType, CallType, State, Duration,  
			CallRevenue, Descript,  RecordFile, RecordID2, CallCount,LinkCount, shapeId, levelId, cNum, cPhone, Language)

			Select facilityID, PhoneID, RecordID, fromNo, T.toNo, startTime,  ConnectDateTime, CallingCard, T.InmateID, BillType, CallType, State, Duration,  
			CallRevenue, Descript,  RecordFile, RecordID2, 1, 0 as LinkCount, 0 as ShapeId,
			@lvl as levelId, t.cNum, cPhone, Language
			 from  @temp T
			 inner join @XXX X
				on T.toNo = X.toNo and T.cNum = X.cNum
							

			Update @Phone set Fname = Left(FirstName, 25), LName =  Left(LastName,25),DOB =  Left(I.DOB, 10), Sex= Left(S.Descript, 12), Race= Left(R.Descript, 30),
				callCount = (select callcount from @XXX P where C.toNo = P.toNo and C.cNum = P.cNum )
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

		

	if (select count(*) from @XXX) > 0 
	begin
		set @lvl = @lvl + 1;
		insert @Phone(facilityID, PhoneID, RecordID, fromNo, T.toNo, startTime,  ConnectDateTime, CallingCard, T.InmateID, BillType, CallType, State, Duration,  
			CallRevenue, Descript,  RecordFile, RecordID2, CallCount, LinkCount, shapeId, levelId, cNum, cPhone, language)

			Select facilityID, PhoneID, RecordID, fromNo, T.toNo, startTime,  ConnectDateTime, CallingCard, T.InmateID, BillType, CallType, State, Duration,  
			CallRevenue, Descript,  RecordFile, RecordID2, 1, 0 as LinkCount, 0 as ShapeId,
			 @lvl as levelId, T.cNum, cPhone, Language
			 from  @temp T
			 inner join @XXX X
				on T.toNo = X.toNo and T.cNum = X.cNum
				
			

			Update @Phone set Fname = Left(FirstName, 25), LName =  Left(LastName,25),DOB =  Left(I.DOB, 10), Sex= Left(S.Descript, 12), Race= Left(R.Descript, 30),
				callCount = (select callcount from @XXX P where C.toNo = P.toNo and C.cNum = P.cNum )
				
				From @Phone  C, tblInmate I WITH(NOLOCK),   tblRaces R WITH(NOLOCK),  
				tblSex S WITH(NOLOCK)
				where   C.InmateId = I.InmateID And isnull(I.RaceID, 0) = R.RaceID 
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

	
	Delete from @XXX

		insert @XXX(cNum, toNo,  CallCount)
			select cNum, toNo, sum(1) as callcount
			from @Temp D
			where D.cNum in (select top 1 cNum from @Phone where levelId = @lvl)
			and not exists (select cNum, toNo from @phone where D.toNo = toNo and D.cNum = cNum)
			group by toNo, cNum;

		--Select * from @XXX

	
	if (select count(*) from @XXX) > 0 		
	begin
	set @lvl = @lvl + 1;
	insert @Phone(facilityID, PhoneID, RecordID, fromNo, toNo, startTime,  ConnectDateTime, CallingCard, InmateID, BillType, CallType, State, Duration,  
		CallRevenue, Descript,  RecordFile, RecordID2, CallCount, linkcount,shapeId, levelId, cNum, cPhone, Language)

		Select facilityID, PhoneID, RecordID, fromNo, T.toNo, startTime,  ConnectDateTime, CallingCard, T.InmateID, BillType, CallType, State, 
		duration, CallRevenue, Descript,  RecordFile, RecordID2, 1, 0 as LinkCount, 0 as ShapeId, 
		@lvl as levelId, T.cNum, cPhone, Language
		 from  @temp T
		 inner join @XXX X
			on T.toNo = X.toNo and T.cNum = X.cNum
			

			Update @Phone set Fname = Left(FirstName, 25), LName =  Left(LastName,25),DOB =  Left(I.DOB, 10), Sex= Left(S.Descript, 12), Race= Left(R.Descript, 30),
			callCount = (select callcount from @XXX P where C.toNo = P.toNo and C.cNum = P.cNum )
			
			From @Phone  C, tblInmate I WITH(NOLOCK), tblSex S WITH(NOLOCK), tblRaces R WITH(NOLOCK)
			where   C.InmateID = I.InmateID And isnull(I.RaceID, 0) = R.RaceId
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

	--select * from @Phone
	--order by cNum

	PRINT 'Done WHILE LOOP on TechOnTheNet.com';

Declare @temp3 Table (cNum varchar(12), toNo varchar(12), InmateId varchar(16), Fname varchar(25), Lname varchar(25), CallCount int, LinkCount int, ShapeId int, VFname varchar(25), VLname varchar(25))
	insert @temp3 (cNum,  toNo , InmateId, Fname, Lname , CallCount,LinkCount, ShapeId, VFname, VLname)

	Select cNum,  toNo,  InmateId,  Fname,  LName, callCount, LinkCount, ShapeId, '' VFname, '' VLname

	from @Phone
	ORDER BY  ShapeId desc, toNo

	 --select * from @temp3  

	Delete from @XXX

		insert @XXX(toNo, cNum,  CallCount)
			select tono, cNum, sum(1) as callcount
			from @Temp3 D
			
			group by cNum, toNo;

		--Select * from @XXX

		Declare @CCCount Table (cNum varchar(16) Null, LinkCount int, ccTotal int)		
		insert @CCCount(cNum, LinkCount, ccTotal)
				select cNum, sum(1) as LinkCount, sum(CallCount) as pTotal
				 from @XXX group by cNum;

			--select * from @CCCount

		Declare @PhoneCount Table (toNo varchar(16) Null,  LinkCount int, pTotal int)
	
		insert @PhoneCount(toNo, LinkCount, pTotal)
				select tono, sum(1) as LinkCount, sum(CallCount) as pTotal
				from @XXX group by toNo;

				--select * from @phoneCount

	

Declare @Result Table ([SetId] tinyint, [FromShapeName] varchar(12),[ToShapeName] varchar(12), [ShapeName] varchar(12), [ShapeContent] varchar(3),
FromNo varchar(12), Fname varchar(25), Lname varchar(25), RecordId varchar(12), ConnectDateTime datetime, RecordFile varchar(20),  
Duration varchar(8) Null,  CallCount smallint, linkcount int, TransRecordId varchar(12), cNum varchar(20), VFname varchar(25), VLname varchar(25),
[InmateId] varchar(12), userLanguage varchar(40))

---Connections
insert @result ([SetId], FromShapeName, [ToShapeName], [ShapeName] , [ShapeContent], fromNo, Fname, Lname, RecordId, ConnectDateTime, RecordFile, 
duration, CallCount, linkcount,TransRecordId, cNum, Vfname, VLname, InmateId, userLanguage )

Select distinct 1, cNum, toNo, '', '', '' fromNo, '' Fname, '' LName, '' RecordId, '' ConnectDateTime, '' RecordFile, 0 duration, CallCount, LinkCount,'', 
'' cNum, '' Vfname, '' VLname, '' InmateId, '' as userLanguage
from @Temp3

insert @result ([SetId], [FromShapeName], [ToShapeName], [ShapeName], [ShapeContent], fromNo, Fname, Lname, RecordId, ConnectDateTime, RecordFile, 
duration, CallCount, linkcount, TransRecordId, cNum, Vfname, VLname, InmateId, userLanguage)
Select distinct 2, '', '', a.cNum, 
			('C' + 
			cast(case when b.LinkCount > 2 then 3
			when b.LinkCount = 1 then 1 
			when b.LinkCount = 2 then 2
			else b.LinkCount end as varchar(1))),
		  '', '' Fname, '' LName, '' RecordId, '' ConnectDateTime, '' RecordFile, 0 duration, b.ccTotal, b.LinkCount, '', 
		  '' cNum, '' Vfname, '' VLname, '' InmateId, '' as userLanguage
		
	from @Temp3 a, @CCCount b where a.cNum =b.cNum
			--order by InmateId

 --- Shapes for Phones
 insert @result ([SetId], [FromShapeName], [ToShapeName], [ShapeName] , [ShapeContent], FromNo, Fname, Lname, RecordId, ConnectDateTime, 
 RecordFile, duration,CallCount,linkcount, TransRecordId, cNum, Vfname, VLname, InmateId, userLanguage)

Select  distinct 2, '', '', a.toNo,
('P' + 
		cast(case when b.LinkCount > 2 then 3
			when b.LinkCount = 1 then 1 
			when b.LinkCount = 2 then 2
			else b.LinkCount end as varchar(1))),
		'' fromNo, '' Fname, '' LName, '' RecordId, '' ConnectDateTime, '' RecordFile, 0 duration, b.pTotal, 
		b.LinkCount,'', '' cNum, '' Vfname, '' VLname, '' InmateId, '' userLanguage
			from @temp3 a, @PhoneCount b
			where a.toNo = b.toNo
			


insert @result ([SetId], [FromShapeName], [ToShapeName], [ShapeName] , [ShapeContent], FromNo, Fname, Lname, RecordId, ConnectDateTime, RecordFile, 
duration, CallCount, linkcount,TransRecordId, cNum, Vfname, VLname, InmateId, userLanguage)
Select  4,  InmateId, T.toNo, '' ShapeName,
('P' + 
		cast(case when T.LinkCount > 2 then 3
			when T.LinkCount = 1 then 1 
			when T.LinkCount = 2 then 2
			else T.LinkCount end as varchar(1))),
		  fromNo, T.Fname, T.LName, RecordId, ConnectDateTime, RecordFile, 
		  CONVERT(varchar(8), DATEADD(ms, duration * 1000, 0), 114) as duration,
		  T.CallCount, b.LinkCount,
		  '' TransRecordId, T.cNum, '' Vfname, '' VLname, InmateId,
		  (Select nation as userlanguage from tblLanguages where ACPSelectOpt = (select languageId from tblfacilityLanguages where languageOrder = T.Language and facilityId = @facilityId)) 
			from @Phone T, @CCCount b where T.cNum =b.cNum
			--inner join @Phone P on T.cNum = (select top 1 cNum from @Phone X where T.cNum = X.cNum) 
			order by toNo

	Update @result set VFname = Left(FirstName, 25), 
					VLName =  Left(LastName,25), TransRecordId= M.RecordID
			From @result  r, tblPrepaid p WITH(NOLOCK),tblRecordingTransMatch M
			where   p.PhoneNo = r.ShapeName and M.RecordID=r.RecordId

declare  @UserAction varchar(100), @ActTime datetime      
EXEC [p_get_facility_time] @FacilityID ,@ActTime OUTPUT ;
SET  @UserAction =  'View Link Analysis Credit Card Detail from number: ' + @cNum;
EXEC  INSERT_ActivityLogs3	@FacilityID ,46,@ActTime ,0,@UsrName ,@userIP, @cNum,@UserAction ; 

select *, (select DNI from tblWatchList where [ToShapeName] = DNI and watchById = 2 and SetId = 4) watchPhone 
from @Result
 order by SetId, linkcount desc