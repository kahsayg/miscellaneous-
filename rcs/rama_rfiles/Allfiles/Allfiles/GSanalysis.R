# Two step Approach
# Adjusted means are calculated across locations
#meand are then used in ridge regression blup
################################ SET WORKING DIRECTORY
setwd("C:/Users/Rama/Desktop/GenomicSelection-Course")
############################################################################################################33
# In the following script
# I will use rrBLUP to demonstrate to calculate genetic parameters and hertiability 
# using mixed models, BLUP and GBLUP - in BLUP relationship matrix (A matrix) estimted from pedigree is used 
## In GBLUP, relationship matrix (G matrix) calcualted from the SNP genotype information is used 
## Also in the last part of the script, I wil demonstrate how to use rrBLUP to compare the accuracy of prediction using 
## BLUP vs GBLUP in genomic selection. 
# I am using five fold cross validation scheme here, for all the SNPs (8000 SNPs), it can be furthre modified
# The same script can be modified to compare Accuracy of BLUP vs GBLUP at different marker densities ( for example
# 100, 2000, 3000, etc) 
# The idea is to find the lowest possible number of SNP which can give highest accuracy vs GBLUP 
# so that, it can be used for routine genotyping to reduce cost of genotyping in commercial breeding programs
###################################################################################################3

# Install required packages ##
#install.packages("rrBLUP")
#install.packages("reshape")
library(rrBLUP)
library(reshape)
#install.packages("kinship2") # to create A matrix
library(kinship2) 
#install.packages("plyr")
#install.packages("randomForest")
library(plyr)
library(randomForest) 
#install.packages("plyr")
#install.packages("ggplot2")
#install.packages("gridExtra")
#install.packages("scales")
#install.packages("grid")
library(plyr)
library(randomForest) 
library(ggplot2)
library(gridExtra)
library(scales)
library(grid)
library(rrBLUP)

##################################################################################################################3
##################################################################################################################3
##################################################################################################################3

# This data has all the 
# This data file has 
## PHENOTYPES followed by GENOTYPES for the same animals 
alldata<- read.delim(file="C:/Users/Rama/Desktop/GenomicSelection-Course/data.txt", header=TRUE, sep="\t")
#SNP coding
# AA, TT =1
# AG, GC, etc = 0
# GG, CC = -1
# missing = NA
## Take out first 8 columns related to PHENOTYPE
## Check different columsn
## Here trait is DAY - this data is from diseae challenge test 
# day - is number of days fish survived the disease challenge test 
# this is a subset of real data set - property of AquaInnovo S.A., chile and should not be used elsewhere. 
data <-alldata[c(1:8)]
## Take out rest of the columns for Genotypes of the animals 
geno <-alldata[c(-(1:8))]
rownames(geno) = data$animal


#######################################################################
## Randomly devide SNP data into 500, 1000, 3000, 10000, 20000, original 
## First devide the SNP data into randomly to check accuracy of GBLUP at different marker densities
### than List of G-matrix for different marker densities to use below in Five fold cross validation
## However, in this example, i have used entire 8000 SNP
# It can be modified 
#SNPlist= list(100,500,1000,3000,10000,20000,ncol(geno))
SNPlist= list(ncol(geno))
#SNPlist= list(500,1000)
GmatList=list()
for(i in SNPlist){
  SNPmatrix= geno[, sample(ncol(geno), i, replace=FALSE)]
  #create Gmatrix
  GmatList[[i]] <-A.mat(SNPmatrix)
  
}

# calculate marker based relationship matrix - this G-matrix from all the 8000 SNP
## this will be used in GBLUP below
Gmatrix <-A.mat(geno)
data = as.data.frame(data)


##### Pedigree based kin.blup ########
###########################################
## IMPORT Pedigree and prepare A matrix to use in BLUP
## this A matrix is used in BLUP below
pedigree<- read.table(file="C:/Users/Rama/Desktop/GenomicSelection-Course/pedigree.txt", header=TRUE)

#load kinship library
A <- 2*kinship(pedigree$animal, pedigree$sire, pedigree$dam)  #relationship matrix
#Extract Matrix for those animals - with data
names = as.matrix(data$animal)
Amatrix=A[names,names ]

#data <- newdata[order(newdata$Family, newdata$SRS_MORTALITY),]

################### THE FOLLOWING SCRIPT will Calculate 
#### Breeding values, heritability and Accuracy of EBV = sqrt((1-PEV)/genvar)
### Save the results in seperate folders per traits
### BOTH FOR Gmatrix = Matrix from SNP, and Amatrix= matrix from Pedigree
### Gmatrix for GBLUP and AMatrix for BLUP
#### FOR FULL DATA
################################

## List of traits to include in the data - Change the number of traits here. 
trait=list("day")
## you can choose other traits if you want, 
# than the script will estimate for each trait and save the results in seperate folders 

###############################################################
## Loop starts here 

## The trait used is "day" 
  
for(t in trait){
  ## EACH trait with Gmatrix and Amatrix 
  ## GBLUP using Gmatrix, prepared above 
  ## THIS is GBLUP part - MODEL
  GBLUP = kin.blup(data=data,geno="animal",
                   GAUSS=FALSE, pheno =t, 
                   K=Gmatrix, 
                   fixed="group",
                   covariate="finalwt", 
                   reduce=FALSE,
                   PEV=TRUE)
  # here estimate heritability, extract solution, calculate accuracy of EBV etc 
  h2_GBLUP = GBLUP$Vg/(GBLUP$Vg+GBLUP$Ve) 
  sol_GBLUP= round(as.data.frame(GBLUP),6)
  sol_GBLUP$GBLUP_EBVAcc=round(sqrt(1-sol_GBLUP$PEV/sol_GBLUP$Vg),4)
  GBLUP_EBVAcc=mean(sol_GBLUP$GBLUP_EBVAcc) 
  h2Acc_GBLUP=cbind(h2_GBLUP,GBLUP_EBVAcc)
  
  ##### Pedigree based kin.blup ########
  ###########################################
  ## here is the BLUP part - MODEL
  BLUP = kin.blup(data=data,geno="animal",
                  GAUSS=FALSE, pheno =t, 
                  K=Amatrix, 
                  fixed="group",
                  covariate="finalwt",
                  PEV=TRUE)
  
  h2_BLUP = BLUP$Vg/(BLUP$Vg+BLUP$Ve) 
  sol_BLUP= round(as.data.frame(BLUP),6)
  sol_BLUP$BLUP_EBVAcc=round(sqrt(1-sol_BLUP$PEV/sol_BLUP$Vg),4)
  BLUP_EBVAcc=mean(sol_BLUP$BLUP_EBVAcc) 
  h2Acc_BLUP=cbind(h2_BLUP,BLUP_EBVAcc)
  
  ## Saving files in respective folders for the traits
  ## Change the parth according to your folder - my folder is "Results"
  
  path = dir.create(paste0("C:/Users/Rama/Desktop/GenomicSelection-Course/Results",t), showWarnings = FALSE)
  
  ## Save solutions gblup 
  write.table(sol_GBLUP, file.path(paste0("C:/Users/Rama/Desktop/GenomicSelection-Course/Results",t),
                                         "solutions_GBLUP.txt"),  sep="\t", row.names = FALSE, col.names = T,quote = FALSE, append = F)
  ## Save solutions blup
  write.table(sol_BLUP, file.path(paste0("C:/Users/Rama/Desktop/GenomicSelection-Course/Results",t),
                                        "solutions_BLUP.txt"),  sep="\t", row.names = F, col.names = T,quote = FALSE, append = F)
  ## Save hertability and EBV accuracy gblup
  write.table(h2Acc_GBLUP, file.path(paste0("C:/Users/Rama/Desktop/GenomicSelection-Course/Results",t),
                                     "h2Acc_GBLUP.txt"),  sep="\t", row.names = F, col.names = T,quote = FALSE, append = F)
  ## Save heritability and EBV accuracy blup
  write.table(h2Acc_BLUP, file.path(paste0("C:/Users/Rama/Desktop/GenomicSelection-Course/Results",t),
                                    "h2Acc_BLUP.txt"),  sep="\t", row.names = F, col.names = T,quote = FALSE, append = F)
  
  
  
}

############################################################################################################
################### FIVE FOLD CROSS VALIDATION WITH AND WITHOUT SNP INFORMATION
###########################################################################################################
#############################################################################################################
###########################################################################################################
#############################################################################################################

####################
data$ID=data$animal
#Randomly shuffle the data
data<-data[sample(nrow(data)),]

###### Number of Fold = cycles 
cycles=5
### number of traits= one trait at a time 
traits=1
data$ID <- sample(1:cycles, nrow(data), replace = TRUE)
list <- 1:cycles
### List of traits need to be analyzed
trait=list("day")
SNPlist= list(ncol(geno))

## Define empty vectors  for both GBLUP and BLUP
CV_h2_GBLUP=matrix(nrow=cycles, ncol=traits)
CV_acc_GBLUP=matrix(nrow=cycles, ncol=traits)
CV_accpred_GBLUP=matrix(nrow=cycles, ncol=traits)
CV_Rel_GBLUP=matrix(nrow=cycles, ncol=traits)

CV_h2_BLUP=matrix(nrow=cycles, ncol=traits)
CV_acc_BLUP=matrix(nrow=cycles, ncol=traits)
CV_accpred_BLUP=matrix(nrow=cycles, ncol=traits)
CV_Rel_BLUP=matrix(nrow=cycles, ncol=traits)

## Check the progress of the run 

progress.bar <- create_progress_bar("text")
progress.bar$init(cycles)
###############################################################
## K- Fold Cross validation - LOOP STARTS HERE
###############################################################
## For every trait
for (t in trait){
  #### Create directory to save results for this particular trait
  dir.create(paste0("C:/Users/Rama/Desktop/GenomicSelection-Course/CVRESULTS/",t), showWarnings = FALSE)
  ## For everydata
  ## First RUN full model, because we need heritability estimate for the particular trait
  ## This will increase computing time though
  GBLUP = kin.blup(data=data,geno="animal",
                   GAUSS=FALSE, pheno =t, 
                   K=Gmatrix, 
                   fixed="group",
                   covariate="finalwt", 
                   reduce=FALSE,
                   PEV=TRUE)
  
  h2_GBLUP = GBLUP$Vg/(GBLUP$Vg+GBLUP$Ve) 
  ### Here is the heritability 
  BLUP = kin.blup(data=data,geno="animal",
                  GAUSS=FALSE, pheno =t, 
                  K=Amatrix, 
                  fixed="group",
                  covariate="finalwt", 
                  reduce=FALSE,
                  PEV=TRUE)
  
  h2_BLUP = BLUP$Vg/(BLUP$Vg+BLUP$Ve)   
  
## CROSS VALIDATION step starts here   
    for(g in SNPlist){
      for (r in 1:cycles){
        progress.bar <- create_progress_bar("text")
        progress.bar$init(cycles)
        cat("Running trait", t, "and data fold", r, "\n")
        trainingset <- subset(data, ID %in% list[-r])
        testset <- subset(data, ID %in% c(r))
        testpheno=testset
        ## Set trait as missing in test data 
        testset$day = NA
        data1=rbind(trainingset,testset)
        ### LICE COUNT - WITH GENOMIC INFOMRATION and WITHOUT Genomic Information
        CV_GBLUP = kin.blup(data=data1,geno="animal",
                        GAUSS=FALSE, pheno =t, 
                        K=GmatList[[g]], 
                        fixed="group",
                        covariate="finalwt", 
                        reduce=FALSE,
                        PEV=TRUE)
        CV_hGBLUP= sqrt(CV_GBLUP$Vg/(CV_GBLUP$Vg+CV_GBLUP$Ve))
        CV_h2_GBLUP[r,1] = round(CV_GBLUP$Vg/(CV_GBLUP$Vg+CV_GBLUP$Ve),4)
        h_GBLUP =sqrt(h2_GBLUP)
        solution=as.data.frame(CV_GBLUP)
        solution$animal = row.names(solution)
        pheno=cbind(testpheno["animal"], testpheno[t])
        solpheno= merge(solution, pheno, by="animal")
        CV_acc_GBLUP[r,1] = round(cor(solpheno$g, solpheno[t]), 4)
        CV_accpred_GBLUP[r,1] = round(cor(solpheno$pred, solpheno[t]), 4)
        CV_Rel_GBLUP[r,1] = round(cor(solpheno$g, solpheno[t])/h_GBLUP,4)
    
    ############
        CV_BLUP = kin.blup(data=data1,geno="animal",
                       GAUSS=FALSE, pheno =t, 
                       K=Amatrix, 
                       fixed="group",
                       covariate="finalwt", 
                       reduce=FALSE,
                       PEV=TRUE)
        CV_hBLUP= sqrt(CV_BLUP$Vg/(CV_BLUP$Vg+CV_BLUP$Ve))
        CV_h2_BLUP[r,1] = round(CV_BLUP$Vg/(CV_BLUP$Vg+CV_BLUP$Ve),4)
        h_BLUP =sqrt(h2_BLUP)
        solution=as.data.frame(CV_BLUP)
        solution$animal = row.names(solution)
        pheno=cbind(testpheno["animal"], testpheno[t])
        solpheno= merge(solution, pheno, by="animal")
        CV_acc_BLUP[r,1] = round(cor(solpheno$g, solpheno[t]), 4)
        CV_accpred_BLUP[r,1] = round(cor(solpheno$pred, solpheno[t]), 4)
        CV_Rel_BLUP[r,1] = round(cor(solpheno$g, solpheno[t])/h_BLUP,4)
    
    #check the progress of the datastep 
        progress.bar$step()
        }
  ### Summarize the results - Summary and output the accuracy from each fold into specific folders
  
  result= as.data.frame(cbind(CV_h2_GBLUP, CV_acc_GBLUP, CV_accpred_GBLUP, CV_Rel_GBLUP, CV_h2_BLUP, CV_acc_BLUP,CV_accpred_BLUP,CV_Rel_BLUP))
  names(result)=c("h2GBLUP", "AccGBLUP", "AccpredGBLUP", "RelGBLUP", "h2BLUP", "AccBLUP", "AccpredBLUP","RelBLUP")
  result$h2Increase=round((result$h2GBLUP-result$h2BLUP)*100/result$h2BLUP,4)
  result$AccIncrease=round((result$AccGBLUP-result$AccBLUP)*100/result$AccBLUP,4)
  result$AccPredIncrease=round((result$AccpredGBLUP-result$AccpredBLUP)*100/result$AccpredBLUP,4)
  result$RelIncrease=round((result$RelGBLUP-result$RelBLUP)*100/result$RelBLUP,4)
  meanSD= sapply(result, function(cl) list(means=round(mean(cl,na.rm=F),4), sds=round(sd(cl,na.rm=F),4)))
  
  ## Mean and SD
  combine= rbind(result, meanSD)
  AccmeanSD <- data.frame(lapply(combine, as.character), stringsAsFactors=FALSE)
  row.names(AccmeanSD)=row.names(combine)
  AccmeanSD$datafold= row.names(AccmeanSD)
  # Save the output in each folders 
  ## Save  Accuracy 
  path=dir.create(paste0("C:/Users/Rama/Desktop/GenomicSelection-Course/CVRESULTS/",t,"/SNP",g), showWarnings = FALSE)
  ## Save solutions blup
  write.table(AccmeanSD, file.path(paste0("C:/Users/Rama/Desktop/GenomicSelection-Course/CVRESULTS/",t,"/SNP",g),
                                   "Accuracy.txt"),  sep="\t", row.names = F, col.names = T,quote = FALSE, append = F)
 
  }
}



### END OF LOOP 


### Save this data with ID for use in other softwares like BLUPf90 and GS3 to use in for the same data for CROSSS validations

