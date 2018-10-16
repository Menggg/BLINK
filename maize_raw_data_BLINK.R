# This R script is for the maize data format converting in BLINK paper Fig. 3
# Step 1, please download genotype (ZeaGBSv1.0) data from http://cbsusrv04.tc.cornell.edu/users/panzea/filegateway.aspx?category=Genotypes
# and phenotype (USDA Ames inbred collection phenotypes) data from https://www.panzea.org/phenotypes
# Setp2, set up pathway and specify name of data files.
rm(list=ls()) #clean memory
setwd("YOUR PATHWAY") #set pathway
name.gd="NAME of GENOTYPE FILE" #specify name of genotype files
name.gm="NAME of MAP FILE" #specify name of map files
name.pheno="NAME of PHENOTYPE FILE" #specify name of phenotype type files
col.trait=4 #specify column number of phenotype

myGD=read.table(name.gd,head=T)
myGM=read.table(name.gm,head=T)
myY=read.delim(name.pheno,head=T)[c(1,col.trait)]
#convert to PLINK format and filter rare allele (maf<0.05)
myY[which(is.na(myY[,2])),2]=-9
sub <- function(x){
  x=gsub("2","2\t2",x,fixed=TRUE)
  x=gsub("1","1\t2",x,fixed=TRUE)
  x=gsub("0","1\t1", x, fixed=TRUE)
}
myGD2=myGD
myGD2 <- as.data.frame(apply(myGD2,2,sub))
myGD2=t(myGD2)
myGD2=cbind(myGD2[,1:4],myGD2)
myGD2=cbind(myY[,c(1,1)],myGD2)
myGD2[,5]=1
myGD2[,c(3:4)]=0
myGD2[,6]=myY[,2]
write.table(myGD2,file="mydata.ped",quote=F,row.name=F,col.name=F,sep="\t")
myGM=cbind(myGM[,2],myGM)
myGM[,3]=0
myGM[,2]=1:nrow(myGM)
write.table(myGM,file="mydata.map",quote=F,row.name=F,col.name=F,sep="\t")
system("./plink --file mydata --make-bed --maf 0.05 --out maize")
##generate PCA file
system("./plink --bfile maize --pca --out maize")




