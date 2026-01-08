test_that("cell_to_lon_lat works correctly", {
  ll <- cell_to_lon_lat(7161034019553935360)
  expect_equal(ll, list(lon = -0.1597184, lat = 51.5118429))

  # cell <- lon_lat_to_cell(4.4260, 50.8433, 14) # 0x63c7b85580000000
  # expect_equal(cell, 7189918007479500800)
})
