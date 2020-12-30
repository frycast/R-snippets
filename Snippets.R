## %% An assignment function that behaves as if it has side effects
`foo<-` <- function(x, value) {
  attr(x, "foo") <- value
  x
}

## %% Assign to two or more variables at once
x <- z <- 2

## %% Assign in opposite directions at once
x <- 3 -> z

## %% Use map to apply a function to each element
library(purrr)
c(1,2,3) %>% map(function(x){x^2})
c(1,2,3) %>% map_dbl(function(x){x^2})
c(a = 1, b = 2, c = 3) %>% map_dfr(function(x){x^2})

## %% Capture string output from print
a <- capture.output(cat("hi"))
s <- summary(lm(mpg ~ cyl, data = mtcars))
os <- capture.output(s)

## %% Unlist a list of factors combines them well
fac1 <- factor(c("a","a","b"))
fac2 <- factor(c("b","b","a"))
unlist(list(fac1, fac2))

## %% Evaluate an R expression in an environment constructed from data
df <- data.frame(x = 1:10, y = 1:10, z = rep("a",10))
with(df, {
  m <- x + y
  print(paste0(z[1], " number is ", m))
})







