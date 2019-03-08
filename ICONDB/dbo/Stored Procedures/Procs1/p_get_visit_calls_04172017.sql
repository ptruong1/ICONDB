-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_visit_calls_04172017] 
@facilityID int,
@fromDate varchar(10),
@toDate	  varchar(25),
@PIN	 varchar(12),
@InmateID varchar(12)

AS
BEGIN
  if (@toDate = '' or @toDate is null)
	Set @toDate = GETDATE(); 
  
  Set @toDate = DATEADD (D,1,@toDate)
  if( @fromDate <>'' and @fromDate is not null and @PIN <> '' and @InmateID = '')
	  SELECT P.StationID , C.PIN  ,    dateadd(s,-duration,RecordDate) as StartTime ,  duration ,  RecordName as FileName ,
	  (ComputerName + '\' + CAST(C.facilityID as varchar(12)) + '\'+ FolderDate  + '\' + RecordName + '.WAV') as RecordName
	  ,(ComputerName + '\' + CAST(C.facilityID as varchar(12)) + '\'+ FolderDate  + '\' + RecordName + '.WAV') as RecordID
	  , I.FirstName, I.LastName, I.InmateID 
	  FROM [leg_Icon].[dbo].[tblVisitCalls] C
	  left join [leg_Icon].[dbo].tblInmate I on  (C.InmateID = I.InmateID and C.facilityID = I.facilityID) 
	  , [leg_Icon].[dbo].tblACPs A, [leg_Icon].[dbo].tblVisitPhone P
	  where C.ServerIP = A.IpAddress  and 
			C.FacilityID = P.FacilityID and
			C.ExtID = P.ExtID And 
			C.FacilityID = @facilityID and 
			C.RecordDate between @fromDate and @todate	and
			C.PIN = @PIN 
			order by C.RecordDate Desc
  else if( @fromDate <>'' and @fromDate is not null and @PIN <> '' and @InmateID <> '')
	  SELECT P.StationID , C.PIN  ,    dateadd(s,-duration,RecordDate) as StartTime ,  duration ,  RecordName as FileName ,
	  (ComputerName + '\' + CAST(C.facilityID as varchar(12)) + '\'+ FolderDate  + '\' + RecordName + '.WAV') as RecordName
	  ,(ComputerName + '\' + CAST(C.facilityID as varchar(12)) + '\'+ FolderDate  + '\' + RecordName + '.WAV') as RecordID
	  , I.FirstName, I.LastName, I.InmateID 
	  FROM [leg_Icon].[dbo].[tblVisitCalls] C
	  left join [leg_Icon].[dbo].tblInmate I on (C.InmateID = I.InmateID and C.facilityID = I.facilityID) 
	  , [leg_Icon].[dbo].tblACPs A, [leg_Icon].[dbo].tblVisitPhone P
	  where C.ServerIP = A.IpAddress  and 
			C.FacilityID = P.FacilityID and
			C.ExtID = P.ExtID And 
			C.FacilityID = @facilityID and 
			C.RecordDate between @fromDate and @todate	and
			C.PIN = @PIN and
			I.InmateID =@InmateID
			order by C.RecordDate Desc
  else if( @fromDate <>'' and @fromDate is not null and @PIN = '' and @InmateID <> '')
	  SELECT P.StationID , C.PIN  ,    dateadd(s,-duration,RecordDate) as StartTime ,  duration ,  RecordName as FileName ,
	  (ComputerName + '\' + CAST(C.facilityID as varchar(12)) + '\'+ FolderDate  + '\' + RecordName + '.WAV') as RecordName
	  ,(ComputerName + '\' + CAST(C.facilityID as varchar(12)) + '\'+ FolderDate  + '\' + RecordName + '.WAV') as RecordID
	  , I.FirstName, I.LastName, I.InmateID 
	  FROM [leg_Icon].[dbo].[tblVisitCalls] C
	  left join [leg_Icon].[dbo].tblInmate I on  (C.InmateID = I.InmateID and C.facilityID = I.facilityID) 
	  , [leg_Icon].[dbo].tblACPs A, [leg_Icon].[dbo].tblVisitPhone P
	  where C.ServerIP = A.IpAddress  and 
			C.FacilityID = P.FacilityID and
			C.ExtID = P.ExtID And 
			C.FacilityID = @facilityID and 
			C.RecordDate between @fromDate and @todate	and
			I.InmateID =@InmateID
			order by C.RecordDate Desc
  		
  else if( @fromDate <>'' and @fromDate is not null )
	  SELECT P.StationID , C.PIN  ,    dateadd(s,-duration,RecordDate) as StartTime,  duration ,  RecordName as FileName ,    
	  (ComputerName + '\' + CAST(C.facilityID as varchar(12)) + '\'+ FolderDate  + '\' + RecordName + '.WAV') as RecordName
	  ,(ComputerName + '\' + CAST(C.facilityID as varchar(12)) + '\'+ FolderDate  + '\' + RecordName + '.WAV') as RecordID
	  , I.FirstName, I.LastName , I.InmateID 
	  FROM [leg_Icon].[dbo].[tblVisitCalls] C
	  left join [leg_Icon].[dbo].tblInmate I on (C.InmateID = I.InmateID and C.facilityID = I.facilityID) 
	  , [leg_Icon].[dbo].tblACPs A, [leg_Icon].[dbo].tblVisitPhone P
	  where C.FacilityID = P.FacilityID and
			C.ExtID = P.ExtID And 
			C.ServerIP = A.IpAddress  and 
			C.FacilityID = @facilityID and 
			C.RecordDate between @fromDate and @todate	
			order by C.RecordDate Desc
  else
	  SELECT P.StationID , C.PIN  ,   dateadd(s,-duration,RecordDate) as StartTime,  duration ,  RecordName as FileName ,    
	  (ComputerName + '\' + CAST(C.facilityID as varchar(12)) + '\'+ FolderDate  + '\' + RecordName + '.WAV') as RecordName 
	  , I.FirstName, I.LastName , I.InmateID 
	  FROM [leg_Icon].[dbo].[tblVisitCalls] C
	  left join [leg_Icon].[dbo].tblInmate I on (C.InmateID = I.InmateID and C.facilityID = I.facilityID) 
	  , [leg_Icon].[dbo].tblACPs A, [leg_Icon].[dbo].tblVisitPhone P
	  where C.FacilityID = P.FacilityID and
			C.ExtID = P.ExtID And 
			C.ServerIP = A.IpAddress  and 
			C.FacilityID = @facilityID 
			order by C.RecordDate Desc
END

