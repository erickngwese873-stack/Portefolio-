# Marketing dataset

This project uses the Kaggle dataset:

- `rabieelkharoua/predict-conversion-in-digital-marketing-dataset`

## Download (via KaggleHub)

```python
import kagglehub

# Download latest version
path = kagglehub.dataset_download("rabieelkharoua/predict-conversion-in-digital-marketing-dataset")

print("Path to dataset files:", path)
```

## Notes

- You may need to authenticate KaggleHub (Kaggle API credentials) locally.
- The dataset files will be downloaded to a local cache directory; add the downloaded data files to `.gitignore` if you do not want to commit them.
