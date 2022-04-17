## Southlake Tri-City Management Corporation d/b/a
## Geminus Corporation 428 employees, Total Rev $45m
## Judith K. Sikora President
## 2020 990
url <- 'https://s3.amazonaws.com/irs-form-990/202121369349302127_public.xml?_ga=2.194687789.1859810749.1647874380-819108233.1647874380'
## 2019 990
url <- 'https://s3.amazonaws.com/irs-form-990/202000559349301100_public.xml?_ga=2.143235893.1859810749.1647874380-819108233.1647874380'
## 2018 990
url <- 'https://s3.amazonaws.com/irs-form-990/201901339349306705_public.xml?_ga=2.143235893.1859810749.1647874380-819108233.1647874380'
## 2
## TIPPECANOE COUNTY CHILD CARE INC d/b/a Right Steps Child Development
## 180 employees, total revenue $5.25m
## Debi Debruyn President
## 2019 990
url <- 'https://s3.amazonaws.com/irs-form-990/202043169349304719_public.xml?_ga=2.246355524.113271553.1648058999-819108233.1647874380'
## 2018 990
url <- 'https://s3.amazonaws.com/irs-form-990/201933169349302438_public.xml?_ga=2.108944578.113271553.1648058999-819108233.1647874380'
## 2017 990
url <- 'https://s3.amazonaws.com/irs-form-990/201812699349300521_public.xml?_ga=2.108944578.113271553.1648058999-819108233.1647874380'

## 3
## Child Care Answers of Central Indiana
## Mollie Smith Looks like their exemption was approved in 2020.
## No 990s avaible

## 4
## Chances and Services for Youth Inc. 42 employees
## Total Rev 4.1 million
## Karen Harding President
## 2019 990
url <- 'https://s3.amazonaws.com/irs-form-990/202042269349300819_public.xml?_ga=2.247371972.113271553.1648058999-819108233.1647874380'
## 2018 990
## NOT AVAILABLE IN XML!
## 2017 990
url <- 'https://s3.amazonaws.com/irs-form-990/201811849349300826_public.xml?_ga=2.17103097.113271553.1648058999-819108233.1647874380'

## Community Coordinated Child Care of S Indiana d/b/a
## Building Blocks Employees 29, Gross Revenue $2m
## Aleisha Sheridan President
## 2020 990
url <- 'https://s3.amazonaws.com/irs-form-990/202110719349300306_public.xml?_ga=2.240884739.1859810749.1647874380-819108233.1647874380'
## 2019 990
url <- 'https://s3.amazonaws.com/irs-form-990/202000419349300810_public.xml?_ga=2.206091027.1859810749.1647874380-819108233.1647874380'
## 2018 990
url <- 'https://s3.amazonaws.com/irs-form-990/201901849349301005_public.xml?_ga=2.206091027.1859810749.1647874380-819108233.1647874380'




library(xml2)
library(rvest)
#2020
url1 <- 'https://s3.amazonaws.com/irs-form-990/202000419349300810_public.xml?_ga=2.231256735.1859810749.1647874380-819108233.1647874380'
file <- xml2::read_xml(url1) |> xml_ns_strip()
my.l <- file |> xml_nodes("IRS990") %>% as_list() |> unlist()
df.2020 <- data.frame(variables = names(my.l), `2020` = my.l)
#2019
url2 <- 'https://s3.amazonaws.com/irs-form-990/202000419349300810_public.xml?_ga=2.206091027.1859810749.1647874380-819108233.1647874380'
file <- xml2::read_xml(url2) |> xml_ns_strip()
my.l <- file |> xml_nodes("IRS990") %>% as_list() |> unlist()
df.2019 <- data.frame(variables = names(my.l), `2019` = my.l)
# combine
bb <- cbind(df.2020, df.2019)
