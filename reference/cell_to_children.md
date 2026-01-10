# Get the children cells at a finer resolution

Get the children cells at a finer resolution

## Usage

``` r
cell_to_children(cell_id, child_resolution)
```

## Arguments

- cell_id:

  ID of the cell.

- child_resolution:

  target resolution (must be greater than current), or NULL for
  immediate children.

## Value

vector of child cell IDs.
