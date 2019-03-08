
CREATE PROCEDURE [dbo].[UPDATE_PrepaidAccountAdjByPhoneNo]
(
	@PhoneNo char(12),
	@Balance numeric(7, 2),
	@Username varchar(20),
	@AdjTypeID varchar(10),
	@AdjAmount numeric (7,2),
	@Descript varchar(100)
	
	
)
AS
SET NOCOUNT OFF;
Declare  @LastBalance numeric(7, 2)
Declare @return_value int, @nextID bigint, @ID bigint, @tblAdjustment nvarchar(32)
select  @LastBalance =  [Balance] from   [tblPrepaid]  with(nolock)  WHERE ([PhoneNo] = @PhoneNo) 
UPDATE [tblPrepaid] SET [Balance] = @LastBalance + @AdjAmount,
			 [Username] = @Username,
			 [ModifyDate] = getdate() 
			WHERE ([PhoneNo] = @PhoneNo)
  EXEC   @return_value = p_create_nextID 'tblAdjustment', @nextID   OUTPUT
        set           @ID = @nextID ;   
INSERT  tblAdjustment(AdjID, AccountNo,LastBalance, AdjAmount ,  AdjustDate  ,  UserName, Descript, AdjTypeID )
values( @ID, @PhoneNo ,    @LastBalance ,  @AdjAmount ,   getdate(),  @Username, @Descript, @AdjTypeID)

