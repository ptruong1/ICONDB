-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_retrieve_All_MailBox]

@FacilityID int	
AS
BEGIN
	SELECT  [MailboxID]
      ,[FacilityID]
      ,[InmateID]
      ,[SetupDate]
      ,[status]
      ,S.Descipt as InmateStatus
      ,[MailBoxTypeID]
      ,T.Descript as MailBoxType
      ,[AccountNo]
      
      
  FROM [leg_Icon].[dbo].[tblMailbox] M
  left join [leg_Icon].[dbo].[tblMailBoxType] T on M.MailBoxTypeID = T.SenderTypeID
  left join [leg_Icon].[dbo].[tblInmateStatus] S on M.status = S.statusID
  
where FacilityID = @facilityID
END

