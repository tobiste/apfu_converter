source('global.R')

olivine2 <- c(31.85, 58.85, 0.85, 8.49)
names(olivine2) <- c("SiO2", "FeO", "MnO", "MgO")
apfu(olivine2, 4)


olivine <- c(30.09, 0, 0, 0, 69.42, 0.28, 0.91, 0.08)
names(olivine) <- c("SiO2", "TiO2", "Al2O3", "Fe2O3", "FeO", "MnO", "MgO", "CaO")
apfu(olivine, 4)


my_example <- readxl::read_excel('chlorite_example.xlsx')

# wt% to apfu
my_example |>
  as.matrix() %>%
  replace(is.na(.), 0) |>
  apply(1, apfu, n_oxygen = 36) |>
  t() |>
  round(Inf)
  as.data.frame()


  # wt% to mol wt
  wt_to_molwt(my_example)
