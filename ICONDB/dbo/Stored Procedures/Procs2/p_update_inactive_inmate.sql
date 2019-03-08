CREATE PROCEDURE [dbo].[p_update_inactive_inmate]
@facilityFolder	varchar(20)
AS
SET NOCOUNT ON
Declare @facilityId int, @flatform int, @sendStatus tinyint, @autoPin tinyint, @callupdate int;
set @facilityId =1;
SET @flatform = 0;
SET @sendStatus =0;
SET @autoPin =0;

select @facilityId = FacilityID,@sendStatus=inmateStatus  from tblFacilityOption  where FTPfolderName = @facilityFolder	;
if(@sendStatus =1)
 begin
	if(@facilityId =675)
		Update [leg_Icon].[dbo].tblInmate SET [Status] =2, Rebook=0, RebookDate=NULL, username= 'FTP', modifyDate = getdate()  where FacilityId = @facilityId and  [status] =1 and
			datediff(HH,ModifyDate,GETDATE()) >1  and InmateID not in ('00000','2222','4444','50916','81866','12345678','34056813','123456987','123123','9999420','3723391','4141');

	else
	 begin
		Update [leg_Icon].[dbo].tblInmate SET [Status] =2, Rebook=0, RebookDate=NULL, username= 'FTP', modifyDate = getdate() where FacilityId = @facilityId and [status] =1 and
			datediff(HH,ModifyDate,GETDATE()) >4  and InmateID not in ('00000','2222','4444','50916','81866','12345678','34056813','123456987','123123','9999420','3723391','356535');
        if (@facilityID =701)
			Update [leg_Icon].[dbo].tblInmate SET [Status] =2, Rebook=0, RebookDate=NULL, username= 'FTP', modifyDate = getdate() where FacilityId = @facilityId and [status] =1 and
			datediff(MI,ModifyDate,GETDATE()) >20  and InmateID not in ('00000','2222','4444','50916','81866','12345678','34056813','123456987','123123','9999420','3723391','356535');

				
				
	end

 
 end
if(select COUNT(*) from tblFTPfileprocess with(nolock) where FacilityID = @FacilityID) =0
	Insert tblFTPfileprocess(FacilityID,  FolderName , lastUpdate ,  FileCount)
					values(@facilityId,@facilityFolder ,GETDATE(),1);
else
	Update tblFTPfileprocess SET lastUpdate = GETDATE() where FacilityID = @facilityId;

					
