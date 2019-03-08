CREATE PROCEDURE [dbo].[p_Report_High_volume_calls_by_tono]
@FacilityID	int,
@threshold	int, 
@fromDate	smalldatetime,
@toDate	smalldatetime,
@complete	bit,
@uncomplete	bit
 AS

If(@complete =1 and  @uncomplete =1)
Begin
	Select   ToNo,  Count( ToNo )   as [Total  Calls] , sum(CEILING( Duration/60.00)) as [Total Minutes]  from tblcallsBilled with(nolock) 
		 WHERE  FacilityID = @FacilityID and RecordDate > @fromDate and  convert(varchar(10), RecordDate ,101) <= @toDate
			group by  ToNo 
			 having Count( ToNo )  >= @threshold
	Union
	Select   ToNo,  Count( ToNo )   as [Total  Calls] , 0 as [Total Minutes]  from tblcallsUnBilled with(nolock) 
		 WHERE  FacilityID = @FacilityID and RecordDate > @fromDate and  convert(varchar(10), RecordDate ,101) <= @toDate
			group by  ToNo 
			 having Count( ToNo )  >= @threshold
			Order by   [Total  Calls]  Desc
End
Else If(@complete =1)
Begin
	Select   ToNo,  Count( ToNo )   as [Total  Calls] , sum(CEILING( Duration/60.00)) as [Total Minutes]  from tblcallsBilled with(nolock) 
		 WHERE  FacilityID = @FacilityID and RecordDate > @fromDate and  convert(varchar(10), RecordDate ,101) <= @toDate
			group by  ToNo 
			 having Count( ToNo )  >= @threshold
			Order by   [Total  Calls]  Desc

End
Else If(@uncomplete =1)
Begin
	Select   ToNo,  Count( ToNo )   as [Total  Calls] , 0 as [Total Minutes]  from tblcallsUnBilled with(nolock) 
		 WHERE  FacilityID = @FacilityID and RecordDate > @fromDate and  convert(varchar(10), RecordDate ,101) <= @toDate
			group by  ToNo 
			 having Count( ToNo )  >= @threshold
			Order by   [Total  Calls]  Desc

End
