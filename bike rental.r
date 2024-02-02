# 1. Exploratory data analysis:

#Importing libraries useful for the assesmnet 
library(tidyverse)
library(ggplot2)
library(tidyr)
library(readr)
library(purrr)
library(dplyr)
library(stringr)
library(forcats)
#Loading dataset and relevant libraries 
bike<-read_excel("C:/Users/hp/Downloads/1657875746_day.xlsx")
head(bike,5)
bike<-subset(bike,select=-c(casual,registered))
head(bike,5)
dim(bike)
summary(bike)
str(bike)
names(bike)<-c('rec_id','datetime','season','year','month','holiday','weekday','workingday','weather_condition','temp','atemp','humidity','windspeed','total_count')
head(bike,5)
#Typecasting the datetime and numerical attributes to category
bike$datetime<- as.Date(bike$datetime)
bike$year<-as.factor(bike$year)
bike$month<-as.factor(bike$month)
bike$season <- as.factor(bike$season)
bike$holiday<- as.factor(bike$holiday)
bike$weekday<- as.factor(bike$weekday)
bike$workingday<- as.factor(bike$workingday)
bike$weather_condition<- as.factor(bike$weather_condition)

#Carry out the missing value analysis
missing_val<-data.frame(apply(bike,2,function(x){sum(is.na(x))}))
names(missing_val)[1]='missing_val'
missing_val

#2.Attributes distribution and trends

#Column Plot monthly distribution of the total number of bikes rented
ggplot(bike,aes(x=month,y=total_count,fill=season))+theme_bw()+geom_col()+
labs(x='Month',y='Total_Count',title='Monthly and season wise distribution of total number of bikes rented')
#Column Plot yearly distribution of the total number of bikes rented
ggplot(bike,aes(x=year,y=total_count,fill=year))+geom_col()+theme_bw()+
labs(x='Year',y='Total_Count',title='Yearly distribution of total number of bikes rented')
#Boxplot for total_count_outliers
par(mfrow=c(1, 1))#divide graph area in 1 columns and 1 rows
boxplot(bike$total_count,main='Total_count',sub=paste(boxplot.stats(bike$total_count)$out))
#box plots for outliers
par(mfrow=c(2,2))
#Box plot for temp outliers
boxplot(bike$temp, main="Temp",sub=paste(boxplot.stats(bike$temp)$out))
#Box plot for humidity outliers
boxplot(bike$humidity,main="Humidity",sub=paste(boxplot.stats(bike$humidity)$out))
#Box plot for windspeed outliers
boxplot(bike$windspeed,main="Windspeed",sub=paste(boxplot.stats(bike$windspeed)$out))

#3. Split the dataset into train and test dataset
train_index<-sample(1:nrow(bike),0.7*nrow(bike))
train_data<-bike[train_index,]
test_data<-bike[-train_index,]
dim(train_data)
dim(test_data)
#Read the train and test data
head(train_data,5)
head(test_data,5)
#Selecting the required independent and dependent variables
#Create a new subset for train attributes 
train<-subset(train_data,select=c('season','year','month','holiday', 'weekday','workingday','weather_condition','temp','humidity','windspeed','total_count'))
#Create a new subset for test attributes
test<-subset(test_data,select=c('season','year','month','holiday','weekday','workingday','weather_condition','temp','humidity','windspeed','total_count'))
head(train,5)
head(test,5)
#create a new subset for train categorical attributes
train_cat_attributes<-subset(train,select=c('season','holiday','workingday','weather_condition','year'))
#create a new subset for test categorical attributes
test_cat_attributes<-subset(test,select=c('season','holiday','workingday','weather_condition','year'))
#create a new subset for train numerical attributes
train_num_attributes<-subset(train,select=c('weekday','month','temp','humidity','windspeed','total_count'))
#create a new subset for test numerical attributes
test_num_attributes<-subset(test,select=c('weekday','month','temp', 'humidity','windspeed','total_count'))
library(caret)
#other variables along with target variable to get dummy variables
othervars<-c('month','weekday','temp','humidity','windspeed','total_count')
set.seed(2626)
#Categorical variables
vars<-setdiff(colnames(train),c(train$total_count,othervars))
#formula pass through encoder to get dummy variables
f <- paste('~', paste(vars, collapse = ' + '))
#encoder is encoded the categorical variables to numeric
encoder<-dummyVars(as.formula(f), train)
#Predicting the encode attributes
encode_attributes<-predict(encoder,train)
#Binding the train_num_attributes and encode_attributes
train_encoded_attributes<-cbind(train_num_attributes,encode_attributes)
head(train_encoded_attributes,5)
# Test encoded attributes
set.seed(5662)
#Categorical variables
vars<-setdiff(colnames(test),c(test$total_count,othervars))
#formula pass through encoder to get dummy variables
f<- paste('~',paste(vars,collapse='+'))
#Encoder is encoded the categorical variables to numeric
encoder<-dummyVars(as.formula(f),test)
#Predicting the encoder attributes
encode_attributes<-predict(encoder,test)
#Binding the test_num_attributes and encode_attributes
test_encoded_attributes<-cbind(test_num_attributes,encode_attributes)
head(test_encoded_attributes,5)

#4. Create a model using the random forest algorithm
set.seed(6788271)
library(randomForest)
rf_model<-randomForest(total_count~.,train_encoded_attributes,importance=TRUE,ntree=200)
rf_model

#5. Predict the performance of the model on the test dataset
set.seed(7889)
rf_predict<-predict(rf_model,test_encoded_attributes[,-c(6)])
head(rf_predict,5)

