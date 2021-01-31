module Propensity

# Dependencies
using Statistics
using StatsModels
using GLM
using DataFrames
using Distributions
using Gadfly

# Module test
greet() = print("Hello World!")


# Core functionality (refactor)

function assign_formula(y, df)
    
    y = Symbol(y)
    fm = term(y) ~ sum(term.(Symbol.(names(df, Not(y)))))
    return fm
end
  

function fit_logit(fm, df)
    
    logit = glm(fm, df, Binomial(), LogitLink())
    return logit
end

    
function assign_propensity_scores(df, fitted_logit)
    
    df[!,Symbol("Propensity_Scores")] = predict(logit, df)
    return df
end


# Matching functionality (refactor)

function assign_quartile(x, Q1, Q2, Q3, Q4)
    if x .<= Q1
        return "Q1"
    elseif x .<= Q2
        return "Q2"
    elseif x .<= Q3
        return "Q3"
    else
        return "Q4"
    end
end


function quartile_col(df, col, new_col)
    
    Q1, Q2, Q3, Q4 = quantile(df[!, Symbol(col)], [0.25 0.5 0.75 1.0])
    
    df = sort(df, [order(Symbol(col), rev=false)])
    
    df[!, Symbol(new_col)] = assign_quartile.(df[:, Symbol(col)], Q1, Q2, Q3, Q4)
    
    return df
end


function sample_by_covariate_quartile()   
end


function sample_by_propensity_score()   
end


# Visualize/Analysis (refactor)

function plot_prop_by_factor(df, factor)
    set_default_plot_size(12cm, 8cm)
    
    fig = plot(
        df,
        x=Symbol(factor),
        y=:Propensity_Scores, 
        color=Symbol(factor),
        Stat.x_jitter(range=0.5),
        Guide.title("Propensity Score")
    ) 
    return fig
end
    


function plot_prop_by_covariate(
        df,
        factor,
        covariate,
        covariate_quartiles
    )
    
    set_default_plot_size(21cm, 8cm)
    
    factor = Symbol(factor)
    covariate = Symbol(covariate)
    covariate_quartiles = Symbol(covariate_quartiles)

    covariate_by_prop = plot(
    df,
        x=covariate,
        y=:Propensity_Scores, 
    color=factor,
        Stat.x_jitter(range=0.5),
    Guide.title("$covariate by Propensity Score")
    )
    covariate_quartile_by_prop = plot(
    df,
        x=covariate_quartiles,
        y=:Propensity_Scores, 
    color=factor,
        Stat.x_jitter(range=0.5),
    Guide.title("$covariate Quartile by Propensity Score")
    )

    h = hstack(covariate_by_prop, covariate_quartile_by_prop)
    
    return h
end
    

end # module
