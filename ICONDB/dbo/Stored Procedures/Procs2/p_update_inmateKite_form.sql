-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_inmateKite_form] 
		   @FacilityID int,
           @FormID int,
           @Status tinyint
           

AS
BEGIN
SET NOCOUNT ON;
Declare @RequestDate datetime, @LocationID int, @timeZone tinyint;

SET @timeZone =0;
--SET @timeZone = (select timeZone from tblfacility where FacilityID =@FacilityID ); 
--SET @RequestDate = dateadd(hour,@timeZone, GETDATE()); 
	Update [leg_Icon].[dbo].[tblInmateRequestForm] SET Status =@Status  where FormID = @FormID ;
           

select  [FormID]
      ,G.[FacilityID]
      ,G.[InmateID],(I.FirstName + ' ' + I.LastName) as InmateName 
      ,[BookingNo]
      ,[InmateLocation]
      ,[RequestDate]
      ,[Request]
      ,[Reply]
      ,[ReplyName]
      ,[ReplyDateTime]
      ,G.[Status] as [StatusID]     
            
      ,F.[Descript] as [Status] from tblInmateRequestForm G inner join tblInmate  I on (G.FacilityID = I.FacilityId and G.InmateID =I.InmateID )
           Inner join tblFormstatus F on (G.status = F.statusID)
           where formID =@formID ;
           
END


