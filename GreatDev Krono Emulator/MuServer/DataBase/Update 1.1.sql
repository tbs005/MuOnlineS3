USE [MuOnline]
GO
/****** Object:  StoredProcedure [dbo].[SP_CHECK_WHITEANGEL_GET_ITEM_EVENT]    Script Date: 2018.01.10. 10:57:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--//************************************************************************
--// 내   용 : 화이트엔젤 아이템 지급 이벤트
--// 부   서 : MU_STUDIO 
--// 만들일 : 2006.08.23
--// 만들이 : 김혜화
--// 
--// 리턴값 설명
--// 
--// 	성공코드 :	0x00 : 아이템 지급 대상자(성공)
--//			0x01 : 등록된 사용자가 아님(실패)
--//			0x02 : 이미 아이템을 지급했음(실패)
--//			0x03 : 유효하지 않은 쿠폰 등록 날짜(실패)			
--//				유효하지 않은 발급 날짜(실패)
--// 	
--// 
--//************************************************************************


CREATE PROC [dbo].[SP_CHECK_WHITEANGEL_GET_ITEM_EVENT]
	@AccountID	varchar( 10 )
AS
BEGIN

	BEGIN TRANSACTION

	SET 		NOCOUNT ON
	SET		XACT_ABORT ON				-- 에러발생시 모든 트랜잭션 취소

	DECLARE 	@Count 		tinyint			-- 아이템 카운트
	DECLARE	@RegDate	smalldatetime		-- DB에 화이트엔젤 유저정보를 등록한 날짜
	DECLARE	@ItemGetDate	smalldatetime		-- 아이템을 지급한 날짜


	SET		 LOCK_TIMEOUT	1000			-- 트랜잭션 장기 잠금처리를 막기 위해서 	
	
	--*******************************************************
	-- 등록된 계정인지 확인
	--*******************************************************
	IF EXISTS ( SELECT AccountID FROM T_WhiteAngelEvent2006 WHERE AccountID = @AccountID )
		BEGIN
		-- 데이터를 얻는다.
		SELECT @Count = Count, @RegDate = RegDate, @ItemGetDate = ItemGetDate FROM T_WhiteAngelEvent2006 WHERE AccountID = @AccountID

		--*******************************************************
		-- 등록된 날짜가 유효한가?
		--*******************************************************
		IF ( @RegDate > GetDate() )	
			BEGIN			
			UPDATE T_WhiteAngelEvent2006 SET Count = 0 WHERE AccountID = @AccountID
			SELECT 0x03 AS ResultCode
			END

		--*******************************************************
		-- 카운트가 0인가?
		--*******************************************************
		ELSE IF ( @Count = 0 )
			BEGIN
			SELECT 0x02 AS ResultCode
			END
			
		--*******************************************************
		-- 아이템 지급 날짜가 NULL이 아닌가?
		--*******************************************************
		ELSE IF ( @ItemGetDate  <> NULL )
			BEGIN			
			UPDATE T_WhiteAngelEvent2006 SET Count = 0 WHERE AccountID = @AccountID
			SELECT 0x02 AS ResultCode
			END

		--*******************************************************
		-- 아이템 지급 가능
		--*******************************************************
		ELSE
			BEGIN			
			SELECT 0x00 AS ResultCode
			END

		END
	ELSE
	BEGIN
		--*******************************************************
		-- 등록되지 않은 사용자이다.
		--*******************************************************
		BEGIN		
		SELECT 0x01 AS ResultCode
		END
	END

	IF( @@Error <>0 )
		ROLLBACK TRANSACTION
	ELSE
		COMMIT TRANSACTION
	

	SET NOCOUNT OFF
END

GO
/****** Object:  StoredProcedure [dbo].[SP_REQ_POSSIBLE_PCBANG_COUPON_EVENT]    Script Date: 2018.01.10. 10:57:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--//************************************************************************
--// 내   용 : PC방 쿠폰 이벤트
--// 부   서 : MU_STUDIO 
--// 만들일 : 2006.01.25
--// 만들이 : 김혜화
--// 
--// 리턴값 설명
--// 
--// 	성공코드 :	0x00 : 쿠폰 발급 가능(성공)
--//			0x01 : 미등록 계정(실패)
--//			0x02 : 0 카운트-발급된 쿠폰(실패)
--//			0x03 : 유효하지 않은 쿠폰 등록 날짜(실패)			
--//				유효하지 않은 발급 날짜(실패)
--// 	
--// 
--//************************************************************************


CREATE PROC [dbo].[SP_REQ_POSSIBLE_PCBANG_COUPON_EVENT]
	@AccountID	varchar( 10 )
AS
BEGIN

	BEGIN TRANSACTION

	SET 		NOCOUNT ON
	SET		XACT_ABORT ON				-- 에러발생시 모든 트랜잭션 취소

	DECLARE 	@Count 		tinyint			-- 쿠폰 카운트
	DECLARE	@RegDate	smalldatetime		-- 쿠폰을 웹에 등록한 날짜
	DECLARE	@GetDate	smalldatetime		-- 쿠폰을 발급한 날짜

	DECLARE 	@DATEDIFF	INT			-- 날자차

	SET		 LOCK_TIMEOUT	1000			-- 트랜잭션 장기 잠금처리를 막기 위해서 	
	
	-- 하루에 한번씩 지급으로 수정(goni)

	IF EXISTS ( SELECT AccountID FROM T_PCBangEvent2006 WHERE AccountID = @AccountID )
	BEGIN
		-- 데이터를 얻는다.
		SELECT @Count = Count, @RegDate = RegDate, @GetDate = GetDate FROM T_PCBangEvent2006 WHERE AccountID = @AccountID

		SET @DATEDIFF = DATEDIFF( DAY, @GetDate,  GETDATE())

		--*******************************************************
		-- 카운트가 0인가?
		--*******************************************************
		--IF ( @Count = 0 )
		--BEGIN
		--	SELECT 0x02 AS ResultCode
		--END	
		--*******************************************************
		-- 하루이상 안지남
		--*******************************************************
		--ELSE IF ( @DATEDIFF <= 0)
		 IF ( @DATEDIFF <= 0)
		BEGIN
			SELECT 0x02 AS ResultCode
		END		
		--*******************************************************
		-- 성공, 아이템 지급
		--*******************************************************
		ELSE
		BEGIN
			SELECT 0x00 AS ResultCode
		END	
	END
	ELSE
	BEGIN
		INSERT T_PCBangEvent2006 VALUES (@AccountID, GETDATE(), NULL, 1 )
		
		SELECT 0x00 AS ResultCode
		
	END
/*
	--*******************************************************
	-- 등록된 계정인지 확인
	--*******************************************************
	IF EXISTS ( SELECT AccountID FROM T_PCBangEvent2006 WHERE AccountID = @AccountID )
		BEGIN
		-- 데이터를 얻는다.
		SELECT @Count = Count, @RegDate = RegDate, @GetDate = GetDate FROM T_PCBangEvent2006 WHERE AccountID = @AccountID

		--*******************************************************
		-- 등록된 날짜가 유효한가?
		--*******************************************************
		IF ( @RegDate > GetDate() )	
			BEGIN			
			UPDATE T_PCBangEvent2006 SET Count = 0 WHERE AccountID = @AccountID
			SELECT 0x03 AS ResultCode
			END

		--*******************************************************
		-- 카운트가 0인가?
		--*******************************************************
		ELSE IF ( @Count = 0 )
			BEGIN
			SELECT 0x02 AS ResultCode
			END
			
		--*******************************************************
		-- 발급날짜가 NULL이 아닌가?
		--*******************************************************
		ELSE IF ( @GetDate  <> NULL )
			BEGIN			
			UPDATE T_PCBangEvent2006 SET Count = 0 WHERE AccountID = @AccountID
			SELECT 0x02 AS ResultCode
			END

		--*******************************************************
		-- 발급 가능
		--*******************************************************
		ELSE
			BEGIN			
			SELECT 0x00 AS ResultCode
			END

		END
	ELSE
	BEGIN
		--*******************************************************
		-- 등록되지 않은 사용자이다.
		--*******************************************************
		BEGIN		
		SELECT 0x01 AS ResultCode
		END
	END
*/

	IF( @@Error <>0 )
		ROLLBACK TRANSACTION
	ELSE
		COMMIT TRANSACTION
	

	SET NOCOUNT OFF
END

GO
/****** Object:  StoredProcedure [dbo].[SP_REQ_USE_PCBANG_COUPON_EVENT]    Script Date: 2018.01.10. 10:57:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--//************************************************************************
--// 내   용 : PC방 쿠폰 이벤트_쿠폰 발급
--// 부   서 : MU_STUDIO 
--// 만들일 : 2006.02.03
--// 만들이 : 김혜화
--// 
--// 리턴값 설명
--// 
--// 	성공코드 :	0x00 : 쿠폰 발급(성공)
--//			0x01 : 실패
--// 
--//************************************************************************


CREATE PROC [dbo].[SP_REQ_USE_PCBANG_COUPON_EVENT]
	@AccountID	varchar( 10 )
AS
BEGIN

	BEGIN TRANSACTION

	SET 		NOCOUNT ON
	SET		XACT_ABORT ON				-- 에러발생시 모든 트랜잭션 취소

	DECLARE 	@Count 		tinyint			-- 쿠폰 카운트
	DECLARE	@RegDate	smalldatetime		-- 쿠폰을 웹에 등록한 날짜
	DECLARE	@GetDate	smalldatetime		-- 쿠폰을 발급한 날짜

	SET		 LOCK_TIMEOUT	1000			-- 트랜잭션 장기 잠금처리를 막기 위해서 	
	
	--*******************************************************
	-- 등록된 계정인지 확인
	--*******************************************************
	IF EXISTS ( SELECT AccountID FROM T_PCBangEvent2006 WHERE AccountID = @AccountID )
	BEGIN
		-- 데이터를 얻는다.
		SELECT @Count = Count, @RegDate = RegDate, @GetDate = GetDate FROM T_PCBangEvent2006 WHERE AccountID = @AccountID


		--*******************************************************
		-- 카운트가 0인가?
		--*******************************************************
		--IF ( @Count = 0 )
		--	BEGIN
		--	SELECT 0x01 AS ResultCode
		--	END		

		--*******************************************************
		-- 쿠폰을 등록한다.
		--*******************************************************	
		--ELSE	
		--	BEGIN		
			UPDATE T_PCBangEvent2006 SET GetDate = GetDate(), Count = 0 WHERE AccountID = @AccountID
			SELECT 0x00 AS ResultCode
		--	END
	END
	ELSE
	BEGIN
		--*******************************************************
		-- 등록되지 않은 사용자이다.
		--*******************************************************
		SELECT 0x01 AS ResultCode
	END

	IF( @@Error <>0 )
		ROLLBACK TRANSACTION
	ELSE
		COMMIT TRANSACTION
	

	SET NOCOUNT OFF
END

GO
/****** Object:  Table [dbo].[T_PCBangEvent2006]    Script Date: 2018.01.10. 10:57:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[T_PCBangEvent2006](
	[AccountID] [varchar](10) NOT NULL,
	[RegDate] [smalldatetime] NULL,
	[GetDate] [smalldatetime] NULL,
	[Count] [tinyint] NOT NULL CONSTRAINT [DF__T_PCBangE__Count__0A9D95DB]  DEFAULT ((1)),
 CONSTRAINT [PK_T_PCBangEvent2006_AccountID] PRIMARY KEY CLUSTERED 
(
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[T_WhiteAngelEvent2006]    Script Date: 2018.01.10. 10:57:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[T_WhiteAngelEvent2006](
	[AccountID] [varchar](10) NOT NULL,
	[RegDate] [smalldatetime] NULL,
	[ItemGetDate] [smalldatetime] NULL,
	[Count] [tinyint] NOT NULL,
 CONSTRAINT [PK_T_WhiteAngelEvent2006_AccountID] PRIMARY KEY CLUSTERED 
(
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[T_WhiteAngelEvent2006] ADD  CONSTRAINT [DF__T_WhiteAn__Count__114A936A]  DEFAULT ((1)) FOR [Count]
GO
ALTER TABLE [dbo].[Blocking] ADD PCPoints INT NULL DEFAULT ((0)); 
GO