pcks <- c("data.table", "devtools", "ggplot", "plotly")
install.packages(pcks)
library(data.table)
library(devtools)
library(ggplot2)
library(plotly)
got_chars_full <- fread('character-predictions_pose.csv')
got_chars <- got_chars_full[, .SD,  .SDcols = c("name", "title", "male", 
                                           "culture", "dateOfBirth", 
                                           "DateoFdeath",
                                           "house", "spouse", "age")]
tg_houses <- c("Night's Watch", "House Frey", "House Stark", "House Targaryen", "House Lannister", "House Greyjoy")
got_houses <- 
  list(
    "n_watch" = got_chars[house == "Night's Watch"],
    "h_frey" = got_chars[house == "House Frey"],
    "h_stark" = got_chars[house == "House Stark"],
    "h_targaryen" = got_chars[house == "House Targaryen"],
    "h_lannister" = got_chars[house == "House Lannister"],
    "h_greyjoy" = got_chars[house == "House Greyjoy"],
    "other" = got_chars[!(house %in% tg_houses)])
str(got_houses)
rbind(got_houses$h_frey, got_houses$n_watch)

dt4bind <- got_chars[, list(spouse_name = name,
                            spouse_title = title,
                            spouse_age = age)]
got_spouses <-
  merge(got_chars[male == 1, list(name, title, male, age, spouse_name = spouse)],
        got_chars[male == 0, list(spouse_name = name, spouse_title = title, spouse_age = age)],
        by = 'spouse_name', all = FALSE)

# Длина колонки
got_chars[,.N]
# Фильтрация
got_chars[male == 1,.N]

got_chars[, length(unique(name))]

got_chars[!is.na((age)) ,mean(age)]
got_chars[age<0 ,]
got_chars[!is.na(age)&age>=0,  mean(age)]

got_chars[!is.na(age)&!(name%in% c("Doreah", "Rhaego")),
          list(n_chars = length(unique(name)),
            age_mn = mean(age),
               age_md = median(as.double(age)),
               age_sd = sd(age)),
          by = house]
got_spouses[,list(n_spouses = length(spouse_name)),
            by = name]

got_chars_full %>% 
  count(spouse, sort = T) %>% 
  print(n = 30)

tst <- got_chars[,length(unique(name)),
                     by = spouse]
tst[V1>1&spouse!=''] 
