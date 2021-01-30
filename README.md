# propensity.jl
WIP: Propensity score utilities for Julia

Outline functionality: <br>

<b>Interface</b>
* select covariates (artifact -> list of covariates)

<b>Core</b>
* calculate propensity score 
  * fit scores with logit (artifact -> trained model object)
  * predict score with trained model (artifact -> scores per instance table)
  
<b>Stratification/matching</b>
   * find matches by propensity score (if exists)
      * methods: greedy/random, nearest (knn), threshold (based on distance)
      * (artifact -> matched/sampled training instances table)
      
<b>Weighting</b>
* TBD

<b>Analysis</b>
   * plot scores
   * tests
