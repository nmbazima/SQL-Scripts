UPDATE [dbo].[TbliSAMSManagerUsers]
	SET 
		[intFailedLogins]				= @failedLoginCount,
        [txtLastFailedLoginDateTime]	= @lastFailedLoginDateTime,
		[intFailedLoginsDisabled]		= @failedLoginToDisabledCount,
		[txtLastDisabledLoginDate]		= @lastFailedLoginDisabledDateTime,
		[txtStatus]						= @status,
		[txtLoginDateTime]				= @lastLoginDateTime
	WHERE 
		[txtUsercode] = @usercode
