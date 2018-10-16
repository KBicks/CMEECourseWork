# Average UK Rainfall (mm) for 1910 by month
# http://www.metoffice.gov.uk/climate/uk/datasets
rainfall = (('JAN',111.4),
            ('FEB',126.1),
            ('MAR', 49.9),
            ('APR', 95.3),
            ('MAY', 71.8),
            ('JUN', 70.2),
            ('JUL', 97.1),
            ('AUG',140.2),
            ('SEP', 27.0),
            ('OCT', 89.4),
            ('NOV',128.4),
            ('DEC',142.2),
           )

# (1) Use a list comprehension to create a list of month,rainfall tuples where
# the amount of rain was greater than 100 mm.
 
# (2) Use a list comprehension to create a list of just month names where the
# amount of rain was less than 50 mm. 

# (3) Now do (1) and (2) using conventional loops (you can choose to do 
# this before 1 and 2 !). 


## (1) List comprehension - list of month,rainfall tuples where rain > 100mm

def over100(name):
    return name[1]>100

greaterthan100_lc = set([month for month in rainfall if over100(month)])
print(greaterthan100_lc)

## (2) List comprehension - list of months where rain < 50mm

def under50(name):
    return name[1]<50

lessthan50_lc = set([month[0] for month in rainfall if under50(month)])
print(lessthan50_lc)

## (3) Conventional loop for part (1) - create a list of month,rainfall tuples with
# amount of rain > 100mm

def over100(name):
    return name[1]>100

greaterthan100_loop = set()
for month in rainfall:
    if over100(month):
        greaterthan100_loop.add(month)
print(greaterthan100_loop)

## (3) Conventional loop for part (2) - create a list of months where rain < 50mm

def under50(name):
    return name[1]<50

lessthan50_loop = set()
for month in rainfall:
    if under50(month):
        lessthan50_loop.add(month[0])
print(lessthan50_loop)
