/****** Object:  StoredProcedure [dbo].[p_process_inmate_debit_cardless]    Script Date: 11/14/2013 15:55:37 ******/

CREATE PROCEDURE [dbo].[p_process_inmate_temp]
@facilityID int,
@InmateID	varchar(12),
@firstName	varchar(25),
@lastName	varchar(25),
@PIN		varchar(12)


AS
SET NOCOUNT ON
Declare   @sendStatus tinyint;
set @sendStatus =0;

select @sendStatus = [status] from leg_Icon.dbo.tblInmate with(nolock) where FacilityId =@facilityID and InmateID =@InmateID  ;
if ( @sendStatus >1 )
 Begin 
	update leg_Icon.dbo.tblInmate  set Status=1 where FacilityId =@facilityID and InmateID =@InmateID ;
 end
else if ( @sendStatus =0 )
 Begin
	Insert leg_Icon.dbo.tblInmate (FacilityId,InmateID ,FirstName ,LastName ,Status,PIN, inputdate  )
							values(@facilityID ,@InmateID ,@firstName ,@lastName ,1,@PIN, GETDATE() );
	Insert tblVisitInmateConfig (InmateID ,FacilityID ,ApprovedReq ,AtLocation )
							values(@InmateID,@facilityID ,0,'X.X')					
 end							
 
 
