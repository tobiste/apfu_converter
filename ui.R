fluidPage(
  # App title ----
  headerPanel(
    HTML("<p>Converts wt.% to molar weight (g/mol) or apfu (atom per formula unit)</p>")
  ),
  sidebarLayout(
    # Sidebar panel for inputs ----
    sidebarPanel(
      fileInput("file", "Choose xlsx file",
        accept = c(".xlsx")
      ),
      helpText(
        "Table has to be arranged with oxides in columns and samples in rows.",
        "First row must contain the names of the oxides as Al2O3, SiO2, MgO etc.",
        "Note: There will be an error due to case sensitivity (not working: AL2o3) and when there are typos (e.g. MgX).",
        "No columns other than the oxides are allowed."
      ),

      # selectInput("input_type", "Input data type",
      #             choices = list(
      #               "wt" = "wt.%",
      #               "mol" = "molar weight"
      #             ),
      #             selected = "wt"
      # ),

      selectInput("output_type", "Output data type",
        choices = list(
          "apfu" = "apfu",
          # "wt" = "wt.%",
          "mol" = "molar wt.%"
        ),
        selected = "apfu"
      ),
      numericInput("nO", "Number of oxygens in mineral formula",
        value = 1,
        min = 0
      ),
      numericInput("round", "Number of decimal digits",
        value = 3,
        min = 0, max = Inf
      ),
      helpText("Leave blank if no rounding is desired."),
      downloadButton("download", "Download as csv")
    ),

    # Main panel for displaying outputs ----
    mainPanel(
      dataTableOutput("apfu_dt")
    )
  )
)
