This repository contains source code and data needed to generate outputs
needed for the following paper:

Petr Ryšavý, Jiří Kléma, Michaela Dostálová Merkerová
GPACDA -- circRNA-disease association prediction with generating polynomials

You might be also interested in our related work, circGPA: https://ida.fel.cvut.cz/~rysavy/circgpa/

=== Before we start ===
First, the following packages need to be installed in R. Open R terminal and install using the following commands:
install.packages("openxlsx")
install.packages("xlsx")
install.packages("readr")
install.packages("pracma")
install.packages("stringr")
install.packages("polynom")
install.packages("geometry")
install.packages("tictoc")
BiocManager::install("miRBaseConverter")
install.packages("GO.db")
install.packages("org.Hs.eg.db")
install.packages("httr")
install.packages("biomaRt")
install.packages("multiMiR")
install.packages("msigdbr")
install.packages("GGally")
install.packages("network")
install.packages("sna")
install.packages("httr")
install.packages("ggplot2")
install.packages("disgenet2r")
install.packages("Rcpp")
Next, download the source code with the associated graph. There is no need to build your own graph. A graph of interactions is included in the repository. To download the code, call in bash:
git clone https://github.com/petrrysavy/GPACDA.git

==== Run with the default graph ====
The repository you just downloaded comes with the graph of interactions used in the paper's experiments. To generate the output, go to bash and call
> ./GPACDA/runDiseases.sh hsa_circ_0000228
Some of the outputs that can be generated using this command are available in the diseases-small directory.

==== Run with a custom graph ====
If you want to run the GPACDA with our own data, follow the "run with a custom graph" section in guide at https://github.com/petrrysavy/circgpa-paper.

==== Known limitations ====
The algorithm requires a long double value with more exponent bits than common on regular desktop computers. The used long double type needs to accommodate (together with some room for operations with them) binomial coefficients up to the number of mRNAs over the size of the annotation term. See pvalue.cpp. 

==== Sources of the data for the default interaction graph ====
The included RData and CSV files contain a snapshot of interaction graph obtained
from the following databases:

[1] CircInteractome (https://circinteractome.nia.nih.gov/index.html)

Dudekula DB, Panda AC, Grammatikakis I, De S, Abdelmohsen K, and Gorospe M.
CircInteractome: A web tool for exploring circular RNAs and their interacting
proteins and microRNAs. RNA Biology, 2016, Jan 2;13(1):34-42


[2] multiMiR R package (http://multimir.org/)

Yuanbin Ru*, Katerina J. Kechris*, Boris Tabakoff, Paula Hoffman, Richard A. Radcliffe,
Russell Bowler, Spencer Mahaffey, Simona Rossi, George A. Calin, Lynne Bemis,
and Dan Theodorescu. (2014) The multiMiR R package and database: integration
of microRNA-target interactions along with their disease and drug associations.
Nucleic Acids Research, doi: 10.1093/nar/gku631.

[3] ENA Quick GO database (https://www.ebi.ac.uk/QuickGO/)

[4] MSigDB database C5 cathegory (http://www.gsea-msigdb.org/gsea/msigdb/)

Subramanian, A., Tamayo, P., Mootha, V. K., Mukherjee, S., Ebert, B. L., Gillette,
M. A., ... & Mesirov, J. P. (2005). Gene set enrichment analysis: a knowledge-based
approach for interpreting genome-wide expression profiles. Proceedings of the National
Academy of Sciences, 102(43), 15545-15550.

[5] Disgenet

Janet Piñero, Núria Queralt-Rosinach, Àlex Bravo, Jordi Deu-Pons, Anna Bauer-Mehren, Martin Baron, Ferran Sanz, Laura I. Furlong, DisGeNET: a discovery platform for the dynamical exploration of human diseases and their genes, Database, Volume 2015, 2015, bav028, https://doi.org/10.1093/database/bav028

[6] mir2disease

Jiang Q., Wang Y., Hao Y., Juan L., Teng M., Zhang X., Li M., Wang G., Liu Y., (2009) miR2Disease: a manually curated database for microRNA deregulation in human disease. Nucleic Acids Res 37:D98-104.

[7] HMDD3

Huang et al. HMDD v3.0: a database for experimentally supported human microRNA-disease associations. Nucleic Acids Res. 2019 Jan 8;47(D1):D1013-D1017.

[8] circ2disease

Yao, D., Zhang, L., Zheng, M. et al. Circ2Disease: a manually curated database of experimentally validated circRNAs in human disease. Sci Rep 8, 11018 (2018). https://doi.org/10.1038/s41598-018-29360-3

[9] CDASOR

Chengqian Lu, Min Zeng, Fang-Xiang Wu, Min Li, Jianxin Wang, Improving circRNA–disease association prediction by sequence and ontology representations with convolutional and recurrent neural networks, Bioinformatics, Volume 36, Issue 24, December 2020, Pages 5656–5664, https://doi.org/10.1093/bioinformatics/btaa1077

[10] NCPCDA

Li, Guanghui & Yue, Yingjie & Liang, Cheng & Xiao, Qiu & Ding, Pingjian & Luo, Jiawei. (2019). NCPCDA: Network consistency projection for circRNA-disease association prediction. RSC Advances. 9. 33222-33228. 10.1039/C9RA06133A.

[11] DWNCPCDA

Guanghui Li, Jiawei Luo, Diancheng Wang, Cheng Liang, Qiu Xiao, Pingjian Ding, Hailin Chen,
Potential circRNA-disease association prediction using DeepWalk and network consistency projection,
Journal of Biomedical Informatics,
Volume 112,
2020,
103624,
ISSN 1532-0464,
https://doi.org/10.1016/j.jbi.2020.103624.

