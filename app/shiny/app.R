## app.R ##
library(shinydashboard)
library(stringr)
library(tidyverse)
library(dplyr)
library(shinyalert)
library(httr)
library(jsonlite)
library(DT)


ui <- dashboardPage(
  dashboardHeader(
    title = strong("Diabetes binary classification"),
    titleWidth = 350)
  , skin = "purple",
  
  dashboardSidebar(
    sidebarMenu(
      id="tabs",
      menuItem("Dashboard description", tabName = "description", icon = icon("bookmark",lib = "glyphicon")),
      menuItem(" Data overview", tabName = "overview", icon = icon("chart-line")),
      menuItem("Add ", tabName = "add", icon = icon("plus")),
      menuItem("Delete", tabName = "delete", icon = icon("minus")),
      menuItem("Search ", tabName = "search", icon = icon("magnifying-glass")),
      menuItem("Update", tabName = "update", icon = icon("pen")),
      menuItem("Predict", tabName = "predict", icon = icon("paper-plane"))
    )
  ),
  
  
  dashboardBody(
    tags$head(
      tags$style(HTML('.content-wrapper { overflow: auto;}'))
    )
    ,tabItems(
      # 1 tab content
      tabItem(
        tabName = "description"
        # Title 
        ,h2("Diabetes binary classification dashboard "
            ,style = "margin-bottom: 20px; font-weight: bold; padding: 0.5em; color: #6753C6 ")
        ,mainPanel(
          # Dashboard description
          div(p("- This dashboard was created thanks to the dataset obtained from the National Institute of Diabetes and Digestive and Kidney Diseases,
                each row of the dataset contains a patient observation indicating his/her measurements for 9 main diagnostic indicators. 
                More information of the dataset can be found ",a("here.", href = "https://www.kaggle.com/datasets/mathchi/diabetes-data-set"))
              ,br()
              ,p("- The objective of this dashboard is to predict based on diagnostic measurements whether a patient has diabetes or not, while allowing the user to add/delete/search and update any new observation. 
                The dashboard is organized in the following sections: ")
              , style = "color:#595959
                           ;font-size:18px
                           ;background-color:#FFFFFF
                           ;padding-left:15px 
                           ;padding-right:15px
                           ;padding-bottom:15px
                           ;padding-top:15px
                           ;left:11%
                           ;right:11%
                           ;display: inline-block
                           ;max-width:150000px
                           ;width: 825px;
              ")
          # Tab 1 - Section 1 
          ,div(strong("Data overview", style = "color:#595959;font-size:18px
                                                ;padding-left:15px;width: 100em
                                                ;border: 1px solid #333
                                                ;box-shadow: 8px 8px 5px #444
                                                ;padding: 8px 28px
                                                ;background-image: linear-gradient(180deg, #fff, #ddd 40%, #ccc)
                                                ;position:relative; left:5px; top:20px;width: 825px"))
          ,div(" In this first section the user can find data visualizations of some of the main measurements of the dataset in order to give insights about the data distribution."
               , style = "color:#595959;font-size:18px;padding-left:30px
                          ;position:relative; left:170px; top:-15px;width: 645px;")
          #Tab 1 -Section 2
          ,div(strong("Add section", style = "color:#595959;font-size:18px
                                                ;padding-left:15px;width: 100em
                                                ;border: 1px solid #333
                                                ;box-shadow: 8px 8px 5px #444
                                                ;padding: 8px 40px
                                                ;background-image: linear-gradient(180deg, #fff, #ddd 40%, #ccc)
                                                ;position:relative; left:5px; top:20px;"))
          ,div(" In this section, the user will be able to input a new observation by filling in the necessary measurements."
               , style = "color:#595959;font-size:18px;padding-left:30px;position:relative; left:170px; top:-20px;width: 650px;")
          #Tab 1 -Section 3
          ,div(strong("Delete section", style = "color:#595959;font-size:18px
                                                ;padding-left:15px;width: 15em
                                                ;border: 1px solid #333
                                                ;box-shadow: 8px 8px 5px #444
                                                ;padding: 8px 32px
                                                ;background-image: linear-gradient(180deg, #fff, #ddd 40%, #ccc)
                                                ;position:relative; left:5px; top:20px;"))
          ,div(" The purpose of this section is to allow the user to delete an observation by inputting an observation ID."
               , style = "color:#595959;font-size:18px;padding-left:30px;position:relative; left:170px; top:-15px;width: 650px;")
          #Tab 1 -Section 4
          ,div(strong("Search section", style = "color:#595959;font-size:18px
                                                ;padding-left:15px;width: 15em
                                                ;border: 1px solid #333
                                                ;box-shadow: 8px 8px 5px #444
                                                ;padding: 8px 30px
                                                ;background-image: linear-gradient(180deg, #fff, #ddd 40%, #ccc)
                                                ;position:relative; left:5px; top:20px;"))
          ,div("In this section the users will be able to query all the data of an observation by inputting the desired observation ID."
               , style = "color:#595959;font-size:18px;padding-left:30px;position:relative; left:170px; top:-20px;width: 650px;")
          #Tab 1 -Section 5
          ,div(strong("Update section", style = "color:#595959;font-size:18px
                                                ;padding-left:15px;width: 15em
                                                ;border: 1px solid #333
                                                ;box-shadow: 8px 8px 5px #444
                                                ;padding: 8px 27px
                                                ;background-image: linear-gradient(180deg, #fff, #ddd 40%, #ccc)
                                                ;position:relative; left:5px; top:20px;"))
          ,div("In this section the user will be able to modify an observation by inputting an observation ID. "
               , style = "color:#595959;font-size:18px;padding-left:30px;position:relative; left:170px; top:-15px;width:650px;")
          #Tab 1 -Section 6
          ,div(strong("Prediction section", style = "color:#595959;font-size:18px
                                               ;padding-left:15px;width: 15em
                                               ;border: 1px solid #333
                                               ;box-shadow: 8px 8px 5px #444
                                               ;padding: 8px 12px
                                               ;background-image: linear-gradient(180deg, #fff, #ddd 40%, #ccc)
                                               ;position:relative; left:5px; top:20px;"))
          ,div("If the user wants to get a prediction of cancer, he/she should input in this section the diagnostic measurements."
               , style = "color:#595959;font-size:18px;padding-left:30px;position:relative; left:170px; top:-10px;width: 650px;")
          
        )
        
        
      ),
      
      # 2 tab content
      tabItem(tabName = "overview"
              #,h5(textOutput("add_overview_message"),style = ("color:green; font-weight: bold;")) 
              ,fluidRow(
                box(
                radioButtons("radio", label = h4("Select data to visualize"),
                             choices = list("All data" = 1, "Cancer observations" = 2, "Non cancer observations" = 3), 
                             selected = 1))
              )
              
              ,fluidRow(
                column(6,
                       box(
                         title = "Number of observations with diabetes"
                         ,status="danger", solidHeader = TRUE
                         , height = 130
                         ,div(strong(textOutput("diabetes_num"), style= "text-align: center
                                                                          ;font-size:25px
                                                                          ;color:#595959;"))
                       ))
                       
    
                ,column(6,
                        box(
                          title = "Number of observations without diabetes"
                          ,status="success", solidHeader = TRUE
                          , height = 130
                          ,div(strong(textOutput("non_diabetes_num"), style= "text-align: center
                                                                          ;font-size:25px
                                                                          ;color:#595959;"))
                        ))
                )
              ,fluidRow(
                box(plotOutput("glucose_hist", height = 250)),
                box(plotOutput("boxplot_preg", height = 250))
              )
              ,fluidRow(
                box(plotOutput("insulin_hist", height = 250)),
                box(plotOutput("boxplot_age", height = 250))
              )
              
              
              
      ), 
      
      # 3 tab content
      tabItem(tabName = "add"
              #,h5(textOutput("add_validation_message"),style = ("color:green; font-weight: bold;"))
              ,box(
                title = "Add an observation",status="success", solidHeader = TRUE
                , width = 10 
                , height = 15
                ,div(em(strong("Complete the following fields to add an observation", style = ("color:grey"))))
                ,textInput(inputId="add_preg_txt" , label = "pregnancies:" , placeholder= "Number of times pregnant")
                ,textInput(inputId="add_glucose_txt", label = "glucose:", placeholder= "Plasma glucose concentration a 2 hours in an oral glucose tolerance test")
                ,textInput(inputId="add_blood_txt", label = "Blood Pressure:", placeholder="Diastolic blood pressure (mm Hg)")
                ,textInput(inputId="add_skin_txt", label = "Skin Thickness:", placeholder="Triceps skin fold thickness (mm)")
                ,textInput(inputId="add_insulin_txt", label = "insulin:", placeholder="2-Hour serum insulin (mu U/ml)")
                ,textInput(inputId="add_bmi_txt", label = "BMI:", placeholder="Body mass index (weight in kg/(height in m)^2)")
                ,textInput(inputId="add_pedegree_txt", label = "Diabetes Pedigree Function:", placeholder="Diabetes pedigree function")
                ,textInput(inputId="add_age_txt", label = "age:", placeholder="age in years")
                ,textInput(inputId="add_cancer_txt", label = "Cancer:", placeholder=" Input 1 if cancer, 0 if not  ")
                ,useShinyalert()  # Set up shinyalert
                ,actionButton(inputId= "add_button",label="Submit new observation",style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
                
              )
      ), 
      
      # 4 tab content
      tabItem(tabName = "delete"
              #,h5(textOutput("delete_validation_message"),style = ("color:green; font-weight: bold;"))
              ,box(
                title = "Delete an observation",status="danger", solidHeader = TRUE, width = 10 , height = 10
                ,div(em(strong("Complete the following field to delete an observation", style = ("color:grey"))))
                ,textInput(inputId="delete_id_txt" , label = "ID:" , placeholder= "ID of the observation to delete ")
                ,useShinyalert()  # Set up shinyalert
                ,actionButton(inputId= "delete_button",label="Delete the observation",style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
                
              )
              
      ), 
      
      # 5 tab content
      tabItem(tabName = "search"
              ,dataTableOutput("observation")
              #,h5(textOutput("search_validation_message"),style = ("color:green; font-weight: bold;"))
              ,box(
                title = "Search for an observation",status="info", solidHeader = TRUE, width = 10 , height = 10
                ,div(em(strong("Complete the following field to search for an observation", style = ("color:grey"))))
                ,textInput(inputId="search_id_txt" , label = "ID:" , placeholder= "ID of the observation to search ")
                ,useShinyalert()  # Set up shinyalert
                ,actionButton(inputId= "search_button",label="Search for this observation",style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
                
              )
              
              
      ), 
      
      # 6 tab content
      tabItem(tabName = "update"
              #,h5(textOutput("update_validation_message"),style = ("color:green; font-weight: bold;"))
              ,box(
                title = "Update an observation",status="warning", solidHeader = TRUE, width = 10 , height = 10
                ,div(em(strong("Complete the following fields to update an observation", style = ("color:grey"))))
                ,textInput(inputId="update_id_txt", label = "ID:" , placeholder= "ID of the observation to update")
                ,textInput(inputId="update_preg_txt", label = "pregnancies:" , placeholder= "Number of times pregnant")
                ,textInput(inputId="update_glucose_txt", label = "glucose:", placeholder= "Plasma glucose concentration a 2 hours in an oral glucose tolerance test")
                ,textInput(inputId="update_blood_txt ", label = "Blood Pressure:", placeholder="Diastolic blood pressure (mm Hg)")
                ,textInput(inputId="update_skin_txt ", label = "Skin Thickness:", placeholder="Triceps skin fold thickness (mm)")
                ,textInput(inputId="update_insulin_txt", label = "insulin:", placeholder="2-Hour serum insulin (mu U/ml)")
                ,textInput(inputId="update_bmi_txt", label = "BMI:", placeholder="Body mass index (weight in kg/(height in m)^2)")
                ,textInput(inputId="update_pedegree_txt", label = "Diabetes Pedigree Function:", placeholder="Diabetes pedigree function")
                ,textInput(inputId="update_age_txt", label = "age:", placeholder="age in years")
                ,textInput(inputId="update_cancer_txt", label = "Cancer:", placeholder=" Input 1 if cancer, 0 if not")
                ,useShinyalert()  # Set up shinyalert
                ,actionButton(inputId="update_button",label="Update this observation",style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
              )
              
      ), 
      
      # 7 tab content
      tabItem(tabName = "predict"
              #,h5(textOutput("predict_validation_message"),style = ("color:green; font-weight: bold;"))
              ,box(
                title = "Prediction based on an observation",status="primary", solidHeader = TRUE,width = 10 , height = 10
                ,div(em(strong("Complete the following fields to make a prediction for an observation", style = ("color:grey"))))
                ,textInput(inputId="predict_preg_txt" , label = "pregnancies:" , placeholder= "Number of times pregnant")
                ,textInput(inputId="predict_glucose_txt", label = "glucose:", placeholder= "Plasma glucose concentration a 2 hours in an oral glucose tolerance test")
                ,textInput(inputId="predict_blood_txt", label = "Blood Pressure:", placeholder="Diastolic blood pressure (mm Hg)")
                ,textInput(inputId="predict_skin_txt", label = "Skin Thickness:", placeholder="Triceps skin fold thickness (mm)")
                ,textInput(inputId="predict_insulin_txt", label = "insulin:", placeholder="2-Hour serum insulin (mu U/ml)")
                ,textInput(inputId="predict_bmi_txt", label = "BMI:", placeholder="Body mass index (weight in kg/(height in m)^2)")
                ,textInput(inputId="predict_pedegree_txt", label = "Diabetes Pedigree Function:", placeholder="Diabetes pedigree function")
                ,textInput(inputId="predict_age_txt", label = "age:", placeholder="age in years")
                ,useShinyalert()  # Set up shinyalert
                ,actionButton(inputId= "predict_button",label="Predict this observation",style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
                
              )
              
      )
      
    )
  )
)

server <- function(input, output) {
  
  # ----------- GET INFO FOR DASHBOAD  -----------
  
  observeEvent(input$tabs, {
    if (input$tabs == "overview" ){
      
      # Get dashboard filter 
      radio_choice <- input$radio 
      
      # Get data 
      # diabetes_original <-read.csv("../data/diabetes.csv")
      resp <- GET('web:8080/')
      diabetes_original<- fromJSON(content(resp, as='text'))
      
      # ALL values
      if(radio_choice == 1){
        diabetes_df <- diabetes_original
      }
      # cancer values
      if(radio_choice == 2){
        diabetes_df <-filter(diabetes_original,outcome == "1")
      }
      # non cancer values 
      if(radio_choice == 3){
        diabetes_df <-filter(diabetes_original,outcome == "0")
      }
      
      # Get number of people with diabetes 
      output$diabetes_num <- renderText(toString(filter(diabetes_df,outcome == "1") %>% count()))
      
      # Get number of people with non-diabetes 
      output$non_diabetes_num <- renderText(toString(filter(diabetes_df,outcome == "0") %>% count()))
      
      # Histogram of glucose
      output$glucose_hist <- renderPlot({
        hist(diabetes_df$glucose,
             main = "Histogram of glucose"
             ,xlab = "glucose"
             ,ylab = "Number of observations"
             ,col = "lightgray"
        )
      })
      
      # Box plot of pregnancies
      output$boxplot_preg <- renderPlot({
        boxplot( diabetes_df$pregnancies
                 ,col = "lightgray"
                 ,main = "Box plot of pregnancies"
                 ,xlab = "Number of pregnancies"
                 ,ylab = ""
                 , horizontal=TRUE
        )
      })
      
      # Box plot of ages
      output$boxplot_age <- renderPlot({
        boxplot( diabetes_df$age
                 ,col = "lightgray"
                 ,main = "Box plot of age"
                 ,xlab = "age in years"
                 ,ylab = ""
                 , horizontal=TRUE
        )
      })
      
     
      # Histogram of insulin
      output$insulin_hist <- renderPlot({
        hist(diabetes_df$insulin,
             main = "Histogram of insulin"
             ,xlab = "insulin"
             ,ylab = "Number of observations"
             ,col = "lightgray"
        )
      })
   
   
      
      
       }

  })
  
  # ----------- GET INFO FOR DASHBOAD IF THE RADIO BUTTON CHANGED  -----------
  
  observeEvent(input$radio, {
      
      # Get dashboard filter 
      radio_choice <- input$radio 
      
      # Get data 
      # diabetes_original <-read.csv("/app/data/diabetes.csv") # Fake data, to test with API  please comment this line
      
      # -- Using API method 
      resp <- GET('web:8080/')
      diabetes_original<- fromJSON(content(resp, as='text'))
      
      # ALL values
      if(radio_choice == 1){
        diabetes_df <- diabetes_original
      }
      # cancer values
      if(radio_choice == 2){
        diabetes_df <-filter(diabetes_original,outcome == "1")
      }
      # non cancer values 
      if(radio_choice == 3){
        diabetes_df <-filter(diabetes_original,outcome == "0")
      }
      
      # Get number of people with diabetes 
      output$diabetes_num <- renderText(toString(filter(diabetes_df,outcome == "1") %>% count()))
      
      # Get number of people with non-diabetes 
      output$non_diabetes_num <- renderText(toString(filter(diabetes_df,outcome == "0") %>% count()))
      
      # Histogram of glucose
      output$glucose_hist <- renderPlot({
        hist(diabetes_df$glucose,
             main = "Histogram of glucose"
             ,xlab = "glucose"
             ,ylab = "Number of observations"
             ,col = "lightgray"
        )
      })
      
      # Box plot of pregnancies
      output$boxplot_preg <- renderPlot({
        boxplot( diabetes_df$pregnancies
                 ,col = "lightgray"
                 ,main = "Box plot of pregnancies"
                 ,xlab = "Number of pregnancies"
                 ,ylab = ""
                 , horizontal=TRUE
        )
      })
      
      # Box plot of ages
      output$boxplot_age <- renderPlot({
        boxplot( diabetes_df$age
                 ,col = "lightgray"
                 ,main = "Box plot of age"
                 ,xlab = "age in years"
                 ,ylab = ""
                 , horizontal=TRUE
        )
      })
      
      
      # Histogram of insulin
      output$insulin_hist <- renderPlot({
        hist(diabetes_df$insulin,
             main = "Histogram of insulin"
             ,xlab = "insulin"
             ,ylab = "Number of observations"
             ,col = "lightgray"
        )
      })
      
      
      
      
    
    
  })
  
  # ----------- ADD A VALUE  -----------
  observeEvent(input$add_button, {
    add_array <- c(
      as.numeric(input$add_preg_txt) #0
      ,as.numeric(input$add_glucose_txt) #1
      ,as.numeric(input$add_blood_txt ) #2
      ,as.numeric(input$add_skin_txt) #3
      ,as.numeric(input$add_insulin_txt) #4
      ,as.numeric(input$add_bmi_txt) #5
      ,as.numeric(input$add_pedegree_txt) #6
      ,as.numeric(input$add_age_txt) #7
      ,as.numeric(input$add_cancer_txt) #8 
    )
    output$add_validation_message <-renderText(toString(add_array))
    
   # -- Using API method   
   POST('web:8080/crud', 
          body=toJSON(data.frame(
            pregnancies = add_array[1]
            ,glucose = add_array[2]
            ,bloodpressure = add_array[3]
            ,skinthickness = add_array[4]
            ,insulin = add_array[5]
            ,bmi = add_array[6]
            ,diabetespedigreefunction = add_array[7]
            ,age = add_array[8]
            ,outcome = add_array[9])))
    
    shinyalert(
      title = "A new observation has been added",
      text = toString(add_array),
      size = "s", 
      closeOnEsc = TRUE,
      closeOnClickOutside = FALSE,
      html = FALSE,
      type = "success",
      showConfirmButton = TRUE,
      showCancelButton = FALSE,
      confirmButtonText = "OK",
      confirmButtonCol = "#AEDEF4",
      timer = 0,
      imageUrl = "",
      animation = TRUE
    )
  })
  
  # ----------- DELETE A VALUE  -----------
  observeEvent(input$delete_button, {
    delete_array <- c(
       as.numeric(input$delete_id_txt)  #0
    )
    output$delete_validation_message <-renderText(toString(delete_array))
    
    # -- Using API method 
    DELETE(paste0('web:8080/crud?id=', delete_array[1]))
    
    shinyalert(
      title = "An observation has been deleted",
      text = toString(delete_array),
      size = "s", 
      closeOnEsc = TRUE,
      closeOnClickOutside = FALSE,
      html = FALSE,
      type = "success",
      showConfirmButton = TRUE,
      showCancelButton = FALSE,
      confirmButtonText = "OK",
      confirmButtonCol = "#AEDEF4",
      timer = 0,
      imageUrl = "",
      animation = TRUE
    )
    
    
  })
  
  # ----------- SEARCH FOR A VALUE  -----------
  observeEvent(input$search_button, {
    search_array <- c(
      as.numeric(input$search_id_txt)  #0
    )
    output$search_validation_message <-renderText(toString(search_array))
    
    # -- Using API method 
    resp_search <- GET(paste0('web:8080/crud?id=', search_array[1]))
    # resp_search <- GET('web:8080/')
    print(typeof(fromJSON(content(resp_search, as='text'))))
    
    ## Get tabla con el search 
    output$observation = renderDataTable({
      df <- data.frame(fromJSON(content(resp_search, as='text')))
    
    })
  })
  
  # ----------- UPDATE VALUES  -----------
  observeEvent(input$update_button, {
    update_array <- c(
       as.numeric(input$update_id_txt)  #0
      ,as.numeric(input$update_preg_txt ) #1
      ,as.numeric(input$update_glucose_txt) #2
      ,as.numeric(input$update_blood_txt ) #3
      ,as.numeric(input$update_skin_txt) #4
      ,as.numeric(input$update_insulin_txt) #5
      ,as.numeric(input$update_bmi_txt) #6
      ,as.numeric(input$update_pedegree_txt) #7
      ,as.numeric(input$update_age_txt) #8
      ,as.numeric(input$update_cancer_txt) #9 
    )
    output$update_validation_message <-renderText(toString(update_array))
    
    print(update_array)
    
    # -- Using API method 
    PATCH(paste0('web:8080/crud?id=', update_array[1]),
          body=toJSON(
              data.frame(
                pregnancies = update_array[2]
                ,glucose = update_array[3]
                ,bloodpressure = update_array[4]
                ,skinthickness = update_array[5]
                ,insulin = update_array[6]
                ,bmi = update_array[7]
                ,diabetespedigreefunction = update_array[8]
                ,age = update_array[9]
                ,outcome = update_array[10])
              ))
    
    
    shinyalert(
      title = "If the observation exists, it has been updated ",
      text = toString(update_array),
      size = "s", 
      closeOnEsc = TRUE,
      closeOnClickOutside = FALSE,
      html = FALSE,
      type = "success",
      showConfirmButton = TRUE,
      showCancelButton = FALSE,
      confirmButtonText = "OK",
      confirmButtonCol = "#AEDEF4",
      timer = 0,
      imageUrl = "",
      animation = TRUE
    )
  }) 
  
  # ----------- PREDICT A VALUE  -----------
  observeEvent(input$predict_button, {
    predict_array <- c(
       as.numeric(input$predict_preg_txt ) #0
      ,as.numeric(input$predict_glucose_txt) #1
      ,as.numeric(input$predict_blood_txt ) #2
      ,as.numeric(input$predict_skin_txt) #3
      ,as.numeric(input$predict_insulin_txt) #4
      ,as.numeric(input$predict_bmi_txt) #5
      ,as.numeric(input$predict_pedegree_txt) #6
      ,as.numeric(input$predict_age_txt) #7
    )
    output$predict_validation_message <-renderText(toString(predict_array))
    
    print(predict_array)
    
    # -- Using API method 
    prediction_value <- POST('web:8080/predict', 
                               body=toJSON(data.frame(
                                  pregnancies = predict_array[1]
                                  ,glucose =predict_array[2]
                                  ,bloodpressure = predict_array[3]
                                  ,skinthickness = predict_array[4]
                                  ,insulin = predict_array[5]
                                  ,bmi= predict_array[6]
                                  ,diabetespedigreefunction = predict_array[7]
                                  ,age = predict_array[8])))
    
    outcome <- fromJSON(content(prediction_value, as='text'))
    diabetes <- "It is unlikely that the patient has diabetes"
    if(outcome$outcome == 1){diabetes <- "It is highly likely that the patient has diabetes"}
    
    shinyalert(
      title = "The prediction of your observation is :  ",
      text = toString(diabetes),
      size = "s", 
      closeOnEsc = TRUE,
      closeOnClickOutside = FALSE,
      html = FALSE,
      #type = "success",
      showConfirmButton = TRUE,
      showCancelButton = FALSE,
      confirmButtonText = "OK",
      confirmButtonCol = "#AEDEF4",
      timer = 0,
      imageUrl = "",
      animation = TRUE
    )
  }) 
  

  

  
  
}

shinyApp(ui, server)


