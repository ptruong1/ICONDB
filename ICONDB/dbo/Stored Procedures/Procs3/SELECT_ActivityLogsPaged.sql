


CREATE PROCEDURE [dbo].[SELECT_ActivityLogsPaged]
(	
    @FacilityID int,
    @startRowIndex int,
    @maximumRows int
)
AS

DECLARE @first_id int, @startRow int
	
-- A check can be added to make sure @startRowIndex isn't > count(1)
-- from employees before doing any actual work unless it is guaranteed
-- the caller won't do that

-- Get the first custID for our page of records
SET @startRowIndex = @startRowIndex + 1
SET ROWCOUNT @startRowIndex 

SELECT @first_id = ActivityLogID FROM tblActivityLog WHERE FacilityID=@FacilityID ORDER BY ActivityLogID DESC 

-- Now, set the row count to MaximumRows and get
-- all records >= @first_id
SET ROWCOUNT @maximumRows

SELECT     A.ActivityLogID, A.ActivityID, A.ActTime, A.RecordID, A.FacilityID, A.Username, A.UserIP, B.Descript as [ActivityDescription]  
FROM	tblActivityLog A INNER JOIN tblActivity B
		ON A.ActivityID = B.ActivityID
WHERE A.FacilityID = @FacilityID AND A.ActivityLogID <= @first_id
ORDER BY ActivityLogID DESC 

SET ROWCOUNT 0


