jpegGenes_171209<-function(li){
name=0
#for (i in 1:nrow(li))
#for (i in 1:500)
for (i in 501:nrow(li))
{
print(i)
#strand=unlist(strsplit(as.character(li[i,3]),"",fixed=TRUE))

left=(as.numeric(li[i,2])-3000)/1000
right=(as.numeric(li[i,3])+3000)/1000

utrl=li[i,2]
utrr=li[i,3]
utrl1=li[i,9]
utrr1=li[i,10]

if (left <= 0){left=0.001}
if (right <=0){right=0.001}
if (length(utrl) != 1){utrl=0}
if (length(utrr) != 1){utrr=0}
if (length(utrl1) != 1){utrl1=0}
if (length(utrr1) != 1){utrr1=0}

x=paste("SPNG",i,sep="")
jpeg(paste(paste("SPNG",i,sep=""),"jpg",sep="."),width=1280,height=800)
err=try(viewSEQ.dots(range=c(left,right),chr=li[i,7], highlights=c(utrl,utrr,utrl1,utrr1)),TRUE)

if (class(err)=="try-error"){plot(1,1)}
dev.off()

name[i]= paste("SPNG",i,sep="")
}
out=cbind(li[1:i,],name)
write.table(as.matrix(out),file="output.printJPEG.txt")
}
################################################################################################


jpegGenes<-function(li){
name=0
#for (i in 1:nrow(li))
for (i in 1:500)

{
print(i)
#strand=unlist(strsplit(as.character(li[i,3]),"",fixed=TRUE))

left=(as.numeric(li[i,2])-3000)/1000
right=(as.numeric(li[i,3])+3000)/1000

utrl=li[i,4]
utrr=li[i,5]
utrl1=li[i,6]
utrr1=li[i,7]

if (left <= 0){left=0.001}
if (right <=0){right=0.001}
if (length(utrl) != 1){utrl=0}
if (length(utrr) != 1){utrr=0}
if (length(utrl1) != 1){utrl1=0}
if (length(utrr1) != 1){utrr1=0}

x=paste("SPNG",i,sep="")
jpeg(paste(paste("SPNG",i,sep=""),"jpg",sep="."),width=1280,height=800)
err=try(viewSEQ.dots(range=c(left,right),chr=li[i,8], highlights=c(utrl,utrr,utrl1,utrr1)),TRUE)

if (class(err)=="try-error"){plot(1,1)}
dev.off()

name[i]= paste("SPNG",i,sep="")
}
out=cbind(li[1:i,],name)
write.table(as.matrix(out),file="output.printJPEG.txt")
}
################################################################################################

jpegGenes2<-function(li){
name=0
for (i in 1:nrow(li))
#for (i in 1:10)

{
print(i)
strand=unlist(strsplit(as.character(li[i,3]),"",fixed=TRUE))
#print(li[i,1])
#print(li[i,2])
left=(as.numeric(li[i,1])-2000)/1000
right=(as.numeric(li[i,2])+2000)/1000

#print(left)
#print(right)
#if (left <= 0){left=1}
#if (right <=0){right=1}
#x=paste("SPNG",i,sep="")
jpeg(paste(paste("SPNG",i,sep=""),"jpg",sep="."),width=1280,height=800)

#jpeg(paste(paste("SPNG",i,sep=""),"jpg",sep="."),width=600,height=800)
#print(3)
#err=try(viewSeg.heat2(f1=as.matrix(EXO1.vsn.5), range=c(left,right),chr=strand[1], highlights=c(li[i,1],li[i,2])),TRUE)
err=try(viewSeg.heat2(f1=as.matrix(allb.vsn.5), range=c(left,right),chr=strand[1], highlights=c(li[i,1],li[i,2])),TRUE)

if (class(err)=="try-error")
{
plot(1,1)
#viewSeg.heat2(f1=all.vsn.5)
}
#print(4)
dev.off()
name[i]= paste("SPNG",i,sep="")

}
out=cbind(li,name)
write.table(as.matrix(out),file="anti.110108.printJPEG.txt", sep="\t", quote=F)
}


jpegGenes3<-function(li)
{
 name=0
 for (i in 1:length(li))
 {
  print(i)
  jpeg(paste(paste("SPNG",i,sep=""),"jpg",sep="."),width=1280,height=800)
  err=try(viewGEN.sep(gene=li[i]),TRUE)

  if (class(err)=="try-error")
  {
   plot(1,1)
  }
  dev.off()
  name[i]= paste("SPNG",i,sep="")
 }
out=cbind(li,name)
write.table(as.matrix(out),file="out.pab2.printJPEG.txt", sep="\t", quote=F)
}

jpegGenes4<-function(li, output.file="out.UTR.MM.YE.5.printJPEG.txt")
{
 name=0
 for (i in 1:nrow(li))
 for (i in 1:500)
 {
  print(i)
  jpeg(paste(paste("SPNG",i,sep=""),"jpg",sep="."),width=1280,height=800)
  err=try(viewGEN.sep(sep=T, gene=li[i,1], high=c(li[i,"MM.2.start"],li[i,"MM.2.end"],li[i,"YE.2.start"],li[i,"YE.2.end"]), verbose=F),TRUE)
  if (class(err)=="try-error")
  {
   plot(1,1)
  }
  dev.off()
  name[i]= paste("SPNG",i,sep="")
 }
out=cbind(li[1:i,],name)
write.table(as.matrix(out),file=output.file, sep="\t", quote=F)
}

jpegGenes5<-function(li, output.file="out.UTR.SUM.printJPEG.txt")
{
 name=0
 #for (i in 1:nrow(li))
 for (i in 1:500)
 {
  #print(i)
  jpeg(paste(paste("SPNG",i,sep=""),"jpg",sep="."),width=1280,height=800)
  err=try(viewGEN.sep(sep=T, gene=li[i,1], high=c(li[i,"ORF.start"],li[i,"ORF.end"],li[i,"UTR.start"],li[i,"UTR.end"]), verbose=F),TRUE)
  if (class(err)=="try-error")
  {
   plot(1,1)
  }
  dev.off()
  name[i]= paste("SPNG",i,sep="")
 }
out=cbind(li[1:i,],name)
write.table(as.matrix(out),file=output.file, sep="\t", quote=F)
}

jpegGenes6<-function(li=names, output.file="PICS_090211.txt")
{
 name=0
 for (i in 1:length(li))
 #for (i in 1:1)
 

 {
  #print(i)
  jpeg(paste(paste("SPNG",i,sep=""),"jpg",sep="."),width=1280,height=800)
  err=try(viewGEN.sep(sep=T, gene=li[i], verbose=F),TRUE)
  if (class(err)=="try-error")
  {
   plot(1,1)
  }
  dev.off()
  name[i]= paste("SPNG",i,sep="")
 }
out=cbind(li[1:i],name)
write.table(as.matrix(out),file=output.file, sep="\t", quote=F)
}

jpegGenes7<-function(li=constance, output.file="PICS_090112.txt")
{
 name=0
 for (i in 1:length(li))
 #for (i in 1:1)
 

 {
  #print(i)
  jpeg(paste(paste("SPNG",i,sep=""),"jpg",sep="."),width=1280,height=800)
  err=try(viewGEN.sep(sep=F, gene=li[i], verbose=F,what="heatmap"),TRUE)
  if (class(err)=="try-error")
  {
   plot(1,1)
  }
  dev.off()
  name[i]= paste("SPNG",i,sep="")
 }
out=cbind(li[1:i],name)
write.table(as.matrix(out),file=output.file, sep="\t", quote=F)
}


jpegGenes8<-function(li=NCRNA, output.file="PICS_250112.txt")
{
 name=0
 for (i in 1:length(li))
 #for (i in 1:1)
 

 {
  #print(i)
  jpeg(paste(paste("SPNG",i,sep=""),"jpg",sep="."),width=1280,height=800)
  err=try(viewGEN.sep(sep=T, gene=li[i], verbose=F,what="dots"),TRUE)
  if (class(err)=="try-error")
  {
   plot(1,1)
  }
  dev.off()
  name[i]= paste("SPNG",i,sep="")
 }
out=cbind(li[1:i],name)
write.table(as.matrix(out),file=output.file, sep="\t", quote=F)
}

jpegGenes9<-function(li=unique(gffg$Name),output.file="PICS_160612.txt")
{
 name=0
 for (i in 1:length(li))
 #for (i in 1:1)
 

 {
  #print(i)
  jpeg(paste(paste("SPNG",i,sep=""),"jpg",sep="."),width=1280,height=800)
  err=try(viewGEN.sep(sep=F, gene=li[i], verbose=F,what="heatmap"),TRUE)
  if (class(err)=="try-error")
  {
   plot(1,1)
  }
  dev.off()
  name[i]= paste("SPNG",i,sep="")
 }
out=cbind(li[1:i],name)
write.table(as.matrix(out),file=output.file, sep="\t", quote=F)
}

jpegGenes10<-function(li=unique(gffg$Name),output.file="PICS_160812.txt")
{
 name=0
 for (i in 1:length(li))
 #for (i in 1:1)
 

 {
  #print(i)
  jpeg(paste(paste("SPNG",i,sep=""),"jpg",sep="."),width=1280,height=800)
  err=try(viewGEN.sep(sep=F, gene=li[i], verbose=F,what="heatmap"),TRUE)
  if (class(err)=="try-error")
  {
   plot(1,1)
  }
  dev.off()
  name[i]= paste("SPNG",i,sep="")
 }
out=cbind(li[1:i],name)
write.table(as.matrix(out),file=output.file, sep="\t", quote=F)
}



jpegGenes11<-function(li=unique(gffg$Name[grep('SPNCRNA',gffg$Name)]),output.file="PICS_NCRNA_310113.txt")
{
 name=0
 for (i in 1:length(li))
 #for (i in 1:1)
 

 {
  #print(i)
  jpeg(paste(paste("SPNG",i,sep=""),"jpg",sep="."),width=1280,height=800)
  err=try(viewGEN.sep(sep=F, gene=li[i], verbose=F,what="heatmap"),TRUE)
  if (class(err)=="try-error")
  {
   plot(1,1)
  }
  dev.off()
  name[i]= paste("SPNG",i,sep="")
 }
out=cbind(li[1:i],name)
write.table(as.matrix(out),file=output.file, sep="\t", quote=F)
}


jpegGenes12<-function(li=unique(gffg$Name[which(gffg$Name %in% overlap)]),output.file="PICS_NCRNA_040313.txt")
{
 name=0
 
 for (i in 1:length(li))
 #for (i in 1:1)
 

 {
  #print(i)
  jpeg(paste(paste("SPNG",i,sep=""),"jpg",sep="."),width=1280,height=800)
  err=try(viewGEN.sep(sep=F, gene=li[i], verbose=F,what="heatmap"),TRUE)
  if (class(err)=="try-error")
  {
   plot(1,1)
  }
  dev.off()
  name[i]= paste("SPNG",i,sep="")
 }
out=cbind(li[1:i],name)
write.table(as.matrix(out),file=output.file, sep="\t", quote=F)
}


jpegGenes13<-function(li=unique(gffg$Name[which(gffg$Name %in% overlap)]),output.file="PICS_NCRNA_260413.txt")
{
 name=0
 
 for (i in 1:length(li))
 #for (i in 1:1)
 {
  if(li[i] %in% spncrna_segments[,1])
  {
   s_start=spncrna_segments[which(spncrna_segments[,1]==li[i]),"st_seg"]
   s_end=spncrna_segments[which(spncrna_segments[,1]==li[i]),"end_seg"]
  }
  else
  {
   s_start=NA
  }
  
  if(is.na(s_start)==T)
  {
   s_start=0
   s_end=0 
  }
  g_start=gffg$start[which(gffg$Name==li[i])]
  g_end=gffg$end[which(gffg$Name==li[i])]
  #print(paste(s_start,s_end,g_start,g_end),sep="-")
  #print(i)
  jpeg(paste(paste("SPNG",i,sep=""),"jpg",sep="."),width=1280,height=800)
  err=try(viewGEN.sep(sep=F, gene=li[i], verbose=F,what="heatmap",high=c(g_start,g_end,s_start,s_end)),TRUE)
  if (class(err)=="try-error")
  {
   plot(1,1)
  }
  dev.off()
  name[i]= paste("SPNG",i,sep="")
 }
 out=cbind(li[1:i],name)
 write.table(as.matrix(out),file=output.file, sep="\t", quote=F)
}


jpegGenes14<-function(li=unique(gffg$Name[which(gffg$Name %in% names)]),output.file="PICS_NCRNA_280413.txt")
{
 name=0
 
 for (i in 1:length(li))
 #for (i in 1:1)
 

 {
  #print(i)
  jpeg(paste(paste("SPNG",i,sep=""),"jpg",sep="."),width=1280,height=800)
  err=try(viewGEN.sep(sep=F, gene=li[i], verbose=F,what="heatmap"),TRUE)
  if (class(err)=="try-error")
  {
   plot(1,1)
  }
  dev.off()
  name[i]= paste("SPNG",i,sep="")
 }
out=cbind(li[1:i],name)
write.table(as.matrix(out),file=output.file, sep="\t", quote=F)
}

jpegGenes15<-function(li=unique(gffg$Name[which(gffg$Name %in% names_sense)]),output.file="PICS_NCRNA_070513.txt")
{
 name=0
 
 for (i in 1:length(li))
 #for (i in 1:1)
 

 {
  #print(i)
  jpeg(paste(paste("SPNG",i,sep=""),"jpg",sep="."),width=1280,height=800)
  err=try(viewGEN.sep(sep=F, gene=li[i], verbose=F,what="heatmap"),TRUE)
  if (class(err)=="try-error")
  {
   plot(1,1)
  }
  dev.off()
  name[i]= paste("SPNG",i,sep="")
 }
out=cbind(li[1:i],name)
write.table(as.matrix(out),file=output.file, sep="\t", quote=F)
}









