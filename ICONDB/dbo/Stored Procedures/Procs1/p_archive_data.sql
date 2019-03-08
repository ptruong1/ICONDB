-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_archive_data]
	@facilityID int, 
	@FrfolderDate varchar(8),
	@TofolderDate varchar(8),
	@RecordID	bigint OUTPUT, 
	@FacilityID_Ar	int OUTPUT,
	@FromNo			char(10) OUTPUT,
	@ToNo		varchar(18) OUTPUT, 
	@RecordDate	datetime	OUTPUT,
	@CallType	varchar(2)	OUTPUT,
	@billType	varchar(2)	OUTPUT,
	@duration	int			OUTPUT, 
	@FolderDate_Ar	varchar(8)	OUTPUT,
	@Channel	varchar(2)	OUTPUT,
	@RecordFile	varchar(20)	OUTPUT,
	@PIN		varchar(12)	OUTPUT, 
	@InmateID	varchar(12)	OUTPUT,
	@ACP		varchar(20)	OUTPUT,
	@CallRevenue numeric(5,2) OUTPUT
AS
BEGIN
	Declare @IPaddres	varchar(18),@ICON	tinyint
	If(@facilityID >0)
	begin
		select @ICON= flatform from leg_Icon.dbo.tblfacility with(nolock) where FacilityID = @facilityID
		
		if(@ICON =1)
			begin				
				if(@FrfolderDate <>'')
					select top 1  @RecordID= RecordID,@FacilityID_Ar= FacilityID,@FromNo=FromNo,@ToNo=ToNo,@CallType= CallType,@billType=billType,
					@duration=duration ,@FolderDate_Ar= FolderDate,@Channel=Channel,@RecordFile=RecordFile,@RecordDate=RecordDate, @PIN=PIN, 
					@InmateID=InmateID,	@IPaddres= userName, @CallRevenue = callRevenue
					from [leg_Icon1].[dbo].tblCallsbilledArchive with(nolock)
					where FacilityID= @facilityID and folderDate >=@FrfolderDate and folderDate <=@TofolderDate  and RecordFile <>'NA' and (InRecordFile is null or InRecordFile='') 
				else
					select top 1 @RecordID= RecordID,@FacilityID_Ar= FacilityID,@FromNo=FromNo,@ToNo=ToNo,@CallType= CallType,@billType=billType,
					@duration=duration ,@FolderDate_Ar= FolderDate,@Channel=Channel,@RecordFile=RecordFile,@RecordDate=RecordDate, @PIN=PIN, 
					@InmateID=InmateID,	@IPaddres= userName , @CallRevenue = callRevenue
					from [leg_Icon1].[dbo].tblCallsbilledArchive with(nolock)
					where  FacilityID= @facilityID and RecordFile <>'NA' and (InRecordFile is null or InRecordFile='') AND DATEDIFF(D, RecordDate , GETDATE()) >732
				if(@RecordID) > 0
						update [leg_Icon1].[dbo].tblCallsbilledArchive set InRecordFile='A' where RecordID=@RecordID
			end
		
		else
			begin
				if(@FrfolderDate <>'')
				 begin
					--select  @facilityID
					select top 1 @RecordID= RecordID,@FacilityID_Ar= FacilityID,@FromNo=FromNo,@ToNo=ToNo,@CallType= CallType,@billType=billType,
					@duration=duration ,@FolderDate_Ar= FolderDate,@Channel=Channel,@RecordFile=RecordFile,@RecordDate=RecordDate, @PIN=PIN, 
					@InmateID=InmateID,	@IPaddres= userName , @CallRevenue = callRevenue
					from [leg_Icon2].[dbo].tblCallsbilledArchive with(nolock)
					where  FacilityID= @facilityID and folderDate >=@FrfolderDate and folderDate <=@TofolderDate and RecordFile <>'NA' and (InRecordFile is null or InRecordFile='')
				end
				else
				 begin
					--select  @facilityID
					select top 1 @RecordID= RecordID,@FacilityID_Ar= FacilityID,@FromNo=FromNo,@ToNo=ToNo,@CallType= CallType,@billType=billType,
					@duration=duration ,@FolderDate_Ar= FolderDate,@Channel=Channel,@RecordFile=RecordFile,@RecordDate=RecordDate, @PIN=PIN, 
					@InmateID=InmateID,	@IPaddres= userName , @CallRevenue = callRevenue
					from [leg_Icon2].[dbo].tblCallsbilledArchive with(nolock)
					where  FacilityID= @facilityID and RecordFile <>'NA' and (InRecordFile is null or InRecordFile='') AND DATEDIFF(D, RecordDate , GETDATE()) >732
				 end
				 if(@RecordID) > 0
						update [leg_Icon2].[dbo].tblCallsbilledArchive set InRecordFile='A' where RecordID=@RecordID
			end
	end
	Else
	begin
			if(@FrfolderDate <>'')
				begin
					select top 1 @RecordID= RecordID,@FacilityID= FacilityID,@FromNo=FromNo,@ToNo=ToNo,@CallType= CallType,@billType=billType,
						@duration=duration ,@FolderDate_Ar= FolderDate,@Channel=Channel,@RecordFile=RecordFile,@RecordDate=RecordDate, @PIN=PIN, 
						@InmateID=InmateID,	@IPaddres= userName , @CallRevenue = callRevenue
						from [leg_Icon1].[dbo].tblCallsbilledArchive with(nolock)
						where folderDate >=@FrfolderDate and folderDate <=@TofolderDate and RecordFile <>'NA' and (InRecordFile is null or InRecordFile='') 
					if(@RecordID) > 0
						update [leg_Icon1].[dbo].tblCallsbilledArchive set InRecordFile='A' where RecordID=@RecordID
					else
					 begin
						select top 1 @RecordID= RecordID,@FacilityID= FacilityID,@FromNo=FromNo,@ToNo=ToNo,@CallType= CallType,@billType=billType,
							@duration=duration ,@FolderDate_Ar= FolderDate,@Channel=Channel,@RecordFile=RecordFile,@RecordDate=RecordDate, @PIN=PIN, 
							@InmateID=InmateID,	@IPaddres= userName , @CallRevenue = callRevenue
							from [leg_Icon2].[dbo].tblCallsbilledArchive with(nolock)
							where folderDate >=@FrfolderDate and folderDate <=@TofolderDate and RecordFile <>'NA' and (InRecordFile is null or InRecordFile='')
						if(@RecordID) > 0
							update [leg_Icon2].[dbo].tblCallsbilledArchive set InRecordFile='A' where RecordID=@RecordID
					 end
				end			
			
			else
			 begin
				select top 1 @RecordID= RecordID,@FacilityID= FacilityID,@FromNo=FromNo,@ToNo=ToNo,@CallType= CallType,@billType=billType,
					@duration=duration ,@FolderDate_ar= FolderDate,@Channel=Channel,@RecordFile=RecordFile,@RecordDate=RecordDate, @PIN=PIN, 
					@InmateID=InmateID,	@IPaddres= userName , @CallRevenue = callRevenue
					from [leg_Icon1].[dbo].tblCallsbilledArchive with(nolock)
					where  RecordFile <>'NA' and (InRecordFile is null or InRecordFile='') AND DATEDIFF(D, RecordDate , GETDATE()) >732
				if(@RecordID) > 0
						update [leg_Icon1].[dbo].tblCallsbilledArchive set InRecordFile='A' where RecordID=@RecordID
				else
				 begin
						select top 1 @RecordID= RecordID,@FacilityID= FacilityID,@FromNo=FromNo,@ToNo=ToNo,@CallType= CallType,@billType=billType,
							@duration=duration ,@FolderDate_ar= FolderDate,@Channel=Channel,@RecordFile=RecordFile,@RecordDate=RecordDate, @PIN=PIN, 
							@InmateID=InmateID,	@IPaddres= userName , @CallRevenue = callRevenue
							from [leg_Icon2].[dbo].tblCallsbilledArchive with(nolock)
							where  RecordFile <>'NA' and (InRecordFile is null or InRecordFile='') AND DATEDIFF(D, RecordDate , GETDATE()) >732
						if(@RecordID) > 0
							update [leg_Icon2].[dbo].tblCallsbilledArchive set InRecordFile='A' where RecordID=@RecordID
				 end
			end
		
	end
	Select @ACP =computerName from  leg_Icon.dbo.tblACPs with(nolock) where IpAddress = @IPaddres
END

