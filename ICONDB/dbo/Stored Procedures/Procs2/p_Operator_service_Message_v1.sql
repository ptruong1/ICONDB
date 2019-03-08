
CREATE PROCEDURE [dbo].[p_Operator_service_Message_v1] 
@AccountNo char(10),
@Message		varchar(200),
@username		varchar(20)
AS

Declare  @return_value int, @nextID int, @ID int, @tblAdjustment nvarchar(32) ;
	EXEC   @return_value = p_create_nextID 'tblAdjustment', @nextID   OUTPUT
             set           @ID = @nextID ; 
Insert tblAdjustment (AdjID, AdjTypeID, AccountNo  ,UserName,  Descript, AdjustDate) values (@ID, 6, @AccountNo ,@username,  @Message, getdate());
Return @@error;


