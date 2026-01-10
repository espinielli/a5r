# Convert A5 cell ID to hexadecimal string

Convert A5 cell ID to hexadecimal string

## Usage

``` r
a5_to_hex(cell)
```

## Arguments

- cell:

  A5 cell ID as an `integer64` value.

## Value

Hexadecimal string representation of the cell ID.

## Examples

``` r
cell <- a5_from_lonlat(-0.16, 51.51, 10)
a5_to_hex(cell)
#> Warning: integer precision lost while converting to double
#> [1] "63611a8000000000"
```
