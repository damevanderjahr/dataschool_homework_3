--use previously created login
IF OBJECT_ID('zharynin_schema.fact_tripdata', 'U') IS NOT NULL
DROP TABLE zharynin_schema.fact_tripdata
GO
CREATE TABLE zharynin_schema.fact_tripdata
WITH (  CLUSTERED COLUMNSTORE INDEX
     ,  DISTRIBUTION =  HASH([tpep_pickup_datetime])
    )
AS
SELECT  *
FROM    zharynin_schema.table_ext_zharynin



IF OBJECT_ID('zharynin_schema.Vendor', 'U') IS NOT NULL
DROP TABLE zharynin_schema.Vendor
GO

CREATE TABLE zharynin_schema.Vendor
WITH
(
  CLUSTERED COLUMNSTORE INDEX,
  DISTRIBUTION = REPLICATE
)
AS
SELECT DISTINCT VendorID AS ID
FROM    zharynin_schema.fact_tripdata
WHERE VendorID IS NOT NULL

ALTER TABLE zharynin_schema.Vendor
ADD Name varchar(255) NULL

UPDATE zharynin_schema.Vendor
   SET Name = CASE ID
                      WHEN 1 THEN 'Creative Mobile Technologies, LLC'
                      WHEN 2 THEN 'VeriFone Inc.'
                      END

INSERT INTO zharynin_schema.Vendor (
  ID,
  Name
)
SELECT  1,  'Creative Mobile Technologies, LLC' UNION ALL
SELECT  2,  'VeriFone Inc.'
EXCEPT (SELECT * FROM zharynin_schema.Vendor)



IF OBJECT_ID('zharynin_schema.RateCode', 'U') IS NOT NULL
DROP TABLE zharynin_schema.RateCode
GO
CREATE TABLE zharynin_schema.RateCode
WITH
(
  CLUSTERED COLUMNSTORE INDEX,
  DISTRIBUTION = REPLICATE
)
AS
SELECT DISTINCT RatecodeID AS ID
FROM    zharynin_schema.fact_tripdata
WHERE RatecodeID IS NOT NULL

ALTER TABLE zharynin_schema.RateCode
ADD Name varchar(255) NULL

UPDATE zharynin_schema.RateCode
   SET Name = CASE ID
                      WHEN 1 THEN 'Standard rate'
                      WHEN 2 THEN 'JFK'
                      WHEN 3 THEN 'Newark'
                      WHEN 4 THEN 'Nassau or Westchester'
                      WHEN 5 THEN 'Negotiated fare'
                      WHEN 6 THEN 'Group ride'
                      END

INSERT INTO zharynin_schema.RateCode (
  ID,
  Name
)
SELECT  1,  'Standard rate' UNION ALL
SELECT  2,  'JFK' UNION ALL
SELECT  3,  'Newark' UNION ALL
SELECT  4,  'Nassau or Westchester' UNION ALL
SELECT  5,  'Negotiated fare' UNION ALL
SELECT  6,  'Group ride'
EXCEPT (SELECT * FROM zharynin_schema.RateCode)



IF OBJECT_ID('zharynin_schema.Payment_type', 'U') IS NOT NULL
DROP TABLE zharynin_schema.Payment_type
GO

CREATE TABLE zharynin_schema.Payment_type
WITH
(
  CLUSTERED COLUMNSTORE INDEX,
  DISTRIBUTION = REPLICATE
)
AS
SELECT DISTINCT payment_type AS ID
FROM    zharynin_schema.fact_tripdata
WHERE payment_type IS NOT NULL

ALTER TABLE zharynin_schema.Payment_type ADD UNIQUE (ID) NOT ENFORCED

ALTER TABLE zharynin_schema.Payment_type
ADD Name varchar(255) NULL

UPDATE zharynin_schema.Payment_type
   SET Name = CASE ID
                      WHEN 1 THEN 'Credit card'
                      WHEN 2 THEN 'Cash'
                      WHEN 3 THEN 'No charge'
                      WHEN 4 THEN 'Dispute'
                      WHEN 5 THEN 'Unknown'
                      WHEN 6 THEN 'Voided trip'
                      END

INSERT INTO zharynin_schema.Payment_type (
                        ID,
                        Name
                      )
                      SELECT  1,  'Credit card' UNION ALL
                      SELECT  2,  'Cash' UNION ALL
                      SELECT  3,  'No charge' UNION ALL
                      SELECT  4,  'Dispute' UNION ALL
                      SELECT  5,  'Unknown' UNION ALL
                      SELECT  6,  'Voided trip'
EXCEPT (SELECT * FROM zharynin_schema.Payment_type)
