CREATE PROCEDURE [dbo].[p_Credit_Card_Threshold]
@ccNo  varchar(18) 
AS
 
  If(select count(*) from  tblprepaidPayments with (nolock)  where   CCNo =@ccNo  and datediff(d,paymentDate,getdate())  =0  group by CCNo   having  sum(Amount) > 60) > 0
	return -2

 If(select count(*) from  tblprepaidPayments with (nolock)  where   CCNo =@ccNo and datediff(d,paymentDate,getdate()) <7   group by CCNo having  sum(Amount) > 110) > 0
	return -2

  If(select count(*) from  tblprepaidPayments with (nolock)  where   CCNo =@ccNo  and datediff(d,paymentDate,getdate()) <31  group by CCNo  having  sum(Amount) > 230) > 0
	return -2
