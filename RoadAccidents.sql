/******  celá tabulka  ******/
select * 
from RoadAccidents.dbo.RoadAccident

/******  celkové množství obìti 2021-2022  ******/
select SUM(number_of_casualties) TotalNumberCasualties 
from RoadAccident

/******  celkové množství obìti za rok 2021  ******/
select SUM(number_of_casualties) Casualties2021
from RoadAccident
where YEAR(accident_date) = '2021'

/******  celkové množství nehod za rok 2021  ******/
select COUNT(distinct accident_index) Accidents2021
from RoadAccident
where YEAR(accident_date) = '2021'

/******  celkové množství fatálních nehod a jejích obìti, v roce 2021  ******/
select COUNT(accident_severity) FatalAccidents2021, SUM(number_of_casualties) NumberOfCasualties 
from RoadAccident
where YEAR(accident_date) = '2021' and accident_severity = 'Fatal'

/******  celkové množství závažných nehod a poèet zranìných, v roce 2021  ******/
select COUNT(accident_severity) SeriousAccidents2021, SUM(number_of_casualties) NumberOfCasualties  
from RoadAccident
where YEAR(accident_date) = '2021' and accident_severity = 'Serious'

/******  celkové množství nezávažných nehod a poèet zranìných, v roce 2021  ******/
select COUNT(accident_severity) SlightAccidents2021, SUM(number_of_casualties) NumberOfCasualties  
from RoadAccident
where YEAR(accident_date) = '2021' and accident_severity = 'Slight'

/******  % obìti s fatálním dopadem  ******/
select CAST(SUM(number_of_casualties) as decimal(10,2)) * 100 / (select CAST(SUM(number_of_casualties) as decimal(10,2))from RoadAccident) PercentageFatalSeverity
from RoadAccident
where accident_severity = 'Fatal'

/******  % obìti se závažnými zranìní  ******/
select CAST(SUM(number_of_casualties) as decimal(10,2)) * 100 / (select CAST(SUM(number_of_casualties) as decimal(10,2))from RoadAccident) PercentageSeriousSeverity
from RoadAccident
where accident_severity = 'Serious'

/******  % obìti s nezávažnými zranìní  ******/
select CAST(SUM(number_of_casualties) as decimal(10,2)) * 100 / (select CAST(SUM(number_of_casualties) as decimal(10,2))from RoadAccident) PercentageSlightSeverity
from RoadAccident
where accident_severity = 'Slight'

/******  druh dopravního prostøedku  ******/
select distinct(vehicle_type)
from RoadAccident

--vehicle_type
--Agricultural vehicle					-> Agricultural vehicle
--Car									-> Car
--Motorcycle 125cc and under			-> Bike
--Motorcycle 50cc and under				-> Bike
--Bus or coach (17 or more pass seats)	-> Bus
--Minibus (8 - 16 passenger seats)		-> Bus
--Motorcycle over 125cc and up to 500cc	-> Bike
--Goods 7.5 tonnes mgw and over			-> Van
--Taxi/Private hire car					-> Car
--Motorcycle over 500cc					-> Bike
--Van / Goods 3.5 tonnes mgw or under	-> Van
--Goods over 3.5t. and under 7.5t		-> Van
--Other vehicle							-> Other
--Pedal cycle							-> Bike
--Ridden horse							-> Other

/******  poèty nehod podle typu dopravního prostøedku v roce 2021 ******/
select
	case
		when vehicle_type in ('Agricultural vehicle') then 'Agricultural vehicle'
		when vehicle_type in ('Car', 'Taxi/Private hire car') then 'Car'
		when vehicle_type in ('Motorcycle 125cc and under', 'Motorcycle 50cc and under', 'Motorcycle over 125cc and up to 500cc', 'Motorcycle over 500cc', 'Pedal cycle') then 'Bike'
		when vehicle_type in ('Bus or coach (17 or more pass seats)', 'Minibus (8 - 16 passenger seats)') then 'Bus'
		when vehicle_type in ('Goods 7.5 tonnes mgw and over', 'Van / Goods 3.5 tonnes mgw or under', 'Goods over 3.5t. and under 7.5t') then 'Van'
		else 'Other'
	end as VehicleGroup,
COUNT(accident_index) NumberOfAccident
from RoadAccident
where YEAR(accident_date) = '2021'
group by
	case
		when vehicle_type in ('Agricultural vehicle') then 'Agricultural vehicle'
		when vehicle_type in ('Car', 'Taxi/Private hire car') then 'Car'
		when vehicle_type in ('Motorcycle 125cc and under', 'Motorcycle 50cc and under', 'Motorcycle over 125cc and up to 500cc', 'Motorcycle over 500cc', 'Pedal cycle') then 'Bike'
		when vehicle_type in ('Bus or coach (17 or more pass seats)', 'Minibus (8 - 16 passenger seats)') then 'Bus'
		when vehicle_type in ('Goods 7.5 tonnes mgw and over', 'Van / Goods 3.5 tonnes mgw or under', 'Goods over 3.5t. and under 7.5t') then 'Van'
		else 'Other'
	end


/******  poèty nehod dle mìsíce ******/
select DATENAME(MONTH, accident_date) Month_Name, COUNT(accident_index) NumberOfAccident
from RoadAccident
where YEAR(accident_date) = '2021'
group by DATENAME(MONTH, accident_date)


/******  poèty nehod dle druhu komunikace ******/
select distinct(road_type)
from RoadAccident

select road_type, COUNT(accident_index) NumberOfAccident
from RoadAccident
where YEAR(accident_date) = '2021'
group by road_type

/******  poèty obìti dle lokality: mìsto vs. vesnice ******/
select urban_or_rural_area, SUM(number_of_casualties) NumberOfCasualties
from RoadAccident
where YEAR(accident_date) = '2021'
group by urban_or_rural_area

/******  poèty nehod dle lokality: mìsto vs. vesnice a % ******/
select urban_or_rural_area, COUNT(accident_index) TotalNumberOfAccident, CAST(COUNT(accident_index) as decimal(10,2)) * 100 / 
	(select CAST(COUNT(accident_index) as decimal(10,2)) from RoadAccident where YEAR(accident_date) = '2021') PercentageOfAccident
from RoadAccident
where YEAR(accident_date) = '2021'
group by urban_or_rural_area

/******  poèty nehod dle èásti dne ******/
select distinct(light_conditions) from RoadAccident

--Daylight						-> Day
--Darkness - no lighting		-> Night
--Darkness - lights lit			-> Night
--Darkness - lighting unknown	-> Night
--Darkness - lights unlit		-> Night
select
	case
		when light_conditions in ('Darkness - no lighting', 'Darkness - lights lit', 'Darkness - lighting unknown', 'Darkness - lights unlit') then 'Night'
		else 'Day'
	end PartOfTheDay, 
	CAST(COUNT(accident_index) as decimal(10,2)) * 100 / (select CAST(COUNT(accident_index) as decimal(10,2)) from RoadAccident where YEAR(accident_date) = '2021') PercentageOfAccident,
	COUNT(accident_index) TotalNumberOfAccident
from RoadAccident
where YEAR(accident_date) = '2021'
group by 
	case
		when light_conditions in ('Darkness - no lighting', 'Darkness - lights lit', 'Darkness - lighting unknown', 'Darkness - lights unlit') then 'Night'
		else 'Day'
	end













