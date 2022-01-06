#!/bin/bash

echo "# mlflow_dvc" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin git@github.com:doncarlos999/mlflow_dvc.git
git push -u origin main
dvc init
git commit -m "dvc init"
dvc remote add -d myremote s3://edge-impulse-staging-dvc-test
git add .dvc/config
git commit -m "configured remote storage"
mkdir data
wget https://github.com/mlflow/mlflow/raw/master/examples/sklearn_elasticnet_wine/wine-quality.csv -P data
mkdir src
wget https://github.com/mlflow/mlflow/raw/master/examples/sklearn_elasticnet_wine/train.py -P data
dvc add data/wine-quality.csv
git add .
git commit -m 'data: track'
git tag -a 'v1' -m 'raw data'
dvc push
