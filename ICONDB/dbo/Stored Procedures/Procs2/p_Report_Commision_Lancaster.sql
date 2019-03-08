CREATE PROCEDURE [dbo].[p_Report_Commision_Lancaster]
@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime

AS


select  X.BillType, X.FromNo,

	 sum(case when M='AL' then callsCount else 0 end) as Intralata,
	 sum(case when M='AL' then Duration else 0 end) as IntralataMinutes,
	 sum(case when M='AL' then Revenue else 0 end) as IntralataRevenue,
	 sum(case when M='AL' then Comm else 0 end) as IntralataComm,
	 sum(case when M='RL' then callsCount else 0 end) as Interlata,
	 sum(case when M='RL' then Duration else 0 end) as InterlataMinutes,
	 sum(case when M='RL' then Revenue else 0 end) as InterlataRevenue,
	 sum(case when M='RL' then Comm else 0 end) as InterlataComm,
	 sum(case when M='LC' then callsCount else 0 end) as Local,
	 sum(case when M='LC' then duration else 0 end) as LocalMinutes,
	 sum(case when M='LC' then Revenue else 0 end) as LocalRevenue,
	 sum(case when M='LC' then Comm else 0 end) as LocalComm,
	 sum(case when M='CA' then callsCount else 0 end) as Canada,
	 sum(case when M='CA' then duration else 0 end) as CanadaMinutes,
	 sum(case when M='CA' then Revenue else 0 end) as CanadaRevenue,
	 sum(case when M='CA' then Comm else 0 end) as CanadaComm,
	 sum(case when M='CB' then callsCount else 0 end) as Caribbean,
	 sum(case when M='CB' then duration else 0 end) as CaribbeanMinutes,
	 sum(case when M='CB' then Revenue else 0 end) as CaribbeanRevenue,
	 sum(case when M='CB' then Comm else 0 end) as CaribbeanComm,
	 sum(case when M='IN' then callsCount else 0 end) as International,
	 sum(case when M='IN' then duration else 0 end) as InternationalMinutes,
	 sum(case when M='IN' then Revenue else 0 end) as InternationalRevenue,
	 sum(case when M='IN' then Comm else 0 end) as InternationalComm,  
	 sum(case when M='NA' then callsCount else 0 end) as None,
	 sum(case when M='NA' then duration else 0 end) as NoneMinutes,
	 sum(case when M='NA' then Revenue else 0 end) as NoneRevenue,
	 sum(case when M='NA' then Comm else 0 end) as NoneComm,
	 sum(case when M='ST' then callsCount else 0 end) as Interstate,
	 sum(case when M='ST' then duration else 0 end) as InterstateMinutes,
	 sum(case when M='ST' then Revenue else 0 end) as InterstateRevenue,
	 sum(case when M='ST' then Comm else 0 end) as InterstateComm, 
	  
	sum(callsCount) as TCalls,
	Sum (Duration) as TDuration,
	sum(Revenue) as TRevenue,
	Sum (Comm) as TComm
	from
	
	
	(Select   tblBillType.descript as BillType, FromNo, tblcallsbilled.Calltype 
as M, 1 as CallsCount, 
	 (dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )) as Duration,
	 CallRevenue as Revenue,
	 CAST (((CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as Comm
			from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock) 
 , tblCommrate with(nolock)  WHERE
						tblcallsbilled.Billtype = tblBilltype.Billtype and
						 tblcallsBilled.errorcode = '0' and 
						tblcallsbilled.Calltype = tblCalltype.Abrev and
						tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
						tblcallsbilled.Billtype =  tblCommrate.billtype and
						 tblcallsbilled.Calltype = tblCommrate.Calltype and
						tblcallsbilled.facilityID	= @FacilityID  And
						
								(RecordDate between @FromDate and 
dateadd(d,1,@toDate) ) and  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15
								and  tono not in (select AuthNo from 
tblOfficeANI where  Billabe =0) 
			) as X

	Group by  X.BillType, X.FromNo
	WITH ROLLUP
