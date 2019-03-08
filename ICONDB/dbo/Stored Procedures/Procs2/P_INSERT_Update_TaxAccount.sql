
CREATE PROCEDURE [dbo].[P_INSERT_Update_TaxAccount]
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
	
	if (select count(*) from [dbo].[tblTaxes] where TaxID = @TaxID) > 0
	Begin
		UPDATE [dbo].[tblTaxes]
	   SET 
		  [State] = @State
		  ,[TaxingJurisName] = @TaxingJurisName
		  ,[TaxTypeID] = @TaxTypeID
		  ,[Rate] = @Rate
		  ,[Amount] = @Amount
		  ,[StartDate] = @StartDate
		  ,[EndDate] = @EndDate
		  ,[LastUpdated] = @LastUpdated
		  ,[TaxOnUsage] = @TaxOnUsage
		  ,[TaxOnProduct] = @TaxOnProduct
		  ,[TaxCategoryID] = @TaxCategoryID
		  ,[TaxOnIntrastate] = @TaxOnIntrastate
		  ,[TaxOnInterstate] = @TaxOnInterstate
		  ,[TaxOnInternational] = @TaxOnInternational
		  ,[UserID] = @UserID
		WHERE TaxID = @TaxID
		end
	else
	Begin
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

	End ;
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

  
