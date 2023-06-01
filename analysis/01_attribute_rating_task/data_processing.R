### CLEANING THE DATA ###

# load data
art <- read.csv("C:/Users/flick/Downloads/raw_data_31May2023.csv")

# select relevant trials
art <- art[art$trial_index > 5 & art$trial_index < 93,]

# select relevant columns
art = art[c("workerid","clip","response","speaker")]
art <- subset(art, !is.na(response) & response != "")
colnames(art)[1] = "id" # rename column

# remove curly braces from "response" column
art$response<-gsub("\\{","",art$response)
art$response<-gsub("\\}","",art$response)

# remove single quotes from "response" column
art$response<-gsub("'","",art$response)

# create empty data frame
art_new <- data.frame()

# loop through the initial data frame to split the responses up
for (i in 1:nrow(art)) {
  response_split <- strsplit(art$response[i], ",")
  for (j in 1:length(response_split[[1]])) {
    art_new <- rbind(art_new, 
                      data.frame(id = art$id[i], 
                                 clip = art$clip[i],
                                 speaker = art$speaker[i],
                                 response = response_split[[1]][j]))
  }
}

# remove leading spaces in the "response" column
art_new$response <- trimws(art_new$response)

# split data in "response" column into two based on colon
art_new <- separate(art_new, response, into = c("factor", "value"), sep =": ")

# create new data frame for each of the six factors
rough <- art_new %>% filter(factor == "rough") %>% select(id, clip, speaker, rough = value)
casual <- art_new %>% filter(factor == "casual") %>% select(id, clip, casual = value)
honest <- art_new %>% filter(factor == "honest") %>% select(id, clip, honest = value)
proper <- art_new %>% filter(factor == "proper") %>% select(id, clip, proper = value)
easygoing <- art_new %>% filter(factor == "easygoing") %>% select(id, clip, easygoing = value)
fastspeaking <- art_new %>% filter(factor == "fastspeaking") %>% select(id, clip, fastspeaking = value)

# merge the data frames together
art <- merge(rough, merge(casual, merge(honest, merge(proper, merge(easygoing, fastspeaking, by = c("id", "clip")), by = c("id", "clip")), by = c("id", "clip")), by = c("id", "clip")), by = c("id", "clip"))
write.csv(art, "C:/Users/flick/Downloads/master_data_including_attn_31May2023.csv", row.names=FALSE)

#####

### FILTERING OUT ATTENTION CHECKS ###

# take out only rows that are attention checks
attn <- subset(art, speaker == "attention_check")

# add new empty column called "attention check"
attn$attention <- NA

# loop through to see if they answered all six options correctly
for (i in 1:nrow(attn)) {
  if (attn$clip[i] == "somewhatagree") {
    if (attn$rough[i] == 4 && attn$casual[i] == 4 && attn$honest[i] == 4 && attn$proper[i] == 4 && attn$easygoing[i] == 4 && attn$fastspeaking[i] == 4) {
      attn$attention[i] <- "pass"
    } else {
      attn$attention[i] <- "fail"
    }
  } else if (attn_test$clip[i] == "somewhatdisagree") {
    if (attn$rough[i] == 2 && attn$casual[i] == 2 && attn$honest[i] == 2 && attn$proper[i] == 2 && attn$easygoing[i] == 2 && attn$fastspeaking[i] == 2) {
      attn$attention[i] <- "pass"
    } else {
      attn$attention[i] <- "fail"
    }
  } else if (attn$clip[i] == "stronglyagree") {
    if (attn$rough[i] == 6  && attn$casual[i] == 6 && attn$honest[i] == 6 && attn$proper[i] == 6 && attn$easygoing[i] == 6 && attn$fastspeaking[i] == 6) {
      attn$attention[i] <- "pass"
    } else {
      attn$attention[i] <- "fail"
    }
  } else if (attn$clip[i] == "stronglydisagree") {
    if (attn$rough[i] == 0  && attn$casual[i] == 0 && attn$honest[i] == 0 && attn$proper[i] == 0 && attn$easygoing[i] == 0 && attn$fastspeaking[i] == 0) {
      attn$attention[i] <- "pass"
    } else {
      attn$attention[i] <- "fail"
    }
  } else {
    attn$attention[i] <- NA
  }
}

# manually inspect the "fail" rows
## if a participant answers four or fewer questions correctly, they are considered to have failed the trial
## if a participant fails two or more attention check trials, they are considered to have failed the attention checks
### in this case, their data will be excluded

# after inspection, exclude data from:
## 1290, 1311, 1323, 1339, 1356, 1374, 1474, 1604

# exclude the data from participants who failed attention checks
exclude_ids <- c("1290", "1311", "1323", "1339", "1356", "1374", "1474", "1604")
art_new <- art[!(art$id %in% exclude_ids), ]

# remove attention check rows from new data frame
art_new <- subset(art_new, speaker != "attention_check")

# add markhov rankings
art_new <- art_new %>%
  select(id:clip, speaker, rough, casual, honest, proper, easygoing, fastspeaking) %>%
  mutate (
    clip_rank = case_when(
      clip == "M1_01" ~ 16,
      clip == "M1_02" ~ 27,
      clip == "M1_03" ~ 26,
      clip == "M1_04" ~ 12,
      clip == "M2_01" ~ 40,
      clip == "M2_02" ~ 33,
      clip == "M2_03" ~ 38,
      clip == "M2_04" ~ 39,
      clip == "M3_01" ~ 1,
      clip == "M3_02" ~ 2,
      clip == "M3_03" ~ 4,
      clip == "M3_04" ~ 11,
      clip == "M4_01" ~ 28,
      clip == "M4_02" ~ 37,
      clip == "M4_03" ~ 31,
      clip == "M4_04" ~ 34,
      clip == "M5_01" ~ 3,
      clip == "M5_02" ~ 13,
      clip == "M5_03" ~ 14,
      clip == "M5_04" ~ 20,
      clip == "F1_01" ~ 15,
      clip == "F1_02" ~ 35,
      clip == "F1_03" ~ 32,
      clip == "F1_04" ~ 29,
      clip == "F2_01" ~ 6,
      clip == "F2_02" ~ 5,
      clip == "F2_03" ~ 19,
      clip == "F2_04" ~ 9,
      clip == "F3_01" ~ 7,
      clip == "F3_02" ~ 25,
      clip == "F3_03" ~ 10,
      clip == "F3_04" ~ 8,
      clip == "F4_01" ~ 17,
      clip == "F4_02" ~ 30,
      clip == "F4_03" ~ 22,
      clip == "F4_04" ~ 18,
      clip == "F5_01" ~ 21,
      clip == "F5_02" ~ 24,
      clip == "F5_03" ~ 23,
      clip == "F5_04" ~ 36
    )
  )

# add markhov scores
art_new <- art_new %>%
  select(id:clip, speaker, rough, casual, honest, proper, easygoing, fastspeaking, clip_rank) %>%
  mutate (
    clip_score = case_when(
      clip == "M1_01" ~ 0.018169617,
      clip == "M1_02" ~ 0.028218922,
      clip == "M1_03" ~ 0.02696179,
      clip == "M1_04" ~ 0.014735169,
      clip == "M2_01" ~ 0.065596691,
      clip == "M2_02" ~ 0.037960827,
      clip == "M2_03" ~ 0.052556086,
      clip == "M2_04" ~ 0.059150123,
      clip == "M3_01" ~ 0.003367623,
      clip == "M3_02" ~ 0.006378264,
      clip == "M3_03" ~ 0.008813734,
      clip == "M3_04" ~ 0.013449753,
      clip == "M4_01" ~ 0.028242256,
      clip == "M4_02" ~ 0.050428094,
      clip == "M4_03" ~ 0.035503484,
      clip == "M4_04" ~ 0.038071256,
      clip == "M5_01" ~ 0.007128886,
      clip == "M5_02" ~ 0.015584027,
      clip == "M5_03" ~ 0.016325555,
      clip == "M5_04" ~ 0.020458101,
      clip == "F1_01" ~ 0.016965039,
      clip == "F1_02" ~ 0.038585534,
      clip == "F1_03" ~ 0.036892293,
      clip == "F1_04" ~ 0.031933347,
      clip == "F2_01" ~ 0.010929073,
      clip == "F2_02" ~ 0.008914872,
      clip == "F2_03" ~ 0.019875982,
      clip == "F2_04" ~ 0.012412881,
      clip == "F3_01" ~ 0.011230533,
      clip == "F3_02" ~ 0.026941786,
      clip == "F3_03" ~ 0.012805009,
      clip == "F3_04" ~ 0.012303802,
      clip == "F4_01" ~ 0.01880579,
      clip == "F4_02" ~ 0.034770413,
      clip == "F4_03" ~ 0.023395184,
      clip == "F4_04" ~ 0.019366527,
      clip == "F5_01" ~ 0.022457065,
      clip == "F5_02" ~ 0.026667368,
      clip == "F5_03" ~ 0.024972075,
      clip == "F5_04" ~ 0.042675168
    )
  )

# add speaker gender
art_new <- art_new %>%
  select(id:clip, speaker, rough, casual, honest, proper, easygoing, fastspeaking, clip_rank, clip_score) %>%
  mutate (
    speaker_gender = case_when(
      speaker == "M1" ~ "male",
      speaker == "M2" ~ "male",
      speaker == "M3" ~ "male",
      speaker == "M4" ~ "male",
      speaker == "M5" ~ "male",
      speaker == "F1" ~ "female",
      speaker == "F2" ~ "female",
      speaker == "F3" ~ "female",
      speaker == "F4" ~ "female",
      speaker == "F5" ~ "female"
    )
  )

# add phonetic features
features <- read.csv("C:/Users/flick/Desktop/Research/Phonetic correlates of Singlish/phoneticfeatures.csv") # load csv
colnames(features)[1] = "speaker" # rename column
list_df = list(art_new, features)
art_new <- list_df %>% reduce(inner_join, by='clip')

# remove duplicate columns
art_new <- subset(art_new, select = -c(speaker.y, speaker_gender.y))

# rename speaker and speaker_gender columns
colnames(art_new)[3] = "speaker"
colnames(art_new)[12] = "speaker_gender"

# save new data frame! this is the one that will be used for models
write.csv(art_new, "C:/Users/flick/Downloads/master_data_31May2023.csv", row.names=FALSE)

#####

### GETTING DEMOGRAPHIC DATA ###

# load raw data again
raw_data <- read.csv("C:/Users/flick/Downloads/raw_data_31May2023.csv")

# select relevant trials
raw_data <- raw_data[raw_data$trial_index > 92 & raw_data$trial_index < 102,]

# select relevant columns
raw_data = raw_data[c("workerid","response")]
raw_data <- subset(raw_data, !is.na(response) & response != "")
colnames(raw_data)[1] = "id" # rename column

# remove curly braces from "response" column
raw_data$response<-gsub("\\{","",raw_data$response)
raw_data$response<-gsub("\\}","",raw_data$response)

# remove single quotes from "response" column
raw_data$response<-gsub("'","",raw_data$response)

# Remove square brackets from data
raw_data$response<-gsub("\\[","",raw_data$response)
raw_data$response<-gsub("\\]","",raw_data$response)

# create new data frame
questionnaire <- data.frame()

# splitting the response column
for (i in 1:nrow(raw_data)) {
  response_split <- strsplit(raw_data$response[i], ",")
  for (j in 1:length(response_split[[1]])) {
    questionnaire <- rbind(questionnaire, 
                      data.frame(id = raw_data$id[i], 
                                 response = response_split[[1]][j]))
  }
}

# remove leading spaces in the "response" column
questionnaire$response <- trimws(questionnaire$response)

# split data in "response" column into two based on colon
questionnaire <- separate(questionnaire, response, into = c("factor", "value"), sep =": ")

# create new data frame for age, race, gender, income, and education + other relevant things
age <- questionnaire %>% filter(factor == "age") %>% select(id, age = value)
race <- questionnaire %>% filter(factor == "race") %>% select(id, race = value)
gender <- questionnaire %>% filter(factor == "gender") %>% select(id, gender = value)
income <- questionnaire %>% filter(factor == "income") %>% select(id, income = value)
education <- questionnaire %>% filter(factor == "education") %>% select(id, education = value)
instructions_correct <- questionnaire %>% filter(factor == "instructions_correct") %>% select(id, instructions_correct = value)
previous_study <- questionnaire %>% filter(factor == "previous_study") %>% select(id, previous_study = value)
fair <- questionnaire %>% filter(factor == "fair") %>% select(id, fair = value)
enjoy <- questionnaire %>% filter(factor == "enjoy") %>% select(id, enjoy = value)

# get payment data
payment <- questionnaire %>% filter(factor == "payment") %>% select(id, payment = value)
write.csv(payment, "C:/Users/flick/Downloads/payment_details.csv", row.names=FALSE)

# join factors together by id
list_df = list(age, race, gender, income, education, instructions_correct, previous_study, fair, enjoy)
questionnaire_data <- list_df %>% reduce(inner_join, by='id')

# merge questionnaire data with rating data
list_df = list(art_new, questionnaire_data)
art_data <- list_df %>% reduce(inner_join, by='id')

# save full data
write.csv(art_data, "C:/Users/flick/Downloads/master_data_with_questionnaire_31May2023.csv", row.names=FALSE)