### Created by Justin Freels
### email: jfreels@gmail.com
### twitter: https://twitter.com/jfreels4
### github: https://github.com/jfreels

# Load libraries
libs<-c("lubridate","plyr","reshape2","ggplot2","xts","PerformanceAnalytics")
lapply(libs,require,character.only=TRUE)

# load functions
longToXts<-function (longDataFrame) { xts(longDataFrame[,-1],longDataFrame[,1]) }
xtsToLong<-function (Xts) { 
  df<-data.frame(date=index(Xts),coredata(Xts)) 
  names(df)<-c("date",names(Xts))
  df<-melt(df,id.vars="date")
  names(df)<-c("date","fund","return")
  df
}

# load example dataset
setwd("~/ShinyApps/fund_import")
example<-read.csv("example.csv")
example$date<-ymd(example$date)
example<-dcast(example,date~fund,value.var="return")

##### SHINY SERVER
shinyServer(function(input, output) {
  
# reactive: upload_dataset
  upload_dataset <- reactive({
    if (is.null(input$csv)) { return(NULL) }
    d<-read.csv(input$csv$datapath,check.names=FALSE)
    d$date<-ymd(d$date)
    d
  })

# reactive: dataset
  dataset <- reactive({
    if (input$upload=="Yes") { upload_dataset() }
    else { example }
  })
  
# reactive: datasetXts
  datasetXts <- reactive({
    xts(dataset()[,-1],dataset()[,1])
  })
  
# reactive: choice
  choice <- reactive({
    if(input$upload=="No") { input$upload_choose_fund }
    else { input$example_choose_fund }
  })

  
### sideBarPanel reactive UIs
  output$example_choose_fund<-renderUI({
    if (input$upload=="No") { return(NULL) }
    conditionalPanel(
      condition="input.upload=='Yes'",
      selectInput(inputId="example_choose_fund",label="Choose Fund:",choices=names(upload_dataset()[-1]))
    )
  })
  
  output$upload_choose_fund<-renderUI({
    if (input$upload=="Yes") { return(NULL) }
    conditionalPanel(
      condition="input.upload=='No'",
      selectInput(inputId="upload_choose_fund",label="Choose Fund:",choices=names(example[-1]))
    )    
  })
  
### Tab: "Test"
  output$test<-renderPrint({
    as.matrix(datasetXts()[,choice()])
  })
  
### Tab: VAMI
  output$chart_vami<-renderPlot({
    chart.CumReturns(as.xts(as.matrix(datasetXts()[,choice()])),wealth.index=TRUE)
  })
  
### Tab: "Example"
  output$example<-renderTable({
    example$date<-as.character(example$date)
    head(na.omit(example[,1:3]),10)
  },digits=4)
    
})