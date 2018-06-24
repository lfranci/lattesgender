#Project women in science in Brazil
#May 2018
#Code by Luciana Franci

library(XML) #package to open the researchers xml files

cva <- xmlParse("curriculo.xml")
cva
class(cva)

#Just checking the nodes
cv.root <- xmlRoot(cva)
xmlName(cv.root[[1]])
xmlSize(cv.root)
head(cv.root[[1]][1])

#Everything looks fine, so lets convert the xml to a list of characters, then it will be easy to work on these data
cv.lista <- xmlToList(cva)
cv.lista

#Checking the researchers full name
cv.name <- cv.list[["DADOS-GERAIS"]][[".attrs"]][["NOME-COMPLETO"]]


###############################################################################
#Read all files at the same time
library(XML) #for opening xml files
library(dplyr) #for lapply function
library(genderBR) # package for check the gender names

files <- list.files(pattern = "*.xml")
files

#Reading all XML files
cvFiles  <- lapply(files, function(x) {
  temp <- xmlParse(x)
})


#xml to list
cvList <- list()
for (cv in seq(cvFiles)){
  cvList[[cv]] <- xmlToList(cvFiles[[cv]])
}

#getting names from the list
nameList <- list()
for (name in seq(cvList)){
  nameList[[name]] <-  cvList[[name]][["DADOS-GERAIS"]][[".attrs"]][["NOME-COMPLETO"]]
}

#getting the gender for each name
genderList <- list()
for (gender in seq(nameList)){
  genderList[gender] <- get_gender(nameList[[gender]])
}
genderList

#getting the ID number
idList <- list()
for (id in seq(cvList)){
  idList[[id]] <-  cvList[[id]][[".attrs"]][["NUMERO-IDENTIFICADOR"]]
}

#getting the degree
degreeList <- list()
for (degree in seq(cvList)){
  degreeList[[degree]] <-  cvList[[cv]][["DADOS-GERAIS"]][["FORMACAO-ACADEMICA-TITULACAO"]]
}

#getting the area
areaList <- list()
for (area in seq(cvList)){
  areaList[[area]] <-  cvList[[area]][["DADOS-GERAIS"]][["AREAS-DE-ATUACAO"]][["AREA-DE-ATUACAO"]][["NOME-GRANDE-AREA-DO-CONHECIMENTO"]]
}

#number of published papers
npaperList <- list()
for (npaper in seq(cvList)){
  npaperList[[npaper]] <-  length(cvList[[npaper]][["PRODUCAO-BIBLIOGRAFICA"]][["ARTIGOS-PUBLICADOS"]])
}

#getting the published papers
paperList <- list()
for (paper in seq(cvList)){
  paperList[[paper]] <-  cvList[[paper]][["PRODUCAO-BIBLIOGRAFICA"]][["ARTIGOS-PUBLICADOS"]]
}

#getting the number os supervised students
studentList <- list()
for (student in seq(cvList)){
  studentList[[student]] <-  length(cvList[[student]][["OUTRA-PRODUCAO"]][["ORIENTACOES-CONCLUIDAS"]])
}
studentList

#making a dataframe with name, gender, numer of published papers and number of supervised students
dfCV <- as.data.frame(unlist(nameList))
colnames(dfCV)[1] <- name
dfCV$ID <- unlist(idList)
dfCV$gender <- unlist(genderList)
dfCV$published_papers <- unlist(npaperList)
dfCV$students <- unlist(studentList)

teste <- as.data.frame(unlist(cvList[[1]][["PRODUCAO-BIBLIOGRAFICA"]]))
