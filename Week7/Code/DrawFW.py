#!/usr/bin/env python3
""" """

__author__ = "Katie Bickerton (k.bickerton18@imperial.ac.uk)"
__version__ = "3.5.2"

import networkx as nx
import scipy as sc
import matplotlib.pyplot as p

# generate a random food web with n species and connectance probability C
# initial values - assumption that without input, N starts at 2, and C is 0.5
def GenRdmAdjList(N= 2, C= 0.5):
    """Function docstring."""
    # list of given range
    Ids = range(N)
    # empty list
    ALst = []
    for i in Ids:
        # for i in range of N, if is less than connectance
        if sc.random.uniform(0,1,1) < C:
            # generates a numpy array, so turns into list
            Lnk = sc.random.choice(Ids,2).tolist()
            if Lnk[0] != Lnk[1]:
                ALst.append(Lnk)
    return ALst

MaxN = 30
C = 0.75
AdjL = sc.array(GenRdmAdjList(MaxN,C))
Sps = sc.unique(AdjL)

# Generate nodes - in this case body sizes
SizRan = ([-10,10])
Sizs = sc.random.uniform(SizRan[0],SizRan[1],MaxN)
p.hist(Sizs)
p.hist(10**Sizs)
p.close('all')

Figure = p.figure()
# Using a circular configuration
# calculating coordinates for nodes
pos = nx.circular_layout(Sps)
# generate the network graph object
G = nx.Graph()
# add in nodes
G.add_nodes_from(Sps)
# add links/edges
G.add_edges_from(tuple(AdjL))
# generate node sizes that are proportional to log body sizes
NodSizs = 1000 * (Sizs-min(Sizs)/(max(Sizs)-min(Sizs)))
# rendering the graph
nx.draw_networkx(G, pos, node_size = NodSizs)
Figure.savefig("../Results/NetworkPlot.pdf")