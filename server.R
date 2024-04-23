function(input, output) {
  load_file <- reactive({
    inFile <- input$file

    if (is.null(inFile)) {
      return(NULL)
    } else {
      readxl::read_excel(inFile$datapath)
    }
  })

  number_oxygen <- reactive({
    nO <- input$nO
    if (!is.integer(nO)) {
      round(nO)
    } else {
      nO
    }
  })


  number_digits <- reactive({
    nd <- input$round
    if (is.na(input$round)) {
      Inf
    } else {
      nd
    }
  })

  convert_wt2apfu <- reactive({
    load_file() |>
      as.matrix() %>%
      replace(is.na(.), 0) |>
      apply(1, apfu, n_oxygen = number_oxygen()) |>
      t() |>
      round(number_digits()) |>
      as.data.frame()
  })

  convert_wt2mol <- reactive({
    load_file() |>
      wt_to_molwt() |>
      round(number_digits()) |>
      as.data.frame()
  })


  result <- reactive({
    if (!is.null(load_file())) {
      if (input$output_type == "apfu") {
        df <- convert_wt2apfu()
      } else {
        df <- convert_wt2mol()
      }
    } else {
      df <- NULL
    }

    validate(
      need(!is.null(df), "No data")
    )


    return(df)
  })


  output$apfu_dt <- renderDataTable({
    result()
  })

  output$download <- downloadHandler(
    filename = function() {
      "converted_data.csv"
    },
    content = function(fname) {
      write.csv(result(), fname)
    }
  )
}
