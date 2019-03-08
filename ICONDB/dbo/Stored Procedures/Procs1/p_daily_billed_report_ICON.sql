
CREATE PROCEDURE p_daily_billed_report_ICON
@ConnectDate char(6)
AS
SET NOCOUNT ON
Create  table #b1 (hourly char(2), billed  int)
Insert  #b1 values('00',0)
Insert  #b1 values('01',0)
Insert  #b1 values('02',0)
Insert  #b1 values('03',0)
Insert  #b1 values('04',0)
Insert  #b1 values('05',0)
Insert  #b1 values('06',0)
Insert  #b1 values('07',0)
Insert  #b1 values('08',0)
Insert  #b1 values('09',0)
Insert  #b1 values('10',0)
Insert  #b1 values('11',0)
Insert  #b1 values('12',0)
Insert  #b1 values('13',0)
Insert  #b1 values('14',0)
Insert  #b1 values('15',0)
Insert  #b1 values('16',0)
Insert  #b1 values('17',0)
Insert  #b1 values('18',0)
Insert  #b1 values('19',0)
Insert  #b1 values('20',0)
Insert  #b1 values('21',0)
Insert  #b1 values('22',0)
Insert  #b1 values('23',0)
Create  table #b8 (hourly char(2), billed  int)
Insert  #b8
select   left(connecttime,2) ,count(billtype)    from tblcallsBilled  with(nolock) 
	where callDate=@ConnectDate  and MethodOfRecord='04' and
(billtype = '01'  OR billtype = '00'   oR billtype = '02' )  and  responsecode <>'800' 

group by left(connecttime,2) 

Create table #b2 (hourly char(2), billed  int)
Insert  #b2
select   left(connecttime,2) ,count(billtype)     from  tblcallsBilled  with(nolock) 
	where callDate=@ConnectDate  and MethodOfRecord='04' and (billtype =  '03'   OR billtype =  '05' )  
group by left(connecttime,2) 




--Live
Create  table #b4 (hourly char(2), billed  int)
Insert  #b4
select    left(connecttime,2) ,count(billtype)   from  tblcallsBilled  with(nolock) 
	where callDate=@ConnectDate  and MethodOfRecord='22' and
(billtype = '01'  OR billtype = '00'   oR billtype = '02' )   and  responsecode <>'800'  

group by left(connecttime,2) 

Create table #b5 (hourly char(2), billed  int)
Insert  #b5
select   left(connecttime,2) ,count(billtype)     from  tblcallsBilled with(nolock) 
	where callDate=@ConnectDate  and MethodOfRecord='22' and
(billtype =  '03'   OR billtype =  '05' )  and errorCode ='0'
group by left(connecttime,2) 


Create table #b7 (hourly char(2), billed  int)
Insert  #b7
select   left(connecttime,2) ,count(billtype)     from  tblcallsBilled   with(nolock) 
	where callDate=@ConnectDate  and (billtype = '07'  or billtype = '10' )
	group by left(connecttime,2) 


select #b1.Hourly, Isnull(#b8.billed,0) as ACP_Regular,  Isnull(#b2.billed,0) as ACP_CreditCard,
	 Isnull(#b4.billed,0) as Live_Regular,  Isnull(#b5.billed,0) as Live_CreditCard ,  Isnull(#b7.billed,0) as Prepaid
FROM #b1 left outer join #b2 on #b1.hourly = #b2.hourly
 left outer join #b4 on  #b1.hourly = #b4.hourly
 left outer join #b5 on  #b1.hourly = #b5.hourly 
 left outer join #b7 on #b1.hourly = #b7.hourly 
 left outer join #b8 on #b1.hourly = #b8.hourly

drop table #b1, #b2, #b4, #b5,#b7 ,  #b8
