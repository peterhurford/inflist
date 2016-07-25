## Inflist <a href="https://travis-ci.org/peterhurford/inflist"><img src="https://img.shields.io/travis/peterhurford/inflist.svg"></a> <a href="https://codecov.io/github/peterhurford/inflist"><img src="https://img.shields.io/codecov/c/github/peterhurford/inflist.svg"></a> <a href="https://github.com/peterhurford/inflist/tags"><img src="https://img.shields.io/github/tag/peterhurford/inflist.svg"></a>

**Inflist** provides R support for generating and interacting with infinite lists.

```R
l <- inflist({
  result <- 0
  function() {
    result <- result + 1
  }
})
# `list(1, 2, 3, 4, 5, ...)`
```

Most list operators will then work on this infinite list...

```R
length(l)
# [1] Inf
l[[10]]
# 10
l[2:3]
# [[1]]
# [1] 2
# [[2]]
# [1] 3
take_while(l, function(x) x < 4)
# [[1]]
# [1] 1
# [[2]]
# [2] 2
# [[3]]
# [3] 3
filter(l, function(x) x %% 2 == 0)
# `list(2, 4, 6, 8, 10, ...)`
head(l, 3)
# [[1]]
# [1] 1
# [[2]]
# [2] 2
# [[3]]
# [3] 3
```
