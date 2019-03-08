

CREATE PROCEDURE [dbo].[SELECT_BillType_In_TblCommRate]
(
	@FacilityID int
)
AS
	SET NOCOUNT ON;
SELECT  [Billtype]
      ,[Descript]
  FROM [leg_Icon].[dbo].[tblBillType] 
  where Billtype in ('01', '03', '05', '07', '10')
  and Billtype not in (select Billtype from [leg_Icon].[dbo].[tblCommRate] where facilityID = @FacilityID)


