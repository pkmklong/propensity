module Propensity

# Dependencies
using Statistics
using StatsModels
using GLM
using DataFrames
using Distributions
using Gadfly
using StatsBase:sample

# Module test
greet() = print("Hello World!")


# Core functionality (refactor)

function assign_formula(y, df)
    
    y = Symbol(y)
    fm = term(y) ~ sum(term.(Symbol.(names(df, Not(y)))))
    return fm
end
  

# split to minority and majority class
# record size of minority class (n)
function split_by_class(df, target)
    target = Symbol(target)
    df_1 = df[df[target] .== 1, :]
    df_0 = df[df[target] .== 0, :]
    min_cls_size = size(df_1)[1]
    return df_1, df_0, min_cls_size
end

  
# Generate n trainings sets 
# concat minority and n subsampled majorities
function make_train_sets(df_0, df_1, n_sets)
    
    min_cls_size = size(df_1)[1]
    
    samples = []
    
    for i in 1:n_sets
        subsample = sample(1:nrow(df_0), 
            min_cls_size,
            replace=false)
        
        df_0_sampled = df_0[subsample, :]
        df_train = [df_0_sampled; df_1]
        
        samples = vcat(samples, df_train)
    end
    return samples
end


# train logit functions for each n train set
function train_n_models(y, df_list)
    
    models = [] 
    for df in df_list
        logit = fit_logit(y, df)
        models = append!(models, [logit])     
    end
    return models
end


function fit_logit(y, df)
    
    fm = assign_formula(y, df)
    
    logit = glm(fm, df, Binomial(), LogitLink())
    return logit
end


    
function assign_propensity_scores(df, logit)
    
    df[!,Symbol("Propensity_Scores")] = predict(logit, df)
    return df
end


# Matching functionality (refactor)

function bin_quartile(x, Q1, Q2, Q3, Q4)
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


function assign_quartile(df, col, new_col)
    
    df = sort(df, [order(Symbol(col), rev=false)])
    
    Q1, Q2, Q3, Q4 = quantile(df[!, Symbol(col)], [0.25 0.5 0.75 1.0])
    
    df[!, Symbol(new_col)] = bin_quartile.(df[:, Symbol(col)], Q1, Q2, Q3, Q4)
    
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
