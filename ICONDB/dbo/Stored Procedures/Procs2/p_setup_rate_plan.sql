CREATE PROCEDURE [dbo].[p_setup_rate_plan]  
@Location	varchar(50),
@RatePlanID	varchar(6)  ,  
@MileageCode	varchar(6) = '9999',
@PointID	varchar(2), 
@TYPE		char(1), 
@Description 	varchar(50),
@FirstMin 	numeric(6,4),
@AddlMin	numeric(6,4),
@CollectCallFee	numeric(6,4), 
@CallingCardFee numeric(6,4), 
@CreditCardFee	 numeric(6,4),
@ThirdPartyFee numeric(6,4), 
@PerToPerFee numeric(6,4), 
@ACPCollectCallFee 	numeric(6,4),
@ACPCallingCardFee numeric(6,4), 
@ACPCreditCardFee numeric(6,4), 
@ACPDebitFee	numeric(6,4), 
@MinDuration	tinyint, 
@MinDurationIntl  tinyint, 
@MinIncrement	tinyint, 
@Inputdate  datetime,
@user	varchar(50)

AS

-- Insert Rate plan
Declare  @return_value int, @nextID int, @ID int, @tblRateplan nvarchar(32) ;
 EXEC   @return_value = p_create_nextID 'tblRateplan', @nextID   OUTPUT
    set           @ID = @nextID ;  
insert tblRateplan (RecordID, RateID, Descript ,userName , InputDate)
values(@ID, @RatePlanID,@Location	, @user	, @Inputdate)

--Rate Detail
--Inser Rate Local
insert tblrateplanDetail (RateID, Mileagecode, DayCode, PointID, TYPE, Description , FirstMin ,AddlMin ,CollectCallFee, CallingCardFee, CreditCardFee,
 ThirdPartyFee, PerToPerFee, ACPCollectCallFee, ACPCallingCardFee, ACPCreditCardFee, ACPDebitFee, MinDuration, MinDurationIntl, MinIncrement, Inputdate)                                            
values('520', '9999', '0', 'OR', '3', 'Local' ,0,0,2.35,2.35,2.35,
2.35,2.35,2.35,2.35,2.35,2.35, 1, 1, 1, getdate())  

--Inser Rate Intralata
insert tblrateplanDetail (RateID, Mileagecode, DayCode, PointID, TYPE, Description , FirstMin ,AddlMin ,CollectCallFee, CallingCardFee, CreditCardFee,
 ThirdPartyFee, PerToPerFee, ACPCollectCallFee, ACPCallingCardFee, ACPCreditCardFee, ACPDebitFee, MinDuration, MinDurationIntl, MinIncrement, Inputdate)                                            
values('520', '9999', '0', 'OR', '1', 'IntraLata' ,0.69,0.69,2.75,2.75,2.75,
2.75,2.75,2.75,2.75,2.75,2.75, 1, 1, 1, getdate()) 
--Insert Rate InterLata
insert tblrateplanDetail (RateID, Mileagecode, DayCode, PointID, TYPE, Description , FirstMin ,AddlMin ,CollectCallFee, CallingCardFee, CreditCardFee,
 ThirdPartyFee, PerToPerFee, ACPCollectCallFee, ACPCallingCardFee, ACPCreditCardFee, ACPDebitFee, MinDuration, MinDurationIntl, MinIncrement, Inputdate)                                            
values('520', '9999', '0', 'OR', '2', 'InterLata' ,0.69,0.69,2.75,2.75,2.75,
2.75,2.75,2.75,2.75,2.75,2.75, 1, 1, 1, getdate()) 

--Insert InterState
insert tblrateplanDetail (RateID, Mileagecode, DayCode, PointID, TYPE, Description , FirstMin ,AddlMin ,CollectCallFee, CallingCardFee, CreditCardFee,
 ThirdPartyFee, PerToPerFee, ACPCollectCallFee, ACPCallingCardFee, ACPCreditCardFee, ACPDebitFee, MinDuration, MinDurationIntl, MinIncrement, Inputdate)                                            
values('520', '9999', '0', '1', '0', 'InterState' ,0.89,0.89,3.95,3.95,3.95,
3.95,3.95,3.95,3.95,3.95,3.95, 1, 1, 1, getdate()) 
-- Insert Canada rate
insert tblrateplanDetail (RateID, Mileagecode, DayCode, PointID, TYPE, Description , FirstMin ,AddlMin ,CollectCallFee, CallingCardFee, CreditCardFee,
 ThirdPartyFee, PerToPerFee, ACPCollectCallFee, ACPCallingCardFee, ACPCreditCardFee, ACPDebitFee, MinDuration, MinDurationIntl, MinIncrement, Inputdate)                                            
values('520', '9999', '0', '2', '0', 'Canada' ,0.89,0.89,3.95,3.95,3.95,
3.95,3.95,3.95,3.95,3.95,3.95, 1, 1, 1, getdate()) 
insert tblrateplanDetail (RateID, Mileagecode, DayCode, PointID, TYPE, Description , FirstMin ,AddlMin ,CollectCallFee, CallingCardFee, CreditCardFee,
 ThirdPartyFee, PerToPerFee, ACPCollectCallFee, ACPCallingCardFee, ACPCreditCardFee, ACPDebitFee, MinDuration, MinDurationIntl, MinIncrement, Inputdate)                                            
values('520', '9999', '0', '3', '0', 'Caribean' ,0.89,0.89,3.95,3.95,3.95,
3.95,3.95,3.95,3.95,3.95,3.95, 1, 1, 1, getdate()) 



---- Insert Rate plan
--insert tblRateplan (RateID, Descript ,userName , InputDate)
--values(@RatePlanID,@Location	, @user	, @Inputdate)

----Rate Detail
----Inser Rate Local
--insert tblrateplanDetail (RateID, Mileagecode, DayCode, PointID, TYPE, Description , FirstMin ,AddlMin ,CollectCallFee, CallingCardFee, CreditCardFee,
-- ThirdPartyFee, PerToPerFee, ACPCollectCallFee, ACPCallingCardFee, ACPCreditCardFee, ACPDebitFee, MinDuration, MinDurationIntl, MinIncrement, Inputdate)                                            
--values('520', '9999', '0', 'OR', '3', 'Local' ,0,0,2.35,2.35,2.35,
--2.35,2.35,2.35,2.35,2.35,2.35, 1, 1, 1, getdate())  

----Inser Rate Intralata
--insert tblrateplanDetail (RateID, Mileagecode, DayCode, PointID, TYPE, Description , FirstMin ,AddlMin ,CollectCallFee, CallingCardFee, CreditCardFee,
-- ThirdPartyFee, PerToPerFee, ACPCollectCallFee, ACPCallingCardFee, ACPCreditCardFee, ACPDebitFee, MinDuration, MinDurationIntl, MinIncrement, Inputdate)                                            
--values('520', '9999', '0', 'OR', '1', 'IntraLata' ,0.69,0.69,2.75,2.75,2.75,
--2.75,2.75,2.75,2.75,2.75,2.75, 1, 1, 1, getdate()) 
----Insert Rate InterLata
--insert tblrateplanDetail (RateID, Mileagecode, DayCode, PointID, TYPE, Description , FirstMin ,AddlMin ,CollectCallFee, CallingCardFee, CreditCardFee,
-- ThirdPartyFee, PerToPerFee, ACPCollectCallFee, ACPCallingCardFee, ACPCreditCardFee, ACPDebitFee, MinDuration, MinDurationIntl, MinIncrement, Inputdate)                                            
--values('520', '9999', '0', 'OR', '2', 'InterLata' ,0.69,0.69,2.75,2.75,2.75,
--2.75,2.75,2.75,2.75,2.75,2.75, 1, 1, 1, getdate()) 

----Insert InterState
--insert tblrateplanDetail (RateID, Mileagecode, DayCode, PointID, TYPE, Description , FirstMin ,AddlMin ,CollectCallFee, CallingCardFee, CreditCardFee,
-- ThirdPartyFee, PerToPerFee, ACPCollectCallFee, ACPCallingCardFee, ACPCreditCardFee, ACPDebitFee, MinDuration, MinDurationIntl, MinIncrement, Inputdate)                                            
--values('520', '9999', '0', '1', '0', 'InterState' ,0.89,0.89,3.95,3.95,3.95,
--3.95,3.95,3.95,3.95,3.95,3.95, 1, 1, 1, getdate()) 
---- Insert Canada rate
--insert tblrateplanDetail (RateID, Mileagecode, DayCode, PointID, TYPE, Description , FirstMin ,AddlMin ,CollectCallFee, CallingCardFee, CreditCardFee,
-- ThirdPartyFee, PerToPerFee, ACPCollectCallFee, ACPCallingCardFee, ACPCreditCardFee, ACPDebitFee, MinDuration, MinDurationIntl, MinIncrement, Inputdate)                                            
--values('520', '9999', '0', '2', '0', 'Canada' ,0.89,0.89,3.95,3.95,3.95,
--3.95,3.95,3.95,3.95,3.95,3.95, 1, 1, 1, getdate()) 
--insert tblrateplanDetail (RateID, Mileagecode, DayCode, PointID, TYPE, Description , FirstMin ,AddlMin ,CollectCallFee, CallingCardFee, CreditCardFee,
-- ThirdPartyFee, PerToPerFee, ACPCollectCallFee, ACPCallingCardFee, ACPCreditCardFee, ACPDebitFee, MinDuration, MinDurationIntl, MinIncrement, Inputdate)                                            
--values('520', '9999', '0', '3', '0', 'Caribean' ,0.89,0.89,3.95,3.95,3.95,
--3.95,3.95,3.95,3.95,3.95,3.95, 1, 1, 1, getdate()) 

