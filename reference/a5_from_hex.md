# Convert hexadecimal string to A5 cell ID

Convert hexadecimal string to A5 cell ID

## Usage

``` r
a5_from_hex(hex)
```

## Arguments

- hex:

  Hexadecimal string representation of the cell ID.

## Value

A5 cell ID as an `integer64` value.

## Examples

``` r
a5_from_hex("63611a8000000000")
#> integer64
#> [1] 7161034019553935360
```
