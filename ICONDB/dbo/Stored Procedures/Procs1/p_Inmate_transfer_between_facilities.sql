CREATE PROCEDURE [dbo].[p_Inmate_transfer_between_facilities]
@PIN	varchar(12),
@fromFacilityID int,
@toFacilityID int
AS

Insert tblInmate  (InmateID , CaseID  ,    LastName   , FirstName,    MidName  , Status ,DNIRestrict ,DateTimeRestrict, AccessType ,AlertEmail  ,  AlertPage,  AlertPhone, AlertCellPhones  ,
                           DNILimit, FacilityId,  inputdate, UserName , ModifyDate ,  PIN, MaxCallTime, HourlyFreq, DailyFreq, WeeklyFreq, MonthlyFreq, MaxCallPerHour ,MaxCallPerDay, MaxCallPerWeek,
		 MaxCallPerMonth, DOB,SEX , TTY,  StartDate ,EndDate,  DebitCardOpt, NameRecorded )

select  InmateID , CaseID  ,    LastName   , FirstName,    MidName  , 1 ,DNIRestrict ,DateTimeRestrict, AccessType ,AlertEmail  ,  AlertPage,  AlertPhone, AlertCellPhones  ,
                           DNILimit, @toFacilityID,  inputdate, UserName , ModifyDate ,  PIN, MaxCallTime, HourlyFreq, DailyFreq, WeeklyFreq, MonthlyFreq, MaxCallPerHour ,MaxCallPerDay, MaxCallPerWeek,
		 MaxCallPerMonth, DOB,SEX , TTY,  StartDate ,EndDate,  DebitCardOpt, NameRecorded  from   tblInmate  where  FacilityID =  @fromFacilityID and PIN = @PIN

Update tblInmate  SET status = 3 where FacilityID =  @fromFacilityID and PIN = @PIN

