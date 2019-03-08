-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_inmate_info_detail]
@FacilityID int,
@InmateID varchar(12)

AS
BEGIN
    Declare @PIN varchar(12);
    Declare @Inmate as table(FacilityID int, BookingNo varchar(12), InmateID varchar(12), PIN varchar(12),ArrestDate varchar(10), ChargeDescript varchar(100), BookingDate varchar(10),BirthDate varchar(10), Sex varchar(4), Race varchar(10), HairColor varchar(10),
							 EyeColor varchar(10), Height varchar(10), [Weight] int,  [Address] varchar(100), City varchar(30), [State] varchar(2), Zipcode Varchar(9))
	
	select @PIN = PIN from tblinmate with(nolock) where facilityID = @facilityID and InmateID = @InmateID and status=1;
	
	

	
	 if(select count(*) from tblInmateBookInfo with(nolock) where FacilityID = @FacilityID and PIN = @InmateID) > 0
	 begin
		--select * from  @Inmate ;
		insert @Inmate (FacilityID,BookingNo, InmateID, PIN,     ChargeDescript) 
		select FacilityID, bookingNo, @InmateID, PIN,   ChargeDescript   from tblInmateBookInfo where FacilityID = @FacilityID and PIN= @InmateID; 
	 end
	 if(select count(*) from tblInmateInfo with(nolock) where FacilityID = @FacilityID and PIN = @InmateID) > 0
	 begin	
	    if(select count (*) from @Inmate) =0   
			insert @Inmate (FacilityID,BookingNo, InmateID, PIN,  BookingDate , BirthDate , Sex,Race ,HairColor,EyeColor,Height,Weight,Address, City,State,Zipcode) 
			select FacilityID, bookingNo, @InmateID, PIN,  BookingDate , BirthDate , Sex,Race ,HairColor,EyeColor,Height,Weight,Address1, City,State,Zip  from tblInmateInfo where FacilityID = @FacilityID and PIN= @InmateID;
		else
			Update @Inmate SET BookingDate = b.BookingDate,
								BirthDate = b.BirthDate,
								Sex= b.Sex,
								race = b.Race,
								HairColor= b.HairColor,
								EyeColor= b.EyeColor,
								Height = b.Height,
								Weight = b.Weight,
								Address=b.Address1,
								city = b.City,
								state = b.State,
								Zipcode= b.Zip
			from @Inmate a, tblInmateInfo  b where a.FacilityID = b.FacilityID and a.InmateID = b.PIN ;
	 end  
	 if(select count (*) from @Inmate) =0 
	  begin
		insert @Inmate (bookingNo, FacilityID, InmateID, PIN,  BookingDate , BirthDate , Sex)
		select 0, FacilityID, InmateID, PIN, Convert(varchar(10), inputdate,101) , DOB , Sex from tblInmate  where facilityID = @facilityID and InmateID = @InmateID;
	  end
	  Select PIN, isnull( BookingNo, 0) BookingNo , isnull(BookingDate,'') BookingDate , isnull (ChargeDescript, '') ChargeDescript, isnull( BirthDate,'')  BirthDate,
	     ISNULL( Sex,'') Sex ,  isnull(Race,'') Race ,Isnull(HairColor,'') HairColor ,isnull(EyeColor,'')EyeColor,isnull(Height,'') Height, isnull(Weight,'') Weight, isnull(Address,'') Address,
		   Isnull(City,'') City, isnull(State,'') State, Isnull(Zipcode,'') ZipCode from @Inmate;
END

