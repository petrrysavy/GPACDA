source("delta_report.R")

source('diseaseAnnotation.R')
loadDiseaseData()

deltaReport("hsa_circ_0000228", file="diseases-small/hsa_circ_0000228-diseases.xlsx", target_file="diseases-small/hsa_circ_0000228-delta-report.txt", fdrcutoff=0.05,
                            plotsFolder="deltareport-circ228-diseases",
                            plotsFiltered1="deltareport-circ228-diseases1",
                            plotsFiltered2="deltareport-circ228-diseases2",
                            plotsFiltered5="deltareport-circ228-diseases5"
                        )
