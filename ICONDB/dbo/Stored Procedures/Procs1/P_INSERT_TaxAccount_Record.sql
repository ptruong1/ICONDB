
CREATE PROCEDURE [dbo].[P_INSERT_TaxAccount_Record]
(@TaxID int  
           ,@State nvarchar(2)  
           ,@TaxingJurisName nvarchar(50)  
           ,@TaxTypeID int  
           ,@Rate float  
           ,@Amount money  
           ,@StartDate datetime  
           ,@EndDate datetime  
           ,@LastUpdated datetime  
           ,@TaxOnUsage int  
           ,@TaxOnProduct int  
           ,@TaxCategoryID int  
           ,@TaxOnIntrastate bit  
           ,@TaxOnInterstate bit  
           ,@TaxOnInternational bit  
           ,@UserID nvarchar(32)  )
AS
	SET NOCOUNT OFF;

	if (select count(*) from [dbo].[tblTaxes] where State = @State and TaxTypeID = @TaxTypeID and TaxingJurisName = @TaxingJurisName and TaxCategoryID=@TaxCategoryID) > 0
	   BEGIN
		RETURN -1;
	   END
	else
	begin
	Declare  @return_value int, @nextID int, @ID int, @tblTaxes nvarchar(32) ;
	 EXEC   @return_value = p_create_nextID 'tblTaxes', @nextID   OUTPUT
        set           @ID = @nextID ; 
	INSERT INTO [dbo].[tblTaxes]
			   ([TaxID]
			   ,[State]
			   ,[TaxingJurisName]
			   ,[TaxTypeID]
			   ,[Rate]
			   ,[Amount]
			   ,[StartDate]
			   ,[EndDate]
			   ,[LastUpdated]
			   ,[TaxOnUsage]
			   ,[TaxOnProduct]
			   ,[TaxCategoryID]
			   ,[TaxOnIntrastate]
			   ,[TaxOnInterstate]
			   ,[TaxOnInternational]
			   ,[UserID])
		 VALUES
			   (@ID   
			   ,@State  
			   ,@TaxingJurisName 
			   ,@TaxTypeID
			   ,@Rate 
			   ,@Amount
			   ,@StartDate 
			   ,@EndDate
			   ,@LastUpdated
			   ,@TaxOnUsage 
			   ,@TaxOnProduct
			   ,@TaxCategoryID 
			   ,@TaxOnIntrastate
			   ,@TaxOnInterstate  
			   ,@TaxOnInternational
			   ,@UserID   )

	SELECT        [TaxID]
		  ,[State]
		  ,[TaxingJurisName]
		  ,[TaxTypeID]
		  ,[Rate]
		  ,[Amount]
		  ,[StartDate]
		  ,[EndDate]
		  ,[LastUpdated]
		  ,[TaxOnUsage]
		  ,[TaxOnProduct]
		  ,[TaxCategoryID]
		  ,[TaxOnIntrastate]
		  ,[TaxOnInterstate]
		  ,[TaxOnInternational]
		  ,[UserID]
	  FROM [leg_Icon].[dbo].[tblTaxes]

	  end
