test_that("deduped(f) runs only on deduplicated values", {
  get_ncalls <- function() as.integer(Sys.getenv("ncalls"))
  increment_ncalls <- function() Sys.setenv(ncalls = get_ncalls() + 1L)

  f <- function(ii) for (i in ii) increment_ncalls()

  withr::with_envvar(
    c(ncalls = 0),
    {
      x <- c(1, 1, 1, 2, 3)
      deduped(f)(x)
      expect_equal(get_ncalls(), 3)
    }
  )

  withr::with_envvar(
    c(ncalls = 0),
    {
      x <- 1:5
      deduped(f)(x)
      expect_equal(get_ncalls(), 5)
    }
  )
})

test_that("deduped(f) returns the data in the same order", {
  x <- c(1, 3, 1, 2, 2, 1)
  pass_through <- \(i) i
  expect_equal(deduped(pass_through)(x), x)
})

test_that("deduped(f) works on lists", {
  x <- list("ABC", "ABC")
  expect_equal(
    deduped(tolower)(x),
    tolower(x)
  )
})

test_that("deduped(f) errors on matrices or data frames", {
  pass_through <- \(i) i

  expect_error(
    deduped(pass_through)(matrix(1:10))
  )

  expect_error(
    deduped(pass_through)(data.frame(1:10))
  )
})
