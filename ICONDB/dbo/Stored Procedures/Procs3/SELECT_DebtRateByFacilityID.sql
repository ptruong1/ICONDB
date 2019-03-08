




CREATE PROCEDURE [dbo].[SELECT_DebtRateByFacilityID]
(
	@FacilityID int,
	@AgentId int
)
AS
	SET NOCOUNT ON;
SELECT FacilityID, AgentID, A.BillType, B.Descript as [BillTypeName], A.CallType, C.Descript as [CallTypeName], Rate,  username, modifyDate,inputdate
FROM            tblBadDebt A INNER JOIN tblBillType B ON A.BillType = B.BillType
				INNER JOIN tblCallType C on A.CallType = C.Abrev
WHERE FacilityID = @FacilityID and A.billtype in ( '01','03','05','07','10')
ORDER BY B.Descript, C.Descript 


