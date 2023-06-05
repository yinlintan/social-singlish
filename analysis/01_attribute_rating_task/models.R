### DATA ANALYSIS ###

library(tidyverse)
library(brms)
library(dplyr)
library(boot)
theme_set(theme_bw())
cbPalette <- c("#CC6677", "#332288", "#882255", "#999933", "#E69F00", "#117733", "#D55E00") 

# load data
# the recode file has +1 on all raw values, i.e., 0 -> 1, 1 -> 2, etc.
art_data <- read.csv("C:/Users/flick/Downloads/art_data_recode.csv")

# recode ratings as factors
art_data$rough <- factor(art_data$rough, ordered=TRUE)
art_data$casual <- factor(art_data$casual, ordered=TRUE)
art_data$easygoing <- factor(art_data$easygoing, ordered=TRUE)
art_data$honest <- factor(art_data$honest, ordered=TRUE)
art_data$proper <- factor(art_data$proper, ordered=TRUE)
art_data$fastspeaking <- factor(art_data$fastspeaking, ordered=TRUE)

# center the clip scores (dep. variable)
art_data = art_data %>% 
  mutate(c.clip_score = as.numeric(clip_score) - mean(as.numeric(clip_score)))

### DECIDING WHICH MODEL TO USE? ###

# cumulative link model

## model with random slope for Singlish score by participant
m.logit = brm(rough ~ c.clip_score + (1|clip) + (1+c.clip_score|id) + (1|speaker),
              data=art_data,
              family=cumulative(),
              cores=4)
summary(m.logit)
# what is the Bayes Factor and the probability of the Singlish score main effect being greater than 0?
h.logit <- hypothesis(m.logit, "c.clip_score > 0")
print(h.logit, digits = 4)

## model with random intercept for participant
m.logit.int = brm(rough ~ c.clip_score + (1|clip) + (1|id) + (1|speaker),
                  data=art_data,
                  family=cumulative(),
                  cores=4)
summary(m.logit.int)
# what is the Bayes Factor and the probability of the Singlish score main effect being greater than 0?
h.logit.int <- hypothesis(m.logit.int, "c.clip_score > 0")
print(h.logit.int, digits = 4)

## deciding which model is better? (1+c.clip_score|id) or (1|id)
loo(m.logit,m.logit.int)
# LOOIC difference is not more than twice the standard error
## here, we will use the more theoretically sensible model, i.e., with (1+c.clip_score|id)

# adjacent category model
m.acat = brm(rough ~ c.clip_score + (1|clip) + (1+c.clip_score|id) + (1|speaker),
             data=art_data,
             family=acat(),
             cores=4)
summary(m.acat)
h.acat <- hypothesis(m.acat, "c.clip_score > 0")
print(h.acat, digits = 4)

## decide whether to use cumulative link or adjacent category model?
loo(m.logit,m.acat)
# LOOIC difference is not more than twice the standard error
## we will use the model with a lower LOOIC estimate, i.e., the cumulative link model

### ACTUAL MODEL -- CUMULATIVE LINK ORDINAL REGRESSION MODEL ###
# Dependent Variable: Attribute Rating
# Fixed effect: Singlish (Markov) score (c.clip_score)
# Random effects: random intercept of speaker and clip, by-participant slope for Singlish score

## Rough
# full model
m.rough = brm(rough ~ c.clip_score + (1+c.clip_score|id) + (1|clip) + (1|speaker),
              data=art_data,
              save_all_pars=TRUE,
              family=cumulative(),
              cores=4)
summary(m.rough)
# null model
m.rough.null = brm(rough ~ (1+c.clip_score|id) + (1|clip) + (1|speaker),
              data=art_data,
              family=cumulative(),
              save_all_pars=TRUE,
              cores=4)
summary(m.rough.null)
# check bayes factor by comparing the two models
bayes_factor(m.rough, m.rough.null)
bayesfactor.rough <- bayes_factor(m.rough, m.rough.null)
print(bayesfactor.rough)
# check model
loo.rough <- loo(m.rough, m.rough.null)
print(loo.rough)
# what is the Bayes Factor and the probability of the Singlish score main effect being greater than 0?
m.rough <- hypothesis(m.rough, "c.clip_score > 0")
print(m.rough, digits = 4)

## Honest
# full model
m.honest = brm(honest ~ c.clip_score + (1+c.clip_score|id) + (1|clip) + (1|speaker),
               data=art_data,
               family=cumulative(),
               save_all_pars=TRUE,
               cores=4)
summary(m.honest)
# null model
m.honest.null = brm(honest ~ (1+c.clip_score|id) + (1|clip) + (1|speaker),
               data=art_data,
               family=cumulative(),
               save_all_pars=TRUE,
               cores=4)
summary(m.honest.null)
# what is the Bayes Factor and the probability of the Singlish score main effect being greater than 0?
h.honest <- hypothesis(m.honest, "c.clip_score > 0")
print(h.honest, digits = 4)

## Easygoing
m.easygoing = brm(easygoing ~ c.clip_score + (1+c.clip_score|id) + (1|clip) + (1|speaker),
                  data=art_data,
                  family=cumulative(),
                  cores=4)
summary(m.easygoing)
# what is the Bayes Factor and the probability of the Singlish score main effect being greater than 0?
h.easygoing <- hypothesis(m.easygoing, "c.clip_score > 0")
print(h.easygoing, digits = 4)

## Casual
m.casual = brm(casual ~ c.clip_score + (1+c.clip_score|id) + (1|clip) + (1|speaker),
               data=art_data,
               family=cumulative(),
               cores=4)
summary(m.casual)
# what is the Bayes Factor and the probability of the Singlish score main effect being greater than 0?
h.casual <- hypothesis(m.casual, "c.clip_score > 0")
print(h.casual, digits = 4)

## Fast-speaking
m.fastspeaking = brm(fastspeaking ~ c.clip_score + (1+c.clip_score|id) + (1|clip) + (1|speaker),
                     data=art_data,
                     family=cumulative(),
                     cores=4)
summary(m.fastspeaking)
# what is the Bayes Factor and the probability of the Singlish score main effect being greater than 0?
h.fastspeaking <- hypothesis(m.fastspeaking, "c.clip_score > 0")
print(h.fastspeaking, digits = 4)

## Proper
# need to reverse-code first, because the hypothesized relationship between Singlish score and Proper is negative
art_data_proper <- art_data_proper %>%
  mutate (
    new_proper = case_when(
      proper == 1 ~ 7,
      proper == 2 ~ 6,
      proper == 3 ~ 5,
      proper == 4 ~ 4,
      proper == 5 ~ 3,
      proper == 6 ~ 2,
      proper == 7 ~ 1
    )
  )
# now actually run the model
m.proper = brm(new_proper ~ c.clip_score + (1+c.clip_score|id) + (1|clip) + (1|speaker),
               data=art_data_proper,
               family=cumulative(),
               cores=4)
summary(m.proper)
# what is the Bayes Factor and the probability of the Singlish score main effect being more than 0?
h.proper <- hypothesis(m.proper, "c.clip_score > 0")
print(h.proper, digits = 4)
# model without reverse-coding
m.proper2 = brm(proper ~ c.clip_score + (1+c.clip_score|id) + (1|clip) + (1|speaker),
                data=art_data,
                family=cumulative(),
                cores=4)
summary(m.proper2)
# what is the Bayes Factor and the probability of the Singlish score main effect being less than 0?
h.proper2 <- hypothesis(m.proper2, "c.clip_score < 0")
print(h.proper2, digits = 4)