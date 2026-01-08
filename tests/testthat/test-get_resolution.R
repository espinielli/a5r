test_that("get_resolution returns correct resolution", {
  # Test cells at different resolutions
  # Note: a5 crate has issues with very high resolutions (>24)
  for (res in c(0, 5, 10, 15, 20)) {
    cell <- lon_lat_to_cell(4.4260, 50.8433, res)
    expect_equal(get_resolution(cell), res)
  }
})

test_that("get_resolution works with different locations", {
  # London
  cell <- lon_lat_to_cell(-0.16, 51.51, 12)
  expect_equal(get_resolution(cell), 12)

  # Tokyo
  cell <- lon_lat_to_cell(139.69, 35.69, 8)
  expect_equal(get_resolution(cell), 8)

  # New York
  cell <- lon_lat_to_cell(-74.00, 40.71, 14)
  expect_equal(get_resolution(cell), 14)
})
