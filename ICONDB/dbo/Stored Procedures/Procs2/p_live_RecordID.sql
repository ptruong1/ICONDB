CREATE PROCEDURE [dbo].[p_live_RecordID]
@recordID	varchar(12)
AS

SELECT  [RecordID]
      ,[FromNo]
      ,userName
      ,isnull(duration,0) as duration
  FROM [leg_Icon].[dbo].[tblOnCalls]
  where RecordID = @RecordID 
  
  --and	Errorcode ='0' AND
		--Duration is Null AND 
		--Billtype < '12'  AND
		--RecordFile <> 'NA' AND
		--datediff(hh,recorddate,getdate()) <2 
