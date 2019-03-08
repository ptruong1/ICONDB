
CREATE PROCEDURE [dbo].[p_view_payment_by_Facility]
@FacilityID	int,
@fromDate	datetime,
@toDate	datetime

 AS

if(@FacilityID >0) 
Begin
	select  Location ,   AccountNo,CCFirstName as FirstName  ,  CCLastName  as    LastName   ,Amount as Payment,PaymentDate, Descript as PaymentType  
	from tblPrepaidPayments with(nolock), tblFacility  with(nolock) ,tblpaymentType with(nolock)
	 where  tblFacility.facilityID = tblPrepaidPayments.facilityID  and  tblPrepaidPayments.PaymentTypeID = tblpaymentType.PaymentTypeID and
	
	 PaymentDate >= @fromDate  and   PaymentDate <=  dateadd(d,1, @toDate) 	and  tblPrepaidPayments.facilityID = @FacilityID 
	
	order by PaymentDate
 end

else 
 begin

	select  Location ,   AccountNo,CCFirstName as FirstName  ,  CCLastName  as    LastName   ,Amount as Payment,PaymentDate, Descript as PaymentType  
		from tblPrepaidPayments with(nolock), tblFacility  with(nolock) ,tblpaymentType with(nolock)
		 where  tblFacility.facilityID = tblPrepaidPayments.facilityID  and  tblPrepaidPayments.PaymentTypeID = tblpaymentType.PaymentTypeID and
		
		 PaymentDate >= @fromDate  and   PaymentDate <=  dateadd(d,1, @toDate) 	
		
		order by PaymentDate

 end

