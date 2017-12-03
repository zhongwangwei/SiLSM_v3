function[Angle,Angle2]= Solar_zenith_angle(Year, Month, Day, Hour,Minute)
%    time.year: year. Valid for [-2000, 6000]
%       time.month: month [1-12]
%       time.day: calendar day [1-31]
%       time.hour: local hour [0-23]
%       time.min: minute [0-59]
%       time.sec: second [0-59]
%       time.UTC: offset hour from UTC. Local time = Greenwich time + time.UTC
%   This input can also be passed using the Matlab time format ('dd-mmm-yyyy HH:MM:SS'). 
%   In that case, the time has to be specified as UTC time (time.UTC = 0)
%
%   location: a structure that specify the location of the observer
%       location.latitude: latitude (in degrees, north of equator is
%       positive)
%       location.longitude: longitude (in degrees, positive for east of
%       Greenwich)
%       location.altitude: altitude above mean sea level (in meters) 
%

    Angle=ones(length(Year),1);

    Angle2=ones(length(Year),1);

for i=1:length(Year)
		location.longitude = 140.03; 
		location.latitude = 36.05; 
		location.altitude = 13;
		

		
		
[Angle(i),Angle2(i)] = sun_position(Year(i),Month(i),Day(i),Hour(i),Minute(i), location);

end
end


