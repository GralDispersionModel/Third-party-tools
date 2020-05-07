#!/usr/bin/env python2

"""Calculate aggregated concentrations per hour

Sum concentrations for all groups in each hour and generate one file per hour



Scripts by CESGA (http://trafair.eu/)
"""

from __future__ import print_function, division
import numpy as np
import glob


def ascii_header(filename):
    """Retrieve ESRI ASCII raster format header"""
    with open(filename) as raster:
        header = []
        for _ in range(6):
            header.append(raster.readline().strip())
    return '\n'.join(header)


def read_concentrations(filename):
    """Read concentrations from filename and return a numpy array"""
    with open(filename) as out:
        rows = out.readlines()[6:]

    data = []
    for row in rows:
        data.append(row.split())

    concentrations = np.array(data, dtype='float64')
    return concentrations


def write_concentrations(header, concentrations, filename):
    """Write the contentrations to an ascii file using the given header"""
    np.savetxt(filename, concentrations, delimiter=' ',
               header=header, comments='')


def computed_groups():
    """Returns a list with the numbers of the source groups computed"""
    return [int(filename[7:9]) for filename in glob.glob('00001-1*.txt')]


def computed_hours():
    """Returns the number of hours computed"""
    return len(glob.glob('000*-101.txt'))


def main():
    # Number of hours simulated
    hours = computed_hours()
    # List of source groups used for the calculation
    groups = computed_groups()
    # All concentration output files will share the same header
    # FIXME: We assume there will always be a source group named 1
    header = ascii_header('00001-101.txt')

    for hour in range(1, hours + 1):
        print('Aggregating concentrations for simulation hour {}'.format(hour))
        # We read the concentrations of first group for the given hour
        total = read_concentrations('000{:02d}-1{:02d}.txt'
                                    .format(hour, groups[0]))
        # And then we accumulate the rest of groups generating the total
        for group in groups[1:]:
            total += read_concentrations('000{:02d}-1{:02d}.txt'
                                         .format(hour, group))
        write_concentrations(header, total, '000{:02d}.total.txt'.format(hour))

if __name__ == '__main__':
    main()
