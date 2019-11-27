SELECT [x.Sessions].[Id], [x.Sessions].[Action], [x.Sessions].[AuthenticatingClientId], [x.Sessions].[IpAddress], [x.Sessions].[Key], [x.Sessions].[LastContactDateTime], [x.Sessions].[LoginDateTime], [x.Sessions].[SessionId], [x.Sessions].[UserStatusId], [x.Sessions].[Usercode]
FROM [auth].[vwSessionActive] AS [x.Sessions]
INNER JOIN (
    SELECT DISTINCT [t].*
    FROM (
        SELECT TOP(1) [x0].[txtUserCode]
        FROM [auth].[vwUser] AS [x0]
        LEFT JOIN [auth].[vwIdentityProvider] AS [x.IdentityProvider0] ON [x0].[intIdentityProviderId] = [x.IdentityProvider0].[TblIdentityProviderId]
        WHERE LOWER([x0].[txtUserCode]) = @__ToLower_0
        ORDER BY [x0].[txtUserCode]
    ) AS [t]
) AS [t0] ON [x.Sessions].[Usercode] = [t0].[txtUserCode]
ORDER BY [t0].[txtUserCode]
