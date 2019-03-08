﻿-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_comm_off_by_date_by_facility] 
@CallDate varchar(6),
@facilityID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

declare @duration int;
Set @duration=25;

--set @calldate ='160221'
while @duration <100
begin
	set  @duration =  @duration  +  @duration%5 +2
	--select  @duration;
	Update  tblcallsbilled set errorcode ='5' , DBError= 'E'
	 where calldate =@calldate  and errorCode='0' and billtype <> '08' and billtype <'11' 
	and facilityID = @facilityID 
	and duration =@duration
 end

Set @duration=101;
while @duration <400
begin
	set  @duration =  @duration  +  @duration%7 +3
	--select  @duration;
	Update  tblcallsbilled set errorcode ='5' , DBError= 'E'
	 where calldate =@calldate and errorCode='0' and billtype <> '08' and billtype <'11' 
	and facilityID = @facilityID 
	and duration =@duration
 end

 Set @duration=401;
while @duration <800
begin
	set  @duration =  @duration  +  @duration%6 +3
	--select  @duration;
	Update  tblcallsbilled set errorcode ='5' , DBError= 'E'
	 where calldate =@calldate and errorCode='0' and billtype <> '08' and billtype <'11' 
	and facilityID = @facilityID 
	and duration =@duration
 end

 
 Set @duration=801;
while @duration <1041
begin
	set  @duration =  @duration  +  @duration%7 +3
	--select  @duration;
	Update  tblcallsbilled set errorcode ='5' , DBError= 'E'
	 where calldate =@calldate and errorCode='0' and billtype <> '08' and billtype <'11' 
	and facilityID = @facilityID 
	and duration =@duration
 end
  Set @duration=1041;
while @duration <1220
begin
	set  @duration =  @duration  +  @duration%8 +3
	--select  @duration;
	Update  tblcallsbilled set errorcode ='5' , DBError= 'E'
	 where calldate =@calldate  and errorCode='0' and billtype <> '08' and billtype <'11' 
	and facilityID = @facilityID 
	and duration =@duration
 end
END

