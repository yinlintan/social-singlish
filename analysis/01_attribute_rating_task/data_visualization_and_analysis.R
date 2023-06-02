### DATA ANALYSIS ###

library(tidyverse)
library(brms)
library(dplyr)

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

# cumulative link model
## rough
m.rough = brm(rough ~ c.clip_score + (1|clip) + (1|id) + (1|speaker),
              data=art_data,
              family=cumulative(),
              cores=4)
summary(m.rough)
h.rough <- hypothesis(m.rough, "c.clip_score > 0")
print(h.rough, digits = 4)
## honest
m.honest = brm(honest ~ c.clip_score + (1|clip) + (1|id) + (1|speaker),
              data=art_data,
              family=cumulative(),
              cores=4)
summary(m.honest)
h.honest <- hypothesis(m.honest, "c.clip_score > 0")
print(h.honest, digits = 4)

# adjacent category model
m.acat = brm(rough ~ c.clip_score + (1|clip) + (1|id) + (1|speaker),
             data=art_data,
             family=acat(),
             cores=4)
summary(m.acat)

## VISUALIZING DATA ##

# plotting attribute ratings on y-axis and clip score on x-axis

## rough
ggplot(art_data, aes(x=clip_score,y=rough)) +
  geom_point(size=0.5, alpha=0.5, colour="grey", position = position_jitter(width = 0)) +
  geom_smooth(method="lm", aes(group = 1)) + 
  labs(title="Rating for 'Rough' vs Singlish Markhov score")
## casual
ggplot(art_data, aes(x=clip_score,y=casual)) +
  geom_point(size=0.5, alpha=0.5, colour="grey", position = position_jitter(width = 0)) +
  geom_smooth(method="lm", aes(group = 1)) + 
  labs(title="Rating for 'Casual' vs Singlish Markhov score")
## honest
ggplot(art_data, aes(x=clip_score,y=honest)) +
  geom_point(size=0.5, alpha=0.5, colour="grey", position = position_jitter(width = 0)) +
  geom_smooth(method="lm", aes(group = 1)) + 
  labs(title="Rating for 'Honest' vs Singlish Markhov score")
## easygoing
ggplot(art_data, aes(x=clip_score,y=easygoing)) +
  geom_point(size=0.5, alpha=0.5, colour="grey", position = position_jitter(width = 0)) +
  geom_smooth(method="lm", aes(group = 1)) + 
  labs(title="Rating for 'Easygoing' vs Singlish Markhov score")
## proper
ggplot(art_data, aes(x=clip_score,y=proper)) +
  geom_point(size=0.5, alpha=0.5, colour="grey", position = position_jitter(width = 0)) +
  geom_smooth(method="lm", aes(group = 1)) + 
  labs(title="Rating for 'Proper' vs Singlish Markhov score")
## fast-speaking
ggplot(art_data, aes(x=clip_score,y=fastspeaking)) +
  geom_point(size=0.5, alpha=0.5, colour="grey", position = position_jitter(width = 0)) +
  geom_smooth(method="lm", aes(group = 1)) + 
  labs(title="Rating for 'Fast-speaking' vs Singlish Markhov score")

# plot proportion of responses by clip score
agr = art_data %>% 
  select(c.clip_score,clip,speaker) %>% 
  mutate(One = case_when("rough" == 1 ~ 1,
                         TRUE ~ 0),
         Two = case_when("rough" == 2 ~ 1,
                         TRUE ~ 0),
         Three = case_when("rough" == 3 ~ 1,
                           TRUE ~ 0),
         Four = case_when("rough" == 4 ~ 1,
                          TRUE ~ 0),
         Five = case_when("rough" == 5 ~ 1,
                          TRUE ~ 0),
         Six = case_when("rough" == 6 ~ 1,
                         TRUE ~ 0),
         Seven = case_when("rough" == 7 ~ 1,
                           TRUE ~ 0)) %>% 
  pivot_longer(cols = One:Seven, names_to=c("Response"), values_to=c("Value"))

agr_part = agr %>% 
  group_by(c.clip_score,Response) %>% 
  summarize(Mean = mean(Value), CILow=ci.low(Value), CIHigh = ci.high(Value)) %>% 
  ungroup() %>% 
  mutate(YMin=Mean-CILow,YMax=Mean+CIHigh) %>% 
  mutate(Rating = as.numeric(as.character(fct_recode(Response, "1"="One", "2"="Two","3"="Three","4"="Four","5"="Five","6"="Six","7"="Seven"))))