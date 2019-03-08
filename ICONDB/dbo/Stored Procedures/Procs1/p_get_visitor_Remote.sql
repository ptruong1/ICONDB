﻿-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_visitor_Remote] 
	@confirmID int,
	@AcctNo	   varchar(12)	
AS
BEGIN
	
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
   DECLARE  @StationID varchar(25),@PIN varchar(12), @InmateID varchar(12),@facilityID int,@timeZone tinyint,@flatform tinyint,   @localTime datetime,@timePass int, @cAcctNo varchar(12),@AppStatus  tinyint ;
   DECLARE  @ChatSerVerIP varchar(60), @VisitorName varchar(50) ,@InmateName  varchar(50),@AppDateTime	datetime ,@AppDuration int ,@VisitorID	int,@RecordOpt  char,@TextOpt char ,@RemainTime bigint ;
   DECLARE @visitType tinyint;
   SET @VisitorName='';
   SET @InmateName='';
   SET @ChatSerVerIP = '207.141.147.179';
   SET @RecordOpt='Y';
   SET @TextOpt='N';
   SET @AppDateTime='1/1/2000'	;
   SET @VisitorID=0;
   SET @RemainTime=0;
   SET @timeZone =0;
   SET @AppDuration =0;
   SET @AppStatus = 0;
   
   if(@AcctNo <>'0')
	   select @InmateName=inmateName, @InmateID=InmateID,@VisitorID=VisitorID,@AppDuration=LimitTime,@StationID=StationID,@AppStatus =[status],
	   @AppDateTime=  ApmDate + ApmTime , @facilityID = FacilityID,@RecordOpt = isnull(RecordOpt,'Y') , @visitType = visitType  from leg_Icon.dbo.tblVisitEnduserSchedule
		where   RoomID=@confirmID and (status=2 or status=3) and visitType =2 and EndUserID =@AcctNo ;
   
   if(@VisitorID >0)
    Begin	
	   SELECT @timeZone = timeZone,@flatform =flatform from tblFacility where facilityID =@facilityID;
	   SELECT @ChatSerVerIP=ChatServerIP from  leg_Icon.dbo.tblVisitPhoneServer  where facilityID =@facilityID;
	    select @VisitorName= left(VFirstName,24) + ' ' + VLastName from  leg_Icon.dbo.tblVisitors where VisitorID =@VisitorID;
	   Select @PIN = PIN from tblInmate with(nolock) where FacilityId = @facilityID and InmateID =@InmateID ;
	    SET @localTime = DATEADD(HH, @timeZone,GETDATE());
	   SET  @timePass =DATEDIFF (mi,@AppDateTime,@localTime );
	   if( @timePass >0)
		begin
		   if(@timePass < @AppDuration)
			begin
				SET @AppDuration =@AppDuration- @timePass;
				SET @RemainTime= DATEDIFF(SS, @localTime,@AppDateTime);
				if(select COUNT(*) from tblVisitOnline where RoomID = @confirmID) = 0
					INSERT tblVisitOnline(RoomID,FacilityID,  InmateID , InmateName , StationID  , ApmDate , status ,visitType ,LimitTime ,  VisitorName ,   VisitorIP, locationID , RecordOpt, VisitorLoginTime,ChatServerIP )
					values(@confirmID , @facilityID ,@PIN ,@InmateName ,@StationID ,@AppDateTime ,3,@visitType,@AppDuration, @VisitorName ,'Remote',NULL,@RecordOpt, GETDATE(), @ChatSerVerIP  );
				else
					Update tblVisitOnline SET VisitorName= @VisitorName, VisitorIP='Remote',status =5,  VisitorLoginTime=GETDATE() where RoomID = @confirmID ;
			end
		   else
			begin
				SET @AppDuration=0;
				
				SET @RemainTime =0;
			end 
			
		end
		else
		 begin
		   SET @RemainTime= DATEDIFF(SS, @localTime,@AppDateTime);
		   if(select COUNT(*) from tblVisitOnline where RoomID = @confirmID) = 0
					INSERT tblVisitOnline(RoomID,FacilityID,  InmateID , InmateName , StationID  , ApmDate , status ,visitType ,LimitTime ,  VisitorName ,   VisitorIP, locationID , RecordOpt, VisitorLoginTime,ChatServerIP )
					values(@confirmID , @facilityID ,@PIN ,@InmateName ,@StationID ,@AppDateTime ,3,@visitType,@AppDuration, @VisitorName ,'Remote',NULL,@RecordOpt, GETDATE(), @ChatSerVerIP  );
			else
					Update tblVisitOnline SET VisitorName= @VisitorName,VisitorIP='Remote',status =5,  VisitorLoginTime=GETDATE() where RoomID = @confirmID ;
		 end
	  
	  
	   
	 end
	else
	 Begin
		
		 ---visit exists but not online or approved----
		 if(select COUNT(*) from  leg_Icon.dbo.tblVisitEnduserSchedule  where EndUserID = @AcctNo and RoomID=@confirmID) > 0
			 begin
				set @VisitorID = -2;
				select @AppStatus= [status] from  leg_Icon.dbo.tblVisitEnduserSchedule  where EndUserID = @AcctNo and RoomID=@confirmID ;
			 end

		---account no exists => bad confirm no.
		 else if (select COUNT(*) from  leg_Icon.dbo.tblVisitEnduserSchedule  where EndUserID = @AcctNo) > 0
			set  @VisitorID = -1;

		--- account no doesn't exist
		 else
			set  @VisitorID = 0;

	 end 
	 select   @ChatSerVerIP as ChatSerVerIP , @VisitorName as VisitorName ,@InmateName  as InmateName,@AppDateTime	as AppDateTime ,
			@AppDuration as  AppDuration,@VisitorID	 as VisitorID,@RecordOpt  as RecordOpt,@TextOpt as TextOpt ,@RemainTime as RemainTime, @AppStatus as AppStatus ;
					
	
END

