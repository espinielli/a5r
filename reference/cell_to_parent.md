# Get the parent cell at a coarser resolution

Get the parent cell at a coarser resolution

## Usage

``` r
cell_to_parent(cell_id, parent_resolution)
```

## Arguments

- cell_id:

  ID of the cell.

- parent_resolution:

  target resolution (must be less than current), or NULL for immediate
  parent.

## Value

parent cell ID.
