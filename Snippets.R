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

## %% Set the names of an object without making a temporary variable
setNames( 1:3, c("foo", "bar", "baz") )
# this is just a short form of
tmp <- 1:3
names(tmp) <-  c("foo", "bar", "baz")
tmp

## %% Functions can cause side effects with <<-
g <- 0
myfunc <- function() {
  g <- g + 1
}
myfunc2 <- function() {
  g <<- g + 1
}
myfunc()
g
myfunc2()
g

## %% Blocks are a thing! But don't have local scope
print({
    a = 1 + 1
    a = a + 1
    a
})

## %% rbindlist is just like do.call("rbind", l)
# use it to bind a list of matrices into a single one
DT1 = data.table(A=1:3,B=letters[1:3])
DT2 = data.table(A=4:5,B=letters[4:5])
l = list(DT1,DT2)
rbindlist(l)
m1 <- matrix(1:9, nrow = 3)
m2 <- matrix(1:9, nrow = 3)
do.call(rbind, list(m1,m2))


## %% Get the name of the current worker when parallel processing
# combining the node name with the processid of the worker
foreach(i = 1:12, .combine=c) %dopar% {
  paste(Sys.info()[['nodename']], Sys.getpid(), sep='-')
}
