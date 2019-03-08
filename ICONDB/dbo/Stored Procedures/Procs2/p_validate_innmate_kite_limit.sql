-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE p_validate_innmate_kite_limit
@FacilityID int,
@InmateID  varchar(12),
@FormType tinyint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Declare @Perday smallint, @PerMonth smallint, @PerWeek smallint, @Request smallint ;
	SET  @Perday =0;
	SET @PerMonth  =0;
	SET @PerWeek =0;
	SET @Request =0;
	SELECT @Perday = isnull(PerDay,@Perday) , @PerWeek = isnull(PerWeek,@perweek), @PerMonth =isnull( PerMonth,@PerMonth)  from tblFormFacilityConfig with(nolock) where FacilityID =@FacilityID and FormTypeID= @FormType;
	If(@Perday >0)
	 begin		
		 select @Request= dbo.fn_determine_inmate_kite_per_day (@FacilityID ,	@InmateID ,	@FormType ,	@Perday) ;
		 if (@Request >0 )
		  begin
			select @Request as KiteRequest;
			return 0;
		  end
	 end
    If(@PerWeek >0)
	 begin		
		 select @Request= dbo.fn_determine_inmate_kite_per_week (@FacilityID ,	@InmateID ,	@FormType ,	@PerWeek) ;
		 if (@Request >0 )
		  begin
			select @Request as KiteRequest;
			return 0;
		  end
	 end
	 If(@PerMonth >0)
	 begin		
		 select @Request= dbo.fn_determine_inmate_kite_per_month (@FacilityID ,	@InmateID ,	@FormType ,	@PerMonth) ;
		 if (@Request >0 )
		  begin
		    select @Request as KiteRequest;
			return 0;
		  end
	 end
	 select @Request as KiteRequest;

	 Return 0;

END
