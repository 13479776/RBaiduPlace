### http://developer.baidu.com/map/index.php?title=webapi/guide/webservice-placeapi
library(WriteXLS)
library(rjson)
library(RCurl)

keyword = "餐馆"
key = "" ### 请前往此处申请key: http://lbsyun.baidu.com/apiconsole/key?application=key
city = "长沙"
page_size = 20
page_num = 0
total = 20
placeIDSet = name = lat = lng = address = NULL
while(page_num <= ceiling(total/page_size)-1){
  
  searchURL = paste("http://api.map.baidu.com/place/v2/search?q=",
                    keyword,
                    "&scope=",1,
                    "&page_num=",page_num,
                    "&page_size=",page_size,
                    "&region=",city,
                    "&output=json",
                    "&ak=",key,
                    sep="")
  result = getURL(url = searchURL,ssl.verifypeer = FALSE)
  
  x = fromJSON(result)
  total = x$total
  cat("Retrieving",page_num+1,"from total",ceiling(total/page_size),"pages ...\n")
  page_num = page_num + 1
  
  placeIDSet = c(placeIDSet,
                 unlist(lapply(X = x$results,FUN = function(x)return(x$uid))))
  name = c(name,
                 unlist(lapply(X = x$results,FUN = function(x)return(x$name))))
  lat = c(lat,
                 unlist(lapply(X = x$results,FUN = function(x)return(x$location$lat))))
  lng = c(lng,
                 unlist(lapply(X = x$results,FUN = function(x)return(x$location$lng))))
  address = c(address,
              unlist(lapply(X = x$results,FUN = function(x)return(x$address))))
}
dat = data.frame(name,lng,lat,address,placeIDSet)
WriteXLS(x = "dat",ExcelFileName = "searchResult-baidu.xlsx")
