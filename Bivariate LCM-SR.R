#### Example code for running a bivariate latent growth curve model 
#### using data from an accelerated longitudinal cohort design
#### Authors: Faaiza Khan and R. Chris Fraley

## Notes:V1 = Variable 1; V2 = Variable 2

model <- '  

# Define the latent intercepts and slopes

I_V1 =~ 1*V1_T1 + 1*V1_T2 + 1*V1_T3 
S_V1 =~ 0*V1_T1 + 1*V1_T2 + 2*V1_T3 

I_V2 =~ 1*V2_T1 + 1*V2_T2 + 1*V2_T3 
S_V2 =~ 0*V2_T1 + 1*V2_T2 + 2*V2_T3

# Add cohort

I_V1 ~ cohort
S_V1 ~ cohort
I_V2 ~ cohort
S_V2 ~ cohort

# Define phantom residuals

V1res1 =~ 1*V1_T1
V1res2 =~ 1*V1_T2
V1res3 =~ 1*V1_T3

V2res1 =~ 1*V2_T1
V2res2 =~ 1*V2_T2
V2res3 =~ 1*V2_T3

# Fix means and variances of manifest variables to 0

V1_T1 ~ 0
V1_T2 ~ 0
V1_T3 ~ 0

V2_T1 ~ 0
V2_T2 ~ 0
V2_T3 ~ 0

# Estimate means and variances of latent intercepts and slopes

I_V1 ~ 1
S_V1 ~ 1		

I_V2 ~ 1
S_V2 ~ 1

# Fix residual variances of manifest variables to 0
# We dont need these because we are creating
# phantom variables to function as residuals
# and giving those residuals structure.

V1_T1 ~~ 0*V1_T1
V1_T2 ~~ 0*V1_T2
V1_T3 ~~ 0*V1_T3

V2_T1 ~~ 0*V2_T1
V2_T2 ~~ 0*V2_T2
V2_T3 ~~ 0*V2_T3

# Allow phantom residuals to covary across waves
# Add an equality constraint (optional)

V1res1 ~~ equal3*V2res1
V1res2 ~~ equal3*V2res2
V1res3 ~~ equal3*V2res3

# Allow growth terms to covary

I_V1 ~~ S_V1
I_V1 ~~ I_V2
I_V1 ~~ S_V2

S_V1 ~~ I_V2
S_V1 ~~ S_V2

I_V2 ~~ S_V2

I_V1 ~~ v1*I_V1
S_V1 ~~ v2*S_V1	
I_V2 ~~ v3*I_V2
S_V2 ~~ v4*S_V2

# Model constraints

v1 > 0.01
v2 > 0.01
v3 > 0.01
v4 > 0.01

'

mod1 <- sem(model, data=Data, missing = "ML", mimic="Mplus", orthogonal=TRUE)
summary(mod1, standardized=TRUE)
fitMeasures(mod1, c("chisq","df","pvalue","aic","cfi", "rmsea", "srmr"))
inspect(mod1,what="cov.lv")