Convex Optimization by convexjlr
================

`convexjlr` is an `R` package for [Disciplined Convex Programming (DCP)](http://dcp.stanford.edu/) by providing a high level wrapper for [Convex.jl](https://github.com/JuliaOpt/Convex.jl). The aim is to provide optimization results rapidly and reliably in `R` once you formulate your problem as a convex problem. `convexjlr` can solve linear programs, second order cone programs, semidefinite programs, exponential cone programs, mixed-integer linear programs, and some other DCP-compliant convex programs through `Convex.jl`.

**Installation**:

We hope you use `convexjlr` to solve your own problems. If you would like to share your experience on using `convexjlr` or have any questions about `convexjlr`, don't hesitate to contact me: <cxl508@psu.edu>.

Quick Example
-------------

We will show a short example for `convexjlr` in solving linear regression problem. To use package `convexjlr`, we first need to attach it:

``` r
library(convexjlr)
```

And this is our linear regression function using `convexjlr`:

``` r
linear_regression <- function(x, y){
    p <- ncol(x)
    ## n is a scalar, you don't have to use J(.) to send it to Julia.
    n <- nrow(x) ## n <- J(nrow(x))
    ## x is a matrix and y is a vector, you have to use J(.) to send them to Julia.
    x <- J(x)
    y <- J(y)
    ## coefficient vector beta and intercept b.
    beta <- Variable(p)
    b <- Variable()
    ## MSE is mean square error.
    MSE <- Expr(sum((y - x %*% beta - b) ^ 2) / n)
    ## In linear regression, we want to minimize MSE.
    p1 <- minimize(MSE)
    cvx_optim(p1)
    list(coef = value(beta), intercept = value(b))
}
```

In the function, `x` is the predictor matrix, `y` is the response we have. And the `linear_regression` function will return the coefficient and intercept solved by `cvx_optim`.

Now we can see a little example using the `linear_regression` function we have just built.

``` r
n <- 1000
p <- 5
## Sigma, the covariance matrix of x, is of AR-1 strcture.
Sigma <- outer(1:p, 1:p, function(i, j) 0.5 ^ abs(i - j))
x <- matrix(rnorm(n * p), n, p) %*% chol(Sigma)
## The real coefficient is all zero except the first, second and fourth elements.
beta0 <- c(5, 1, 0, 2, 0)
y <- x %*% beta0 + 0.2 * rnorm(n)

linear_regression(x, y)$coef
```

    ##              [,1]
    ## [1,]  5.001721342
    ## [2,]  1.006083286
    ## [3,] -0.007552431
    ## [4,]  2.011244424
    ## [5,]  0.004382787

More Examples
-------------

More examples (including using `convexjlr` for Lasso, logistic regression and Support Vector Machine) can be found in the pakage vignette or on the github page: <https://github.com/Non-Contradiction/Convexjl.R/blob/master/report/my-vignette.md>