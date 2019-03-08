

CREATE PROCEDURE [dbo].[p_Report_Debit_Account_Balance]
@FacilityID  int,
@fromDate	smalldatetime,
@toDate	smalldatetime

 AS

SELECT ('#' + AccountNo) as AccountNo
      ,[InmateID]
      ,[FacilityID]
      ,[Balance]
      ,[inputdate]
      ,[Note]
      ,tblstatus.descrip as Status
  FROM [leg_Icon].[dbo].[tblDebit] 
  inner join tblStatus on tbldebit.status = tblstatus.statusID
  where
	 
	 FacilityID = @FacilityID and  InputDate >=@fromDate and InputDate < @toDate


