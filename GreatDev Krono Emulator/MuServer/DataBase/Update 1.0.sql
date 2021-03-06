USE [MuOnline]
GO
/****** Object:  StoredProcedure [dbo].[_SP_ENTER_CHECK_BC]    Script Date: 2016.11.10. 22:30:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE	[dbo].[_SP_ENTER_CHECK_BC]

	@AccountID		varchar(10),
	@CharacterName	varchar(10),
	@Server		smallint
AS
BEGIN
	DECLARE	@iMaxEnterCheck	INT
	DECLARE	@iNowEnterCheck	INT

	SET		@iMaxEnterCheck	= 6
	
	BEGIN TRANSACTION
	
	SET NOCOUNT ON	

	IF EXISTS (SELECT AccountID FROM T_ENTER_CHECK_BC  WITH (READUNCOMMITTED) 
				WHERE  AccountID = @AccountID AND ServerCode = @Server AND CharName = @CharacterName)
	BEGIN
		SELECT @iNowEnterCheck = ToDayEnterCount 
		FROM T_ENTER_CHECK_BC  WITH (READUNCOMMITTED) 
		WHERE  AccountID = @AccountID AND ServerCode = @Server AND CharName = @CharacterName

		IF (@iNowEnterCheck >= @iMaxEnterCheck)
		BEGIN
			SELECT 0 AS EnterResult
		END
		ELSE
		BEGIN
			UPDATE T_ENTER_CHECK_BC 
			SET ToDayEnterCount = ToDayEnterCount + 1, LastEnterDate = GetDate()
			WHERE  AccountID = @AccountID AND ServerCode = @Server AND CharName = @CharacterName

			SELECT 1 AS EnterResult
		END
		
	END
	ELSE
	BEGIN
		INSERT INTO T_ENTER_CHECK_BC (AccountID, CharName, ServerCode, ToDayEnterCount, LastEnterDate) VALUES (
			@AccountID,
			@CharacterName,
			@Server,
			1,
			DEFAULT
		)
	
		SELECT 1 AS EnterResult
	END

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END


GO
/****** Object:  StoredProcedure [dbo].[SP_CHECK_BC]    Script Date: 2016.11.10. 22:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE	[dbo].[SP_CHECK_BC]

	@AccountID		varchar(10),
	@CharacterName	varchar(10),
	@Server		smallint
AS
BEGIN
	DECLARE	@iMaxEnterCheck	INT
	DECLARE	@iNowEnterCheck	INT

	SET		@iMaxEnterCheck	= 6
	
	BEGIN TRANSACTION
	
	SET NOCOUNT ON	

	IF EXISTS (SELECT AccountID FROM T_ENTER_CHECK_BC  WITH (READUNCOMMITTED) 
				WHERE  AccountID = @AccountID AND ServerCode = @Server AND CharName = @CharacterName)
	BEGIN
		SELECT @iNowEnterCheck = ToDayEnterCount 
		FROM T_ENTER_CHECK_BC  WITH (READUNCOMMITTED) 
		WHERE  AccountID = @AccountID AND ServerCode = @Server AND CharName = @CharacterName

		IF (@iNowEnterCheck >= @iMaxEnterCheck)
		BEGIN
			SELECT 0 AS EnterResult
		END
		ELSE
		BEGIN
			SELECT 1 AS EnterResult
		END
		
	END
	ELSE
	BEGIN
		SELECT 1 AS EnterResult
	END

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END


GO
/****** Object:  StoredProcedure [dbo].[SP_CHECK_ILLUSION_TEMPLE]    Script Date: 2016.11.10. 22:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE    [dbo].[SP_CHECK_ILLUSION_TEMPLE]
    @AccountID        varchar(10),    -- 拌沥疙
    @CharacterName    varchar(10),    -- 纳腐疙
    @Server        smallint        -- 辑滚
As
Begin
    DECLARE    @iMaxEnterCheck    INT
    DECLARE    @iNowEnterCheck    INT

    SET        @iMaxEnterCheck    = 6        -- 老老 弥措 涝厘啊瓷 冉荐
    
    BEGIN TRANSACTION
    
    SET NOCOUNT ON    

    IF EXISTS ( SELECT AccountID FROM T_ENTER_CHECK_ILLUSION_TEMPLE  WITH (READUNCOMMITTED)
                WHERE  AccountID = @AccountID AND ServerCode = @Server AND CharName = @CharacterName )
    BEGIN
        SELECT @iNowEnterCheck = TodayEnterCount
        FROM T_ENTER_CHECK_ILLUSION_TEMPLE  WITH (READUNCOMMITTED)
        WHERE  AccountID = @AccountID AND ServerCode = @Server AND CharName = @CharacterName

        IF (@iNowEnterCheck >= @iMaxEnterCheck)
        BEGIN
            SELECT 0 As EnterResult    -- 荤盔 涝厘 阂啊瓷
        END
        ELSE
        BEGIN
            SELECT 1 As EnterResult    -- 荤盔 涝厘 啊瓷
        END
        
    END
    ELSE
    BEGIN
        SELECT 1 As EnterResult        -- 荤盔 涝厘 啊瓷
    END

    IF(@@Error <> 0 )
        ROLLBACK TRANSACTION
    ELSE    
        COMMIT TRANSACTION

    SET NOCOUNT OFF    
End


GO
/****** Object:  StoredProcedure [dbo].[SP_ENTER_BC]    Script Date: 2016.11.10. 22:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE	[dbo].[SP_ENTER_BC]

	@AccountID		varchar(10),
	@CharacterName	varchar(10),
	@Server		smallint
AS
BEGIN
	BEGIN TRANSACTION
	
	SET NOCOUNT ON	

	IF EXISTS (SELECT AccountID FROM T_ENTER_CHECK_BC  WITH (READUNCOMMITTED) 
				WHERE  AccountID = @AccountID AND ServerCode = @Server AND CharName = @CharacterName)
	BEGIN
		UPDATE T_ENTER_CHECK_BC 
		SET ToDayEnterCount = ToDayEnterCount + 1, LastEnterDate = GetDate()
		WHERE  AccountID = @AccountID AND ServerCode = @Server AND CharName = @CharacterName
	END
	ELSE
	BEGIN
		INSERT INTO T_ENTER_CHECK_BC (AccountID, CharName, ServerCode, ToDayEnterCount, LastEnterDate) VALUES (
			@AccountID,
			@CharacterName,
			@Server,
			1,
			DEFAULT
		)
	END

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END


GO
/****** Object:  StoredProcedure [dbo].[SP_ENTER_ILLUSION_TEMPLE]    Script Date: 2016.11.10. 22:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE	[dbo].[SP_ENTER_ILLUSION_TEMPLE]

	@AccountID		varchar(10),
	@CharacterName	varchar(10),
	@Server		smallint
AS
BEGIN
	BEGIN TRANSACTION
	
	SET NOCOUNT ON	

	IF EXISTS (SELECT AccountID FROM T_ENTER_CHECK_ILLUSION_TEMPLE  WITH (READUNCOMMITTED) 
				WHERE  AccountID = @AccountID AND ServerCode = @Server AND CharName = @CharacterName)
	BEGIN
		UPDATE T_ENTER_CHECK_ILLUSION_TEMPLE 
		SET TodayEnterCount = TodayEnterCount + 1, LastEnterDate = GetDate()
		WHERE  AccountID = @AccountID AND ServerCode = @Server AND CharName = @CharacterName
	END
	ELSE
	BEGIN
		INSERT INTO T_ENTER_CHECK_ILLUSION_TEMPLE (AccountID, CharName, ServerCode, TodayEnterCount, LastEnterDate) VALUES (
			@AccountID,
			@CharacterName,
			@Server,
			1,
			DEFAULT
		)
	END

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END


GO
/****** Object:  StoredProcedure [dbo].[SP_POINT_ACCM_BC]    Script Date: 2016.11.10. 22:30:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE	[dbo].[SP_POINT_ACCM_BC]

	@Server		smallint,
	@Bridge		tinyint,
	@AccountID		varchar(10),
	@CharacterName	varchar(10),
	@Class			tinyint,
	@Point			int,
	@PCRoomGUID	int
AS
BEGIN
	DECLARE	@TEMP	int
END


GO
/****** Object:  StoredProcedure [dbo].[SP_POINT_ACCM_BC_3RD]    Script Date: 2016.11.10. 22:30:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE	[dbo].[SP_POINT_ACCM_BC_3RD]

	@Server		smallint,
	@Bridge		tinyint,
	@AccountID		varchar(10),
	@CharacterName	varchar(10),
	@Class			tinyint,
	@Point			int,
	@PCRoomGUID	int,
	@LeftTime		int
AS
BEGIN
	
	BEGIN TRANSACTION
	
	SET NOCOUNT ON	

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END


GO
/****** Object:  StoredProcedure [dbo].[SP_POINT_ACCM_BC_4TH]    Script Date: 2016.11.10. 22:30:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE	[dbo].[SP_POINT_ACCM_BC_4TH]

	@Server		smallint,
	@Bridge		tinyint,
	@AccountID		varchar(10),
	@CharacterName	varchar(10),
	@Class			tinyint,
	@Point			int,
	@PCRoomGUID	int,
	@LeftTime		int
AS
BEGIN	
	BEGIN TRANSACTION
	
	SET NOCOUNT ON	

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END


GO
/****** Object:  StoredProcedure [dbo].[SP_POINT_ACCM_BC_5TH]    Script Date: 2016.11.10. 22:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE	[dbo].[SP_POINT_ACCM_BC_5TH]

	@Server		smallint,
	@Bridge		tinyint,
	@AccountID	 	varchar(10),
	@CharacterName	varchar(10),
	@Class			tinyint,
	@Point			int,
	@LeftTime		int,
	@AlivePartyCount	int
AS
BEGIN	
	BEGIN TRANSACTION
	
	SET NOCOUNT ON

	DECLARE @RegDate	SMALLDATETIME
	SET @RegDate = CAST(DATEPART(YY, GetDate()) AS VARCHAR(4)) + '-' + CAST(DATEPART(MM, GetDate()) AS VARCHAR(2)) + '-' + CAST(DATEPART(DD, GetDate()) AS VARCHAR(2)) + ' 00:00:00'

	IF EXISTS (SELECT CharacterName FROM EVENT_INFO_BC_5TH  WITH (READUNCOMMITTED) 
				WHERE RegDate = @RegDate AND Server = @Server AND AccountID = @AccountID AND CharacterName = @CharacterName)
		BEGIN			
			DECLARE @iiiPoint		int
			DECLARE @iMinLeftTime		int
			DECLARE @iAlivePartyCount	int
			DECLARE @iMaxPointLeftTime	int

			SELECT @iiiPoint = Point, @iMinLeftTime = MinLeftTime, @iAlivePartyCount = AlivePartyCount, @iMaxPointLeftTime = MaxPointLeftTime
			FROM EVENT_INFO_BC_5TH
			WHERE  RegDate = @RegDate AND Server = @Server  AND AccountID = @AccountID AND CharacterName = @CharacterName

			IF (@iiiPoint < @Point)
			BEGIN
				IF (@Point > 0)
				BEGIN
					SET @iiiPoint = @Point
					SET @iMaxPointLeftTime = @LeftTime
				END
			END

			IF (@iiiPoint = @Point)
			BEGIN
				IF (@Point > 0)
				BEGIN
					IF (@iMaxPointLeftTime < @LeftTime)
					BEGIN
						SET @iMaxPointLeftTime = @LeftTime
					END
				END
			END

			IF (@iAlivePartyCount <= @AlivePartyCount)
			BEGIN
				IF (@iMinLeftTime < @LeftTime)
				BEGIN
					IF (@Point > 0)
					BEGIN
						SET @iMinLeftTime = @LeftTime
					END
				END
				SET @iAlivePartyCount = @AlivePartyCount
			END

			IF (@iiiPoint < 0)
			BEGIN
				UPDATE EVENT_INFO_BC_5TH
				SET Point = 0 , Bridge = @Bridge, PlayCount = PlayCount+1, SumLeftTime = SumLeftTime + @LeftTime, MinLeftTime = @iMinLeftTime, AlivePartyCount = @iAlivePartyCount, MaxPointLeftTime = @iMaxPointLeftTime
				WHERE  RegDate = @RegDate AND Server = @Server  AND AccountID = @AccountID AND CharacterName = @CharacterName	
			END	
			ELSE
			BEGIN
				UPDATE EVENT_INFO_BC_5TH
				SET Point = @iiiPoint, Bridge = @Bridge, PlayCount = PlayCount+1, SumLeftTime = SumLeftTime + @LeftTime, MinLeftTime = @iMinLeftTime, AlivePartyCount = @iAlivePartyCount, MaxPointLeftTime = @iMaxPointLeftTime
				WHERE  RegDate = @RegDate AND Server = @Server  AND AccountID = @AccountID AND CharacterName = @CharacterName	
			END
		END
	ELSE
		BEGIN
			IF (@Point < 0)
			BEGIN
				INSERT INTO EVENT_INFO_BC_5TH (Server,  Bridge, AccountID, CharacterName, Class, Point, PlayCount, SumLeftTime, MinLeftTime, RegDate, AlivePartyCount, MaxPointLeftTime) VALUES (
					@Server,
					@Bridge,
					@AccountID,
					@CharacterName,
					@Class,
					0,
					1,
					0,
					0,
					@RegDate,
					0,
					0
				)
			END
			ELSE
			BEGIN
				INSERT INTO EVENT_INFO_BC_5TH (Server,  Bridge, AccountID, CharacterName, Class, Point, PlayCount, SumLeftTime, MinLeftTime, RegDate, AlivePartyCount, MaxPointLeftTime) VALUES (
					@Server,
					@Bridge,
					@AccountID,
					@CharacterName,
					@Class,
					@Point,
					1,
					@LeftTime,
					@LeftTime,
					@RegDate,
					@AlivePartyCount,
					@LeftTime
				)
			END

		END

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END


GO
/****** Object:  StoredProcedure [dbo].[SP_POINT_ACCUMULATION]    Script Date: 2016.11.10. 22:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE	[dbo].[SP_POINT_ACCUMULATION]

	@Server		smallint,
	@Square		tinyint,
	@AccountID		varchar(10),
	@CharacterName	varchar(10),
	@Class			tinyint,
	@Point			int
AS
BEGIN	
	BEGIN TRANSACTION
	
	SET NOCOUNT ON	

	IF EXISTS (SELECT CharacterName FROM EVENT_INFO  WITH (READUNCOMMITTED) 
				WHERE  Server = @Server AND AccountID = @AccountID AND CharacterName = @CharacterName)
		BEGIN	
			UPDATE EVENT_INFO
			SET Point = Point + @Point , Square = @Square 										
			WHERE  Server = @Server  AND AccountID = @AccountID AND CharacterName = @CharacterName		
		END
	ELSE
		BEGIN
			INSERT INTO EVENT_INFO (Server, Square, AccountID, CharacterName, Class, Point) VALUES (
				@Server,
				@Square,
				@AccountID,
				@CharacterName,
				@Class,
				@Point	
			)	
		END

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END


GO
/****** Object:  StoredProcedure [dbo].[SP_REG_ILLUSION_TEMPLE_RANKPOINT]    Script Date: 2016.11.10. 22:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_REG_ILLUSION_TEMPLE_RANKPOINT]
   @AccountID      varchar(10),
   @Name         varchar(10),
   @Server_code      smallint,
   @IT_Number      tinyint,
   @Class         smallint,
   @Level         int,
   @Win         tinyint,
   @iPCRoom      int,
   @ExpGained      int
   
AS
BEGIN
   BEGIN TRANSACTION
   
   SET NOCOUNT ON   
   
   DECLARE @Wins INT
   DECLARE @Exp INT

   IF EXISTS (SELECT * FROM T_Illusion_Temple_Rank WHERE AccountID = @AccountID AND Name = @Name)
   BEGIN
      SELECT @Wins = Wins, @Exp = Exp FROM T_Illusion_Temple_Rank WHERE AccountID = @AccountID AND Name = @Name
      UPDATE T_Illusion_Temple_Rank SET Level = @Level, Class = @Class, IT_Number = @IT_Number, Wins = @Wins + @Win, Exp = @Exp + @ExpGained WHERE AccountID = @AccountID AND Name = @Name
   END
   ELSE
   BEGIN
      INSERT INTO T_Illusion_Temple_Rank VALUES (@AccountID, @Name, @Class, @Level, @IT_Number, @Wins, @Exp) 
   END

   IF(@@Error <> 0 )
      ROLLBACK TRANSACTION
   ELSE   
      COMMIT TRANSACTION
   
   SET NOCOUNT OFF   
END



GO
/****** Object:  StoredProcedure [dbo].[USP_BloodCastle5_Ranking]    Script Date: 2016.11.10. 22:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_BloodCastle5_Ranking]

	@BridgeSearch	tinyint
AS

SET NOCOUNT ON

	SELECT TOP 50  T1.CharacterName, T1.Server, 0 AS Point, MAX(T1.MinLeftTime) as MinLeftTime, T1.Bridge, 

	(SELECT TOP 1 T2.AlivePartyCount FROM EVENT_INFO_BC_5TH T2 WHERE T1.CharacterName = T2.CharacterName AND T1.Server = T2.Server 
	 AND T1.Bridge = T2.Bridge AND T1.AccountID = T2.AccountID AND T2.AlivePartyCount >= 5 ORDER BY T2.MinLeftTime DESC) AS AlivePartyCount,

	(SELECT TOP 1 Convert(char(8),T3.RegDate,112) FROM EVENT_INFO_BC_5TH T3 WHERE T1.CharacterName = T3.CharacterName AND T1.Server = T3.Server 
	 AND T1.Bridge = T3.Bridge AND T1.AccountID = T3.AccountID AND T3.AlivePartyCount >= 5 ORDER BY T3.MinLeftTime DESC, T3.RegDate) AS RegDate
	FROM EVENT_INFO_BC_5TH  T1 WHERE AlivePartyCount > 4 AND T1.Server <> 13 

	GROUP BY T1.CharacterName,T1.Server, T1.Bridge,T1.AccountID
	Having  T1.Bridge = @BridgeSearch

	ORDER BY AlivePartyCount DESC, MinLeftTime DESC, RegDate, T1.Server
			
SET NOCOUNT OFF


GO
/****** Object:  Table [dbo].[EVENT_INFO]    Script Date: 2016.11.10. 22:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EVENT_INFO](
	[Server] [smallint] NOT NULL,
	[Square] [tinyint] NOT NULL,
	[AccountID] [varchar](10) NOT NULL,
	[CharacterName] [varchar](10) NOT NULL,
	[Class] [tinyint] NOT NULL,
	[Point] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EVENT_INFO_BC]    Script Date: 2016.11.10. 22:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EVENT_INFO_BC](
	[Server] [smallint] NOT NULL,
	[Bridge] [tinyint] NOT NULL,
	[AccountID] [varchar](10) NOT NULL,
	[CharacterName] [varchar](10) NOT NULL,
	[Class] [tinyint] NOT NULL,
	[Point] [int] NOT NULL,
	[PlayCount] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EVENT_INFO_BC_3RD]    Script Date: 2016.11.10. 22:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EVENT_INFO_BC_3RD](
	[Server] [tinyint] NOT NULL,
	[Bridge] [tinyint] NOT NULL,
	[AccountID] [varchar](10) NOT NULL,
	[CharacterName] [varchar](10) NOT NULL,
	[Class] [tinyint] NOT NULL,
	[Point] [int] NOT NULL,
	[PlayCount] [int] NOT NULL,
	[SumLeftTime] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EVENT_INFO_BC_4TH]    Script Date: 2016.11.10. 22:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EVENT_INFO_BC_4TH](
	[Server] [tinyint] NOT NULL,
	[Bridge] [tinyint] NOT NULL,
	[AccountID] [varchar](10) NOT NULL,
	[CharacterName] [varchar](10) NOT NULL,
	[Class] [tinyint] NOT NULL,
	[Point] [int] NOT NULL,
	[PlayCount] [int] NOT NULL,
	[SumLeftTime] [int] NOT NULL,
	[MinLeftTime] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EVENT_INFO_BC_5TH]    Script Date: 2016.11.10. 22:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EVENT_INFO_BC_5TH](
	[Server] [tinyint] NOT NULL,
	[Bridge] [tinyint] NOT NULL,
	[AccountID] [varchar](10) NOT NULL,
	[CharacterName] [varchar](10) NOT NULL,
	[Class] [tinyint] NOT NULL,
	[Point] [int] NOT NULL,
	[PlayCount] [int] NOT NULL,
	[SumLeftTime] [int] NOT NULL,
	[MinLeftTime] [int] NOT NULL,
	[RegDate] [smalldatetime] NOT NULL,
	[AlivePartyCount] [int] NOT NULL,
	[MaxPointLeftTime] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LeoTheHelper]    Script Date: 2016.11.10. 22:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LeoTheHelper](
	[Name] [varchar](11) NULL,
	[Status] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LukeTheHelper]    Script Date: 2016.11.10. 22:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LukeTheHelper](
	[Name] [varchar](11) NULL,
	[Status] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[T_ENTER_CHECK_BC]    Script Date: 2016.11.10. 22:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[T_ENTER_CHECK_BC](
	[AccountID] [varchar](10) NOT NULL,
	[CharName] [varchar](10) NOT NULL,
	[ServerCode] [smallint] NOT NULL,
	[ToDayEnterCount] [tinyint] NOT NULL,
	[LastEnterDate] [smalldatetime] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[T_ENTER_CHECK_ILLUSION_TEMPLE]    Script Date: 2016.11.10. 22:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[T_ENTER_CHECK_ILLUSION_TEMPLE](
	[AccountID] [varchar](10) NOT NULL,
	[CharName] [varchar](10) NOT NULL,
	[ServerCode] [tinyint] NOT NULL,
	[TodayEnterCount] [tinyint] NOT NULL,
	[LastEnterDate] [smalldatetime] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[T_MU2003_EVENT]    Script Date: 2016.11.10. 22:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[T_MU2003_EVENT](
	[AccountID] [varchar](50) NOT NULL,
	[EventChips] [smallint] NOT NULL,
	[MuttoIndex] [int] NOT NULL,
	[MuttoNumber] [int] NOT NULL,
	[Check_Code] [char](1) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
