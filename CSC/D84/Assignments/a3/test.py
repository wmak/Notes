#!/usr/bin/python

from MiniMax_core_GL import *
import argparse

if __name__=="__main__":
    parser = argparse.ArgumentParser(description= "D84 test program")
    parser.add_argument("seed", type=int)
    parser.add_argument("cats", type=int)
    parser.add_argument("cheese", type=int)
    parser.add_argument("type", type=int)
    parser.add_argument("lookahead", type=int)
    args = parser.parse_args()

    initGame(args.seed, args.cats, args.cheese)
    doSearch(args.type, args.lookahead)
