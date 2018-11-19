#!/usr/bin/bash

echo "Running profile on r-selected Lotka-Volterra model."
ipython3 -m cProfile LV1.py
echo "Complete."

echo "Running profile on k-selected Lotka-Volterra model."
ipython3 -m cProfile LV2.py 1 0.5 1.5 0.75
echo "Complete."