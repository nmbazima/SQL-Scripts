UPDATE [dbo].[TbliSAMSManagerUsers]
	SET 
		[intFailedLogins]	= 0,
		[txtStatus]			= 'Active'
	WHERE 
		[txtStatus]			= 'LockedOut'
	AND
		DATEDIFF(MINUTE, [txtLastFailedLoginDateTime], GETUTCDATE()) > (SELECT [LockOutPeriod] FROM [auth].[vwSecurityOption])
