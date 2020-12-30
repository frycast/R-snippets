## %% An assignment function that behaves as if it has side effects
`foo<-` <- function(x, value) {
  attr(x, "foo") <- value
  x
}

## %% Assign to two or more variables at once
x <- z <- 2

## %% Assign in opposite directions at once
x <- 3 -> z






