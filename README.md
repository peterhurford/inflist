## Inflist

Create infinite lists in R!

```R
> infseq <- inflist({
  result <- 0
  function() {
    result %+=% 1
  }
})

> infseq
`list(1, 2, 3, 4, 5, ...)`
```

```R
> fib <- inflist({
  result <- 0
  b <- 1
  function() {
    c(result, b) %<-% c(b, result + b)
  }
})

> fib
`list(1, 1, 2, 3, 5, ...)`

> length(fib)
 [1] Inf
```

You can extract infinite sequences using `head`:

```R
> unlist(head(infseq, 20))
 [1]  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20

> unlist(head(fib, 10))
 [1] 1  1  2  3  5  8 13 21 34 55
```

You can also use bracket indexing:

```R
> fib[[30]]
 [1] 832040
> unlist(fib[seq(4, 7)])
 [1] 3  5  8 13
```

There's the FP classic `take_while`:

```R
> unlist(take_while(fib, function(x) x <= 4000))
 [1]    1    1    2    3    5    8   13   21   34   55   89  144  233  377  610
 [16]  987 1597 2584
```

This is the same as indexing, though:

```R
> unlist(fib[. <= 4000])
 [1]    1    1    2    3    5    8   13   21   34   55   89  144  233  377  610
 [1]  987 1597 2584
```

(Note that `.` must be used to represent the variable in infinite indexing.)

-

Filtering is also possible on infinite lists to narrow down the infinite list:

```R
> filter(fib, is_even)
`list(2, 8, 34, 144, 610, ...)`
```


Together with [funtools](https://github.com/peterhurford/funtools), this lets you solve [Project Euler #2](https://projecteuler.net/problem=2) with very little code:

```R
fib <- inflist({ result <- 0; b <- 1; function() { c(result, b) %<-% c(b, result + b) } })
filter(fib, is_even)[x <= 4000000] %_>% `+`
```
