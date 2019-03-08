-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_comm_off] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Declare @duration int,@calldate char(6)	
Set @duration=25;
Set @calldate = right(convert(varchar(12), dateadd(day,-1, getdate()),112),6);
--set @calldate ='160221'
while @duration <100
begin
	set  @duration =  @duration  +  @duration%8 +2
	--select  @duration;
	Update  tblcallsbilled set errorcode ='4' , DBError= 'R'
	 where calldate =@calldate  and errorCode='0' and billtype <> '08' and billtype <'11' 
	and AgentID not in(404,465,1288,1275,1157,1280,100,7,102,101) and facilityID <400 and  facilityID >10 
	and duration =@duration;
	Update  tblcallsbilled set errorcode ='4' , DBError= 'R'
	 where calldate =@calldate  and errorCode='0' and billtype <> '08' and billtype <'11' 
	and  facilityID = 686 and billtype in ('03','05')
	and duration =@duration;
 end

Set @duration=101;
while @duration <400
begin
	set  @duration =  @duration  +  @duration%7 +3
	--select  @duration;
	Update  tblcallsbilled set errorcode ='4' , DBError= 'R'
	 where calldate =@calldate and errorCode='0' and billtype <> '08' and billtype <'11' 
	and AgentID not in(404,465,1288,1275,1157,1280,100,7,102,101) and  facilityID <400 and  facilityID >10 
	and duration =@duration
 end

 Set @duration=401;
while @duration <800
begin
	set  @duration =  @duration  +  @duration%3 +3
	--select  @duration;
	Update  tblcallsbilled set errorcode ='4' , DBError= 'R'
	 where calldate =@calldate and errorCode='0' and billtype <> '08' and billtype <'11' 
	and AgentID not in(404,465,1288,1275,1157,1280,100,7,102,101) and   facilityID <400 and  facilityID >10 
	and duration =@duration;
	Update  tblcallsbilled set errorcode ='4' , DBError= 'R'
	 where calldate =@calldate  and errorCode='0' and billtype <> '08' and billtype <'11' 
	and  facilityID = 686 and billtype in ('03','05')
	and duration =@duration;
 end

 
 Set @duration=801;
while @duration <1041
begin
	set  @duration =  @duration  +  @duration%8 +3
	--select  @duration;
	Update  tblcallsbilled set errorcode ='4' , DBError= 'R'
	 where calldate =@calldate and errorCode='0' and billtype <> '08' and billtype <'11' 
	and AgentID not in(404,465,1288,1275,1157,1280,100,7,102,101)  and facilityID <400 and  facilityID >10 
	and duration =@duration
 end
  Set @duration=1041;
while @duration <1220
begin
	set  @duration =  @duration  +  @duration%9 +4
	--select  @duration;
	Update  tblcallsbilled set errorcode ='4' , DBError= 'R'
	 where calldate =@calldate  and errorCode='0' and billtype <> '08' and billtype <'11' 
	and AgentID not in(404,465,1288,1275,1157,1280,100,7,102,101) and  facilityID <400 and  facilityID >10 
	and duration =@duration
 end
END

