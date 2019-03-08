CREATE PROCEDURE [dbo].[p_Report_High_volume_calls_by_ANI]
@FacilityID	int,
@threshold	int, 
@fromDate	smalldatetime,
@toDate	smalldatetime,
@complete	bit,
@uncomplete	bit
 AS



 If(@complete=1 and  @uncomplete =1 )
  Begin
	Select   FromNo  ,  Count(FromNo )   as [Total  Calls] , sum(CEILING( Duration/60.00)) as [Total Minutes]  from tblcallsBilled with(nolock)
		  WHERE  FacilityID = @FacilityID and RecordDate > @fromDate and  convert(varchar(10), RecordDate ,101) <= @toDate
			group by  FromNo
			 having Count( FromNo )  >= @threshold
			--Order by   [Total  Calls]  Desc
	UNION 
	Select   FromNo  ,  Count(FromNo )   as [Total  Calls] , 0 as [Total Minutes]  from tblcallsUnBilled with(nolock)  
		WHERE  FacilityID = @FacilityID and RecordDate > @fromDate and  convert(varchar(10), RecordDate ,101) <= @toDate
			group by  FromNo
			 having Count( FromNo )  >= @threshold
			Order by   [Total  Calls]  Desc
 End
Else  If (@complete=1)
	Select   FromNo  ,  Count(FromNo )   as [Total  Calls] , sum(CEILING( Duration/60.00)) as [Total Minutes]  from tblcallsBilled with(nolock) 
		 WHERE  FacilityID = @FacilityID and RecordDate > @fromDate and  convert(varchar(10), RecordDate ,101) <= @toDate
			group by  FromNo
			 having Count( FromNo )  >= @threshold
			Order by   [Total  Calls]  Desc
Else
	Select   FromNo  ,  Count(FromNo )   as [Total  Calls] , 0 as [Total Minutes]  from tblcallsUnBilled with(nolock)  
		WHERE  FacilityID = @FacilityID and RecordDate > @fromDate and  convert(varchar(10), RecordDate ,101) <= @toDate
			group by  FromNo
			 having Count( FromNo )  >= @threshold
			Order by   [Total  Calls]  Desc
