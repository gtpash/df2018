import csv

with open('unique_industry.csv', newline = '') as csvfile:
    reader = csv.reader(csvfile)
    for row in reader:
        print(row)
