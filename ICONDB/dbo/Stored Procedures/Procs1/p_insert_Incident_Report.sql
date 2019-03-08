
CREATE PROCEDURE [dbo].[p_insert_Incident_Report]
@ANI  char(10),
@FacilityID  int,
@InmateID    int ,
@PIN      int  ,
@Channel  smallint,
@FolderName  char(8),
 @FileName     varchar(18),
@DBError	char(1)
   
 AS
Insert  tblIncidentReport(ANI  ,      FacilityID,  InmateID,    PIN      ,    Channel, FolderName, FileName,DBerror )
values(   @ANI ,@FacilityID,@InmateID ,@PIN    ,@Channel  ,@FolderName , @FileName,@DBError	 )

