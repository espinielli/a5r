# Convert A5 cell ID to longitude/latitude

Convert A5 cell ID to longitude/latitude

## Usage

``` r
a5_to_lonlat(cell)
```

## Arguments

- cell:

  A5 cell ID as an `integer64` value.

## Value

A list with `lon` and `lat` components.

## Examples

``` r
cell <- a5_from_lonlat(-0.16, 51.51, 10)
a5_to_lonlat(cell)
#> Warning: integer precision lost while converting to double
#> $lon
#> [1] -0.1597184
#> 
#> $lat
#> [1] 51.51184
#> 
```
