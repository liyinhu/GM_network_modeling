# GM-network-modeling
Gut microbiota (GM) is a micro-ecosystem formed by a large number of microorganisms through competition and cooperation. The project constructs a complex network-based GM modeling approach to evaluate the topological features of the GM micro-ecosystem and provides computational simulations for users to infer the window period and bacterial candidates for GM intervention during disease progression. There are three major parts concluded in the program.<br>
* Network stability assessment<br>
* Network vulnerability assessment<br>
* Network robustness assessment<br>
# Usage
## Network stability assessment  
Before evaluating the stability of the GM networks, we first detect the effect of the nodes in a network by adopting the abundance-weighted mean interaction strength (*wMIS_i*) index. The *wMIS_i* index can be calculated for each node in a network with the following formula.<br>

$$ wMIS_i = \frac{\sum_{{j}\ne{i}}b_j|R_{ij}|}{\sum_{{j}\ne{i}}b_j} $$

where *i* stands for a node in a network, *j* stands for the node connected to node *i*, *bj* stands for the relative abundance of node *j*, and *R_ij* stands for the Spearman correlation coefficient between node *i* and *j*. Here we could get the *wMIS_i* for the nodes with the following script.

perl get_MIS.pl <Averaged.abundances.for.microorganisms.csv> <Microbial.correlation.matrix.csv> <MIS.file>

To evaluate the stability of the networks across the mice development, we detected the core nodes in the networks, and the core nodes were defined as the consistent bacteria that existed in the GM networks across different time points.<br>

$$ S_a = \frac{\sum{i=1}^m wMIS_i}{\sum{j=1}^n wMIS_j} $$

Here

perl 
Then, we calculated the stability of the networks *S_a* with the *wMIS_i* through the following formula.<br>

