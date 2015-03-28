#!/usr/bin/python

from NeuralNets_core_GL import *
import argparse

if __name__=="__main__":
    parser = argparse.ArgumentParser(description= "D84 test program")
    parser.add_argument("hidden", type=int)
    parser.add_argument("sigmoid", type=int)
    parser.add_argument("learning", type=float)
    parser.add_argument("seed", type=int)
    parser.add_argument("threshold", type=float)
    args = parser.parse_args()

    NeuralNets_init(args.hidden, args.sigmoid, args.learning, args.seed)
    NeuralNets_train(args.threshold)
