-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_insert_inmateKite_form_v3] 
		   @FacilityID int,
           @InmateID varchar(12),
           @InmateSO varchar(12),
           @InmateLocation varchar(30),
           @Request varchar(2000),
		   @FormType tinyint,
		   @Property varchar(500),
		   @AcceptName varchar(40),
		   @DL	varchar(10),
		   @DOB varchar(10),
		   @DeviceName varchar(20)
           

AS
BEGIN
SET NOCOUNT ON;
Declare @RequestDate datetime, @LocationID int, @timeZone tinyint,@FormID  int, @status tinyint, @FacilityFormID int;
SET @FormID =0;
SET @timeZone =0;
SET @FacilityFormID =1;
set @status=1;
SET @timeZone = (select timeZone from tblfacility where FacilityID =@FacilityID ); 
SET @RequestDate = dateadd(hour,@timeZone, GETDATE()); 
Declare  @return_value int, @nextID int, @ID int, @tblInmateRequestForm nvarchar(32) ;

	 EXEC   @return_value = p_create_nextID 'tblInmateRequestForm', @nextID   OUTPUT;
     set           @ID = @nextID ; 
	
	 Select @FacilityFormID  = isnull( InmateTemplate,1) from tblFacilityForms with(nolock) where FacilityID =@FacilityID;
	 
	Select @status = statusID from tblFormstatus with(nolock) where FacilityFormID= @FacilityFormID and Descript='Submitted';
	--select * from  tblFormstatus
	INSERT INTO [tblInmateRequestForm]
           ([FormId]
		   ,[FacilityID]
           ,[InmateID]
           ,[BookingNo]
           ,[InmateLocation]
           ,[RequestDate]
           ,[Request]
		   ,[FormType]
           ,[Status]
		   ,[DOB]
		   ,[DL]
		   ,DeviceName
		   )
          
     VALUES
           (@ID,
		   @FacilityID ,
           @InmateID ,
           @InmateSO ,
           @InmateLocation ,
           @RequestDate ,      
           @Request,
		   @FormType,
           @status,
		   @DOB,
		   @DL,
		   @DeviceName );


SET  @formID = @ID ;

If(@FormType in (1,2))
 begin
	insert tblInmateProperty (FormID, Property, AcceptName) values (@formID, @Property,@AcceptName);

	select  G.FormID,G.[FacilityID]
           ,G.[InmateID],(I.FirstName + ' ' + I.LastName) as InmateName 
           ,[BookingNo]
           ,[InmateLocation]
           ,[RequestDate]           
           ,[Request],  p.Property, p.AcceptName , G.[status] as [StatusID]   
           ,F.[Descript] as [Status], @DL as DL, @DOB as DOB from   tblInmateRequestForm G with(nolock)  inner join tblInmate I with(nolock)  on (G.FacilityID = I.FacilityId and G.InmateID =I.InmateID )
           Inner join tblFormstatus F with(nolock) on (G.status = F.statusID) inner Join tblInmateProperty p with(nolock) on (G.FormID= p.formID)
           where G.formID =@formID;
 end
 else
  begin
	select  G.FormID,G.[FacilityID]
           ,G.[InmateID],(I.FirstName + ' ' + I.LastName) as InmateName 
           ,[BookingNo]
           ,[InmateLocation]
           ,[RequestDate]           
           ,[Request],  '' Property, '' AcceptName , G.[status] as [StatusID]   
           ,F.[Descript] as [Status], @DL as DL, @DOB as DOB from   tblInmateRequestForm G with(nolock)  inner join tblInmate I with(nolock)  on (G.FacilityID = I.FacilityId and G.InmateID =I.InmateID )
           Inner join tblFormstatus F with(nolock) on (G.status = F.statusID) 
           where G.formID =@formID;
  end
           
END
