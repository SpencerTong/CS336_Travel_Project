USE travelProject;
DROP TABLE IF EXISTS AssociatedWith;
DROP TABLE IF EXISTS TicketHasFlight;
DROP TABLE IF EXISTS FlightAssignedTo;
DROP TABLE IF EXISTS Aircraft;
DROP TABLE IF EXISTS TicketReserves;
DROP TABLE IF EXISTS AssociatedAccount;
DROP TABLE IF EXISTS QuestionsAndAnswers;
DROP TABLE IF EXISTS AirlineCompany;
DROP TABLE IF EXISTS Airport;
DROP TABLE IF EXISTS Customer;

CREATE TABLE IF NOT EXISTS AirlineCompany(airlineID char(2) primary key);

CREATE TABLE IF NOT EXISTS Airport(airportID char(3) primary key);

CREATE TABLE IF NOT EXISTS Customer(firstName varchar(50), lastName varchar(50), CID varchar(20) primary key, notifications varchar(255));

CREATE TABLE IF NOT EXISTS TicketReserves(ticketNumber integer primary key AUTO_INCREMENT, seat_number integer, bookingFee float, totalFare float, dateAndTimePurchased dateTime, CID varchar(20) not null, cancellationFee integer, FOREIGN KEY(CID) REFERENCES Customer(CID)); 

CREATE TABLE IF NOT EXISTS AssociatedWith(airportID char(3), airlineID char(2), primary key(airportID, airlineID), foreign key (airportID) references Airport(airportID) ON UPDATE CASCADE ON DELETE CASCADE, foreign key (airlineID) references AirlineCompany(airlineID) ON UPDATE CASCADE ON DELETE CASCADE);

CREATE TABLE IF NOT EXISTS Aircraft(aircraftID varchar(20), operates varchar(50), seats integer, airlineID char(2), primary key (aircraftID, airlineID), foreign key (airlineID) references AirlineCompany(airlineID) ON UPDATE CASCADE ON DELETE CASCADE);

CREATE TABLE IF NOT EXISTS FlightAssignedTo(fnumber integer, departure datetime, arrival datetime, returnDeparture datetime, returnArrival datetime, fromAirport char(3), toAirport char(3), numStops integer, travelType char(1), basicPrice float, premiumPrice float, bookingFee float, airlineID char(2), aircraftID varchar(20) not null, waitlist varchar(255), primary key(fnumber, airlineID), foreign key (airlineID) references AirlineCompany(airlineID) ON UPDATE CASCADE ON DELETE CASCADE, foreign key (aircraftID) references Aircraft(aircraftID) ON UPDATE CASCADE ON DELETE CASCADE);

CREATE TABLE IF NOT EXISTS TicketHasFlight(ticketNumber integer, fnumber integer, airlineID char(2), primary key(ticketNumber, fnumber, airlineID), foreign key (ticketNumber) references TicketReserves(ticketNumber) ON DELETE CASCADE, foreign key (fnumber, airlineID) references FlightAssignedTo(fnumber, airlineID) ON UPDATE CASCADE ON DELETE CASCADE);

CREATE TABLE IF NOT EXISTS AssociatedAccount(username varchar(50), password varchar(50), reservationPortfolio varchar(50), CID varchar(20) not null, primary key (username), foreign key (CID) references Customer(CID));

CREATE TABLE IF NOT EXISTS QuestionsAndAnswers(qID int auto_increment primary key, qContent varchar(255), qAnswer varchar(255));

INSERT INTO AirlineCompany values ('AB'), ('CD'), ('EF'), ('GH'), ('IJ'), ('KL');
INSERT INTO Airport values ('JFK'), ('NJA'), ('EWR'), ('SYD'), ('PEK'), ('HNL');
INSERT INTO Customer values ('Timmy', 'Chen', 'txc', ''), ('Spencer', 'Tong', 'sxt', ''), ('Dany', 'Chucri', 'dxc', ''), ('Alex', 'Walcsak', 'asw', '');
-- INSERT INTO TicketReserves values (3, 2, 33.0, 70.0, '2025-03-04 10:25:21', 'sxt', 20) , (1, 1, 20.0, 40.0, '2023-12-31 12:30:00', 'sxt', 0), (2, 2, 30.0, 50.0, '2020-11-29 10:25:21', 'asw', 20);
INSERT INTO AssociatedWith values('JFK', 'AB'), ('NJA','CD'), ('EWR', 'EF'), ('SYD', 'GH'), ('PEK', 'IJ'), ('HNL', 'KL');
INSERT INTO Aircraft values ('aircraft1', 'MTWRFSU', 2, 'AB'), ('aircraft2', 'MTWRFSU', 95, 'AB'), ('aircraft3', 'MTWRFSU', 50, 'EF'), ('aircraft4', 'MTWRFSU', 20, 'GH'), ('aircraft5', 'MTWRFSU', 500, 'IJ');
INSERT INTO FlightAssignedTo values (123, '2024-01-20', '2024-02-01', null, null, 'JFK', 'NJA', 0, 'o', 50.00, 75.00, 20.00, 'AB', 'aircraft1', ''), 
(456, '2020-02-20', '2020-02-20', '2020-02-25', '2020-02-25','NJA', 'JFK', 1, 'r', 25.00, 60.00, 30.00, 'CD', 'aircraft2',''), 
(100, '2023-12-10 00:00:00', '2023-12-11 02:30:00', '2023-12-20 13:00:00', '2023-12-20 23:30:00', 'EWR', 'SYD', '3', 'r', 500.00, 778.36, 35.00, 'EF', 'aircraft3', ''),
(101, '2024-06-05 20:00:00', '2024-06-06 05:30:00', null, null, 'EWR', 'SYD', '2', 'o', 399.00, 600.36, 35.00, 'EF', 'aircraft4', ''),
(102, '2024-02-01 02:00:00', '2023-02-01 07:23:00', '2023-02-05 19:30:00', '2024-02-05 23:30:00', 'HNL', 'PEK', '0', 'r', 1300.23, 1900.78, 35.00, 'IJ', 'aircraft5', ''),
(103, '2025-08-10 10:00:00', '2025-08-10 15:30:00', '2025-08-20 14:00:00', '2025-08-20 20:30:00', 'JFK', 'HNL', '1', 'r', 200.00, 300.36, 35.00, 'GH', 'aircraft4', '');

-- INSERT INTO TicketHasFlight values (1, 123, 'AB'), (2, 456, 'CD');
INSERT INTO AssociatedAccount values ('timmyMen', 'password1', 'portfolio1', 'txc'), ('danychurro', 'password2', 'portfolio2', 'dxc');
INSERT INTO QuestionsAndAnswers values (100, 'content', 'answer!'), (105, 'Can I cancel flights for free?', 'It depends on your ticket type.!');
