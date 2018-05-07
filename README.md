# TAGE based Predictor Verilog Code
Verilog Implementation of TAGE based predictor by  Andre Seznec and  Pierre Michaud
The implementation is based on this paper http://www.irisa.fr/caps/people/seznec/JILP-COTTAGE.pdf

I have done some modification with respect to the tag length, this was to limit the hardware bugdet by varying the tag- length and number of indexes

The TAGE predictor has 1 Bimodal Table and 4 TAGGED predictor Component with different geometric lengths respectively 7, 14, 44, 130

Table 1 . Tag-length of Different tag component in different models

| Model No  | T1 | T2 | T3 | T4 | No of Entries |  Total hardware budget in Bits |
|-----------|----|----|----|----|---------------|--------------------------------|
| 1         | 5  | 5  | 5  | 5  | 256           | 11008                          |
| 2         | 8  | 8  | 9  | 9  | 512           | 29174                          |
| 3         | 5  | 5  | 5  | 5  | 1024          | 44032                          |
| 4         | 8  | 8  | 8  | 8  | 1024          | 58368                          |


I have provided a sample test benchmark. The trace was obtained from the 2011 championship branh predictor tournament.

The implementation is basic, you can optimize the verilog code as per your requirement based on the many TAGE papers published.
