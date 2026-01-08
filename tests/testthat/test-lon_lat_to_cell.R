test_that("lon_lat_to_cell works correctly", {
  cell <- lon_lat_to_cell(-0.1827, 51.4868, 10)
  expect_equal(cell, 7161034019553935360)

  cell <- lon_lat_to_cell(-0.160, 51.512, 10)
  expect_equal(cell, 7161034019553935360)

  ll <- lon_lat_to_cell(lon = -0.1597184, lat = 51.5118429, 10)
  expect_equal(cell, 7161034019553935360)

  # cell <- lon_lat_to_cell(4.4260, 50.8433, 14) # 0x63c7b85580000000
  # expect_equal(cell, 7189918007479500800)
})
