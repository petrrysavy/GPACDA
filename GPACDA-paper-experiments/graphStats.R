source('annotate.R')
source('goterms.R')
source('diseaseAnnotation.R')
loadDiseaseData()

print(paste("CircRNAs:", length(unique(circ_mirna_map$circRNA))))
print(paste("Circ-Mir:", nrow(circ_mirna_map)))
print(paste("mir-gene:", nrow(geneInteract)))

print(paste("mir-disease:", nrow(mirna2disease)))
print(paste("mir-disease:", nrow(mirna2disease)))

print(paste("disease db:", length(goTermNames)))
n <- 0
for(disease in goTermNames) {
    n <- n + sum(buildGOMu(disease))
}
print(paste("mir-disease db:", n))
n <- 0
for(disease in goTermNames) {
    n <- n + sum(buildGOM(disease))
}
print(paste("gene-disease db:", n))

print(paste("test-dataset size:", nrow(read.xlsx("diseases-small/disease-test-dataset.xlsx"))))

