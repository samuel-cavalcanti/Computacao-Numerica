import numpy

interval = [
    [1106, 1520],
    [1331, 1438],
    [1556, 1445],
    [1781, 1445],
    [2006, 1507],
    [2231, 1512],
    [2456, 1512],
    [2681, 1495],
    [2906, 1471],
    [3131, 1520], ]


interval_old =  [
    [1056, 1727],
    [1289, 1440],
    [1522, 1440],
    [1755, 1443],
    [1988, 1488],
    [2221, 1512],
    [2454, 1512],
    [2687, 1493],
    [2920, 1472],
    [3153, 1527],
    [3386, 1727],    
]
numpy.savetxt("intervalo.csv", numpy.array(interval), delimiter=",")

numpy.savetxt("intervalo_old.csv",numpy.array(interval_old), delimiter=",")
