#Rotina para coletar algumas s�ries do FRED
#Feito por: Felipe Simpl�cio Ferreira
#�ltima atualiza��o: 10/11/2020


#Definindo diret�rios a serem utilizados

getwd()
setwd("C:/Users/User/Documents")

#Carregando pacotes que ser�o utilizados
library("fredr")
#library(rio) #Para exportar em formato xlsx

#Criando fun��o para coleta de s�ries
coleta_dados_fred = function(series, datainicial="2018-01-01", datafinal = format(Sys.time(), "%Y-%m-%d")){
  #Argumentos: vetor de s�ries, datainicial que pode ser manualmente alterada e datafinal que automaticamente usa a data de hoje
  #Chave para funcionamento da API do FRED
  fredr_set_key("759fd9f905b9d4025ce26e5ae6e63cb9")
  #Cria estrutura de repeti��o para percorrer vetor com c�digos de s�ries e depois juntar todas em um �nico dataframe
    for (i in 1:length(series)){
    dados = fredr(series[i], observation_start = as.Date(datainicial), observation_end = as.Date(datafinal))
    nome_coluna = series[i] #Nomeia cada coluna do dataframe com o c�digo da s�rie
    colnames(dados) = c('data', 'codigo da serie', nome_coluna)
    nome_arquivo = paste("dados", i, sep = "") #Nomeia os v�rios arquivos intermedi�rios que s�o criados com cada s�rie
    assign(nome_arquivo, dados)
    
    if(i==1)
      base = dados1[,-2] #Primeira repeti��o cria o dataframe
    else
      base = merge(base, dados[,-2], by = "data", all = T) #Demais repeti��es agregam colunas ao dataframe criado
    print(paste(i, length(series), sep = '/')) #Printa o progresso da repeti��o
  }
  
  base$data = as.Date(base$data, "%d/%m/%Y") #Transforma coluna de data no formato de data
  base = base[order(base$data),] #Ordena o dataframe de acordo com a data
  base[,-1]=apply(base[,-1],2,function(x)as.numeric(gsub(",",".",x))) #Transforma o resto do dataframe em objetos num�ricos
  return(base)
}

#Definida a fun��o, podemos criar objetos para guardar os resultados
#Vetor com c�digo para v�rias s�ries do FRED
serie = c("ALTSALES", "AWHAETP", "CES0500000003", "CES0500000011", "CIVPART", "CPIAUCSL", "CPILFESL", "CUSR0000SEHA", "CUSR0000SEHC", "EXHOSLUSM495S", "GS10", "HOUST", "HSN1F", "INDPRO", "IPMANSICS", "IPMINE", "IPUTIL", "PAYEMS", "PCEPI", "PCEPILFE", "PERMIT", "RSAFS", "RSXFS", "SPCS20RNSA", "SPCS20RSA", "TTLCONS", "TWEXMMTH", "TWEXMPA", "U6RATE", "UNRATE")
ex = coleta_dados_fred(serie) #Criando objeto em que ficam guardados as s�ries

write.csv2(ex, "Exemplo.csv", row.names = F) #Salvando arquivo csv em padr�o brasileiro
#export(ex, "Exemplo.xlsx") #Salvando em formato xlsx