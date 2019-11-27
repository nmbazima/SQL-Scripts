INSERT INTO [dbo].[TblPupilManagementCommsHistoryEmail]
					(
					[txtSchoolID]
					,[intBatch]
					,[txtSubject]
					,[txtBody]
					,[txtAttachmentDir]
					,[txtAttachments]
					,[txtAttachmentDir2]
					,[txtAttachments2]
					,[txtFileSize]
					)
				VALUES
					(
					@TxtSchoolId
					,@IntBatch
					,@TxtSubject
					,@TxtBody
					,@TxtAttachmentDir
					,@TxtAttachments
					,@TxtAttachmentDir2
					,@TxtAttachments2
					,@TxtFileSize
					)
				
				-- Get the identity value
				
