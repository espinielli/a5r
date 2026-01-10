# Get the resolution of an A5 cell

Get the resolution of an A5 cell

## Usage

``` r
a5_resolution(cell)
```

## Arguments

- cell:

  A5 cell ID as an `integer64` value.

## Value

Resolution level (0-30) of the cell.

## Examples

``` r
cell <- a5_from_lonlat(-0.16, 51.51, 10)
a5_resolution(cell)
#> Warning: integer precision lost while converting to double
#> [1] 10
```
