-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_insert_inmateKite_form] 
		   @FacilityID int,
           @InmateID varchar(12),
           @InmateSO varchar(12),
           @InmateLocation varchar(30),
           --@RequestDate datetime,
      
           @Request varchar(1000)
           

AS
BEGIN
SET NOCOUNT ON;
Declare @RequestDate datetime, @LocationID int, @timeZone tinyint,@FormID  int;
SET @FormID =0;
SET @timeZone =0;
SET @timeZone = (select timeZone from tblfacility where FacilityID =@FacilityID ); 
SET @RequestDate = dateadd(hour,@timeZone, GETDATE()); 
Declare  @return_value int, @nextID int, @ID int, @tblInmateRequestForm nvarchar(32) ;
EXEC   @return_value = p_create_nextID 'tblInmateRequestForm', @nextID   OUTPUT
     set           @ID = @nextID ; 
	INSERT INTO [leg_Icon].[dbo].[tblInmateRequestForm]
           (FormID
		   ,[FacilityID]
           ,[InmateID]
           ,[BookingNo]
           ,[InmateLocation]
           ,[RequestDate]
           
           ,[Request]
   
           ,[Status])
          
     VALUES
           (@ID,
		   @FacilityID ,
           @InmateID ,
           @InmateSO ,
           @InmateLocation ,
           @RequestDate ,
      
           @Request,
           1 );


SET  @formID = @ID ;

select formID,G.[FacilityID]
           ,G.[InmateID],(I.FirstName + ' ' + I.LastName) as InmateName 
           ,[BookingNo]
           ,[InmateLocation]
           ,[RequestDate]
           
           ,[Request], G.[status] as [StatusID]
   
           ,F.[Descript] as [Status] from tblInmateRequestForm G inner join tblInmate  I on (G.FacilityID = I.FacilityId and G.InmateID =I.InmateID )
           Inner join tblFormstatus F on (G.status = F.statusID)
           where formID =@formID
           
END

