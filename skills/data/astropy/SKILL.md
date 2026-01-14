---
name: astropy
description: Use when "Astropy", "astronomy", "astrophysics", "FITS files", or asking about "celestial coordinates", "cosmological calculations", "astronomical units", "Julian Date", "WCS", "sky coordinates", "redshift distance"
version: 1.0.0
---

<!-- Adapted from: claude-scientific-skills/scientific-skills/astropy -->

# Astropy Astronomy and Astrophysics

Core Python library for astronomy - coordinates, units, FITS files, cosmology, and time.

## When to Use

- Converting celestial coordinate systems (ICRS, Galactic, AltAz)
- Working with physical units and quantities
- Reading/writing FITS files
- Cosmological calculations (distances, ages, redshifts)
- Precise time handling (UTC, TAI, Julian Date)
- World Coordinate System (WCS) transformations

## Quick Start

```python
import astropy.units as u
from astropy.coordinates import SkyCoord
from astropy.time import Time
from astropy.io import fits
from astropy.cosmology import Planck18

# Units and quantities
distance = 100 * u.pc
distance_km = distance.to(u.km)

# Coordinates
coord = SkyCoord(ra=10.5*u.degree, dec=41.2*u.degree, frame='icrs')
coord_galactic = coord.galactic

# Time
t = Time('2023-01-15 12:30:00')
jd = t.jd  # Julian Date

# FITS files
data = fits.getdata('image.fits')

# Cosmology
d_L = Planck18.luminosity_distance(z=1.0)
```

## Units and Quantities

```python
import astropy.units as u

# Create quantities
wavelength = 500 * u.nm
flux = 1e-17 * u.erg / u.s / u.cm**2 / u.angstrom

# Convert units
wavelength_angstrom = wavelength.to(u.angstrom)

# Arithmetic with units
velocity = 100 * u.km / u.s
time = 10 * u.hour
distance = velocity * time

# Equivalencies (spectral)
freq = wavelength.to(u.Hz, equivalencies=u.spectral())
```

## Coordinates

```python
from astropy.coordinates import SkyCoord, EarthLocation, AltAz
from astropy.time import Time
import astropy.units as u

# Create coordinate
c = SkyCoord(ra='05h23m34.5s', dec='-69d45m22s', frame='icrs')
c = SkyCoord(ra=10.5*u.degree, dec=41.2*u.degree)

# Transform to galactic
c_gal = c.galactic
print(f"l={c_gal.l.deg}, b={c_gal.b.deg}")

# Transform to Alt-Az (requires time and location)
location = EarthLocation(lat=40*u.deg, lon=-120*u.deg)
time = Time('2023-06-15 23:00:00')
altaz = c.transform_to(AltAz(obstime=time, location=location))
print(f"Alt={altaz.alt.deg}, Az={altaz.az.deg}")

# Angular separation
sep = c1.separation(c2)

# Match catalogs
idx, sep, _ = coords1.match_to_catalog_sky(coords2)
```

## FITS Files

```python
from astropy.io import fits

# Open and read
with fits.open('image.fits') as hdul:
    hdul.info()  # Show structure
    data = hdul[0].data
    header = hdul[0].header
    exptime = header['EXPTIME']

# Quick read
data = fits.getdata('image.fits')
header = fits.getheader('image.fits')

# Write FITS
fits.writeto('output.fits', data, header, overwrite=True)

# Create new FITS
hdu = fits.PrimaryHDU(data)
hdu.header['OBSERVER'] = 'Me'
hdu.writeto('new.fits')
```

## Cosmology

```python
from astropy.cosmology import Planck18, FlatLambdaCDM
import astropy.units as u

# Built-in cosmologies
cosmo = Planck18

# Distances at redshift z=1.5
z = 1.5
d_L = cosmo.luminosity_distance(z)      # Luminosity distance
d_A = cosmo.angular_diameter_distance(z)  # Angular diameter distance
d_C = cosmo.comoving_distance(z)        # Comoving distance

# Time
age = cosmo.age(z)                      # Age of universe at z
lookback = cosmo.lookback_time(z)       # Lookback time

# Hubble parameter
H = cosmo.H(z)

# Custom cosmology
my_cosmo = FlatLambdaCDM(H0=70, Om0=0.3)
```

## Time

```python
from astropy.time import Time, TimeDelta

# Create time
t = Time('2023-01-15 12:30:00')
t = Time(2459959.5, format='jd')
t = Time(59959.0, format='mjd')

# Convert formats
print(t.iso)    # ISO string
print(t.jd)     # Julian Date
print(t.mjd)    # Modified Julian Date
print(t.unix)   # Unix timestamp

# Time scales
print(t.utc)    # UTC
print(t.tai)    # International Atomic Time
print(t.tt)     # Terrestrial Time

# Time arithmetic
dt = TimeDelta(1 * u.hour)
t_new = t + dt
```

## Tables

```python
from astropy.table import Table, QTable

# Read tables
table = Table.read('catalog.fits')
table = Table.read('catalog.csv')

# Create table
table = Table({
    'name': ['M31', 'M33', 'M101'],
    'ra': [10.68, 23.46, 210.80] * u.deg,
    'dec': [41.27, 30.66, 54.35] * u.deg
})

# Access data
print(table['ra'])
print(table[0])  # First row

# Filter
bright = table[table['magnitude'] < 10]

# Save
table.write('output.fits', overwrite=True)
```

## WCS (World Coordinate System)

```python
from astropy.wcs import WCS
from astropy.io import fits

# Read WCS from FITS
header = fits.getheader('image.fits')
wcs = WCS(header)

# Pixel to world coordinates
ra, dec = wcs.pixel_to_world_values(100, 200)

# World to pixel coordinates
x, y = wcs.world_to_pixel_values(ra, dec)

# Get image footprint
footprint = wcs.calc_footprint()
```

## Best Practices

1. **Always use units** - attach units to avoid errors
2. **Check coordinate frames** before transformations
3. **Use projected CRS** for area/distance in 2D
4. **Use context managers** for FITS files
5. **Specify time scales** for precise timing
6. **Use QTable** for unit-aware table columns

## Resources

- Docs: <https://docs.astropy.org/>
- Tutorials: <https://learn.astropy.org/>
- Examples: <https://docs.astropy.org/en/stable/examples/>
