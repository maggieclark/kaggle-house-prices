
# set up
library(tidyverse)
library(randomForest)

setwd('C:/Users/clark/Documents/GitHub/kaggle-house-prices')


# define functions
ttsplit = function(prepped_data){
  
  sample <- sample(c(TRUE, FALSE), nrow(prepped_data), replace=TRUE, prob=c(0.7,0.3))
  train  <- prepped_data[sample, ]
  test   <- prepped_data[!sample, ]
  
  Xtrain = train %>% 
    select(!REGISTERED_IND)
  
  ytrain = train$REGISTERED_IND
  
  Xtest = test %>% 
    select(!REGISTERED_IND)
  
  ytest = test$REGISTERED_IND
  
  return(list(Xtrain, ytrain, Xtest, ytest))
}


# read data
imported = read_csv('train_cleaned_option1.csv')

# equalize class sizes
unretained_size = xtabs(~REGISTERED_IND, imported)[[1]]
retained_size = xtabs(~REGISTERED_IND, imported)[[2]]

sampled_retained = sample(retained_size, unretained_size)

retained_subset = imported %>% 
  filter(REGISTERED_IND == 'YES')
retained_subset = retained_subset[sampled_retained,]

leftTU_subset = imported %>% 
  filter(REGISTERED_IND == 'NO')

data = rbind(retained_subset, leftTU_subset)


# imputed medians
model1data = data %>% 
  mutate(across(where(is.character), factor)) # convert categoricals to factors

datasets = ttsplit(model1data)

# tree
randomForest(na.roughfix(datasets[[1]]),
             datasets[[2]],
             xtest = na.roughfix(datasets[[3]]),
             ytest = datasets[[4]],
             ntree=1, 
             mtry = ncol(datasets[[1]]),
             importance=T,
             keep.forest=T)

# forest
randomForest(na.roughfix(datasets[[1]]),
             datasets[[2]],
             xtest = na.roughfix(datasets[[3]]),
             ytest = datasets[[4]],
             ntree=100, 
             importance=T)

# missing as factor level
model2data = data %>% 
  mutate(across(where(is.character), \(x) replace_na(x, "unknown"))) %>% 
  mutate(across(where(is.numeric), \(x) replace_na(x, -1)))

model2data = model2data %>% 
  mutate(across(where(is.character), factor)) # convert categoricals to factors

datasets = ttsplit(model2data)

# tree
t = randomForest(datasets[[1]],
                 datasets[[2]],
                 xtest = datasets[[3]],
                 ytest = datasets[[4]],
                 ntree=1,
                 mtry = ncol(datasets[[1]]),
                 importance=T,
                 keep.forest=T)
t

# forest
rf = randomForest(datasets[[1]],
                  datasets[[2]],
                  xtest = datasets[[3]],
                  ytest = datasets[[4]],
                  ntree=100, 
                  importance=T)

### importance plot ###

varImpPlot(t)

### single tree plot ###
tree = getTree(t, 1, labelVar = TRUE) %>%
  tibble::rownames_to_column() %>%
  # make leaf split points to NA, so the 0s won't get plotted
  mutate(`split point` = ifelse(is.na(prediction), `split point`, NA))

# prepare data frame for graph
graph_frame <- data.frame(from = rep(tree$rowname, 2),
                          to = c(tree$`left daughter`, tree$`right daughter`))

# convert to graph and delete the last node that we don't want to plot
graph <- graph_from_data_frame(graph_frame) %>%
  delete_vertices("0")

# set node labels
V(graph)$node_label <- gsub("_", " ", as.character(tree$`split var`))
V(graph)$leaf_label <- as.character(tree$prediction)
V(graph)$split <- as.character(round(tree$`split point`, digits = 2))

# plot
plot <- ggraph(graph, 'dendrogram') + 
  theme_bw() +
  geom_edge_link() +
  geom_node_point() +
  geom_node_text(aes(label = node_label), na.rm = TRUE, repel = TRUE) +
  geom_node_label(aes(label = split), vjust = 2.5, na.rm = TRUE, fill = "white") +
  geom_node_label(aes(label = leaf_label, fill = leaf_label), na.rm = TRUE, 
                  colour = "white", fontface = "bold", show.legend = FALSE) +
  theme(panel.grid.minor = element_blank(),
        panel.grid.major = element_blank(),
        panel.background = element_blank(),
        plot.background = element_rect(fill = "white"),
        panel.border = element_blank(),
        axis.line = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        plot.title = element_text(size = 18))

print(plot)