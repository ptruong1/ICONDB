-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_retrieve_Outsider_InBox_by_inmate_ICON]
@InmateID varchar(12),
@FacilityID int,
@fromDate datetime,
@todate	datetime
AS
BEGIN
	select Md.MessageID,
   Mt.Descript as MessageType, Md.MessageName,Md.MessageDate, Md.Message, 
		(I.LastName + ', ' + I.FirstName) as [From],
		(P.LastName + ', ' + P.FirstName) as [To], 
		IsNew , Md.MailBoxID , M.MailboxID  as SenderMailBoxID , 
	ISNULL(Md.IsReply,0) IsReply, Md.Email as [Email], S.MessStatus as [MessStatus], S.Descript as [status], O.AccountNo
  FROM [leg_Icon].[dbo].[tblMailboxDetailF] Md
  inner join [leg_Icon].[dbo].tblMailbox M on Md.SenderMailBoxID = M.MailboxID 
  inner join [leg_Icon].[dbo].[tblMailboxF] O on Md.MailBoxID = O.MailboxID and O.FacilityID = @facilityID
   inner join [leg_Icon].[dbo].[tblPrepaid] P on P.PhoneNo = O.AccountNo
   inner join [leg_Icon].[dbo].tblMessageType  Mt on Md.MessageTypeID = Mt.MessageTypeID 
   inner join [leg_Icon].[dbo].tblInmate I on M.InmateID = I.InmateID and M.FacilityID = I.FacilityId 
   inner join [leg_Icon].[dbo].[tblMessageStatus] S on Md.MessageStatus = S.MessStatus
    
  where M.InmateID = @InmateID
   and M.FacilityID = @facilityID
   and (Md.MessageDate between @fromDate and dateadd(d,1,@todate))
    order by MessageDate desc
	
			
	return @@error;
END


