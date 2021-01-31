# propensity.jl
WIP: A propensity score utility for Julia


### Demo (WIP)

<i>Installation</i>

```
$ julia -e  'using Pkg; pkg"add https://github.com/XXX";'
```

<i>Load Demo Data</i>

* <b>Subjects</b>: 400 subjects (male) from retrospective cohort study hospital with suspected MI.
* <b>Outcome</b>:: 30-day mortality (death=1)
* <b>Intervention</b>:: Rapid administration of a new clot-busting drug (trt=1) versus a standard therapy (trt=0)
* <b>Source</b>:: http://web.hku.hk/~bcowling/data/propensity.csv

```julia
using Propensity
using CSV

df = CSV.File("../../data/propensity.csv") |> DataFrame;
 
# subset to relevant covariates
df = select(df, Not([:death, :male]))

# fit logit function for propensity of intervention
fm = assign_formula("trt", df)
fitted_logit = fit_logit(fm, df)

# Assign propensity scores
df = assign_propensity_scores(df,fitted_logit)
```

<i>Inspect Propensity Scores by Intervention Status</i>
```julia
df[!, Symbol("Treatment")] .= ifelse.(
  df.trt .== 1, "Treatment", "No Treatment")

plot_prop_by_factor(df, "Treatment")
```
<img src="https://github.com/pkmklong/propensity.jl/blob/master/images/_.svg" height="250"  class="center">

<i>Inspect Propensity Scores by Covariates</i>
```julia
df = quartile_col(df, "age", "age_quartiles");

plot_prop_by_covariate(
        df2,
        "Treatment",
        "age",
        "age_quartiles"
    )
```
<img src="https://github.com/pkmklong/propensity.jl/blob/master/images/_.svg" height="250"  class="center">

    
    


<b>WIP Outline</b>: <br>

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
