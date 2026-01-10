test_that("get_res0_cells returns 12 base cells", {
  res0 <- get_res0_cells()
  expect_equal(length(res0), 12)
})

test_that("get_res0_cells returns cells at resolution 0", {
  res0 <- get_res0_cells()
  resolutions <- sapply(res0, get_resolution)
  expect_true(all(resolutions == 0))
})

test_that("get_res0_cells returns unique cells", {
  res0 <- get_res0_cells()
  expect_equal(length(unique(res0)), 12)
})

test_that("get_num_cells returns 12 at resolution 0", {
  expect_equal(get_num_cells(0), 12)
})

test_that("get_num_cells increases with resolution", {
  for (res in 1:10) {
    expect_true(get_num_cells(res) > get_num_cells(res - 1))
  }
})

test_that("get_num_cells matches expected pattern", {
  # At res 0: 12 cells
  # At res 1: 12 * 5 = 60 cells (each base cell has 5 children at res 1)
  # At res 2+: each cell has 4 children
  expect_equal(get_num_cells(0), 12)
  expect_equal(get_num_cells(1), 60)
  expect_equal(get_num_cells(2), 240) # 60 * 4
  expect_equal(get_num_cells(3), 960) # 240 * 4
})

test_that("get_num_cells returns 0 for negative resolution", {
  expect_equal(get_num_cells(-1), 0)
})
