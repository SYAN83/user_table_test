data <- iris
empty_set <- data.frame(Species = character(0), Sepal.Length= numeric(0))
saved_set <- data[1:3, names(empty_set)]
