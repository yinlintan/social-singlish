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
# Fixed effect: Singlish (Markhov) score (c.clip_score)
# Random effects: random intercept of speaker and clip, by-participant slope for Singlish score

## Rough
m.rough = brm(honest ~ c.clip_score + (1+c.clip_score|id) + (1|clip) + (1|speaker),
               data=art_data,
               family=cumulative(),
               cores=4)
summary(m.rough)
# what is the Bayes Factor and the probability of the Singlish score main effect being greater than 0?
m.rough <- hypothesis(m.rough, "c.clip_score > 0")
print(m.rough, digits = 4)

## Honest
m.honest = brm(honest ~ c.clip_score + (1+c.clip_score|id) + (1|clip) + (1|speaker),
              data=art_data,
              family=cumulative(),
              cores=4)
summary(m.honest)
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

## Fast-speaking --> including speech rate
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

### VISUALIZING DATA ###

# plotting attribute ratings on y-axis and clip score on x-axis

# rename rating levels first

## rough
ggplot(art_data, aes(x=clip_score,y=rough)) +
  geom_point(size=0.5, alpha=0.5, colour="grey", position = position_jitter(width = 0)) +
  geom_smooth(method="lm", aes(group = 1)) + 
  labs(title="Relationship between Singlish score and ROUGH", x="Singlish score", y="This speaker is ROUGH.")
## honest
ggplot(art_data, aes(x=clip_score,y=honest)) +
  geom_point(size=0.5, alpha=0.5, colour="grey", position = position_jitter(width = 0)) +
  geom_smooth(method="lm", aes(group = 1)) + 
  labs(title="Relationship between Singlish score and HONEST", x="Singlish score", y="This speaker is HONEST.")
## easygoing
ggplot(art_data, aes(x=clip_score,y=easygoing)) +
  geom_point(size=0.5, alpha=0.5, colour="grey", position = position_jitter(width = 0)) +
  geom_smooth(method="lm", aes(group = 1)) + 
  labs(title="Relationship between Singlish score and EASYGOING", x="Singlish score", y="This speaker is EASYGOING.")
## casual
ggplot(art_data, aes(x=clip_score,y=casual)) +
  geom_point(size=0.5, alpha=0.5, colour="grey", position = position_jitter(width = 0)) +
  geom_smooth(method="lm", aes(group = 1)) + 
  labs(title="Relationship between Singlish score and CASUAL", x="Singlish score", y="This speaker is CASUAL.")
## fast-speaking
ggplot(art_data, aes(x=clip_score,y=fastspeaking)) +
  geom_point(size=0.5, alpha=0.5, colour="grey", position = position_jitter(width = 0)) +
  geom_smooth(method="lm", aes(group = 1)) + 
  labs(title="Relationship between Singlish score and FAST-SPEAKING", x="Singlish score", y="This speaker is FAST-SPEAKING.")
## proper
ggplot(art_data, aes(x=clip_score,y=proper)) +
  geom_point(size=0.5, alpha=0.5, colour="grey", position = position_jitter(width = 0)) +
  geom_smooth(method="lm", aes(group = 1)) + 
  labs(title="Relationship between Singlish score and PROPER", x="Singlish score", y="This speaker is PROPER.")

# plot proportion of responses for each attribute

## rough
agr_rough = art_data %>% 
  select(rough, c.clip_score) %>% 
  mutate("1" = case_when(rough == 1 ~ 1,
                         TRUE ~ 0),
         "2" = case_when(rough == 2 ~ 1,
                         TRUE ~ 0),
         "3" = case_when(rough == 3 ~ 1,
                           TRUE ~ 0),
         "4" = case_when(rough == 4 ~ 1,
                          TRUE ~ 0),
         "5" = case_when(rough == 5 ~ 1,
                          TRUE ~ 0),
         "6" = case_when(rough == 6 ~ 1,
                         TRUE ~ 0),
         "7" = case_when(rough == 7 ~ 1,
                           TRUE ~ 0)) %>% 
  pivot_longer(cols = "1":"7", names_to=c("Response"), values_to=c("Value"))

sum_rough <- agr_rough %>%
  group_by(Response) %>%
  summarise( 
    n=n(),
    mean=mean(as.numeric(Value)),
    sd=sd(as.numeric(Value))
  ) %>%
  mutate( se=sd/sqrt(n))  %>%
  mutate( ic=se * qt((1-0.05)/2 + .5, n-1))

sum_rough$Response <- factor(sum_rough$Response, levels = c("1", "2", "3", "4", "5", "6", "7"))

ggplot(sum_rough) +
  geom_point( aes(x=Response, y=mean), stat="identity", colour=cbPalette[1]) +
  geom_errorbar( aes(x=Response, ymin=mean-ic, ymax=mean+ic), width=0.4, colour=cbPalette[1], alpha=0.6, linewidth=.7) +
  labs(title = "This speaker is ROUGH.", x = "Rating", y = "Proportion", las=2)

## honest
agr_honest = art_data %>% 
  select(honest, c.clip_score) %>% 
  mutate("1" = case_when(honest == 1 ~ 1,
                         TRUE ~ 0),
         "2" = case_when(honest == 2 ~ 1,
                         TRUE ~ 0),
         "3" = case_when(honest == 3 ~ 1,
                         TRUE ~ 0),
         "4" = case_when(honest == 4 ~ 1,
                         TRUE ~ 0),
         "5" = case_when(honest == 5 ~ 1,
                         TRUE ~ 0),
         "6" = case_when(honest == 6 ~ 1,
                         TRUE ~ 0),
         "7" = case_when(honest == 7 ~ 1,
                         TRUE ~ 0)) %>% 
  pivot_longer(cols = "1":"7", names_to=c("Response"), values_to=c("Value"))

sum_honest <- agr_honest %>%
  group_by(Response) %>%
  summarise( 
    n=n(),
    mean=mean(as.numeric(Value)),
    sd=sd(as.numeric(Value))
  ) %>%
  mutate( se=sd/sqrt(n))  %>%
  mutate( ic=se * qt((1-0.05)/2 + .5, n-1))

sum_honest$Response <- factor(sum_honest$Response, levels = c("1", "2", "3", "4", "5", "6", "7"))

ggplot(sum_honest) +
  geom_point( aes(x=Response, y=mean), stat="identity", colour=cbPalette[2]) +
  geom_errorbar( aes(x=Response, ymin=mean-ic, ymax=mean+ic), width=0.4, colour=cbPalette[2], alpha=0.6, linewidth=.7) +
  labs(title = "This speaker is HONEST.", x = "Rating", y = "Proportion", las=2)

## easygoing
agr_easygoing = art_data %>% 
  select(easygoing, c.clip_score) %>% 
  mutate("1" = case_when(easygoing == 1 ~ 1,
                         TRUE ~ 0),
         "2" = case_when(easygoing == 2 ~ 1,
                         TRUE ~ 0),
         "3" = case_when(easygoing == 3 ~ 1,
                         TRUE ~ 0),
         "4" = case_when(easygoing == 4 ~ 1,
                         TRUE ~ 0),
         "5" = case_when(easygoing == 5 ~ 1,
                         TRUE ~ 0),
         "6" = case_when(easygoing == 6 ~ 1,
                         TRUE ~ 0),
         "7" = case_when(easygoing == 7 ~ 1,
                         TRUE ~ 0)) %>% 
  pivot_longer(cols = "1":"7", names_to=c("Response"), values_to=c("Value"))

sum_easygoing <- agr_easygoing %>%
  group_by(Response) %>%
  summarise( 
    n=n(),
    mean=mean(as.numeric(Value)),
    sd=sd(as.numeric(Value))
  ) %>%
  mutate( se=sd/sqrt(n))  %>%
  mutate( ic=se * qt((1-0.05)/2 + .5, n-1))

sum_easygoing$Response <- factor(sum_easygoing$Response, levels = c("1", "2", "3", "4", "5", "6", "7"))

ggplot(sum_easygoing) +
  geom_point( aes(x=Response, y=mean), stat="identity", colour=cbPalette[3]) +
  geom_errorbar( aes(x=Response, ymin=mean-ic, ymax=mean+ic), width=0.4, colour=cbPalette[3], alpha=0.6, linewidth=.7) +
  labs(title = "This speaker is EASYGOING.", x = "Rating", y = "Proportion", las=2)

## casual
agr_casual = art_data %>% 
  select(casual, c.clip_score) %>% 
  mutate("1" = case_when(casual == 1 ~ 1,
                         TRUE ~ 0),
         "2" = case_when(casual == 2 ~ 1,
                         TRUE ~ 0),
         "3" = case_when(casual == 3 ~ 1,
                         TRUE ~ 0),
         "4" = case_when(casual == 4 ~ 1,
                         TRUE ~ 0),
         "5" = case_when(casual == 5 ~ 1,
                         TRUE ~ 0),
         "6" = case_when(casual == 6 ~ 1,
                         TRUE ~ 0),
         "7" = case_when(casual == 7 ~ 1,
                         TRUE ~ 0)) %>% 
  pivot_longer(cols = "1":"7", names_to=c("Response"), values_to=c("Value"))

sum_casual <- agr_casual %>%
  group_by(Response) %>%
  summarise( 
    n=n(),
    mean=mean(as.numeric(Value)),
    sd=sd(as.numeric(Value))
  ) %>%
  mutate( se=sd/sqrt(n))  %>%
  mutate( ic=se * qt((1-0.05)/2 + .5, n-1))

sum_casual$Response <- factor(sum_casual$Response, levels = c("1", "2", "3", "4", "5", "6", "7"))

ggplot(sum_casual) +
  geom_point( aes(x=Response, y=mean), stat="identity", colour=cbPalette[4]) +
  geom_errorbar( aes(x=Response, ymin=mean-ic, ymax=mean+ic), width=0.4, colour=cbPalette[4], alpha=0.6, linewidth=.7) +
  labs(title = "This speaker is CASUAL.", x = "Rating", y = "Proportion", las=2)

## fast-speaking
agr_fastspeaking = art_data %>% 
  select(fastspeaking, c.clip_score) %>% 
  mutate("1" = case_when(fastspeaking == 1 ~ 1,
                         TRUE ~ 0),
         "2" = case_when(fastspeaking == 2 ~ 1,
                         TRUE ~ 0),
         "3" = case_when(fastspeaking == 3 ~ 1,
                         TRUE ~ 0),
         "4" = case_when(fastspeaking == 4 ~ 1,
                         TRUE ~ 0),
         "5" = case_when(fastspeaking == 5 ~ 1,
                         TRUE ~ 0),
         "6" = case_when(fastspeaking == 6 ~ 1,
                         TRUE ~ 0),
         "7" = case_when(fastspeaking == 7 ~ 1,
                         TRUE ~ 0)) %>% 
  pivot_longer(cols = "1":"7", names_to=c("Response"), values_to=c("Value"))

sum_fastspeaking <- agr_fastspeaking %>%
  group_by(Response) %>%
  summarise( 
    n=n(),
    mean=mean(as.numeric(Value)),
    sd=sd(as.numeric(Value))
  ) %>%
  mutate( se=sd/sqrt(n))  %>%
  mutate( ic=se * qt((1-0.05)/2 + .5, n-1))

sum_fastspeaking$Response <- factor(sum_fastspeaking$Response, levels = c("1", "2", "3", "4", "5", "6", "7"))

ggplot(sum_fastspeaking) +
  geom_point( aes(x=Response, y=mean), stat="identity", colour=cbPalette[5]) +
  geom_errorbar( aes(x=Response, ymin=mean-ic, ymax=mean+ic), width=0.4, colour=cbPalette[5], alpha=0.6, linewidth=.7) +
  labs(title = "This speaker is FAST-SPEAKING.", x = "Rating", y = "Proportion", las=2)

## proper
agr_proper = art_data %>% 
  select(proper, c.clip_score) %>% 
  mutate("1" = case_when(proper == 1 ~ 1,
                         TRUE ~ 0),
         "2" = case_when(proper == 2 ~ 1,
                         TRUE ~ 0),
         "3" = case_when(proper == 3 ~ 1,
                         TRUE ~ 0),
         "4" = case_when(proper == 4 ~ 1,
                         TRUE ~ 0),
         "5" = case_when(proper == 5 ~ 1,
                         TRUE ~ 0),
         "6" = case_when(proper == 6 ~ 1,
                         TRUE ~ 0),
         "7" = case_when(proper == 7 ~ 1,
                         TRUE ~ 0)) %>% 
  pivot_longer(cols = "1":"7", names_to=c("Response"), values_to=c("Value"))

sum_proper <- agr_proper %>%
  group_by(Response) %>%
  summarise( 
    n=n(),
    mean=mean(as.numeric(Value)),
    sd=sd(as.numeric(Value))
  ) %>%
  mutate( se=sd/sqrt(n))  %>%
  mutate( ic=se * qt((1-0.05)/2 + .5, n-1))

sum_proper$Response <- factor(sum_proper$Response, levels = c("1", "2", "3", "4", "5", "6", "7"))

ggplot(sum_proper) +
  geom_point( aes(x=Response, y=mean), stat="identity", colour=cbPalette[6]) +
  geom_errorbar( aes(x=Response, ymin=mean-ic, ymax=mean+ic), width=0.4, colour=cbPalette[6], alpha=0.6, linewidth=.7) +
  labs(title = "This speaker is PROPER.", x = "Rating", y = "Proportion", las=2)

# plot means of attribute rating (y-axis) against clip score (x-axis)

## rough
mean_rough <- art_data %>%
  group_by(c.clip_score) %>%
  summarise( 
    n=n(),
    mean=mean(as.numeric(rough)),
    sd=sd(as.numeric(rough))
  ) %>%
  mutate( se=sd/sqrt(n))  %>%
  mutate( ic=se * qt((1-0.05)/2 + .5, n-1))

ggplot(mean_rough) +
  geom_point( aes(x=c.clip_score, y=mean), stat="identity", colour=cbPalette[1]) +
  geom_errorbar( aes(x=c.clip_score, ymin=mean-ic, ymax=mean+ic), width=0.0005, colour=cbPalette[1], alpha=0.6, linewidth=.7) +
  labs(title = "This speaker is ROUGH.", x = "Singlish score", y = "Rating") +
  ylim(1, 7) 

## honest
mean_honest <- art_data %>%
  group_by(c.clip_score) %>%
  summarise( 
    n=n(),
    mean=mean(as.numeric(honest)),
    sd=sd(as.numeric(honest))
  ) %>%
  mutate( se=sd/sqrt(n))  %>%
  mutate( ic=se * qt((1-0.05)/2 + .5, n-1))

ggplot(mean_honest) +
  geom_point( aes(x=c.clip_score, y=mean), stat="identity", colour=cbPalette[2]) +
  geom_errorbar( aes(x=c.clip_score, ymin=mean-ic, ymax=mean+ic), width=0.0005, colour=cbPalette[2], alpha=0.6, linewidth=.7) +
  labs(title = "This speaker is HONEST.", x = "Singlish score", y = "Rating") +
  ylim(1, 7) 

## easygoing
mean_easygoing <- art_data %>%
  group_by(c.clip_score) %>%
  summarise( 
    n=n(),
    mean=mean(as.numeric(easygoing)),
    sd=sd(as.numeric(easygoing))
  ) %>%
  mutate( se=sd/sqrt(n))  %>%
  mutate( ic=se * qt((1-0.05)/2 + .5, n-1))

ggplot(mean_easygoing) +
  geom_point( aes(x=c.clip_score, y=mean), stat="identity", colour=cbPalette[3]) +
  geom_errorbar( aes(x=c.clip_score, ymin=mean-ic, ymax=mean+ic), width=0.0005, colour=cbPalette[3], alpha=0.6, linewidth=.7) +
  labs(title = "This speaker is EASYGOING.", x = "Singlish score", y = "Rating") +
  ylim(1, 7) 

## casual
mean_casual <- art_data %>%
  group_by(c.clip_score) %>%
  summarise( 
    n=n(),
    mean=mean(as.numeric(casual)),
    sd=sd(as.numeric(casual))
  ) %>%
  mutate( se=sd/sqrt(n))  %>%
  mutate( ic=se * qt((1-0.05)/2 + .5, n-1))

ggplot(mean_casual) +
  geom_point( aes(x=c.clip_score, y=mean), stat="identity", colour=cbPalette[4]) +
  geom_errorbar( aes(x=c.clip_score, ymin=mean-ic, ymax=mean+ic), width=0.0005, colour=cbPalette[4], alpha=0.6, linewidth=.7) +
  labs(title = "This speaker is CASUAL.", x = "Singlish score", y = "Rating") +
  ylim(1, 7) 

## fast-speaking
mean_fastspeaking <- art_data %>%
  group_by(c.clip_score) %>%
  summarise( 
    n=n(),
    mean=mean(as.numeric(fastspeaking)),
    sd=sd(as.numeric(fastspeaking))
  ) %>%
  mutate( se=sd/sqrt(n))  %>%
  mutate( ic=se * qt((1-0.05)/2 + .5, n-1))

ggplot(mean_fastspeaking) +
  geom_point( aes(x=c.clip_score, y=mean), stat="identity", colour=cbPalette[5]) +
  geom_errorbar( aes(x=c.clip_score, ymin=mean-ic, ymax=mean+ic), width=0.0005, colour=cbPalette[5], alpha=0.6, linewidth=.7) +
  labs(title = "This speaker is FAST-SPEAKING.", x = "Singlish score", y = "Rating") +
  ylim(1, 7) 

## proper
mean_proper <- art_data %>%
  group_by(c.clip_score) %>%
  summarise( 
    n=n(),
    mean=mean(as.numeric(proper)),
    sd=sd(as.numeric(proper))
  ) %>%
  mutate( se=sd/sqrt(n))  %>%
  mutate( ic=se * qt((1-0.05)/2 + .5, n-1))

ggplot(mean_proper) +
  geom_point( aes(x=c.clip_score, y=mean), stat="identity", colour=cbPalette[6]) +
  geom_errorbar( aes(x=c.clip_score, ymin=mean-ic, ymax=mean+ic), width=0.0005, colour=cbPalette[6], alpha=0.6, linewidth=.7) +
  labs(title = "This speaker is PROPER.", x = "Singlish score", y = "Rating") +
  ylim(1, 7) 

# scatter plot of attribute ratings (y-axis) against singlish score (x-axis) with linear smoother

## rough
ggplot(art_data) +
  geom_point(aes(x=c.clip_score, y=rough), size=0.5, stat="identity", colour="darkgrey", alpha=0.5, position = position_jitter(width = 0)) +
  geom_smooth(aes(x = c.clip_score, y = rough, group = 1), colour=cbPalette[1], method="lm") + 
  labs(title = "This speaker is ROUGH.", x = "Singlish score", y = "Rating")

## honest
ggplot(art_data) +
  geom_point(aes(x=c.clip_score, y=honest), size=0.5, stat="identity", colour="darkgrey", alpha=0.5, position = position_jitter(width = 0)) +
  geom_smooth(aes(x = c.clip_score, y = honest, group = 1), colour=cbPalette[2], method="lm") + 
  labs(title = "This speaker is HONEST.", x = "Singlish score", y = "Rating")

## easygoing
ggplot(art_data) +
  geom_point(aes(x=c.clip_score, y=easygoing), size=0.5, stat="identity", colour="darkgrey", alpha=0.5, position = position_jitter(width = 0)) +
  geom_smooth(aes(x = c.clip_score, y = easygoing, group = 1), colour=cbPalette[3], method="lm") + 
  labs(title = "This speaker is EASYGOING.", x = "Singlish score", y = "Rating") 

## casual
ggplot(art_data) +
  geom_point(aes(x=c.clip_score, y=casual), size=0.5, stat="identity", colour="darkgrey", alpha=0.5, position = position_jitter(width = 0)) +
  geom_smooth(aes(x = c.clip_score, y = casual, group = 1), colour=cbPalette[4], method="lm") + 
  labs(title = "This speaker is CASUAL.", x = "Singlish score", y = "Rating") 

## fast-speaking
ggplot(art_data) +
  geom_point(aes(x=c.clip_score, y=fastspeaking), size=0.5, stat="identity", colour="darkgrey", alpha=0.5, position = position_jitter(width = 0)) +
  geom_smooth(aes(x = c.clip_score, y = fastspeaking, group = 1), colour=cbPalette[5], method="lm") + 
  labs(title = "This speaker is FAST-SPEAKING.", x = "Singlish score", y = "Rating") 

## proper
ggplot(art_data) +
  geom_point(aes(x=c.clip_score, y=proper), size=0.5, stat="identity", colour="darkgrey", alpha=0.5, position = position_jitter(width = 0)) +
  geom_smooth(aes(x = c.clip_score, y = proper, group = 1), colour=cbPalette[6], method="lm") + 
  labs(title = "This speaker is PROPER.", x = "Singlish score", y = "Rating") 