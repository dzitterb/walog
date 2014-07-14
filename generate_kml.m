function generate_kml(type,lat,lon,name)
%makes a kml file for use in google earth
%input:  name of track, one matrix containing latitude and longitude
%usage:  pwr_kml('track5',latlon)

header=['<kml xmlns="http://earth.google.com/kml/2.0"><Document><name> Polarstern Walog </name>'];

lineheader=['<Placemark><description>"' name '"</description><LineString><tessellate>1</tessellate><coordinates>'];

linefooter=['</coordinates></LineString></Placemark>'];

pointheader=['<Placemark><description>"' name '"</description><Point><coordinates>'];
pointfooter=['</coordinates></Point></Placemark>'];

footer='</Document></kml>';


fid = fopen(['test.kml'], 'wt');
%d=flipud(rot90(fliplr(latlon)));
fprintf(fid, '%s \n',header);
if strcmp(type,'point')
    for k=1:length(lat)
        fprintf(fid, '%s \n',pointheader);
        fprintf(fid, '%.6f, %.6f,0.0\n', lon(k),lat(k));
        fprintf(fid, '%s \n',pointfooter);
    end;
elseif strcmp (type,'line')
    fprintf(fid, '%s \n',lineheader);
    for k=1:length(lat)
        fprintf(fid, '%.6f, %.6f,0.0\n', lon(k),lat(k));
    end
    fprintf(fid, '%s \n',linefooter);
    
end
fprintf(fid, '%s', footer);
fclose(fid);