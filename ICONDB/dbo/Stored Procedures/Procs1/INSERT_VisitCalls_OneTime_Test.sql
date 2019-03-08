


CREATE PROCEDURE [dbo].[INSERT_VisitCalls_OneTime_Test]
(
	@ExtID varchar(15),
           
           @FacilityID int,
           @FolderDate char(8),
           @RecordDate datetime,
           @duration int,
           @CallRevenue numeric(6,2),
           @RecordName varchar(25),
           @CallTime varchar(6)
           )

AS
	SET NOCOUNT OFF;
	
	IF @recordName in (select recordName from tblVisitCalls_Test where FacilityID = @FacilityID)
	BEGIN
		RETURN -1;
	END
else
begin
INSERT INTO [tblVisitCalls_Test]
           ([ExtID]
           ,[PIN]
           ,[FacilityID]
           ,[FolderDate]
           ,[RecordDate]
           ,[duration]
           ,[RateID]
           ,[ConnectFee]
           ,[MinuteCharge]
           ,[CallRevenue]
           ,[VisitType]
           ,[VisitBilltype]
           ,[RecordName]
           ,[CallTime]
           ,[ServerIP])
     VALUES
           (@ExtID
           ,'N/A'
           ,@facilityID
           ,@FolderDate
           ,@RecordDate
           ,@Duration
           ,@facilityID
           ,'0.00'
           ,'0.00'
           ,@CallRevenue
           ,'1'
           ,'1'
           ,@RecordName
           ,@CallTime
           ,'172.20.30.20')
End
