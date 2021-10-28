-- Demonstration 2

-- Step 1 - Open a new query window against tempdb

USE tempdb;
GO

-- Step 2 - Create an xml schema collection

CREATE XML SCHEMA COLLECTION dbo.ProductDetailsSchema
AS 
'<xsd:schema targetNamespace="urn:schemas-microsoft-com:sql:SqlRowSet3" xmlns:schema="urn:schemas-microsoft-com:sql:SqlRowSet3" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:sqltypes="http://schemas.microsoft.com/sqlserver/2004/sqltypes" elementFormDefault="qualified">
  <xsd:import namespace="http://schemas.microsoft.com/sqlserver/2004/sqltypes" schemaLocation="http://schemas.microsoft.com/sqlserver/2004/sqltypes/sqltypes.xsd" />
  <xsd:element name="Production.Product">
    <xsd:complexType>
      <xsd:attribute name="ProductID" type="sqltypes:int" use="required" />
      <xsd:attribute name="Name" use="required">
        <xsd:simpleType sqltypes:sqlTypeAlias="[AdventureWorks2008R2].[dbo].[Name]">
          <xsd:restriction base="sqltypes:nvarchar" sqltypes:localeId="1033" sqltypes:sqlCompareOptions="IgnoreCase IgnoreKanaType IgnoreWidth">
            <xsd:maxLength value="50" />
          </xsd:restriction>
        </xsd:simpleType>
      </xsd:attribute>
      <xsd:attribute name="Color">
        <xsd:simpleType>
          <xsd:restriction base="sqltypes:nvarchar" sqltypes:localeId="1033" sqltypes:sqlCompareOptions="IgnoreCase IgnoreKanaType IgnoreWidth">
            <xsd:maxLength value="15" />
          </xsd:restriction>
        </xsd:simpleType>
      </xsd:attribute>
      <xsd:attribute name="Size">
        <xsd:simpleType>
          <xsd:restriction base="sqltypes:nvarchar" sqltypes:localeId="1033" sqltypes:sqlCompareOptions="IgnoreCase IgnoreKanaType IgnoreWidth">
            <xsd:maxLength value="5" />
          </xsd:restriction>
        </xsd:simpleType>
      </xsd:attribute>
      <xsd:attribute name="ListPrice" type="sqltypes:money" use="required" />
    </xsd:complexType>
  </xsd:element>
</xsd:schema>';
GO

-- Step 3 - Create a table with a column that uses that collection

CREATE TABLE dbo.ProductImport
( ProductImportID int IDENTITY(1,1) PRIMARY KEY,
  ProductDetails xml (CONTENT dbo.ProductDetailsSchema)
);
GO

-- Step 4 - Try to insert malformed xml. Note that this will fail.

INSERT INTO dbo.ProductImport 
  (ProductDetails)
  VALUES ('<invalid xml');
GO

-- Step 5 - Try to insert well-formed XML that does not conform to the schema. Note that this will fail.

INSERT INTO dbo.ProductImport 
  (ProductDetails)
  VALUES ('<validxml><node1>hello</node1></validxml>');
GO

-- Step 6 - Try to insert a single row fragment. Note that this will succeed.

INSERT INTO dbo.ProductImport 
  (ProductDetails)
  VALUES ('<Production.Product xmlns="urn:schemas-microsoft-com:sql:SqlRowSet3" ProductID="1" Name="Adjustable Race" ListPrice="0.0000" />');
GO

-- Step 7 - Try to insert a multi-row fragment Note that this will succeed.

INSERT INTO dbo.ProductImport 
  (ProductDetails)
  VALUES ('
<Production.Product xmlns="urn:schemas-microsoft-com:sql:SqlRowSet3" ProductID="1" Name="Adjustable Race" ListPrice="0.0000" />
<Production.Product xmlns="urn:schemas-microsoft-com:sql:SqlRowSet3" ProductID="2" Name="Bearing Ball" ListPrice="0.0000" />
');
GO

-- Step 8 - View the added XML in the table

SELECT ProductDetails FROM dbo.ProductImport;