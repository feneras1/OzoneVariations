% Change the current folder to the folder of this .m file.
if(~isdeployed)
  cd(fileparts(which(mfilename)));
end

%List of avaiable csv files in the directory of the .m file
Path = ".\";
AvailableFiles = dir((fullfile(Path, "*.csv")));
%disp(AvailableFiles);

%menu system 
%Chosing between the normal or the colorblind colormaps
menu1 = menu("Select an option:","Normal","Colorblind");

%menu of the Normal view colormaps
%once selected set the colormap
if menu1 == 1
    menu_normal = menu("Select the map:","HSV","Cool","Spring",...
                   "Summer","Pink");
    if menu_normal == 1
        colormap("HSV")
        cmap = colormap;
    elseif menu_normal == 2
        colormap("Cool")
        cmap = colormap;
    elseif menu_normal == 3
        colormap("Spring")
        cmap = colormap;
    elseif menu_normal == 4
        colormap("Summer")
        cmap = colormap;
    elseif menu_normal == 5
        colormap("Pink")
        cmap = colormap;
    end
end
%menu of the Colorblind view colormaps
%once selected set the colormap
if menu1 == 2
    menu_colorblind = menu("Select the map:","Parula","Jet","Hot","Autumn",...
                       "Winter");
    if menu_colorblind == 1
        colormap("Parula")
        cmap = colormap;
    elseif menu_colorblind == 2
        colormap("Jet")
        cmap = colormap;
    elseif menu_colorblind == 3
        colormap("Hot")
        cmap = colormap;
    elseif menu_colorblind == 4
        colormap("Autumn")
        cmap = colormap;
    elseif menu_colorblind == 5
        colormap("Winter")
        cmap = colormap;
    end
end
%opening the first fig so i can load the Latitude and Longitude values
OpenFileName = "24HR_CBE_01.fig";
fig = openfig(OpenFileName);
Longitude = double(fig.Children.Children.XData);
Latitude = double(fig.Children.Children.YData);
close(fig)

for idx = 1: size(AvailableFiles,1)
    
    
    % Set Ozone value
    Ozone =  csvread(AvailableFiles(idx).name);
    worldmap('Europe'); % set the part of the earth to show
    

    % Import and plot the coastlines
    load coastlines
    plotm(coastlat,coastlon)
    
    % Assign LON, LAT & Ozone to map
    surfm(Latitude , Longitude, Ozone)
    
    %plot only the outline of Europian land
    %so that we can still see the data
    land_area = shaperead('landareas', 'UseGeoCoords', true);
    geoshow(gca, land_area, 'FaceColor', "none",'LineWidth',1)
    
    %get the frame
    f = getframe(gcf);
    %play the animation of the ozone variations for all figures
    animate(:,:,1,idx) = rgb2ind(f.cdata, cmap, 'nodither');
    

end
% Creates the gif
gif = "Ozone.gif";
imwrite(animate, cmap, gif, 'DelayTime', 0.3, 'LoopCount', inf);
% Output the gif
web(gif)
    