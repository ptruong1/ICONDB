-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_Message_Comm_Rate] 

AS
BEGIN
  SELECT [FacilityID]
      ,R.MessageTypeID
      ,T.Descript
      ,cast(Charge as numeric(6,2)) as Charge
      ,Cast(ChargePerTrans as numeric(6,2)) as ChargePerTrans
      ,Cast(Comm * 100 as numeric(6,2)) as Comm
      ,[UserName]
  FROM [leg_Icon].[dbo].[tblMessageRate] R
  inner join [leg_Icon].[dbo].[tblMessageType] T on R.MessageTypeID = T.MessageTypeID
  order by FacilityID, R.MessageTypeID
END

