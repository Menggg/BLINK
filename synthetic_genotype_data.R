##Please download demo data from https://github.com/Menggg/BLINK/tree/master/demo_data/blink_binary 
##and https://github.com/Menggg/BLINK/tree/master/demo_data/PLINK
##Then put all the files in these two folders and BLINK executable file into same folder.
##change the name of BLINK executable file to blink
##change pathway to this folder using setwd()
set.seed(123456)
myY=read.table("myData.txt",head=T)
n=5e2  ##number of samples in synthetic data file
name.file="5e2"  ##name of synthetic files
index=as.matrix(sample(1:nrow(myY),n,replace = T))
write.table(index,file="myData.list",quote=F,row.name=F,col.name=F,sep="\t") #keep the file pre-name same as raw data file's name
write.table(myY[index[,1],],file=paste("copy_",name.file,".txt",sep=''),quote=F,row.name=F,col.name=T,sep="\t") #keep the file pre-name same as raw data file's name
system(paste("./blink --file myData --binary --keep --out copy_",name.file,sep='')) #generate synthetic binary BLINK file
file.copy("myData.map", paste("copy_",name.file,".map",sep=''))
system(paste("./blink --file copy_",name.file," --recode --plink --out copy_",name.file,sep='')) #convert synthetic binary BLINK file to PLINK format
system(paste("./blink --file copy_",name.file," --recode --numeric --out copy_",name.file,sep='')) #convert synthetic binary BLINK file to Farmcpu and BLINK-R format
myBIM=read.table("myData.bim",head=F)
myFAM=read.table("myData.fam",head=F)
myFAM_S=myFAM[index[,1],]
myFAM_S[,1]=1:nrow(myFAM_S)
myFAM_S[,2]=myFAM_S[,1]
write.table(myFAM_S,file=paste("copy_",name.file,".fam",sep=''),quote=F,row.name=F,col.name=F,sep="\t")
file.copy("myData.bim", paste("copy_",name.file,".bim",sep=''))

##test new synthetic files
system(paste("./blink --file copy_",name.file," --numeric --gwas",sep=''))
system(paste("./blink --file copy_",name.file," --plink --gwas",sep=''))
