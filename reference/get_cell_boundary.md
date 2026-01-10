# Get the boundary of an A5 cell as a list of coordinates

Get the boundary of an A5 cell as a list of coordinates

## Usage

``` r
get_cell_boundary(cell_id, closed, segments)
```

## Arguments

- cell_id:

  ID of the cell.

- closed:

  whether to close the ring by repeating the first point (default:
  TRUE).

- segments:

  number of segments per edge, or NULL for automatic (default: NULL).

## Value

a list with `lon` and `lat` vectors representing the boundary vertices.
