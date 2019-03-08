
CREATE PROCEDURE [dbo].[p_Operator_service_Message] 
@AccountNo char(10),
@Message		varchar(200)
AS

Insert tblAdjustment (AdjTypeID, AccountNo  ,  Descript, AdjustDate) values (6, @AccountNo , @Message, getdate())

