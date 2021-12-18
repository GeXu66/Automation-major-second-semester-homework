function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...          
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

%----------------------------PART 1----------------------------------
%---caculate cost 

% convert y（0-9） to vector
c = 1:num_labels;
yt = zeros(m,num_labels); 
for i = 1:m
    yt(i,:) = (c==y(i));   
end

% compute h(x)
a1 = [ones(m, 1) X];    % 5000 x 401
z2 = a1 * Theta1';      % 5000 x 25 = 5000 x 401 * 401 x 25。  即把401个feature映射到25
a2 = sigmoid(z2);       % 5000 x 25

a2 = [ones(m, 1) a2];   % 5000 x 26
z3 = a2 * Theta2';      % 5000 x 10 = 5000 x 26 * 26 x 10。    即把26个feature映射到10
hx = sigmoid(z3);       % 5000 x 10

% first term
part1 = -yt.*log(hx);
% second term
part2 = (1-yt).*log(1-hx);
hx = sigmoid(z3);  

% regularization term
regTerm = lambda / 2 / m * (sum(sum(Theta1(:,2:end).^2)) + sum(sum(Theta2(:,2:end).^2)));

% J with regularization
J = 1 / m * sum(sum(part1 - part2)) + regTerm; 

%----------------------------PART 2----------------------------------
%--- Backpropagation

% Accumulate the error term
delta_3 = hx - yt;                                               % 5000 x 10
delta_2 = delta_3 * Theta2 .* (a2 .* (1-a2));  % 5000 x 26 = 5000 x 10 * 10 x 26 .* 5000 x 26
delta_2 = delta_2(:,2:end);   % 5000 x 25

% Accumulate the gradient 
D2 = delta_3' * a2;    % 10 x 26 = 10 x 5000 * 5000 x 26
D1 = delta_2' * a1;    % 25 x 401 = 25 x 5000 * 5000 x 401

% Obtain the (unregularized) gradient for the neural network cost function
Theta2_grad = 1/m * D2;
Theta1_grad = 1/m * D1;
%----------------------------PART 3----------------------------------
%---Regularize gradients

temp1 = Theta1;
temp2 = Theta2;
temp1(:,1) = 0; % set first column to 0
temp2(:,1) = 0; % set first column to 0
Theta1_grad = Theta1_grad + lambda/m * temp1;
Theta2_grad = Theta2_grad + lambda/m * temp2;

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end

