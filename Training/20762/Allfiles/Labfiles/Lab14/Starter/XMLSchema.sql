USE tempdb;
GO

-- Script 14.10 Create an xml schema collection for resumes
CREATE XML SCHEMA COLLECTION ResumeSchemaCollection
AS
N'<?xml version="1.0" ?>
  <xsd:schema 
     targetNamespace="http://schemas.adventure-works.com/EmployeeResume" 
     xmlns="http://schemas.adventure-works.com/EmployeeResume" 
     elementFormDefault="qualified" 
     attributeFormDefault="unqualified"
     xmlns:xsd="http://www.w3.org/2001/XMLSchema" >
    <xsd:element name="resume">
      <xsd:complexType>
        <xsd:sequence>
          <xsd:element name="name" type="xsd:string" 
                       minOccurs="1" maxOccurs="1"/>
          <xsd:element name="employmentHistory">
            <xsd:complexType>
              <xsd:sequence minOccurs="1" maxOccurs="unbounded">
                <xsd:element name="employer">
                  <xsd:complexType>
                      <xsd:simpleContent>
                        <xsd:extension base="xsd:string">
                          <xsd:attribute name="endDate" 
                                         use="optional"/>
                        </xsd:extension>
                      </xsd:simpleContent>
                  </xsd:complexType>
                </xsd:element>
              </xsd:sequence>
            </xsd:complexType>
          </xsd:element>
        </xsd:sequence>
      </xsd:complexType>
    </xsd:element>
  </xsd:schema>';
GO

-- Script 14.11 Retrieve information about the components in the schema collection
--              Note that schemas are stored as components, not as the original
--              schema text
SELECT cp.* 
FROM sys.xml_schema_components AS cp
JOIN sys.xml_schema_collections AS c
ON cp.xml_collection_id = c.xml_collection_id
WHERE c.name = 'ResumeSchemaCollection';
GO

