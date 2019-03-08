

CREATE PROCEDURE [dbo].[p_insert_biometric_results]
(
	@FacilityId int,
	@InmateID varchar(12),
	@RecordID int,
	@TransactionID int,
	@SegmentNo int,
	@BioStatus varchar(20),
	@BioScores int,
    @BioUsableTime int,
    @VerifyStatus varchar(1),
    @InputDate datetime,
    @Note varchar(150)
)
AS
	SET NOCOUNT OFF;
INSERT INTO [leg_Icon].[dbo].[tblBioMetricResults]
           ([facilityId]
           ,[InmateID]
           ,[RecordID]
           ,[TransactionID]
           ,[SegmentNo]
           ,[BioStatus]
           ,[BioScores]
           ,[BioUsableTime]
           ,[VerifyStatus]
           ,[InputDate]
           ,[Note])
     VALUES
           (@facilityId
           ,@InmateID
           ,@RecordID
           ,@TransactionID
           ,@SegmentNo
           ,@BioStatus
           ,@BioScores
           ,@BioUsableTime
           ,@VerifyStatus
           ,@InputDate
           ,@Note)

