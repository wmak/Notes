###########################################################
#
# CSC D84 - A2 - Local search for K-medians problem
#
# In this script you will implement two methods for
# solving the K-medians problem:
#
# 1) Simple local search
#
# 2) Local search with deterministic annealing
#
# Your code will be called by Kmedians_core_GL to
# solve particular instances of the problem, so you
# should not add any tester functions here.
#
# You have access to the following global data (all
# prefixed by 'Kmedians_global_data.' )
#
# all_points      - List of [x,y] point coordinates
# current_medians - List of [x,y] with current medians
# N               - Number of points
# K               - Number of medians
# Temperature	  - Temperature for deterministic annealing
# Decay           - Decay factor for deterministic annealing
#
# Use the global 'current_cost' function to return the cost 
# of a potential solution, e.g.
#
#	Kmedians_global_data.current_cost(guess)
#	will return the cost of 'guess' where guess is
#       a lst of tuples containing a potential solution
#
# Sorry, that's bad style, but I claim poetic license!
# 
# Do not add any additional global data.
#
# Updated by: F.J.E. Jan. 2014
##########################################################

import Kmedians_global_data as g #renamed g for convenience.
import random
from math import *

def distance(a, b):
    return sqrt((a[0] - b[0]) ** 2 + (a[1] - b[1]) ** 2)

def local_search():
    # This function carries out a local search to improve
    # the current guess. You can only examine *ONE* possible
    # update to the current solution per call. That is, at
    # most one of the current medians should change from
    # call to call. Note that this procedure is greedy
    # and will only update the current solution if its
    # new guess yields a better cost

    #####################################################
    # NEIGHBOURHOOD DEFINITION:
    # At each step, one of the current guesses for your
    # median locations can be swaped for another
    # point as long as the distance between the current
    # guess and the point is less than 250 units
    # (this is Euclidean distance of course)
    # This means that you CAN NOT SWAP with just any
    # point! Make sure your updates consider this 
    # simple neighbourhood structure.
    #
    # If the proposed swap is more than 250 units away,
    # do not perform the sawp! just return from this
    # function with the same guess you started with.
    #####################################################

    g.current_cost(g.current_medians)
    old_median = random.choice(g.current_medians)
    new_median = random.choice(g.all_points)
    if distance(old_median, new_median) > 250:
        return
    new_medians = g.current_medians[:]
    new_medians.remove(old_median)
    new_medians.append(new_median)
    if g.current_cost(g.current_medians) > g.current_cost(new_medians):
        g.current_medians = new_medians
    print g.current_cost(g.current_medians)

def deterministic_annealing():
    # This function carries out a local search using the
    # deterministic annealing method as discussed in lecture.
    # The 'temperature' is set by the initKmedians function.
    # Each call to this function will try a new solution
    # and accept it under the conditions specified by the
    # deterministic annealing method.
    # Also, each call to this function will update the
    # temperature as T=T*D, where D<1.0 is a decay factor that
    # controls how quickly the temperature decreases.
    # Both the temperature and decay factor are global
    # variables.

    # Each call to this function can examine only *ONE* 
    # guess at the solution.

    ####################################################
    # THE SAME NEIGHBOURHOOD DEFINITION APPLIES AS FOR 
    # LOCAL SEARCH ABOVE
    ####################################################
    # all_points      - List of [x,y] point coordinates
    # current_medians - List of [x,y] with current medians
    # N               - Number of points
    # K               - Number of medians
    # Temperature	  - Temperature for deterministic annealing
    # Decay           - Decay factor for deterministic annealing

    g.current_cost(g.current_medians)
    old_median = random.choice(g.current_medians)
    new_median = random.choice(g.all_points)
    if distance(old_median, new_median) > 250:
        return
    new_medians = g.current_medians[:]
    new_medians.remove(old_median)
    new_medians.append(new_median)
    dT = abs(g.current_cost(g.current_medians) - g.current_cost(new_medians))
    P = exp(-dT/g.Temperature)
    g.Temperature *= g.Decay
    print("temp: %f" % g.Temperature)
    print("cost: %f" % g.current_cost(g.current_medians))
    if g.current_cost(g.current_medians) > g.current_cost(new_medians):
        g.current_medians = new_medians
    elif random.random() < P:
        g.current_medians = new_medians


    return
