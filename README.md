# propensity.jl
WIP: A propensity score utility for Julia

Outline functionality: <br>

<b>Interface</b>
* select covariates (artifact -> list of covariates)

<b>Core</b>
* calculate propensity score 
  * fit scores with logit (artifact -> trained model object)
  * predict score with trained model (artifact -> scores per instance table)
  
<b>Stratification/matching</b>
* Inspect covariates by propensity scores (quartiles)
* find matches by propensity score (if exists)
    * methods: greedy/random, nearest (knn), threshold (based on distance)
    * (artifact -> matched/sampled training instances table)
      
<b>Propensity Score Weighting</b>
* TBD

<b>Analysis</b>
   * plot scores
   * tests

Resources
* [Five Steps to Successfully Implement and Evaluate
Propensity Score Matching in Clinical Research Studies](https://www.medschool.umaryland.edu/media/SOM/Departments/Anesthesiology/Resources/Faculty-Development-/Five_Steps_to_Successfully_Implement_and_Evaluate.96979.pdf)
* [Propensity Score Analysis](http://web.hku.hk/~bcowling/examples/propensity.htm)
