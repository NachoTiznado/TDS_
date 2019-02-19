install.packages("sf")
install.packages("tmap")
library(dplyr)
library(sf)
u = "https://github.com/ITSLeeds/TDS/releases/download/0.1/desire_lines.geojson"
download.file(u, "desire_lines.geojson")
desire_lines = read_sf("desire_lines.geojson")
# note: you can also read-in the file from the url:
# desire_lines = read_sf(u)

#Plot the lines statically as follows
library(tmap)
tm_shape(desire_lines) + tm_lines()
#Plot the lines showing the number of car drivers as follows:
tm_shape(desire_lines) + tm_lines(col = "car_driver")
#Plot the same lines, but with colour according to the number of people who walked to work in the 2011 Census
tm_shape(desire_lines) + tm_lines(col = "foot")

#Re-do the plot of the number of trips made by driving, but make the line widths proportional to the total number (`all`) trips made (hint: you may need to set the scale with `scale = 5`, or another number greater than 1, for example)
tm_shape(desire_lines) + tm_lines(col = "foot", lwd = "all", scale = 9)

#Filter-out all lines between 1 and 3km and call the resulting object`desire_lines_1_5km` with the following command (or similar):
desire_lines_1_5km = desire_lines %>% filter(e_dist_km > 1 & e_dist_km < 3)

#Plot the results to make sure the operation worked (you should get a result like the on below):
plot(desire_lines_1_5km$geometry)

#Create a new variable called `percent_drive` that contains the percentage of trips driven in each of the lines in the `desire_lines_1_5km` object with the following command:
desire_lines_pcar = desire_lines %>% mutate(percent_drive = car_driver / all * 100)

#Find the top 100 most 'car dependent' short desire lines in West Yorkshire and plot the results. It should look something like this:
car_dep_100 = desire_lines_pcar %>% top_n(n = 100, wt = percent_drive)
tm_shape(car_dep_100) + tm_lines(col = "percent_drive", lwd = "all", scale = 5)

#Plot the results in an interactive map and explore the results. Where are the top 100 most car-dependent major commuting desire lines in West Yorkshire (hint: you may use the `ttm()` function to switch to interactive mode in **tmap**)?
ttm()
tm_shape(car_dep_100) + tm_lines(col = "percent_drive", lwd = "all", scale = 5) + tm_view(basemaps = leaflet::providers$OpenStreetMap.BlackAndWhite)
