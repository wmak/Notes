###########################################################
#
# CSC D84 - A5 - Neural Networks for classification
#
# Your tas here is to implement the equations and algorithms
# required to train a Neural Network to perform classification
# of hand-written digits. The goal is to strengthen your
# understanding of
#
# Network structure
# Feed-forward computations
# Error computation
# Error back-propagation
#
# Your code will be called by NeuralNets_core_GL
# during training and testing.
#
# You have access to the following global data (all
# prefixed by 'NeuralNets_global_data.' )
#
# N_out		- Number of output neurons (one per
#                 digit in this case, so this is fixed
#		  at 10, digits are 0 to 9)
# N_in		- Number of inputs. Digits in our
#		  problem consist of a matrix of
#		  8x8 pixels, so 64 inputs plus 1
#		  for the bias term = 65
# N_hidden	- Number of hidden-layer units. 
#		  we will train networks with 
#		  different numbers of units. See
#		  the REPORT.TXT for more details
#		  Note that the actual number of 
#		  neurons is N_hidden-1, but we have
#		  one extra entry for the bias term!
# alpha		- The network's learning rate. Set by
#		  the NeuralNets_init() function.
# sig_type	- Type of sigmoidal function to use,
#		  0 -> logistic, 1 -> tanh
#
# W_io		- For networks with NO hidden layer,
#		  this gives the weights connecting
#		  inputs to output neurons.
#		  This array is of size (N_in, N_out)
#		  and W_io(i,j) gives the weight
#		  connecting input i to output j
#
# W_ih		- For networks with hidden layer, 
#		  this contains the weights linking
#		  inputs to hidden layer neurons.
#		  the arry has size (N_in, N_hidden-1)
#		  (MIND the -1!)
#
# W_ho		- For networks with hidden layer,
#		  this gives the weights connecting
#		  neurons in the hidden layer to
#		  units in the output layer. The
#		  array is of size (N_hidden, N_out)
# 
# Do not add any additional global data.
#
# Starter code: F.J.E. Mar. 2013, Updated Jan. 2014
##########################################################

import NeuralNets_global_data as gdata
import random
import math
from numpy import *

def sigmoid(x):
    if (gdata.sig_type):
        return(tanhyp(x))
    else:
        return(logistic(x))

def logistic(x):
    return (1.0)/(1.0 + math.e ** (-x))

def tanhyp(x):
    return math.tanh(x)

def sigmoid_prime(a):
    if (gdata.sig_type):
        return 1.0 - a**2
    else:
        return a * (1 - a)

def FeedForward(input_sample):
##########################################################
# This function computes the feed-forward activation of
# each neuron in the network. 
#
# For networks with no hidden layer, the feed-forward pass
# is straightforward. The input sample already contains all
# the information you need (including the bias term).
#
# For networks with a hidden layer, compute the outputs 
# for each hidden layer neuron, put them all in a list, 
# and add a bias term of 1.0. This list will be the input
# to the output layer.
#
# You should have completed the logistic() or tanhyp()
# function(s) before you can attempt this part.
#
# NOTE: Your code for this part should call the 
#                       sigmoid()
#       function. NeuralNets_core_GL will set the sigmoid
#       type, so that either logistic() or tanhyp() will be
#       called depending on what the user specifies.
##########################################################

    # Array of activation values for output units
    outputActivation = zeros(shape=(gdata.N_out, 1))
    # Array of activation values for hidden units
    hiddenActivation = zeros(shape=(gdata.N_hidden, 1))
    sample = array(input_sample)

    if gdata.N_hidden:
        for i in range(gdata.N_hidden - 1):
            hiddenActivation[i] = sigmoid(sample.dot(gdata.W_ih[:, i]))
        hiddenActivation[-1] = 1.0
        for i in range(gdata.N_out):
            outputActivation[i] = \
            sigmoid(transpose(hiddenActivation).dot(gdata.W_ho[:, i]))
    else:
        for i in range(gdata.N_out):
            # sample x W_io[column_i]
            outputActivation[i] = sigmoid(sample.dot(gdata.W_io[:, i]))

    return [outputActivation,hiddenActivation]

def trainOneSample(input_sample, input_label):
################################################################
#
# This function performs the actual weight training (!!) of the
# network. It receives an input sample, and the correct label
# for the input sample (a number in [0,9] corresponding to 
# which digit the input represents).
#
# You must use your FeedForward() function to compute the
# activation values for all the units in the network, then
# use the correct label to compute error values *for each
# output unit* (these will be returned!). Then you will
# adjust the weights using the error back-propagation method.
#
# Note that for networks with no hidden layer, you will be
# adjusting the weights in W_io and the computation is
# straightforward.
# For networks with a hidden layer, you will adjust weights
# in both W_ho and W_ih.
#
# NOTE: You will need to use the appropriate derivative of the
#       sigmoid function. Implement the function sigmoid_prime(a)
#       before you start working on this function, and mind
#       the fact that the sigmoid_prime function takes as
#       an argument the *activation* value for the unit, i.e.
#       the output of the neuron.
################################################################

    ###############################################################
    # Use the 'errors' array to store the error between each
    # output neuron and the target value. 
    # Error is defined as e=target - output
    # 
    # We have one output neuron per digit. The 'target' output
    #   should be as follows:
    #      When using the logistic function as the activation
    #          - Correct output neuron should output .8
    #          - All others should output .2
    #      When using the hyperbolic tangent as the activation
    #	   - Correct output neuron should output .6
    #          - All other neurons should output -.6
    ###############################################################

    errors = zeros(shape=(gdata.N_out, 1))
    output = FeedForward(input_sample)

    if gdata.sig_type:
        targets = [0.6, -0.6]
    else:
        targets = [0.8, 0.2]

    for i in range(gdata.N_out):
        target = targets[1]
        if i == input_label:
            target = targets[0]
        errors[i] = target - output[0][i]
    
    if gdata.N_hidden:
        weight = zeros(shape=(gdata.N_hidden, 1))
        for i in range(gdata.N_hidden):
            weight[i] = 0
            for j in range(gdata.N_out):
                weight[i] += \
                    gdata.W_ho[i][j] * sigmoid_prime(output[0][j]) * errors[j]
        for i in range(gdata.N_hidden):
            err = gdata.alpha * weight[i]
            for j in range(gdata.N_in):
                gdata.W_ih[j][i] += err * input_sample[j]
        for i in range(gdata.N_out):
            err = (gdata.alpha * sigmoid_prime(output[0][i]) * errors[i])
            for j in range(gdata.N_hidden):
                gdata.W_ho[j][i] += err * output[1][j]
    else:
        for i in range(gdata.N_out):
            error = gdata.alpha * sigmoid_prime(output[0][i]) * errors[i]
            for j in range(gdata.N_in):
                gdata.W_io[j][i] += error * input_sample[j]

    return errors
