hpccData.layout<-function(logicalfilename,out.struct){
  body<-""
  body <-paste('<?xml version="1.0" encoding="utf-8"?>\
               <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"\
               xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"\
               xmlns="urn:hpccsystems:ws:wsdfu">\
               <soap:Body>\
               <DFUInfoRequest>\
               <Name>',logicalfilename,'</Name>\
               </DFUInfoRequest>\
               </soap:Body>\
               </soap:Envelope>\n')
  
  headerFields =
    c(Accept = "text/xml",
      Accept = "multipart/*",
      'Content-Type' = "text/xml; charset=utf-8",
      SOAPAction="urn:hpccsystems:ws:wsdfu")
  
  reader = basicTextGatherer()
  handle = getCurlHandle()
  
  fileout<-getwd()
  str<-.libPaths()
  str1<-paste(str,"/rtoHpcc/hostsetting.txt",sep="")
  tt<-read.table(str1,sep="\t")
  f1<-as.character(tt$V1[[1]])
  f2<-as.character(tt$V1[[2]])
  ur<-paste("http://",f1,":",f2,"/WsDfu?ver_=1.2",sep="")
  curlPerform(url = ur,
              httpheader = headerFields,
              postfields = body,
              writefunction = reader$update,
              curl =handle
  )
  #status = getCurlInfo( handle )$response.code
  
  sResponse <- reader$value()
  responseXml <- xmlParse(sResponse)
  layout <- getNodeSet(responseXml, "//*[local-name()='Ecl']/text()", namespaces = xmlNamespaceDefinitions(responseXml,simplify =
                                                                                                              TRUE))
  colLayout <- layout[[1]]
  assign(paste(out.struct),xmlToList(colLayout,addAttributes=TRUE), envir = .GlobalEnv)
}