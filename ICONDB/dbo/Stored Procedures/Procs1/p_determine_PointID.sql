

CREATE PROCEDURE [dbo].[p_determine_PointID]
@ANI_pointID  char(1),
@fromState	char(2),
@toState	char(2),
@isGU		tinyint,
@DNI_pointID   char(1),
@pointID  	varchar(2)  OUTPUT

 AS

Set NOCOUNT ON

If( @ANI_pointID = '0'   or @ANI_pointID = '6'   Or @ANI_pointID = '3' )  -- Us Or  HI or AK
	  Begin
	    IF(  @fromstate = @toState )  	
			If @isGU > 0   
				SET  @pointID = 'GU';
			Else 	
				SET  @pointID =   @fromstate;
	
	    ELSE	
			Begin
		  		If (@DNI_pointID = '0'   Or  @DNI_pointID = '6'  Or @DNI_pointID = '3'   )  
					SET  @pointID = '1';
		  		ELSE If  (@DNI_pointID = '2')  
					SET  @pointID =  '2';
				ELSE   
					SET  @pointID =  '3';
			End
		if( @tostate = 'PR' )
			SET  @pointID =   '2'  ;
	   End
ELSE IF ( @ANI_pointID =  '4')
  Begin
	IF(@fromstate = 'PR'  ) 	
	  Begin
		IF (@fromstate =  @tostate ) 
			SET  @pointID =   'PR'   ;
		
		ELSE  SET  @pointID =   'PU'   ;
	  End
	Else
	 begin
		if( @tostate = 'PR' )
			SET  @pointID =   '2'  ;
		Else
			SET  @pointID =   '3'  ;
	 end
  End

ELSE IF  (@ANI_pointID =  '5' )
	 SET   @pointID =  '9';

ELSE  
	SET @pointID =   @ANI_pointID ;

