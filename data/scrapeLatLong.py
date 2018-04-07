import os, csv

with open('USALatLong.csv', newline = '') as csvfile:
    reader = csv.reader(csvfile)
    for row in reader:
        if not row[-1] == '':
            print("new google.maps.LatLng(%s, %s)," %(row[-2],row[-1]))
