library(convexjlr)
context("Exponential Cone Programming")

## The original Julia version

# x = Variable(4)
# p = satisfy(norm(x) <= 100, exp(x[1]) <= 5, x[2] >= 7, geomean(x[3], x[4]) >= x[2])
# solve!(p, SCSSolver(verbose=0))
# println(p.status)
# x.value

if (setup()) {

    ## The R version with convexjl.R

    x <- Variable(4)
    p <- satisfy(norm(x) <= 100, exp(x[1]) <= 5, x[2] >= 7, geomean(x[3], x[4]) >= x[2])
    cvx_optim(p)

    ## The R version with XRJulia directly

    ev <- XRJulia::RJulia()
    ev$Command("using Convex")
    ev$Command("x = Variable(4)")
    ev$Command("p = satisfy(norm(x) <= 100, exp(x[1]) <= 5, x[2] >= 7, geomean(x[3], x[4]) >= x[2])")
    ev$Command("solve!(p)")

    ## Compare the results

    test_that("Results for example of exponential cone programming", {
        expect_equal(value(x), ev$Eval("x.value", .get = TRUE))
    })
}
