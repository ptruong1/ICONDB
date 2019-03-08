
CREATE PROCEDURE [dbo].[UPDATE_DebitAccountAdjByAccountNo_bk08232016]
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
select  @LastBalance =  [Balance] from   [tblDebit]  with(nolock)  WHERE ([AccountNo] = @AccountNo) 
UPDATE [tblDebit] SET [Balance] = @LastBalance + @AdjAmount,
			 [Username] = @Username,
			 [ModifyDate] = getdate() 
			WHERE ([AccountNo] = @AccountNo)

INSERT  tblAdjustment( AccountNo,LastBalance, AdjAmount ,  AdjustDate  ,  UserName, Descript, AdjTypeID )
values(  @AccountNo ,    @LastBalance ,  @AdjAmount ,   getdate(),  @Username, @Descript, @AdjTypeID)

