test_that("get_cell_boundary returns a list with lon and lat", {
  cell <- lon_lat_to_cell(4.4260, 50.8433, 10)
  boundary <- get_cell_boundary(cell, TRUE, NULL)

  expect_type(boundary, "list")
  expect_named(boundary, c("lon", "lat"))
  expect_type(boundary$lon, "double")

  expect_type(boundary$lat, "double")
})

test_that("get_cell_boundary returns closed ring when requested", {
  cell <- lon_lat_to_cell(0, 0, 5)
  boundary_closed <- get_cell_boundary(cell, TRUE, NULL)
  boundary_open <- get_cell_boundary(cell, FALSE, NULL)

  # Closed ring should have first point repeated at end
  n_closed <- length(boundary_closed$lon)
  n_open <- length(boundary_open$lon)

  expect_equal(n_closed, n_open + 1)
  expect_equal(boundary_closed$lon[1], boundary_closed$lon[n_closed])
  expect_equal(boundary_closed$lat[1], boundary_closed$lat[n_closed])
})

test_that("get_cell_boundary returns 5 vertices for pentagons (open ring)", {
  cell <- lon_lat_to_cell(-74.00, 40.71, 8)
  boundary <- get_cell_boundary(cell, FALSE, 1L)

  # A5 cells are pentagons, should have 5 vertices when segments = 1
  expect_equal(length(boundary$lon), 5)
  expect_equal(length(boundary$lat), 5)
})

test_that("get_cell_boundary segments parameter increases vertices", {
  cell <- lon_lat_to_cell(139.69, 35.69, 10)

  boundary_1seg <- get_cell_boundary(cell, FALSE, 1L)
  boundary_2seg <- get_cell_boundary(cell, FALSE, 2L)

  # More segments = more vertices
  expect_true(length(boundary_2seg$lon) > length(boundary_1seg$lon))
})

test_that("get_cell_boundary coordinates are valid", {
  cell <- lon_lat_to_cell(-0.16, 51.51, 12)
  boundary <- get_cell_boundary(cell, TRUE, NULL)

  # Longitude should be in [-180, 180]
  expect_true(all(boundary$lon >= -180 & boundary$lon <= 180))

  # Latitude should be in [-90, 90]
  expect_true(all(boundary$lat >= -90 & boundary$lat <= 90))
})

test_that("get_cell_boundary center is within boundary bbox", {
  cell <- lon_lat_to_cell(4.4260, 50.8433, 10)
  boundary <- get_cell_boundary(cell, FALSE, NULL)
  center <- cell_to_lon_lat(cell)

  # Center should be within bounding box of boundary
  expect_true(center$lon >= min(boundary$lon) & center$lon <= max(boundary$lon))
  expect_true(center$lat >= min(boundary$lat) & center$lat <= max(boundary$lat))
})
