##to install the latest versions of cranvas and tourr, uncomment and run the following 2 lines, may take a minute.##
#c(install.packages("devtools"),library(devtools),pkgs <- list(ggobi = c("objectSignals", "objectProperties", 
#"objectWidgets", "cranvas", "tourr")), for (repo in names(pkgs)) {for (pkg in pkgs[[repo]]) install_github(pkg, repo)})

##  for a list of functions in qtour go to the below website.  ##
#   https://github.com/ggobi/cranvas/blob/master/R/qtour.R


library(cranvas)
library(tourr)
library(objectWidgets)
library(objectProperties)

vaxis.slide = setNumericWithRange("Numeric", min=0, max=10)
haxis.slide = setNumericWithRange("Numeric", min=0, max=10)
speed.slide = setNumericWithRange("Numeric", min=.05, max=3)
pause.binary = setMultipleEnum("running", levels = c("running"))

gpar.method = setRefClass("GraphicPars",
    fields = properties(list(pause = pause.binary@className,    ##sets properties to the property set, a global listener.##
                             speed = speed.slide@className),
        prototype = list(pause = new(pause.binary@className, "running"),  ##Initializes the property set.##
                         speed = new(speed.slide@className, .5))),
                         contains = "PropertySet")   ##creats a 'global listener' aka, makes coding less picky.##

obj <- gpar.method$new()

data(flea, package = 'tourr')
qflea = qdata(flea, color = species)
flea_tour = qtour(1:6, data = qflea, tour_path = grand_tour(3))
flea_tour$start()

Sys.sleep(.5)  ##need a pause to catch the new iterations.    is this 1/2 sec period?? .3, .5, 1 work but .1 doesn't? 
qscatter(proj1, proj2, data = qflea, xlim = c(-.8, .8), ylim = c(-.8, .8), xlab="Projection 1", ylab="Projection 2")

##set the signals##
obj$pauseChanged$connect(function() cat("Pause Status:", obj$pause[1], " \n"))       ##outputs pause status
obj$pauseChanged$connect(function() if(is.na(obj$pause[1])){flea_tour$pause()}       ##changes the status
                                    else flea_tour$start())  ##note that, once you pause you need to run start, not speed.
obj$speedChanged$connect(function() cat("Rotation Speed:", obj$speed, " \n"))        ##outputs the speed of the tour
obj$speedChanged$connect(function() flea_tour$speed(obj$speed))                      ##changes the speed of the tour

ControlPanel(obj)

##Viewing properties/aspects of the tour.##
#flea_tour$speed()[1]
#class(flea_tour)
#ls(flea_tour)
#ls(obj)