

CREATE PROCEDURE [dbo].[p_payment_visit_schedule]
@AccountNo  varchar(10),
@ApmNo		int,  -- or confirm number
@facilityID int,
@ChargeAmount    numeric(7,2) ,  
@paymentTypeID	tinyint ,  -- 1 for credit Card , 3 paypal
@ccNo		VARCHAR(16), 
@ccExp	VARCHAR(4),
@ccCVV	VARCHAR(4)	,
@BilltoFirstName	VARCHAR(20)	, 
@BillToLastName	VARCHAR(20),  
@BillToEmail	varchar(30),
@BillToAddress	varchar(50),
@BillToCity	varchar(24),
@BillToZip		VARCHAR(5), 
@BillToState	varchar(2),
@BillToCountry	varchar(30),
@authorizationCode	varchar(7)

AS
SET NoCount ON ;

Declare  @return_value int, @nextID int, @ID int, @tblVisitPayments nvarchar(32) ;

update tblprepaid set Balance=Balance -@ChargeAmount, ModifyDate =GETDATE() 
where phoneno=@AccountNo ;
    EXEC   @return_value = p_create_nextID 'tblVisitPayments', @nextID   OUTPUT
    set           @ID = @nextID ;   
INSERT INTO tblVisitPayments(paymentID ,AccountNo, FacilityID,  Amount   ,    PaymentTypeID , CCExp ,CCzip ,CCcode, CCFirstName,CCLastName ,  UserName ,  PaymentDate, PurchaseNo )
					        Values(@ID, @AccountNo, @FacilityID, @ChargeAmount , @paymentTypeID, @ccExp,@BilltoZip, @ccCVV, @BillToFirstName,@BillToLastName	,@AccountNo, getdate(), @ApmNo);


--update tblprepaid set Balance=Balance -@ChargeAmount, ModifyDate =GETDATE() 
-- 													 where phoneno=@AccountNo ;
--INSERT INTO tblVisitPayments(AccountNo, FacilityID,  Amount   ,    PaymentTypeID , CCExp ,CCzip ,CCcode, CCFirstName,CCLastName ,  UserName ,  PaymentDate, PurchaseNo )
--					        Values(@AccountNo, @FacilityID, @ChargeAmount , @paymentTypeID, @ccExp,@BilltoZip, @ccCVV, @BillToFirstName,@BillToLastName	,@AccountNo, getdate(), @ApmNo);

