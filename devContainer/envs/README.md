# 建立environment.yml
```bash
conda env export --from-history --no-builds > envs/environment.yml

conda env export --no-builds > envs/environment_full.yml

conda list --explicit > envs/environment_explicit.txt
```
