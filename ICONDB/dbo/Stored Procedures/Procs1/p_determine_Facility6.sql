
CREATE PROCEDURE [dbo].[p_determine_Facility6]   -- Use for Live OP
@ANI	varchar(10)  ,
@facilityID  int  OUTPUT,
@AgentID  Varchar(7) OUTPUT,
@maxCallTime	smallint  OUTPUT,
@ratePlanID    varchar(5) OUTPUT,
@City		   varchar(10) OUTPUT,
@State		   varchar(2) OUTPUT,
@Property	   varchar(150) OUTPUT

 AS
SET NOCOUNT ON
Declare  @Fphone char(10);
SET @facilityID = 0;
SET @AgentID =0;


if(@facilityID =0)
	SELECT  @facilityID =  facilityID 	 from tblANIs  with(nolock) where ANIno =  @ANI;
--- Modify more on this

Select 	 @AgentID =F.AgentID, @Fphone = phone, @maxCallTime = maxCallTime,@ratePlanID = RateplanID,@City= left(City,2) ,@State = [State], @Property = left(Location,150)  	From   tblFacility  F with(nolock) 
		where  F.FacilityID = @facilityID   ;
 
