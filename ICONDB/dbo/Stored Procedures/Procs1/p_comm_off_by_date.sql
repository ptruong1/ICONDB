-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_comm_off_by_date] 
@CallDate varchar(6)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @duration int;
Set @duration=25;

--set @calldate ='160221'
while @duration <100
begin
	set  @duration =  @duration  +  @duration%8 +3
	--select  @duration;
	Update  tblcallsbilled set errorcode ='5' , DBError= 'R'
	 where calldate =@calldate  and errorCode='0' and billtype <> '08' and billtype <'11' 
	and AgentID not in(404,465,1288,1275,1157,1280,7,102,101) and facilityID not in( 689,686,781,786) and  facilityID >10 
	and duration =@duration
 end

Set @duration=101;
while @duration <400
begin
	set  @duration =  @duration  +  @duration%7 +4
	--select  @duration;
	Update  tblcallsbilled set errorcode ='5' , DBError= 'R'
	 where calldate =@calldate and errorCode='0' and billtype <> '08' and billtype <'11' 
	and AgentID not in(404,465,1288,1275,1157,1280,7,102,101) and facilityID not in ( 689,686,781,786) and  facilityID >10 
	and duration =@duration
 end

 Set @duration=401;
while @duration <800
begin
	set  @duration =  @duration  +  @duration%3 +4
	--select  @duration;
	Update  tblcallsbilled set errorcode ='5' , DBError= 'R'
	 where calldate =@calldate and errorCode='0' and billtype <> '08' and billtype <'11' 
	and AgentID not in(404,465,1288,1275,1157,1280,7,102,101) and facilityID not in ( 689,686,781,786) and  facilityID >10 
	and duration =@duration
 end

 
 Set @duration=801;
while @duration <1041
begin
	set  @duration =  @duration  +  @duration%8 +4
	--select  @duration;
	Update  tblcallsbilled set errorcode ='5' , DBError= 'R'
	 where calldate =@calldate and errorCode='0' and billtype <> '08' and billtype <'11' 
	and AgentID not in(404,465,1288,1275,1157,1280,7,102,101) and facilityID not in ( 689,686,781,786) and  facilityID >10 
	and duration =@duration
 end
  Set @duration=1041;
while @duration <1220
begin
	set  @duration =  @duration  +  @duration%9 +5
	--select  @duration;
	Update  tblcallsbilled set errorcode ='5' , DBError= 'R'
	 where calldate =@calldate  and errorCode='0' and billtype <> '08' and billtype <'11' 
	and AgentID not in(404,465,1288,1275,1157,1280,7,102,101) and facilityID not in ( 689,686,781,786) and  facilityID >10 
	and duration =@duration
 end
END

