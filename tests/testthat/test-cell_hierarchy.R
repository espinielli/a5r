test_that("cell_to_parent returns parent at coarser resolution", {
  cell <- lon_lat_to_cell(4.4260, 50.8433, 10)
  parent <- cell_to_parent(cell, NULL)

  expect_equal(get_resolution(parent), 9)
})

test_that("cell_to_parent with explicit resolution works", {
  cell <- lon_lat_to_cell(4.4260, 50.8433, 10)

  parent_8 <- cell_to_parent(cell, 8L)
  expect_equal(get_resolution(parent_8), 8)

  parent_5 <- cell_to_parent(cell, 5L)
  expect_equal(get_resolution(parent_5), 5)
})

test_that("cell_to_parent errors on invalid resolution", {
  cell <- lon_lat_to_cell(4.4260, 50.8433, 10)

  # Can't get parent at finer resolution

  expect_error(cell_to_parent(cell, 12L))
})

test_that("cell_to_children returns children at finer resolution", {
  cell <- lon_lat_to_cell(4.4260, 50.8433, 10)
  children <- cell_to_children(cell, NULL)

  expect_true(length(children) > 0)
  expect_true(all(sapply(children, get_resolution) == 11))
})

test_that("cell_to_children with explicit resolution works", {
  cell <- lon_lat_to_cell(4.4260, 50.8433, 5)

  children_6 <- cell_to_children(cell, 6L)
  expect_true(all(sapply(children_6, get_resolution) == 6))

  children_7 <- cell_to_children(cell, 7L)
  expect_true(all(sapply(children_7, get_resolution) == 7))
  expect_true(length(children_7) > length(children_6))
})

test_that("cell_to_children errors on invalid resolution", {
  cell <- lon_lat_to_cell(4.4260, 50.8433, 10)

  # Can't get children at coarser resolution
  expect_error(cell_to_children(cell, 8L))
})

test_that("parent-child relationship is consistent", {
  cell <- lon_lat_to_cell(4.4260, 50.8433, 10)
  children <- cell_to_children(cell, NULL)

  # All children should have the same parent
  for (child in children) {
    parent <- cell_to_parent(child, NULL)
    expect_equal(parent, cell)
  }
})

test_that("cell_to_children returns 4 immediate children", {
  # A5 cells subdivide into 4 children
  cell <- lon_lat_to_cell(-74.00, 40.71, 8)
  children <- cell_to_children(cell, NULL)

  expect_equal(length(children), 4)
})
