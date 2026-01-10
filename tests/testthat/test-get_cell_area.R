test_that("get_cell_area returns positive values", {
  for (res in 0:24) {
    area <- get_cell_area(res)
    expect_true(area > 0)
  }
})

test_that("get_cell_area decreases with resolution", {
  # Higher resolution = smaller cells = smaller area
  for (res in 1:24) {
    area_lower <- get_cell_area(res - 1)
    area_higher <- get_cell_area(res)
    expect_true(area_lower > area_higher)
  }
})

test_that("get_cell_area returns expected magnitude at resolution 0", {
  # At resolution 0, area should be approximately Earth's surface area / 6
  # Earth's surface area ~ 510 million km² = 5.1e14 m²
  # With 6 base cells, each ~ 8.5e13 m²
  area_res0 <- get_cell_area(0)
  expect_true(area_res0 > 1e13) # At least 10 trillion m²
  expect_true(area_res0 < 1e15) # Less than 1 quadrillion m²
})

test_that("get_cell_area returns reasonable values at high resolution", {
  # At resolution 20, cells should be small (~31 m²)
  area_res20 <- get_cell_area(20)
  expect_true(area_res20 < 100) # Less than 100 m²
  expect_true(area_res20 > 1)   # More than 1 m²

  # At resolution 24, cells should be sub-meter scale

  area_res24 <- get_cell_area(24)
  expect_true(area_res24 < 1) # Less than 1 m²
  expect_true(area_res24 > 0)
})
