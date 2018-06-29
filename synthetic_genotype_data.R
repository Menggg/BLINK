
##Please download demo data from https://github.com/Menggg/BLINK/tree/master/demo_data/blink_binary
set.seed(123456)
myY=read.table("myData.txt",head=T)
n=2e4  ##number of samples in synthetic data file
index=as.matrix(sample(1:nrow(myY),n,replace = T))
write.table(index,file="myData.list",quote=F,row.name=F,col.name=F,sep="\t") #keep the file pre-name same as raw data file's name
write.table(myY[index[,1],],file="copy_2e4.txt",quote=F,row.name=F,col.name=T,sep="\t") #keep the file pre-name same as raw data file's name
system("./blink --file myData --binary --keep --out copy_2e4") #generate synthetic binary BLINK file
system("./blink --file copy_2e4 --recode --plink --out copy_2e4") #convert synthetic binary BLINK file to PLINK format
system("./blink --file copy_2e4 --recode --numeric --out copy_2e4") #convert synthetic binary BLINK file to Farmcpu and BLINK-R format
