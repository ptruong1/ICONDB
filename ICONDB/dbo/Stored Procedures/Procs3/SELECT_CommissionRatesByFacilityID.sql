




CREATE PROCEDURE [dbo].[SELECT_CommissionRatesByFacilityID]
(
	@FacilityID int
)
AS
	SET NOCOUNT ON;
SELECT FacilityID, AgentID, A.BillType, B.Descript as [BillTypeName], A.CallType, C.Descript as [CallTypeName], CommRate, PifPaid, A.Descript, username, modifyDate,inputdate
FROM            tblCommRate A INNER JOIN tblBillType B ON A.BillType = B.BillType
				INNER JOIN tblCallType C on A.CallType = C.Abrev
WHERE FacilityID = @FacilityID 
ORDER BY B.Descript, C.Descript 


