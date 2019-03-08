-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_visitor_for_request_schedule_v1]
@FacilityID int,
@InmateID  varchar(12)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   select (b.VFirstName + ' ' + b.VLastName) as VisitorName, (d.FirstName + d.LastName) InmateName, f.Location, c.UserName, c.Password, c.Email
  from tblVisitorInmate a ,  tblVisitors b, tblendusers c, tblinmate d , tblfacility f
where (a.VisitorID = b.VisitorID and a.FacilityID = b.FacilityID)  
	and (a.InmateID = d.InmateID and a.FacilityID = d.FacilityId)
	 and (a.FacilityID = b.FacilityId  and b.FacilityID = d.FacilityId  and d.FacilityId= f.FacilityId)
	  and 	b.EndUserid = c.UserName and a.InmateID =@InmateID  and f.FacilityId =@FacilityID;
END

