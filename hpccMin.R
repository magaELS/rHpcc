hpccMin<-function(dataframe,fields,out.dataframe){
  
  strim<-function (dataframe)
  {
    gsub("^\\s+|\\s+$", "", dataframe)
  }
  
  varlst<<-strsplit(fields, ",")
  str1<-NULL
  str2<-NULL
  for (i in 1:length(varlst[[1]]))
  {
    k<-strim(varlst[[1]][i])
    h<<-strsplit(k," ")
    if (i > 1)
    {
      charh<-paste("'",h[[1]][1],"'",sep="")
      str1<-strim(paste(str1,charh,sep=","))
      hh<-strim(paste("LEFT.",h[[1]][1],sep=""))
      str2<-strim(paste(str2,hh,sep=","))
    }
    else
    {
      charh<-paste("'",h[[1]][1],"'",sep="")
      str1<-strim(paste(str1,charh))
      hh<-strim(paste("LEFT.",h[[1]][1],sep=""))
      str2<-strim(paste(str2,hh))
    }
    
  }
  
  xyz<<-paste(xyz,paste("recmin :=RECORD"),"\n")
  xyz<<-paste(xyz,paste("INTEGER3 id;"),"\n")
  xyz<<-paste(xyz,paste(dataframe,";"),"\n")
  xyz<<-paste(xyz,paste("END;"),"\n")
  xyz<<-paste(xyz,paste("recmin mintrans (",dataframe," L, INTEGER C) := TRANSFORM"),"\n")
  xyz<<-paste(xyz,paste("SELF.id :=C;"),"\n")
  xyz<<-paste(xyz,paste("SELF :=L;"),"\n")
  xyz<<-paste(xyz,paste("END;"),"\n")
  xyz<<-paste(xyz,paste("DSRMIN:=PROJECT(",dataframe,",mintrans(LEFT,COUNTER));"),"\n")
  #xyz<<-paste(xyz,paste("DSR;"),"\n")
  xyz<<-paste(xyz,paste("NumField:=RECORD"),"\n")
  xyz<<-paste(xyz,paste("UNSIGNED id;"),"\n")
  xyz<<-paste(xyz,paste("STRING Field;"),"\n")
  xyz<<-paste(xyz,paste("REAL8 value;"),"\n")
  xyz<<-paste(xyz,paste("END;"),"\n")
  xyz<<-paste(xyz,paste("OutDsMin:=NORMALIZE(DSRMIN,",length(varlst[[1]]),",TRANSFORM(NumField,SELF.id:=LEFT.id,SELF.Field:=CHOOSE
                        (COUNTER,",str1,sep="",");SELF.value:=CHOOSE(COUNTER,",str2,")));","\n"))
  #xyz<<-paste(xyz,paste("OutDsMin;"),"\n")
  xyz<<-paste(xyz,paste("SingleField := RECORD"),"\n")
  xyz<<-paste(xyz,paste("OutDSMin.Field;"),"\n")
  xyz<<-paste(xyz,paste("Minval := MIN(GROUP,OutDSMin.value);"),"\n")
  xyz<<-paste(xyz,paste("END;"),"\n")
  xyz<<-paste(xyz,paste(out.dataframe,":= TABLE(OutDSMin,SingleField,Field);"),"\n")
  xyz <<-strim(paste(xyz,paste("OUTPUT(",out.dataframe,",named('",out.dataframe,"'));",sep="")))
}