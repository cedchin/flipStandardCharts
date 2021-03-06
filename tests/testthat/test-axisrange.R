context("Axis range")

test_that("Range as a string",
{
    xx <- 1:10
    names(xx) <- letters[xx]
    expect_error(Bar(xx, x.bounds.maximum = ""), NA)
    expect_error(Column(xx, y.bounds.maximum = "2e1"), NA)
    expect_error(Column(xx, y.bounds.maximum = "2,000"), NA)
})
