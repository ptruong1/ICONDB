
CREATE PROCEDURE [dbo].[p_Select_Missing_Audio_Record]
(
	@IpAddress varchar(16)
           ,@ComputerName varchar(15)
           ,@FacilityId int
           ,@MissCount int
)
AS
	SET NOCOUNT OFF;

if (select count(*) from tblACPs_missing_Audio WHERE IpAddress = @IpAddress and facilityID = @facilityId) = 0
  begin
  INSERT INTO [dbo].[tblACPs_missing_Audio]
           ([IpAddress]
           ,[ComputerName]
           ,[FacilityId]
           ,[MissCount])
     VALUES
           (@IpAddress
           ,@ComputerName
           ,@facilityId
           ,1)
	End
 else
 
	BEGIN
	    UPDATE [dbo].[tblACPs_missing_Audio]
   SET 
       [MissCount] = MissCount + 1
 WHERE IpAddress = @IpAddress and facilityID = @facilityID
	END

