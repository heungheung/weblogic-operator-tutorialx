
--Prepare database with LOYALTY schema and table before start of Lab


--Create the user LOYALTY with a valid password using SQLPlus or SQLDeveloper

DROP USER loyalty cascade;

CREATE USER loyalty IDENTIFIED BY "Welcome_123456";
GRANT CREATE SESSION TO loyalty;
GRANT ALL PRIVILEGES TO loyalty;
COMMIT;


--Once you have the LOYALTY user, disconnect DB and reconnect DB as LOYALTY user
--Now create the table PRODUCT and insert sample data

DROP TABLE product;

CREATE TABLE product
(	"ID"            NUMBER NOT NULL ENABLE
   ,  "PRODUCTNAME"   VARCHAR2(255 BYTE)
   ,  "PRODUCTPRICE"  NUMBER
   ,  "PRODUCTIMAGE"  VARCHAR2(255 BYTE)
   ,  "PRODUCTDESC"   VARCHAR2(255 BYTE)
   ,  CONSTRAINT      "PRODUCT_PK" PRIMARY KEY ("ID")
 );

Insert into PRODUCT (ID,PRODUCTNAME,PRODUCTPRICE,PRODUCTIMAGE,PRODUCTDESC) values (20001,'Aroma Beans',21,'20001.jpg','Blend of incomparable Balance of sweetness, aroma and body. Composed of 50% Arabica and 50% Robusta.');
Insert into PRODUCT (ID,PRODUCTNAME,PRODUCTPRICE,PRODUCTIMAGE,PRODUCTDESC) values (20002,'Valentine',20,'20002.jpg','Specialty coffee roasted in small batches by people who care. The specialty part means we only choose to roast top-tier, rigorously-graded, traceable coffees.');
Insert into PRODUCT (ID,PRODUCTNAME,PRODUCTPRICE,PRODUCTIMAGE,PRODUCTDESC) values (20003,'Coffee Break',15,'20003.jpg','Celebrates the rich flavor of espresso. It is a simple drink, yet we prepare it with care. Baristas pour two espresso shots, and then quickly pour hot water over the top to produce a light layer of crema.');
Insert into PRODUCT (ID,PRODUCTNAME,PRODUCTPRICE,PRODUCTIMAGE,PRODUCTDESC) values (20004,'Festival Blend',5,'20004.jpg','Tea x Coffee blend combining high quality Uji tea and tasty coffee beans to appear at food festival Taste of Paris');
COMMIT;


--Then create a read only DB user WLSOPR
--Provide WLSOPR credential to lab participants for the Lab 8

GRANT CREATE SESSION to WLSOPR IDENTIFIED BY "Welcome_123456";
COMMIT;
GRANT READ ON LOYALTY.PRODUCT TO WLSOPR;
COMMIT;
