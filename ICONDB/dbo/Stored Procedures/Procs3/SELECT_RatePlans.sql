


CREATE PROCEDURE [dbo].[SELECT_RatePlans]
(
    @startRowIndex int,
    @maximumRows int
)
AS

DECLARE @first_id int, @startRow int
	
-- A check can be added to make sure @startRowIndex isn't > count(1)
-- from tblRatePlan before doing any actual work unless it is guaranteed
-- the caller won't do that

-- Get the first RateID for our page of records
SET @startRowIndex = @startRowIndex + 1
SET ROWCOUNT @startRowIndex 

SELECT @first_id = RecordID FROM tblRatePlan ORDER BY RecordID

-- Now, set the row count to MaximumRows and get
-- all records >= @first_id
SET ROWCOUNT @maximumRows

SELECT        RateID, Descript, userName,inputdate
FROM            tblRatePlan
WHERE RecordID >= @first_id
ORDER BY RecordID;

SET ROWCOUNT 0


