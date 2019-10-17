WITH PageIndex AS (
					SELECT TOP 2147483647 row_number() over (order by [TblTeachingManagerSubjectDepartmentsSubjectLinksID]) AS RowIndex
					, [TblTeachingManagerSubjectDepartmentsSubjectLinksID]
					, [intDepartment]
					, [intSubject]
					, [intOrder]
					, [txtSubmitBy]
					, [txtSubmitDateTime]
					FROM [dbo].[TblTeachingManagerSubjectDepartmentsSubjectLinks] where  (intSubject IN ('73'))
				)
				SELECT
				       [TblTeachingManagerSubjectDepartmentsSubjectLinksID],
				       [intDepartment],
				       [intSubject],
				       [intOrder],
				       [txtSubmitBy],
				       [txtSubmitDateTime]
				  FROM PageIndex
				 WHERE RowIndex > 0
				   AND RowIndex <= 2147483647
				ORDER BY [TblTeachingManagerSubjectDepartmentsSubjectLinksID];
				

				-- get total count
				
