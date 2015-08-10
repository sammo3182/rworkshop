
## Vector {.smaller}
1:10  # numeric (integer/double)
c("R", "workshop") # character
3 == 5  # logical
factor(1:3, levels = 1:3, labels = c("low", "medium", "high"))  # factor 


## Dataset {.smaller}

matrix(1:4, ncol = 2)  # matrix
data.frame(x = 1:2, y = 3:4)  # data.frame
list(c("one", "two"), c(3, 4)) # 2-D list

array(c(1:4,5:8), dim = c(2, 2, 3)) # 3-D or n-D "list""


## Save data to an object

x <- rep(c(.01, .05, .1), times = 2) # repeat 1:5 for twice
df <- data.frame(x = 1:1, y = 3:4)
list <- list(x, df)

list # == print(list)



## Attributes of an object {.smaller .build}

str(df)
unique(df$x)
x[3]
list[[2]]

names(df)

length(x)

class(x);typeof(x)  # ; is used to write two commands in one line

## Detect the attributes

is.numeric(x)
is.na(x) # detect if x includes missing values


## Do math in R

# basic math
x + (1 - 2) * 3 / 4

# advanced math
x^2;sqrt(x);log(x);exp(x)

# matrix algebra
z <- matrix(1:4, ncol = 2)
z + z - z
z %*% z  # inner mul<span style="color:green">Tip</span>lication 
z %o% z  # outter mul<span style="color:green">Tip</span>lication

# logical evaluation
x == z; x != Z
x & z; x | z
x > z; x <= z

  
# Data Analysis
  ## Input data {.build}
load("<FileName>.RData")

df_txt <- read.table("<FileName>.txt")
df_csv <- read.csv("<FileName>.csv")

data(mtcars)

ncol(mtcars);names(mtcars)

## Have a look at the data{.build}

head(mtcars) # show the first six lines of mtcars

## Look at a specific area in a dataset
mtcars[1:2,3:4] # show first and the second rows of the third and fourth columns
mtcars[,"mpg"] # show the column "mpg"
mtcars[,"mpg"][3]  # show the third component of the column "mpg"

mtcars[mtcars$mpg < 20,][1,] # show the first rows which mpg are below 5.

mtcars$id <- seq(1:nrow(mtcars))
names(mtcars)

summary(mtcars)

table(mtcars$cyl)

nrow(mtcars)  # observation (N)
ncol(mtcars)  # variable number



## Data manipulation{.build}


mtcars$newvar <- rbinom(32, 1, .5)  #create a random binomial variable 

mtcars$newvar <- c(1:nrow(mtcars)) # create an "ID" variable

mtcars$newvar <- NULL

rm(x)

# Method I
mtcars$newvar[mtcars$mpg > mean(mtcars$mpg)] <- 1
mtcars$newvar[mtcars$mpg <= mean(mtcars$mpg)] <- 0

# Method II
mtcars$newvar <- ifelse(mtcars$mpg > mean(mtcars$mpg), 1, 0) # overwrite the NAs
mtcars$newvar <- ifelse(is.na(mtcars$mpg), NA,
ifelse(mtcars$mpg > mean(mtcars$mpg), 1, 0))

mtcars$newvar <- factor(mtcars$gear, levels = 3:5, labels = c("3-gear", "4-gear", "5-gear"))
table(mtcars$newvar)



## T test
t.test(mtcars$cyl, mtcars$gears) 

# one side, cyl > gear, alpha = .01
t.test(mtcars$cyl, mtcars$gear,
alternative = "greater", conf.level = .99)     
) 

# comparing with the parameter (true value)
t.test(mtcars$cyl, mu = 6)   # the true mean is 6.



## Binary Tests: Correlation

cor.test(mtcars$cyl, mtcars$gear)

cor.test(mtcars$cyl, mtcars$gear, method = "kendall")

cor(mtcars[,1:4])


## Binary Tests: ANOVA{.smaller}
aov_one <- aov(cyl ~ gear, data = mtcars) #one-way

aov_two <- aov(cyl ~ gear + am, data = mtcars) #two-way

summary(aov_one); summary(aov_two)

aov_one #print it
summary(aov_one) #summarize it

  
  # Multiple Regression
  ## Ordinary Linear Regression{.build}

lm_ols <- lm(mpg ~ cyl + hp + wt, data = mtcars)

summary(lm_ols)

lm_tran <- lm(log(mpg) ~ I(cyl^2) + exp(hp) + I(1/wt), data = mtcars)

summary(lm_tran)

mtcars$gear_f <- factor(mtcars$gear, levels = 3:5, labels = c("3-gear", "4-gear", "5-gear"))

lm_f <- lm(mpg ~ cyl + hp + wt + gear_f, data = mtcars)


summary(lm_f)

lm_in <- lm(mpg ~ cyl + hp * wt, data = mtcars)
lm_in2 <- lm(mpg ~ cyl + hp + wt + hp:wt, data = mtcars)

summary(lm_in)


## Post-estimate diagnoses: Residural


res_long <- mtcars$mpg - predict(lm_ols)
res_short <- resid(lm_ols)

plot(lm_ols, which = 1) # residural vs. fitted plot

library(car) # Bonferonni p-value for most extreme obs

outlierTest(lm_ols)

qqPlot(lm_ols)  #qq plot for studentized resid 

ncvTest(lm_ols) 

vif(lm_ols) 

durbinWatsonTest(lm_ols)


## Logit

logit <- glm(vs ~ cyl + hp + wt, data = mtcars, family = "binomial")

summary(logit)

library(mfx)
logit_m <- logitmfx(vs ~ cyl + hp + wt, data = mtcars) 
logit_m

# Step 1: creat an aggregate data 
mtcars_fake <- with(mtcars, data.frame(cyl = 4:6, hp = mean(hp), wt = mean(wt)))
# Step 2: predict based on the new data
logit_pp4 <- cbind(mtcars_fake,predict(logit, newdata = mtcars_fake, type = "link", se = TRUE))
# Step 3: convert to probability 
logit_pp4 <- within(logit_pp4, {pp <- plogis(fit) 
lb <- plogis(fit - 1.96 * se.fit)
ub <- plogis(fit + 1.96 * se.fit)})
logit_pp4[,7:9]

  
  ## Tabling

library(stargazer)
stargazer(lm_ols, align = T)

hist(mtcars$mpg)
st(mtcars$mpg, freq = F,  # plot the density rather than frequency
breaks = 10,  # change the number of bins
col = "purple", # change the color of the bins 
xlab="Miles Per Gallon",   # adding the x-axis label
main="Histogram")  # adding a title

hist<-hist(mtcars$mpg, breaks=10, col="purple", xlab="Miles Per Gallon", 
main="Histogram with Normal Curve") 

xfit<-seq(min(mtcars$mpg),max(mtcars$mpg),length=40) 
yfit<-dnorm(xfit,mean=mean(mtcars$mpg),sd=sd(mtcars$mpg)) 
yfit <- yfit*diff(hist$mids[1:2])*length(mtcars$mpg) 
lines(xfit, yfit, col="blue", lwd=2)

jpeg("histgraph.jpg")
hist
dev.off()


## histogram in `ggplot`

ggplot(mtcars, aes(x=mpg)) + 
geom_histogram(aes(y=..density..), 
binwidth=2,
colour="black", fill="purple") +
geom_density(alpha=.2, fill="blue")  + # Overlay with transparent density plot
theme_bw() + 
ggtitle("histogram with Normal Curve") + 
xlab("Miles Per Gallon") + ylab("Density")

ggplot(mtcars, aes(x=mpg, fill = factor(vs))) +  # Separate cars with V or straight engine
geom_histogram(aes(y=..density..), 
binwidth=2, alpha = .5, position = "identity") +
geom_density(alpha=.2)  + # Overlay with transparent density plot
theme_bw() + 
ggtitle("histogram with Normal Curve") + 
xlab("Miles Per Gallon") + ylab("Density")

ggplot(mtcars,aes(mpg,qsec)) + 
geom_point() + 
geom_rug(col="purple",alpha=.5) +
xlab("Miles Per Gallon") + ylab("1/4 Mile Time") + 
theme_bw()

library(gridExtra)
#placeholder plot - prints nothing at all
empty <- ggplot()+geom_point(aes(1,1), colour="white") +
theme(                              
plot.background = element_blank(), 
panel.grid.major = element_blank(), 
panel.grid.minor = element_blank(), 
panel.border = element_blank(), 
panel.background = element_blank(),
axis.title.x = element_blank(),
axis.title.y = element_blank(),
axis.text.x = element_blank(),
axis.text.y = element_blank(),
axis.ticks = element_blank()
)

#scatterplot of x and y variables
scatter <- ggplot(mtcars,aes(mpg, qsec)) + 
geom_point(aes(color=factor(vs))) + 
xlab("Miles Per Gallon") + ylab("Density") + 
scale_color_manual(values = c("orange", "purple")) + 
theme(legend.position=c(1,1),legend.justification=c(1,1)) 

#marginal density of x - plot on top
plot_top <- ggplot(mtcars, aes(mpg, fill=factor(vs))) + 
geom_density(alpha=.5) + 
scale_fill_manual(values = c("orange", "purple")) + 
theme(legend.position = "none")

#marginal density of y - plot on the right
plot_right <- ggplot(mtcars, aes(qsec, fill=factor(vs))) + 
geom_density(alpha=.5) + 
coord_flip() + 
scale_fill_manual(values = c("orange", "purple")) + 
theme(legend.position = "none") 

#arrange the plots together, with appropriate height and width for each row and column
grid.arrange(plot_top, empty, scatter, plot_right, ncol=2, nrow=2, widths=c(4, 1), heights=c(1, 4))

qplot(mtcars$mpg) 

## Two special types: estimate plot{.smaller}

library(dotwhisker)
library(broom)
lm_df <- tidy(lm_ols)
lm_df

lm_df <- by_2sd(lm_df, mtcars) %>% # rescale the coefficients
filter(term != "(Intercept)") # omit intercept
dwplot(lm_df)


library(interplot)
summary(lm_in)

interplot(m = lm_in, var1 = "hp", var2 = "wt") + 
xlab("Automobile Weight (thousands lbs)") + 
ylab("Estimated Coefficient for \nGross horsepower")
          
