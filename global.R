# Mineral formulae -------------------------------------

library(stringr)
library(dplyr)
library(PeriodicTable)

identify_oxide <- function(x) {
  x_split <- stringr::str_split(x, "(?<=.)(?=[A-Z])", simplify = TRUE) |> as.vector()


  elements <- gsub("[0-9]+", "", x_split)
  numbers <- stringr::str_extract(x_split, "[0-9]+")

  data.frame(M1 = elements[1], n1 = numbers[1], M2 = elements[2], n2 = numbers[2]) |>
    mutate(
      n1 = ifelse(is.na(n1), 1L, as.integer(n1)),
      n2 = ifelse(is.na(n2), 1L, as.integer(n2))
    )
}

molecular_weight <- function(x) {
  elements <- identify_oxide(x)
  elements$n1 * PeriodicTable::mass(elements$M1) + elements$n2 * PeriodicTable::mass(elements$M2)
}


apfu <- function(x, n_oxygen) {
  res <- data.frame(Element = names(x), Oxide_wt = x, row.names = NULL) |>
    cbind(t(sapply(names(x), identify_oxide))) |>
    mutate(
      mol_wt = sapply(Element, molecular_weight),
      Oxide_mol = Oxide_wt / mol_wt,
      Oxygen = as.numeric(n2) * Oxide_mol,
      norm_fact = n_oxygen / sum(Oxygen),
      Anions_n = Oxygen * norm_fact,
      O_per_Cat = as.numeric(n2) / as.numeric(n1),
      Cations_n = Anions_n / O_per_Cat
    )
  structure(c(dplyr::pull(res, Cations_n), n_oxygen), names = c(res$M1, "O"))
}


wt_to_molwt <- function(x){
  oxides <- names(x)

  f = oxides |>
    sapply(identify_oxide) |>
    t()

  ox_molwt <- sapply(oxides, molecular_weight)
  wt <- as.matrix(x)

  res = wt/ox_molwt * 100 * as.numeric(f[, 2])
  colnames(res) <- as.character(f[, 1])
  res
}
