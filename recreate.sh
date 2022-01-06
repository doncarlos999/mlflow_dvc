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
wget https://github.com/doncarlos999/mlflow_dvc/raw/8f8fcc0c124f263b2a54ccf700bdff8d3229ba91/src/train.py -P src
dvc add data/wine-quality.csv
git add .
git commit -m 'data: track'
git tag -a 'v1' -m 'raw data'
dvc push
sed -i.bu '2,1001d' data/wine-quality.csv
rm -f data/wine-quality.csv.bu
dvc add data/wine-quality.csv
git add .
git commit -m "data: remove 1000 lines"
git tag -a 'v2' -m 'removed 1000 lines'
dvc push
python3 src/train.py
sed -i.bu 's/v1/v2/' src/train.py
rm -f src/train.py.bu
python3 src/train.py
mlflow ui
