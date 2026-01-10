# Convert longitude/latitude to A5 cell ID

Convert longitude/latitude to A5 cell ID

## Usage

``` r
a5_from_lonlat(lon, lat, resolution)
```

## Arguments

- lon:

  Longitude in decimal degrees.

- lat:

  Latitude in decimal degrees.

- resolution:

  Resolution level of the grid (0-30).

## Value

A5 cell ID as an `integer64` value.

## Examples

``` r
cell <- a5_from_lonlat(-0.16, 51.51, 10)
```
