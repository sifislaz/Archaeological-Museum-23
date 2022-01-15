CREATE TABLE "EXHIBIT" (
	"id" integer NOT NULL,
	"name" varchar(50) NOT NULL,
	"found_place" varchar(25) DEFAULT NULL,
	"found_date" date DEFAULT NULL,
	"time_period" varchar(30) DEFAULT NULL,
	"material" varchar(50) NOT NULL,
	"artist" varchar(50) DEFAULT NULL,
	PRIMARY KEY ("id" AUTOINCREMENT)
);

CREATE TABLE "TEMPORARY" (
	"id" integer NOT NULL,
	"receive_date" date NOT NULL,
	"return_date" date NOT NULL,
	PRIMARY KEY ("id" AUTOINCREMENT),
	FOREIGN KEY(id) REFERENCES EXHIBIT(id) ON DELETE CASCADE,
	CONSTRAINT RET_DATE CHECK(return_date > receive_date)
);

CREATE TABLE "PERMANENT" (
    "id" integer NOT NULL,
    "receive_date" date NOT NULL,
    PRIMARY KEY ("id" AUTOINCREMENT),
    FOREIGN KEY (id) REFERENCES EXHIBIT(id) ON UPDATE CASCADE
);

CREATE TABLE "EX_POSITION" (
    "wing" varchar(20) NOT NULL,
    "aisle" varchar(1) NOT NULL,
    "aisle_num" integer NOT NULL,
    "ex_id" integer NOT NULL,
    PRIMARY KEY ("wing", "aisle", "aisle_num"),
    FOREIGN KEY ("ex_id") REFERENCES EXHIBIT("id") ON DELETE SET NULL,
	CONSTRAINT WING CHECK(wing IN ("Μελίνα Μερκούρη", "Μανόλης Ανδρόνικος", "Ερρίκος Σλήμαν")),
	CONSTRAINT AISLE CHECK(aisle BETWEEN "A" AND "C"),
	CONSTRAINT A_NUM CHECK(aisle_num BETWEEN 1 AND 3)
);

CREATE TABLE "EXHIBITION" (
	"id" integer NOT NULL,
	"name" varchar(50) NOT NULL,
	"begin_date" date NOT NULL,
	"end_date" date NOT NULL,
	PRIMARY KEY ("id" AUTOINCREMENT)
);

CREATE TABLE "VISITOR" (
	"id" integer NOT NULL,
	"fname" varchar(15) NOT NULL,
	"lname" varchar(15) NOT NULL,
	"email" varchar(25) DEFAULT NULL,
	"telephone" varchar(15) DEFAULT NULL,
	"group_member" binary NOT NULL,
	PRIMARY KEY ("id" AUTOINCREMENT)
);

CREATE TABLE "DISCOUNT" (
	"discount_code" integer NOT NULL,
	"percentage" integer NOT NULL,
	"type" varchar(25) NOT NULL,
	PRIMARY KEY ("discount_code"),
	CONSTRAINT DISC_TYPE CHECK(type IN ('STUDENT', 'UNEMPLOYED', 'LARGE FAMILIES', 'UNDERAGED', 'DISABLED')),
	CONSTRAINT DISC_PER
	CHECK
	(
	(type = 'STUDENT' AND percentage == 50)OR
	(type = 'UNEMPLOYED' AND percentage == 25)OR
	(type = 'LARGE FAMILIES' AND percentage == 25)OR
	(type = 'UNDERAGED' AND percentage == 50)OR
	(type = 'DISABLED' AND percentage == 100)
	)
	CONSTRAINT DISC_CODE
	CHECK
	(
	(type = 'STUDENT' AND discount_code == 0)OR
	(type = 'UNEMPLOYED' AND discount_code == 1)OR
	(type = 'LARGE FAMILIES' AND discount_code == 2)OR
	(type = 'UNDERAGED' AND discount_code == 3)OR
	(type = 'DISABLED' AND discount_code == 4)
	)
);

CREATE TABLE "TICKET" (
	"ticket_num" integer NOT NULL,
	"price" float NOT NULL,
	"type" varchar(25) NOT NULL,
	"exp_date" date NOT NULL,
	PRIMARY KEY ("ticket_num" AUTOINCREMENT)
);

CREATE TABLE "VISITS" (
    "visitor_id" integer NOT NULL,
    "ex_id" integer NOT NULL,
    "visit_date" date NOT NULL,
    PRIMARY KEY ("visitor_id", "ex_id", "visit_date"),
    FOREIGN KEY ("visitor_id") REFERENCES VISITOR("id") ON UPDATE CASCADE,
    FOREIGN KEY ("ex_id") REFERENCES EXHIBITION("id") ON DELETE CASCADE
);

CREATE TABLE "CONTAINS" (
    "exhibit_id" integer NOT NULL,
    "exhibition_id" integer NOT NULL,
    PRIMARY KEY ("exhibit_id" , "exhibition_id"),
    FOREIGN KEY ("exhibit_id") REFERENCES EXHIBIT("id") ON DELETE CASCADE,
    FOREIGN KEY ("exhibition_id") REFERENCES EXHIBITION("id") ON DELETE CASCADE
);

CREATE TABLE "LOANS" (
	"exhibit_id" integer NOT NULL,
	"donor_id" integer NOT NULL,
	"agreement_date" date NOT NULL,
	PRIMARY KEY ("exhibit_id" , "donor_id"),
	FOREIGN KEY(exhibit_id) REFERENCES EXHIBIT(id) ON DELETE CASCADE,
	FOREIGN KEY(donor_id) REFERENCES DONOR(id) ON DELETE CASCADE,
	CONSTRAINT DON_DATE CHECK(julianday(agreement_date) >= julianday(2005-05-21))
);

CREATE TABLE "DESERVES" (
    "visitor_id" integer NOT NULL,
    "discount_code" integer DEFAULT 0 NOT NULL,
    "discount_document" varchar(25) NOT NULL,
    PRIMARY KEY ("visitor_id" , "discount_code"),
    FOREIGN KEY ("visitor_id") REFERENCES VISITOR("id") ON DELETE CASCADE,
    FOREIGN KEY ("discount_code") REFERENCES DISCOUNT("discount_code") ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT DOC_STD
	CHECK
	(
	(discount_code == 0 AND discount_document == "Academic ID")OR
	(discount_code == 1 AND discount_document == "Unemployment Pass")OR
	(discount_code == 2 AND discount_document == "Large Families Pass")OR
	(discount_code == 3 AND discount_document == "ID")OR
	(discount_code == 4 AND discount_document == "Disability Certificate")
	)
);

CREATE TABLE "APPLIES" (
    "ticket_num" integer NOT NULL,
    "disc_code" integer DEFAULT 0 NOT NULL,
    PRIMARY KEY ("ticket_num" , "disc_code"),
    FOREIGN KEY ("ticket_num") REFERENCES TICKET("ticket_num") ON DELETE CASCADE,
    FOREIGN KEY ("disc_code") REFERENCES DISCOUNT("discount_code") ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE "BUYS" (
    "ticket_num" integer NOT NULL,
    "visitor_id" integer NOT NULL,
    "buy_date" date NOT NULL,
    PRIMARY KEY ("ticket_num" , "visitor_id"),
    FOREIGN KEY ("ticket_num") REFERENCES TICKET("ticket_num") ON DELETE CASCADE,
    FOREIGN KEY ("visitor_id") REFERENCES VISITOR("id") ON DELETE CASCADE,
	CONSTRAINT PUR_DATE CHECK(datetime('2005-05-21')<=buy_date)
);

CREATE TABLE "OUTSIDE_ORG" (
	"id" integer NOT NULL,
	"name" varchar(25) NOT NULL,
	"email" varchar(25) DEFAULT NULL,
	"address" varchar(35) NOT NULL,
	"phone" varchar(15) DEFAULT NULL,
	"country" varchar(10) NOT NULL,
	PRIMARY KEY ("id" AUTOINCREMENT)
);

CREATE TABLE "BORROWS" (
	"org_id" integer NOT NULL,
	"exhibit_id" integer NOT NULL,
	"borrow_date" date NOT NULL,
	"return_date" date NOT NULL,
	PRIMARY KEY ("org_id" , "exhibit_id"),
	FOREIGN KEY(org_id) REFERENCES OUTSIDE_ORG(id) ON DELETE CASCADE,
	FOREIGN KEY(exhibit_id) REFERENCES EXHIBIT(id) ON DELETE CASCADE,
	CONSTRAINT BR_DATE CHECK(julianday(return_date) - julianday(borrow_date) > 0)
);


