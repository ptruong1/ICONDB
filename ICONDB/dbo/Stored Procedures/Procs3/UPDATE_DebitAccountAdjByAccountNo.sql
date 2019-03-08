
CREATE PROCEDURE [dbo].[UPDATE_DebitAccountAdjByAccountNo]
(
	@AccountNo char(12),
	@Balance numeric(7, 2),
	@Username varchar(20),
	@AdjTypeID varchar(10),
	@AdjAmount numeric (7,2),
	@Descript varchar(100)
	
	
)
AS
SET NOCOUNT OFF;
Declare  @LastBalance numeric(7, 2)
Declare  @return_value int, @nextID int, @ID int, @tblAdjustment nvarchar(32) ;
select  @LastBalance =  [Balance] from   [tblDebit]  with(nolock)  WHERE ([AccountNo] = @AccountNo) 
UPDATE [tblDebit] SET [Balance] = @LastBalance + @AdjAmount,
			 [Username] = @Username,
			 [ModifyDate] = getdate() 
			WHERE ([AccountNo] = @AccountNo)

    EXEC   @return_value = p_create_nextID 'tblAdjustment', @nextID   OUTPUT
    set           @ID = @nextID ;  
INSERT  tblAdjustment(AdjID, AccountNo,LastBalance, AdjAmount ,  AdjustDate  ,  UserName, Descript, AdjTypeID )
values(@ID,  @AccountNo ,    @LastBalance ,  @AdjAmount ,   getdate(),  @Username, @Descript, @AdjTypeID)

