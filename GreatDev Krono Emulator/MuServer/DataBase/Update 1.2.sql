USE [MuOnline]
GO
/****** Object:  StoredProcedure [dbo].[SP_REG_SERIAL]    Script Date: 2018.01.11. 21:02:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
--//************************************************************************
--// 내   용 : 뮤 상용화 2주년 기념 복권 이벤트 관련 - 시리얼 등록
--// 부   서 : 게임개발팀 
--// 만들일 : 2003.10.20
--// 만들이 : 준일
--// 
--//************************************************************************

CREATE PROCEDURE	[dbo].[SP_REG_SERIAL]
	@AccountID		varchar(10),	-- 계정명
	@MembGUID		int,		-- GUID
	@SERIAL1		varchar(4),	-- 시리얼1
	@SERIAL2		varchar(4),	-- 시리얼2
	@SERIAL3		varchar(4)	-- 시리얼3
As
Begin
	BEGIN TRANSACTION
	
	SET NOCOUNT ON	
/*
	-- 1 . T_RegCount_Check 테이블에서 해당 계정이 이미 등록했는지, 카운트를 넘었는지 체크한다.
	DECLARE @MAX_REGCOUNT	INT
	DECLARE @iREG_COUNT	INT
	DECLARE @iREG_ALREADY	BIT

	SET @MAX_REGCOUNT 	= 20
	SET @iREG_ALREADY		= 0
	
	IF EXISTS ( SELECT * FROM T_RegCount_Check  WITH (READUNCOMMITTED) 
				WHERE AccountID = @AccountID)
	BEGIN	
		-- T_RegCount_Check 에는 이미 계정명이 있을 것이므로 별도의 검증없이 등록여부를 변경한다.
		SELECT @iREG_ALREADY = RegAlready FROM T_RegCount_Check WHERE AccountID = @AccountID
*/
		
/*		IF (@iREG_ALREADY = 1 )
		BEGIN
			SELECT 5 As RegResult, 0 As F_Register_Section
		END
		ELSE
		BEGIN
*/			
/*
			SELECT @iREG_COUNT = RegCount 
			FROM T_RegCount_Check
			WHERE AccountID = @AccountID
		
			IF (@iREG_COUNT >= @MAX_REGCOUNT)
			BEGIN
				SET @iREG_ALREADY = 1

				SELECT 2 As RegResult, 0 As F_Register_Section
			END
			ELSE
			BEGIN
				UPDATE T_RegCount_Check
				SET RegCount = RegCount + 1
				WHERE AccountID = @AccountID
			END
--		END
	END
	ELSE
	BEGIN
		INSERT INTO T_RegCount_Check
		VALUES (@AccountID, default, default)
	END
*/

/*	IF (@iREG_ALREADY =1)
	BEGIN
		IF(@@Error <> 0 )
			ROLLBACK TRANSACTION
		ELSE	
			COMMIT TRANSACTION
		
		SET NOCOUNT OFF	

		RETURN
	END
*/	

	-- 2 . T_Serial_Bank 테이블에 시리얼을 등록한다.
	DECLARE @REG_CHECK	BIT
	
	IF EXISTS ( SELECT F_RegisterCheck FROM T_Serial_Bank  WITH (READUNCOMMITTED) 
		WHERE  P_Serial_1 = @SERIAL1 and P_Serial_2 = @SERIAL2 and P_Serial_3 = @SERIAL3)
	BEGIN	
		SELECT @REG_CHECK = F_RegisterCheck FROM T_Serial_Bank  WITH (READUNCOMMITTED) 
		WHERE  P_Serial_1 = @SERIAL1 and P_Serial_2 = @SERIAL2 and P_Serial_3 = @SERIAL3

		IF (@REG_CHECK = 0)
		BEGIN
			UPDATE T_Serial_Bank
			SET F_Member_Guid = @MembGUID, F_Member_Id = @AccountID, F_RegisterCheck = 1, F_Register_Date = GetDate()
			WHERE  P_Serial_1 = @SERIAL1 and P_Serial_2 = @SERIAL2 and P_Serial_3 = @SERIAL3

			-- T_RegCount_Check 에는 이미 계정명이 있을 것이므로 별도의 검증없이 등록여부를 변경한다.
			--UPDATE T_RegCount_Check
			--SET RegAlready = 1
			--WHERE AccountID = @AccountID
			
			SELECT 0 As RegResult, F_Register_Section
			FROM T_Serial_Bank
			WHERE  P_Serial_1 = @SERIAL1 and P_Serial_2 = @SERIAL2 and P_Serial_3 = @SERIAL3
		END
		ELSE
		BEGIN	-- 이미 등록되었다.
			SELECT 1 As RegResult, 0 As F_Register_Section
		END

	END
	ELSE
	BEGIN	-- 해당 시리얼은 존재하지 않는다.
		SELECT 3 As RegResult, 0  As F_Register_Section
	END

	
	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION
	
	SET NOCOUNT OFF	
End

GO
