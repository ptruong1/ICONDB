
CREATE PROCEDURE [dbo].[p_billed_threshold]
@billtoNo	char(10)
AS
Set NOCOUNT ON

declare @Revenue numeric(7,2)  
SET  @Revenue =0
--daily 
select @Revenue = isnull( sum(callRevenue) ,0)  from tblcallsbilled with(nolock)
where calldate =  convert(char(6),getdate(),12)   and billtype ='01' and  billtono =@billtoNo  and  billtono not in (select authNo from  tblofficeANI with(nolock) )  

if (@Revenue > 100) return -1

--weekly

select  @Revenue = isnull( sum(callRevenue),0)  from tblcallsbilled with(nolock)
where calldate  > convert(char(6),dateadd(day,-8,getdate()),12)   and  billtype ='01'    and  billtono =@billtoNo and billtono not in (select authNo from  tblofficeANI with(nolock) )


if (@Revenue > 150) return -1


--monthly

select @Revenue = isnull( sum(callRevenue),0)   from tblcallsbilled with(nolock)
where calldate > convert(char(6),dateadd(day,-30,getdate()),12)    and billtype ='01'  and  billtono =@billtoNo  and billtono not in (select authNo from  tblofficeANI with(nolock) )


if (@Revenue > 250) return -1

