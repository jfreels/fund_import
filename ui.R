### Created by Justin Freels
### email: jfreels@gmail.com
### twitter: https://twitter.com/jfreels4
### github: https://github.com/jfreels


shinyUI(pageWithSidebar(
  headerPanel("File input test"),
  sidebarPanel(
    radioButtons(inputId="upload",label="Would you like to use an uploaded dataset?",choices=c("Yes","No"),selected="No"),
    conditionalPanel(
      condition="input.upload=='Yes'",
      helpText("Import data from a CSV file in the format of the \"Example\" tab."),
      helpText("The \"date\" column should be formatted yyyy/mm/dd."),
      fileInput(inputId="csv", label="Select CSV file:")
    ),
    uiOutput("example_choose_fund"),
    uiOutput("upload_choose_fund"),
    # contact info
    helpText(HTML("<br>*Created by: <a href = \"https://twitter.com/jfreels4\">@jfreels4</a>
                  <br>*github <a href = \"https://github.com/jfreels/fund_import\">code</a>
                  ")
    )
  ),
  mainPanel(
    tabsetPanel(
      #tabPanel("Test",
      #  verbatimTextOutput("test")
      #),
      tabPanel("VAMI",
        plotOutput("chart_vami")
      ),
      tabPanel("Example",
        tableOutput("example")
      )
    )
  )
))