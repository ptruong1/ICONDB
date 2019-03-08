/****** Object:  StoredProcedure [dbo].[p_commissary_refund_multi_account]    Script Date: 5/26/2015 5:41:03 PM ******/


CREATE PROCEDURE [dbo].[p_commissary_refund_multi_account]
@RequestID varchar(22),
@ClientType	varchar(16),  -- not use
@SystemID	varchar(12)	,			--ClientID
@SystemTag varchar(12),  -- facilityID	int,
@Vendor	varchar(12), --Swandons
@Residents Nvarchar(2000),
@TimeStamp  varchar(30),
@IPaddress varchar(16)
AS

SET		ANSI_NULLS OFF;
SET		QUOTED_IDENTIFIER,
		ANSI_PADDING,
		ANSI_WARNINGS,
		CONCAT_NULL_YIELDS_NULL
		ON; 


declare  @AccountNo varchar(12),@FacilityID int, @balance as numeric(6,2);
declare @Replystatus varchar(2);
Declare @SubRequestID varchar(22),@ResidentIdentifier varchar(12), @PIN varchar(12), @XMLResident xml  ;
DECLARE @MyXML as NVARCHAR(2000), @Reply as XML;
SET @MyXML = '';
if (isnumeric(@SystemTag) =0)
begin
	 SET @Replystatus='3'; 
	 
	 --SET @MyXML = '<Residents>' + Cast(@Residents as varchar(2000)) ;
	SET @MyXML =  Cast(@Residents as varchar(2000)) ;
end
else
 begin
	SET @FacilityID = cast(@SystemTag  as int);
	SET @AccountNo='0' ;
	SET @Replystatus ='0';
	SET @Replystatus= dbo.fn_verify_commissary_client(@ClientType,@FacilityID,@SystemID) ;
	SET  @balance = 0;
	--SET @MyXML = '<Residents>' ;
	SET @XMLResident = Cast(@Residents as XML);
 end

if(@Replystatus='0')
 begin
	DECLARE res_curs CURSOR    FOR
	select 
		t.x.value('SubRequestID[1]','varchar(20)') as SubRequestID,
		t.x.value('ResidentIdentifier[1]','varchar(20)') as ResidentIdentifier,
		 t.x.value('PIN[1]','varchar(20)') as PIN
	--from @XMLResident.nodes('Residents/Resident') t(x)
	from @XMLResident.nodes('Resident') t(x)
	Open res_curs
	FETCH NEXT FROM res_curs into @SubRequestID , @ResidentIdentifier, @PIN
	

	select 
		t.x.value('SubRequestID[1]','varchar(20)') as SubRequestID,
		t.x.value('ResidentIdentifier[1]','varchar(20)') as ResidentIdentifier,
		 t.x.value('PIN[1]','varchar(20)') as PIN
	from @XMLResident.nodes('Resident') t(x)

    WHILE @@FETCH_STATUS = 0 BEGIN
	     SET  @balance=0 ;
		-- print 'TEST';
         Select @balance = balance from tbldebit where facilityID = @facilityID and inmateID = @ResidentIdentifier;
		 if(@balance >0)
		  begin
			 update tbldebit set status = 4 , modifyDate = getdate(), username=@Vendor,Balance=0, Note='Release and Refund:' + @SubRequestID   where facilityID = @facilityID and inmateID = @ResidentIdentifier;
		 
			 if(@@ERROR =0)
				SET  @MyXML = @MyXML + '<Resident><SubReplyStatus>0</SubReplyStatus>' ;
			 else
				SET  @MyXML = @MyXML + '<Resident><SubReplyStatus>99</SubReplyStatus>' ;
			 SET  @MYXML = @MyXML
								+ '<SubRequestID>' +@SubRequestID  +'</SubRequestID>'
								+ '<ResidentIdentifier>' + @ResidentIdentifier + '</ResidentIdentifier>'
								+ '<PIN>' + @PIN +'</PIN>'
								+ '<Amount>' +CAST( @balance as Varchar(12)) +'</Amount>'
								+ '</Resident>' ;
	      end
		 else
		   begin
		     SET  @MyXML = @MyXML + '<Resident><SubReplyStatus>0</SubReplyStatus>' ;
			 SET  @MYXML = @MyXML 	+ '<SubRequestID>' +@SubRequestID  +'</SubRequestID>'
								+ '<ResidentIdentifier>' + @ResidentIdentifier + '</ResidentIdentifier>'
								+ '<PIN>' + @PIN +'</PIN>'
								+ '<Amount>0</Amount>'
								+ '</Resident>' ;

				--select 'TEST'
		   end

		FETCH NEXT FROM res_curs into @SubRequestID , @ResidentIdentifier, @PIN ;
     END
	 
	 close res_curs;
	 deallocate res_curs ;
	 

 end
 --SET  @MyXML = @MyXML +  '</Residents>' ;


if(@@ERROR =0)
		select @Replystatus as ReplyStatus,
		@RequestID as RequestID,
		@ClientType as ClientType,  -- not use
		@SystemID	as SystemID	,			--ClientID
		@SystemTag as SystemTag,  -- facilityID	int,
		@Vendor	as Vendor, --Swandons
		@MyXML	as Residents,
		@TimeStamp  as [TimeStamp]  ;

else
		select '99'  as ReplyStatus,
		@RequestID as RequestID,
		@ClientType as ClientType,  -- not use
		@SystemID	as SystemID	,			--ClientID
		@SystemTag as SystemTag,  -- facilityID	int,
		@Vendor	as Vendor, --Swandons
		@Residents as Residents,
		@TimeStamp  as [TimeStamp] ;
 						
 


