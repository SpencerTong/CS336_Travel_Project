USE travelProject;

CREATE TABLE IF NOT EXISTS AirlineCompany(airlineID char(2) primary key);

CREATE TABLE IF NOT EXISTS Airport(airportID char(3) primary key);

CREATE TABLE IF NOT EXISTS Customer(firstName varchar(50), lastName varchar(50), CID varchar(20) primary key);

CREATE TABLE IF NOT EXISTS TicketReserves(ticketNumber integer primary key, seat_number integer, bookingFee double, totalFare double, datePurchased date, timePurchased time, CID varchar(20) not null, cancellationFee integer, FOREIGN KEY(CID) REFERENCES Customer(CID)); 

CREATE TABLE IF NOT EXISTS AssociatedWith(airportID char(3), airlineID char(2), primary key(airportID, airlineID), foreign key (airportID) references Airport(airportID), foreign key (airlineID) references AirlineCompany(airlineID));

CREATE TABLE IF NOT EXISTS Aircraft(aircraftID varchar(20), operates varchar(50), seats integer, airlineID char(2), primary key (aircraftID, airlineID), foreign key (airlineID) references AirlineCompany(airlineID));

CREATE TABLE IF NOT EXISTS FlightAssignedTo(fnumber integer, departure datetime, arrival datetime, fromAirport char(3), toAirport char(3), travelType char(1), airlineID char(2), aircraftID varchar(20) not null, primary key(fnumber, airlineID), foreign key (airlineID) references AirlineCompany(airlineID), foreign key (aircraftID) references Aircraft(aircraftID));

CREATE TABLE IF NOT EXISTS TicketHasFlight(ticketNumber integer, fnumber integer, airlineID char(2), primary key(ticketNumber, fnumber, airlineID), foreign key (ticketNumber) references TicketReserves(ticketNumber) ON DELETE CASCADE, foreign key (fnumber, airlineID) references FlightAssignedTo(fnumber, airlineID));

CREATE TABLE IF NOT EXISTS AssociatedAccount(username varchar(50), password varchar(50), reservationPortfolio varchar(50), CID varchar(20) not null, primary key (username), foreign key (CID) references Customer(CID));

CREATE TABLE IF NOT EXISTS QuestionsAndAnswers(qID int auto_increment primary key, qContent varchar(255), qAnswer varchar(255));


--test data
--
--
--
--INSERT INTO AirlineCompany values ('AB'), ('CD'), ('EF');
--INSERT INTO Airport values ('JFK'), ('NJA');
--INSERT INTO Customer values ('Timmy', 'Chen', 'txc'), ('Spencer', 'Tong', 'sxt'), ('Dany', 'Chucri', 'dxc'), ('Alex', 'Walcsak', 'asw');
--INSERT INTO TicketReserves values (1, 1, 20.0, 40.0, '2023-12-31','12:30:00', 'sxt', 0), (2, 2, 30.0, 50.0, '2020-11-29','10:25:21', 'asw', 20);
--INSERT INTO AssociatedWith values('JFK', 'AB'), ('NJA','CD');
--INSERT INTO Aircraft values ('aircraft1', 'operate1', 10, 'AB'), ('aircraft2', 'operate2', 95, 'AB');
--INSERT INTO FlightAssignedTo values (123, '2024-01-20', '2024-02-01', 'JFK', 'NJA', 'w', 'AB', 'aircraft1'), (456, '2020-02-20', '2020-02-20', 'NJA', 'JFK', 'r', 'CD', 'aircraft2');
--INSERT INTO TicketHasFlight values (1, 123, 'AB'), (2, 456, 'CD');
--INSERT INTO AssociatedAccount values ('timmyMen', 'password1', 'portfolio1', 'txc'), ('danychurro', 'password2', 'portfolio2', 'dxc');
--INSERT INTO QuestionsAndAnswers values (100, 'content', 'answer!');