inflist <- function(expr) {
  env <- environment(expr)
  env$listresult <- list()
  fn <- eval(substitute(expr), envir = env)
  environment(fn) <- env
  class(fn) <- "inflist"
  fn
}

nextseq <- function(fn) {
  result <- eval(body(fn),
    as.environment(c(as.list(environment(fn)), as.list(globalenv()), as.list(baseenv()))))
  environment(fn) <- as.environment(c(as.list(environment(fn)), as.list(environment())))
  environment(fn)$listresult <- append(environment(fn)$listresult, result)
  fn
}

print.inflist <- function(x, ...) {
  out <- head(x, 5)
  print.default(as.name(paste0(gsub(")", "", capture.output(dput(out)), fixed = TRUE), ", ...)")), ...)
}

length.inflist <- function(x) Inf

`length<-.inflist` <- function(x, value) {
  assign(deparse(substitute(x)), head(x, value), envir = parent.frame(3))
}

`[[.inflist` <- function(x, i) {
  head(x, i)[[i]]
}

`[.inflist` <- function(x, i) {
  i <- substitute(i)
  if (grepl(".", deparse(i), fixed = TRUE)) {
    f <- function(x) {  }
    body(f) <- i
    take_while(x, f)
  } else {
    i <- eval.parent(i)
    head(x, last(i))[i]
  }
}


take_while <- function(seq, condition) {
  result <- NULL
  while (is.null(result) || isTRUE(condition(last(result)))) {
    seq <- nextseq(seq)  
    result <- environment(seq)$listresult
  }
  out <- init(result)
  if (!is.null(environment(seq)$filter)) {
    out <- filter(out, environment(seq)$filter)
  }
  out
}

cycle <- function(xs) {
  inflist({
    i <- 1
    function() {
      if (i > length(xs)) { i <- 1 }
      result <- xs[[i]]
      i %+=% 1
      result
    }
  })
}

#TODO: filter composition
filter.inflist <- function(seq, f) {
  filters <- environment(seq)$filter
  e2 <- as.environment(as.list(environment(seq), all.names = TRUE))
  parent.env(e2) <- globalenv()  
  environment(seq) <- e2
  if (!is.null(filters)) {
    filters <- filters %.% f
  } else {
    filters <- f
  }
  environment(seq)$filter <- filters
  seq
}

head.inflist <- function(x, n = 6) {
  for (i in seq(n)) { x <- nextseq(x) }
  out <- environment(x)$listresult
  if (!is.null(environment(x)$filter)) {
    out <- filter(out, environment(x)$filter)
  }
  suppressWarnings({
    if (length(out) < n) { out <- head(x, n * 2) }
    if (length(out) > n) { length(out) <- n }
    return(out)
  })
}

# TODO: Allow tail to work with negative numbers.
tail.inflist <- function(x, m) {
  if (m < 0) {
    x[seq(-1, m)]
  } else if (m == 0) {
    vector(class(x[[1]]), 0)
  } else {
    stop("Cannot take the tail of an infinite list.", call. = FALSE)
  }
}

#TODO: map and reduce for infinite lists
