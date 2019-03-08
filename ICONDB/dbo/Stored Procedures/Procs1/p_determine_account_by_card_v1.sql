-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_determine_account_by_card_v1]
@AccountNo varchar(15),
@CCNo		varchar(16),
@Allow		tinyint OUTPUT,
@Alert      tinyint OUTPUT,
@Address	varchar(200) OUTPUT


AS
BEGIN
	SET NOCOUNT ON;
	Declare @AcctByCCC int, @FacilityID int, @AmountToday numeric(5,2), @AmountThisWeek numeric(5,2), @AmountThisMonth numeric(5,2) ;
	Select @FacilityID = facilityID, @Address= (CASE lastName when 'For Prepaid' then 'Input/ByPhone/10833 Valley view/NA/NA/NA/no@email.com/000051325420' else   lastname + '/' + firstname + '/' + isnull([address],'10833 Valley view') +'/' + isnull(city,'NA') + '/' + isnull([state],'NA') + '/' + isnull(Country,'MA') + '/' + isnull (b.email,'no@email.com')  + '/000051325420'  end )
			from tblprepaid a with(nolock) , tblEndusers b with(nolock)   where a.EndUserID= b.EndUserID and PhoneNo= @AccountNo;
	SET @Allow =1;
	SET @Alert =0;
	Select  @AcctByCCC = count(distinct  accountno) from tblPrepaidPayments with(nolock)
			where  datediff( day, PaymentDate ,getdate()) < =30  and  FacilityID =@FacilityID and ccno=@CCNo; 

	
	If (@AcctByCCC = 3)  --- For now 
	 Begin
		--SET @Allow =2;
		SET @Alert=1;
	 End
	else if (@AcctByCCC > 3)
	 Begin
		--SET @Allow =0;
		SET @Alert= 1;
	 end
    
	--If (select count(cnum) from TecoData.dbo.tblBCResponse with(nolock) where cNum =@AccountNo and transtype=2 and statusCode >'0' and MerchantProfileID <> '000051325420' )>2
	--begin
	--		SET @Allow =0;
	--		return 0;
	--end

	If (select count (*) from TecoData.dbo.tblFraud with (nolock) where accountNo = @AccountNo) >0
	 begin	
			SET @Allow =0;
			return 0;
	 end

    select @AmountToday = sum(approvedamount)  from  TecoData.dbo.tblBCResponse with(nolock) Where cnum=@CCNo and datediff( day,transDate ,getdate())  =0  and MerchantProfileID='000051325420'; 
	select @AmountThisWeek = sum(approvedamount)  from  TecoData.dbo.tblBCResponse with(nolock) Where cnum=@CCNo and datediff( day,transDate ,getdate()) <=7 and MerchantProfileID='000051325420' ; 
	select @AmountThisMonth =sum(approvedamount) from  TecoData.dbo.tblBCResponse with(nolock) Where cnum=@CCNo and datediff( day,transDate ,getdate()) <=30 and MerchantProfileID='000051325420';
    If( @AmountToday >100 or  @AmountThisWeek > 200 or @AmountThisMonth >300 )
	 begin
		SET @Alert=1;
	 end

END

