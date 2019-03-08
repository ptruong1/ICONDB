CREATE TABLE [dbo].[tblVoiceBioException] (
    [FacilityID]  INT          NOT NULL,
    [InmateID]    VARCHAR (12) NOT NULL,
    [InputDate]   DATETIME     CONSTRAINT [DF_tblVoiceBioException_InputDate] DEFAULT (getdate()) NULL,
    [ModifyDate]  DATETIME     NULL,
    [VoiceStatus] TINYINT      NOT NULL,
    [userID]      VARCHAR (20) NULL
);

