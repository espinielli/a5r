# Tests for compact and uncompact functions

# ==============================================================================
# compact() tests
# ==============================================================================

test_that("compact merges complete sibling group to parent", {
  # Get a cell and its children
  cell_res5 <- lon_lat_to_cell(4.4, 52.0, 5)
  children <- cell_to_children(cell_res5, NULL)

  # Compact should return the parent
 compacted <- compact(children)
  expect_equal(length(compacted), 1)
  expect_equal(compacted[1], cell_res5)
})

test_that("compact preserves incomplete sibling groups", {
  cell_res5 <- lon_lat_to_cell(4.4, 52.0, 5)
  children <- cell_to_children(cell_res5, NULL)

  # Remove one child - now incomplete group
  incomplete <- children[1:3]
  compacted <- compact(incomplete)

  # Should return the 3 children unchanged
  expect_equal(length(compacted), 3)
})

test_that("compact handles single cell", {
  cell <- lon_lat_to_cell(4.4, 52.0, 10)
  compacted <- compact(cell)
  expect_equal(length(compacted), 1)
  expect_equal(compacted[1], cell)
})

test_that("compact handles empty vector", {
  compacted <- compact(numeric(0))
  expect_equal(length(compacted), 0)
})

test_that("compact removes duplicates", {
  cell <- lon_lat_to_cell(4.4, 52.0, 10)
  duplicated <- c(cell, cell, cell)
  compacted <- compact(duplicated)
  expect_equal(length(compacted), 1)
  expect_equal(compacted[1], cell)
})

test_that("compact handles cells at different resolutions", {
  cell_res5 <- lon_lat_to_cell(4.4, 52.0, 5)
  cell_res10 <- lon_lat_to_cell(-74.0, 40.7, 10)

  mixed <- c(cell_res5, cell_res10)
  compacted <- compact(mixed)

  # Both should remain (no common ancestry to compact)
  expect_equal(length(compacted), 2)
})

test_that("compact works recursively", {
  # Get a cell at res 4
  cell_res4 <- lon_lat_to_cell(4.4, 52.0, 4)

  # Get all grandchildren (res 6)
  grandchildren <- cell_to_children(cell_res4, 6)

  # Compacting all grandchildren should return original res 4 cell
  compacted <- compact(grandchildren)
  expect_equal(length(compacted), 1)
  expect_equal(compacted[1], cell_res4)
})

test_that("compact works on res0 cells", {
  res0 <- get_res0_cells()

  # All 12 res0 cells compact to a single res -1 root cell
  compacted <- compact(res0)
  expect_equal(length(compacted), 1)
  expect_equal(get_resolution(compacted[1]), -1)
})

# ==============================================================================
# uncompact() tests
# ==============================================================================

test_that("uncompact expands to immediate children", {
  cell_res5 <- lon_lat_to_cell(4.4, 52.0, 5)
  expanded <- uncompact(cell_res5, 6)

  expect_equal(length(expanded), 4)  # 4 children per cell at Hilbert levels
  expect_true(all(sapply(expanded, get_resolution) == 6))
})

test_that("uncompact expands multiple levels", {
  cell_res5 <- lon_lat_to_cell(4.4, 52.0, 5)

  # Expand to res 7 (2 levels = 4*4 = 16 cells)
  expanded <- uncompact(cell_res5, 7)
  expect_equal(length(expanded), 16)
  expect_true(all(sapply(expanded, get_resolution) == 7))
})

test_that("uncompact to same resolution returns same cell", {
  cell <- lon_lat_to_cell(4.4, 52.0, 5)
  expanded <- uncompact(cell, 5)

  expect_equal(length(expanded), 1)
  expect_equal(expanded[1], cell)
})

test_that("uncompact errors for lower target resolution", {
  cell_res10 <- lon_lat_to_cell(4.4, 52.0, 10)

  expect_error(uncompact(cell_res10, 5))
})

test_that("uncompact handles multiple input cells", {
  cell1 <- lon_lat_to_cell(4.4, 52.0, 5)
  cell2 <- lon_lat_to_cell(-74.0, 40.7, 5)

  cells <- c(cell1, cell2)
  expanded <- uncompact(cells, 6)

  expect_equal(length(expanded), 8)  # 4 children each
  expect_true(all(sapply(expanded, get_resolution) == 6))
})

test_that("uncompact handles mixed resolution input", {
  cell_res4 <- lon_lat_to_cell(4.4, 52.0, 4)
  cell_res6 <- lon_lat_to_cell(-74.0, 40.7, 6)

  cells <- c(cell_res4, cell_res6)
  expanded <- uncompact(cells, 7)

  # res4 -> res7 = 4*4*4 = 64 cells
  # res6 -> res7 = 4 cells
  expect_equal(length(expanded), 64 + 4)
  expect_true(all(sapply(expanded, get_resolution) == 7))
})

test_that("uncompact and compact are inverse operations", {
  cell_res5 <- lon_lat_to_cell(4.4, 52.0, 5)

  # Uncompact then compact should return original
  expanded <- uncompact(cell_res5, 8)
  compacted <- compact(expanded)

  expect_equal(length(compacted), 1)
  expect_equal(compacted[1], cell_res5)
})

test_that("uncompact preserves spatial coverage", {
  # Get a cell at res 5
  cell <- lon_lat_to_cell(4.4, 52.0, 5)
  center <- cell_to_lon_lat(cell)

  # Uncompact to res 7
  expanded <- uncompact(cell, 7)

  # The center point should be within one of the expanded cells
  matching_child <- lon_lat_to_cell(center$lon, center$lat, 7)
  expect_true(matching_child %in% expanded)
})
