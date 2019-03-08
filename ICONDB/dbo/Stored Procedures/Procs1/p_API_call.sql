-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_API_call]
@RequestID varchar(22),
@ClientType	varchar(16),  
@SystemID	varchar(12)	,			
@SystemTag varchar(12), 
@Vendor	varchar(12), 
@ResidentIdentifier	varchar(12),
@PIN		varchar(12),
@IPaddress varchar(16),
@APIcalltype tinyint,
@Amount	 varchar(10)
AS
BEGIN
	
	SET NOCOUNT ON;
	Declare @facilityID as int;
	Insert tblAPIcalllogs(RequestID, ClientType,SystemID,SystemTag,Vendor,InmateID,PIN,RecordDate,IPaddress,APIcalltype,Amount)
					values(@RequestID,@ClientType,@SystemID,@SystemTag,@Vendor,@ResidentIdentifier,@PIN,getdate(),@IPaddress,@APIcalltype,@Amount)

	SET @facilityID = cast(@SystemTag as int);
    if(select COUNT(*) from tblFTPfileprocess with(nolock) where FacilityID = @FacilityID) =0
		Insert tblFTPfileprocess(FacilityID,  FolderName , lastUpdate ,  FileCount)
						values(@facilityID,@Vendor ,GETDATE(),1);
	else
		Update tblFTPfileprocess SET lastUpdate = GETDATE() where FacilityID = @facilityId;
	
END

