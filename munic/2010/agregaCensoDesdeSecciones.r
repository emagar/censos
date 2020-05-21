rm(list=ls())

rootdir <- "~/Dropbox"
wd <- paste(rootdir, "data/elecs/MXelsCalendGovt/censos/munic/2010", sep="/")
setwd(wd)
# datos Valle-Jones
dd <- paste(rootdir, "data/mapas/seccionesIfe/2013secciones/download-maps12-master/ife", sep="/")

# section-level population filenames
files <- c(
"01Aguascalientes/01poblacion_seccion.csv",
"02BajaCalifornia/02poblacion_seccion.csv",
"03BajaCaliforniaSur/03poblacion_seccion.csv",
"04Campeche/04poblacion_seccion.csv",
"05Coahuila/05poblacion_seccion.csv",
"06Colima/06poblacion_seccion.csv",
"07Chiapas/07poblacion_seccion.csv",
"08Chihuahua/08poblacion_seccion.csv",
"09DistritoFederal/09poblacion_seccion.csv",
"10Durango/10poblacion_seccion.csv",
"11Guanajuato/11poblacion_seccion.csv",
"12Guerrero/12poblacion_seccion.csv",
"13Hidalgo/13poblacion_seccion.csv",
"14Jalisco/14poblacion_seccion.csv",
"15Mexico/15poblacion_seccion.csv",
"16Michoacan/16poblacion_seccion.csv",
"17Morelos/17poblacion_seccion.csv",
"18Nayarit/18poblacion_seccion.csv",
"19NuevoLeon/19poblacion_seccion.csv",
"20Oaxaca/20poblacion_seccion.csv",
"21Puebla/21poblacion_seccion.csv",
"22Queretaro/22poblacion_seccion.csv",
"23QuintanaRoo/23poblacion_seccion.csv",
"24SanLuisPotosi/24poblacion_seccion.csv",
"25Sinaloa/25poblacion_seccion.csv",
"26Sonora/26poblacion_seccion.csv",
"27Tabasco/27poblacion_seccion.csv",
"28Tamaulipas/28poblacion_seccion.csv",
"29Tlaxcala/29poblacion_seccion.csv",
"30Veracruz/30poblacion_seccion.csv",
"31Yucatan/31poblacion_seccion.csv",
"32Zacatecas/32poblacion_seccion.csv"
    )

# read aguascalientes and prepare data frame
tmp <- read.csv(file=paste(dd, files[1], sep="/"))
dat <- data.frame(edon=tmp$Entidad, munn=tmp$Municipio, secn=tmp$Seccion, ptot=tmp$Pob_tot, mun=tmp$Nom_mun)
# read remainder states
for (i in 2:32){
    tmp <- read.csv(file=paste(dd, files[i], sep="/"));
    dat <- rbind( dat, data.frame(edon=tmp$Entidad, munn=tmp$Municipio, secn=tmp$Seccion, ptot=tmp$Pob_tot, mun=tmp$Nom_mun) );
}
rm(tmp)

# agregate municipios
dat <- dat[order(dat$edon, dat$munn, dat$secn),]
dat$clave <- dat$edon*1000 + dat$munn
# así se hace en R un by yr mo: egen tmp=sum(invested) de stata
dat$ptota <- ave(dat$ptot, as.factor(dat$clave), FUN=sum, na.rm=TRUE)
dat$ptot <- NULL
colnames(dat) <- c("edon",  "munn",  "secn",  "mun",   "clave", "ptot")

dat <- dat[duplicated(dat$clave)==FALSE,]

table(dat$edon))

dim(dat)
head(dat)

data.frame(munn=dat$munn[dat$edon==30], mun=dat$mun[dat$edon==30], ptot=dat$ptot[dat$edon==30])
