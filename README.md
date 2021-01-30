# propensity.jl
WIP: Propensity score utilities for Julia

Outline functionality: <br>

<b>interface</b>
* select covariates (artifact -> list of covariates)

<b>core</b>
* calculate propensity score 
  * fit scores with logit (artifact -> trained model object)
  * predict score with trained model (artifact -> scores per instance table)
  
<b>stratification/matching
   * find matches by propensity score (if exists)
      * methods: greedy/random, nearest (knn), threshold (based on distance)
      * (artifact -> matched/sampled training instances table)
<b>weighting

<b>analysis
   * plot scores
   * tests
