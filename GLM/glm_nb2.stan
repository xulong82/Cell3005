data {
   int<lower=0> N;		# number of outcomes
   int<lower=0> K;		# number of predictors
   matrix<lower=0>[N,K] x;	# predictor matrix
   int y[N];			# outcomes
}

parameters {
   vector<lower=0.001>[K] beta;	# coefficients
   real<lower=0.001>	phi;	# precision
}

model {
   phi ~ cauchy(0, 10);
   beta ~ cauchy(0, 10);

   y ~ neg_binomial_2(x * beta, phi);
#  y ~ neg_binomial_2_log(x * beta, phi);
}

