-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_auto_update_status]
	
		
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--SET NOCOUNT ON;
	Declare	@localTime datetime	;		
  --Updat complete 
    --order by v.ApmDate,v.ApmTime
    SET @localTime = GETDATE();
    
    update tblVisitEnduserSchedule set status=7, CancelBy ='Admin'
    --select v.ApmDate,v.ApmTime,DATEADD(MINUTE,limittime,DATEADD(hh,DATEPART(hh,v.ApmTime), v.ApmDate )) ,GETDATE()  
    from tblVisitEnduserSchedule v,tblfacility f
    where
    f.FacilityID = v.FacilityID and
    DATEADD(MINUTE,limittime + 15,DATEADD(MINUTE,DATEPART(MINUTE,v.ApmTime),  DATEADD(HOUR,DATEPART(HOUR,v.ApmTime), v.ApmDate ))) < DATEADD(HOUR, f.timeZone , @localTime) and v.status in (1,2,3)
    and InmateLogInID is null and VisitorLogInID is not null;
    
     update tblVisitEnduserSchedule set status=8, CancelBy ='Admin'
    --select v.ApmDate,v.ApmTime,DATEADD(MINUTE,limittime,DATEADD(hh,DATEPART(hh,v.ApmTime), v.ApmDate )) ,GETDATE()  
    from tblVisitEnduserSchedule v,tblfacility f
    where
    f.FacilityID = v.FacilityID and
    DATEADD(MINUTE,limittime + 15,DATEADD(MINUTE,DATEPART(MINUTE,v.ApmTime),  DATEADD(HOUR,DATEPART(HOUR,v.ApmTime), v.ApmDate ))) < DATEADD(HOUR, f.timeZone , @localTime) and v.status in (1,2,3)
    and  VisitorLogInID is null and InmateLogInID is not null;
    
     update tblVisitEnduserSchedule set status=10,CancelBy ='Admin'
    --select v.ApmDate,v.ApmTime,DATEADD(MINUTE,limittime,DATEADD(hh,DATEPART(hh,v.ApmTime), v.ApmDate )) ,GETDATE()  
    from tblVisitEnduserSchedule v,tblfacility f
    where
    f.FacilityID = v.FacilityID and
    DATEADD(MINUTE,limittime + 15,DATEADD(MINUTE,DATEPART(MINUTE,v.ApmTime),  DATEADD(HOUR,DATEPART(HOUR,v.ApmTime), v.ApmDate ))) < DATEADD(HOUR, f.timeZone , @localTime) and v.status in (1,2,3)
    and  VisitorLogInID is null and InmateLogInID is  null;

	--- Error file 

	 update tblVisitEnduserSchedule set status=7, CancelBy ='Admin'
    --select v.ApmDate,v.ApmTime,DATEADD(MINUTE,limittime,DATEADD(hh,DATEPART(hh,v.ApmTime), v.ApmDate )) ,GETDATE()  
    from tblVisitEnduserSchedule v,tblfacility f
    where
    f.FacilityID = v.FacilityID and
    DATEADD(MINUTE,limittime +180 ,DATEADD(MINUTE,DATEPART(MINUTE,v.ApmTime),  DATEADD(HOUR,DATEPART(HOUR,v.ApmTime), v.ApmDate ))) < DATEADD(HOUR, f.timeZone , @localTime) and v.status =5
    and RecordStatus is null and v.visitDuration IS NULL 
	and ApmNo in (select RoomID from tblVisitOnline with(nolock) where  status=5 and InmateLoginTime is  null and VisitorLoginTime is not null);

	 update tblVisitEnduserSchedule set status=8, CancelBy ='Admin'
    --select v.ApmDate,v.ApmTime,DATEADD(MINUTE,limittime,DATEADD(hh,DATEPART(hh,v.ApmTime), v.ApmDate )) ,GETDATE()  
    from tblVisitEnduserSchedule v,tblfacility f
    where
    f.FacilityID = v.FacilityID and
    DATEADD(MINUTE,limittime + 180,DATEADD(MINUTE,DATEPART(MINUTE,v.ApmTime),  DATEADD(HOUR,DATEPART(HOUR,v.ApmTime), v.ApmDate ))) < DATEADD(HOUR, f.timeZone , @localTime) and v.status =5
    and   RecordStatus is null and v.visitDuration IS NULL
	and ApmNo in (select RoomID from tblVisitOnline with(nolock) where  status=5 and InmateLoginTime is not null and VisitorLoginTime is null);
    
     update tblVisitEnduserSchedule set status=10,CancelBy ='Admin'
    --select v.ApmDate,v.ApmTime,DATEADD(MINUTE,limittime,DATEADD(hh,DATEPART(hh,v.ApmTime), v.ApmDate )) ,GETDATE()  
    from tblVisitEnduserSchedule v,tblfacility f
    where
    f.FacilityID = v.FacilityID and
    DATEADD(MINUTE,limittime + 180,DATEADD(MINUTE,DATEPART(MINUTE,v.ApmTime),  DATEADD(HOUR,DATEPART(HOUR,v.ApmTime), v.ApmDate ))) < DATEADD(HOUR, f.timeZone , @localTime) and v.status =5
    and  RecordStatus is null and v.visitDuration IS NULL 
	and ApmNo in (select RoomID from tblVisitOnline with(nolock) where  status=5 and InmateLoginTime is not null and VisitorLoginTime is not null);
    
   
    
    --SET @localTime = getdate()
    --update tblVisitEnduserSchedule set status=4
    ------select v.ApmDate,v.ApmTime,DATEADD(MINUTE,limittime,DATEADD(hh,DATEPART(hh,v.ApmTime), v.ApmDate )) ,GETDATE()  
    --from tblVisitEnduserSchedule v,tblfacility f
    --where
    --f.FacilityID = v.FacilityID and
    --DATEADD(MINUTE,limittime +80,DATEADD(MINUTE,DATEPART(MINUTE,v.ApmTime),  DATEADD(HOUR,DATEPART(HOUR,v.ApmTime), v.ApmDate )))  < DATEADD(HOUR, f.timeZone , @localTime) and v.status =3
    
	
     update tblVisitEnduserSchedule set status=4,CancelBy ='Admin'
    --select v.ApmDate,v.ApmTime,DATEADD(MINUTE,limittime,DATEADD(hh,DATEPART(hh,v.ApmTime), v.ApmDate )) ,GETDATE()  
    from tblVisitEnduserSchedule v,tblfacility f
    where
    f.FacilityID = v.FacilityID and
    DATEADD(MINUTE,limittime + 60,DATEADD(MINUTE,DATEPART(MINUTE,v.ApmTime),  DATEADD(HOUR,DATEPART(HOUR,v.ApmTime), v.ApmDate ))) 
	 < DATEADD(HOUR, f.timeZone , @localTime) and v.status =3 ;
    
	
END

