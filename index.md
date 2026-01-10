# a5r ![](reference/figures/logo.png)

**a5r** provides R bindings for the [A5](https://a5geo.org/) pentagonal
Discrete Global Grid System (DGGS).

A5 is a hierarchical geospatial indexing system that partitions the
Earth’s surface into pentagonal cells. Unlike hexagonal systems like H3,
A5 uses pentagons which tile the sphere without requiring special
irregular cells.

## Features

- Convert between coordinates and cell IDs
- Navigate the cell hierarchy (parent/children)
- Compact and uncompact cell sets
- Get cell boundaries and areas
- Fast Rust implementation via [extendr](https://extendr.github.io/)

## Installation

You can install the development version of a5r from GitHub:

``` r
# install.packages("pak")
pak::pak("espinielli/a5r")
```

**Note:** Building from source requires Rust. Install via
[rustup](https://rustup.rs/).

## Example

``` r
library(a5r)

# Convert coordinates to a cell at resolution 5
cell <- lon_lat_to_cell(lon = 4.4, lat = 52.0, resolution = 5)

# Get the cell as hex string
u64_to_hex(cell)
#> [1] "63da000000000000"

# Get cell center
cell_to_lon_lat(cell)
#> $lon
#> [1] 4.397673
#> $lat
#> [1] 52.00187

# Get cell resolution
get_resolution(cell)
#> [1] 5

# Navigate hierarchy
parent <- cell_to_parent(cell, NULL)
children <- cell_to_children(cell, NULL)

# Compact children back to parent
compact(children)
```

## Grid Properties

A5 has some unique characteristics:

- **12 base cells** at resolution 0 (pentagons on a dodecahedron)
- **4 children per cell** at most resolutions (5 at resolution 0→1)
- **Cell area** decreases ~4x per resolution level
- **Resolution range**: 0 to 30

``` r
# Get all base cells
get_res0_cells()

# Get cell count at resolution 5
get_num_cells(5)
#> [1] 15360

# Get cell area in square meters
get_cell_area(10)
#> [1] 33201823
```

## License

Apache License 2.0

## Acknowledgements

- [A5 reference implementation](https://github.com/felixpalmer/a5) by
  Felix Palmer
- [A5 website](https://a5geo.org/)
- [A5 implementation in Rust](https://github.com/felixpalmer/a5-rs)
- Built with [extendr](https://extendr.github.io/)
