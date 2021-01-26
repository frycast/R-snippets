# data.table vignettes:
# https://cran.r-project.org/web/packages/data.table/vignettes/

input <- if (file.exists("flights14.csv")) {
  "flights14.csv"
} else {
  "https://raw.githubusercontent.com/Rdatatable/data.table/master/vignettes/flights14.csv"
}
flights <- fread(input)

# A data.table, like a data.frame, is a list of equal length columns
DT = data.table(
  ID = c("b","b","b","a","a","c"),
  a = 1:6,
  b = 7:12,
  c = 13:18
)
DT
class(DT$ID) # Never converted to factor by default
getOption("datatable.print.nrows") # if > then print only top 5 and bottom 5
rownames(DT) # data.table doesn't set or use row names ever

# General usage: DT[i, j, by]
# i  :~ SQL where  | order by
# j  :~ SQL select | update
# by :~ SQL group by

# Example i
ans <- flights[origin == "JFK" & month == 6L]
head(ans)
ans <- flights[1:2]
ans
# Sort flights first by column origin in ascending order, 
# and then by dest in descending order:
ans <- flights[order(origin, -dest)]

# Select a column, but return it as a vector.
ans <- flights[, arr_delay]
head(ans)

# Select a column, but return it as a data.table.
ans <- flights[, list(arr_delay)]
ans
# The function .() is an alias to list()
ans <- flights[, .(arr_delay)]
ans

# bind a list of data.tables into a single one
DT1 = data.table(A=1:3,B=letters[1:3])
DT2 = data.table(A=4:5,B=letters[4:5])
l = list(DT1,DT2)
rbindlist(l)
