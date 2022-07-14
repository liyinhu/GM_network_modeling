#Step1. calcuate the wMISi for all nodes in networks 
perl get_MIS.pl 1M_input/1M_mean.csv 1M_input/AD1M_r.0.05.0.4.csv AD AD1M_MIS.xls
perl get_MIS.pl 2M_input/2M_mean.csv 2M_input/AD2M_r.0.05.0.4.csv AD AD2M_MIS.xls
perl get_MIS.pl 3M_input/3M_mean.csv 3M_input/AD3M_r.0.05.0.4.csv AD AD3M_MIS.xls
perl get_MIS.pl 6M_input/6M_mean.csv 6M_input/AD6M_r.0.05.0.4.csv AD AD6M_MIS.xls
perl get_MIS.pl 9M_input/9M_mean.csv 9M_input/AD9M_r.0.05.0.4.csv AD AD9M_MIS.xls

#Step2. get the common gut bacteria during the development
get_common_taxo.pl mean_abundance.lst AD AD_common_tax.xls

#Step3. stability assessment
perl get_stability.pl AD_MIS.lst AD_common_tax.xls AD_stability.xls
