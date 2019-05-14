#Rotina para coletar e apresentar em gráficos algumas séries do FRED
#Feito por: Felipe Simplício Ferreira
#última atualização: 02/01/2019


#Definindo diretórios a serem utilizados

getwd()
setwd("C:/Users/User/Documents")

#Carregando pacotes que serão utilizados
#library("dplyr")
library("fredr")

#Definindo data incial das séries que serão coletadas
datainicial = "1948-01-01"

#Chave para funcionamento da API do FRED
fredr_set_key("759fd9f905b9d4025ce26e5ae6e63cb9")

#Definindo códigos das séries a serem coletadas
serie = c("ALTSALES", "AWHAETP", "CES0500000003", "CES0500000011", "CIVPART", "CPIAUCSL", "CPILFESL", "CUSR0000SEHA", "CUSR0000SEHC", "EXHOSLUSM495S", "GS10", "HOUST", "HSN1F", "INDPRO", "IPMANSICS", "IPMINE", "IPUTIL", "PAYEMS", "PCEPI", "PCEPILFE", "PERMIT", "RSAFS", "RSXFS", "SPCS20RNSA", "SPCS20RSA", "TTLCONS", "TWEXMMTH", "TWEXMPA", "U6RATE", "UNRATE")

#Repetição para coletar e juntar séries em um arquivo
for (i in 1:length(serie)){
  dados = fredr(serie[i], observation_start = as.Date(datainicial))
  nome = paste("serie", i, sep = "")
  assign(nome, dados)
  if(i==1)
    base = serie1[,-2]
  else
    base = merge(base, dados[,-2], by = "date", all = T)
}

#Nomeando colunas do dataframe com todas as séries
names(base) = c("Date", serie)

#Removendo resíduos
rm(dados)
rm(list=objects(pattern="^serie"))