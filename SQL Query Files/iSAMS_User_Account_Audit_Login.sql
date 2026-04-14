SELECT
                  MAX([audit].[txtDateTime]) AS LastLoginDateTime,
                  [identityProviderType].[txtName] AS IdentityProviderType,
                  [identityProvider].[txtName] AS IdentityProviderName,
                  [identityProvider].[txtConfiguration] AS IdentityProviderConfiguration,
                  (SELECT
                    COUNT(*)
                  FROM [dbo].[TbliSAMSManagerUsers]
                  WHERE [dbo].[TbliSAMSManagerUsers].[intIdentityProviderId] = [identityProvider].[TblIdentityProviderId])
                  AS NumberOfUsers
                FROM TblAuditLogin [audit]
                INNER JOIN [dbo].[TbliSAMSManagerUsers] users
                  ON [audit].[txtUserCode] = [users].[txtUserCode]
                LEFT JOIN [dbo].[TblIdentityProvider] identityProvider
                  ON [users].[intIdentityProviderId] = [identityProvider].[TblIdentityProviderId]
                LEFT JOIN [dbo].[TblIdentityProviderType] identityProviderType
                  ON [identityProvider].[intIdentityProviderTypeId] = [identityProviderType].[TblIdentityProviderTypeId]
                WHERE [audit].[txtDateTime] IS NOT NULL
                  AND [audit].[txtDateTime] > GETDATE() - 60
                GROUP BY [identityProvider].[txtName],
		                 [identityProviderType].[txtName],
                         [identityProvider].[txtConfiguration],
                         [identityProvider].[TblIdentityProviderId];
