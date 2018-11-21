/*CREATE DATABASE nyxdb;*/
CREATE SEQUENCE SQ_ACCOUNTS_PK INCREMENT BY 1 START WITH 1;
CREATE TABLE accounts(
	id INTEGER PRIMARY KEY DEFAULT NEXTVAL('SQ_ACCOUNTS_PK'),
	email VARCHAR(50) UNIQUE NOT NULL,
	hash VARCHAR(64) NOT NULL,
	salt VARCHAR(64) NOT NULL,
	accesslevel INTEGER NOT NULL DEFAULT 3, /*0-root,1-maintence,2-nightclub owner,3-normal*/
	firstname VARCHAR(20) NOT NULL,
	lastname VARCHAR(50) NOT NULL,
	cpf VARCHAR(11),
	active VARCHAR(6) NOT NULL,
  	timeregistered BIGINT NOT NULL,
  	logintoken VARCHAR(64) DEFAULT 'null'
);
ALTER TABLE accounts ADD CONSTRAINT CK_levels CHECK (accesslevel>=0 AND accesslevel<=3);

CREATE SEQUENCE SQ_RENEWPASS_PK INCREMENT BY 1 START WITH 1;
CREATE TABLE renewpass(
	id INTEGER PRIMARY KEY DEFAULT NEXTVAL('SQ_RENEWPASS_PK'),
	id_accounts INTEGER NOT NULL,
	requesterip VARCHAR(20) NOT NULL,
	modifierip VARCHAR(20),
	token VARCHAR(10) NOT NULL,
	active BOOLEAN NOT NULL DEFAULT true,
	stamp BIGINT NOT NULL
);
ALTER TABLE renewpass ADD CONSTRAINT FK_renewpass_accounts FOREIGN KEY(id_accounts) REFERENCES accounts(id) ON DELETE CASCADE ON UPDATE CASCADE;

CREATE SEQUENCE SQ_NIGHTCLUBS_PK INCREMENT BY 1 START WITH 1;
CREATE TABLE nightclubs(
	id INTEGER PRIMARY KEY DEFAULT NEXTVAL('SQ_NIGHTCLUBS_PK'),
	name VARCHAR(75) NOT NULL,
	cnpj VARCHAR(14) NOT NULL,
	phone VARCHAR(15) NOT NULL,
	email VARCHAR(50) NOT NULL,
	id_address INTEGER NOT NULL
);

CREATE SEQUENCE SQ_ADDRESSES_PK INCREMENT BY 1 START WITH 1;
CREATE TABLE addresses(
	id INTEGER PRIMARY KEY DEFAULT NEXTVAL('SQ_ADDRESSES_PK'),
	zipcode INT NOT NULL, 
	street VARCHAR(61) NOT NULL, 
	number INT NOT NULL, 
	xtrainfo VARCHAR(30), 
	district VARCHAR(30) NOT NULL,
	city VARCHAR(30) NOT NULL,
	state VARCHAR(30) NOT NULL,
	country VARCHAR(30) NOT NULL
);
ALTER TABLE nightclubs ADD CONSTRAINT FK_nightclubs_addresses FOREIGN KEY(id_address) REFERENCES addresses(id) ON DELETE CASCADE ON UPDATE CASCADE;

CREATE SEQUENCE SQ_MUSICGENRES_PK INCREMENT BY 1 START WITH 1;
CREATE TABLE musicgenres(
	id INTEGER PRIMARY KEY DEFAULT NEXTVAL('SQ_MUSICGENRES_PK'),
	name VARCHAR(20) NOT NULL
);

CREATE SEQUENCE SQ_EVENTS_PK INCREMENT BY 1 START WITH 1;
CREATE TABLE events(
	id INTEGER PRIMARY KEY DEFAULT NEXTVAL('SQ_EVENTS_PK'),
	name VARCHAR(20) NOT NULL,
	ticketprice NUMERIC(6,2) NOT NULL,
	minimumage SMALLINT NOT NULL,
	startdate BIGINT NOT NULL,
	enddate BIGINT NOT NULL
);

CREATE TABLE eventmusicgenres(
	id_event INTEGER,
	id_genre INTEGER,
	PRIMARY KEY(id_event,id_genre)
);
ALTER TABLE eventmusicgenres ADD CONSTRAINT FK_eventmusicgenres_event FOREIGN KEY(id_event) REFERENCES events(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE eventmusicgenres ADD CONSTRAINT FK_eventmusicgenres_genre FOREIGN KEY(id_genre) REFERENCES musicgenres(id) ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE nightclubevents(
	id_nightclub INTEGER,
	id_event INTEGER,
	PRIMARY KEY(id_nightclub,id_event)
);
ALTER TABLE nightclubevents ADD CONSTRAINT FK_nightclubevents_nightclub FOREIGN KEY(id_nightclub) REFERENCES nightclubs(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE nightclubevents ADD CONSTRAINT FK_nightclubevents_event FOREIGN KEY(id_event) REFERENCES events(id) ON DELETE CASCADE ON UPDATE CASCADE;