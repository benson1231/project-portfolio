# ===============================================================
# 載入套件
# ===============================================================

library(dplyr)        # 資料處理
library(survival)     # 生存分析核心
library(survminer)    # KM 圖、風險表與輔助視覺化
library(ggplot2)      # ggplot2 畫圖（histogram 用到）


# ===============================================================
# survival 套件內建資料集：lung
# ===============================================================

# 轉為 tibble，輸出更易讀
lung <- as_tibble(lung)

# 基本概覽
dim(lung)        # 列數、欄數
summary(lung)    # 數值摘要、缺失概況

# ---------------------------------------------------------------
# lung 資料集欄位說明
# ---------------------------------------------------------------
# inst       : 醫療院所代碼 (Institution code)
# time       : 存活時間 (天) — Survival time in days
# status     : 生存狀態 (1 = 截尾/censored, 2 = 死亡/dead)
# age        : 年齡 (歲) — Age in years
# sex        : 性別 (1 = 男/Male, 2 = 女/Female)
# ph.ecog    : ECOG 醫師評估表現狀態 (0 = 最佳, 5 = 死亡)
# ph.karno   : Karnofsky 表現狀態分數，由醫師評估 (滿分 100 分)
# pat.karno  : Karnofsky 表現狀態分數，由病人自評 (滿分 100 分)
# meal.cal   : 用餐時攝取的熱量 (卡路里)
# wt.loss    : 最近六個月的體重減輕量 (公斤)


# ===============================================================
# 建立 Surv 物件（定義存活時間與事件發生狀態）
# ===============================================================

# 把事件定義為 (status == 2)
# lung$status 原始編碼：1 = 截尾 (存活)，2 = 死亡 (事件)
# 在 Surv() 中需要 0/1 編碼：
#   0 = 截尾（存活到觀測結束）
#   1 = 事件（此處為死亡）
# 因此用 (status == 2) 轉換，死亡 = TRUE (1)，存活 = FALSE (0)
s <- Surv(time = lung$time, event = lung$status == 2)

# 檢查物件型別與內容
class(s)   # "Surv"
s          # 顯示每筆資料的存活時間與事件狀態


# ===============================================================
# Kaplan–Meier（KM）曲線：整體樣本
# ===============================================================

# 整體 KM（~ 1 表示不分組）
sfit_all <- survfit(Surv(time, status == 2) ~ 1, data = lung)

sfit_all               # 模型物件摘要
summary(sfit_all)      # 各時間點的風險人數、存活率等摘要
range(lung$time, na.rm = TRUE)  # 時間範圍（天）

# 指定一系列時間點輸出摘要（0 到 1000，每 100 一格）
summary(sfit_all, times = seq(0, 1000, 100))


# ===============================================================
# Kaplan–Meier（KM）曲線：依性別分組
# ===============================================================

# sex：1=Male, 2=Female
sfit_sex <- survfit(Surv(time, status == 2) ~ sex, data = lung)

sfit_sex
summary(sfit_sex)

# Base R 簡單圖
plot(sfit_sex)

# survminer 美化後的 KM 圖（預設樣式）
ggsurvplot(sfit_sex)

# 加上信賴區間、p 值（log-rank）、風險表與美化
ggsurvplot(
  sfit_sex,
  conf.int = TRUE,               # 95% CI
  pval = TRUE,                   # 顯示 log-rank p 值
  risk.table = TRUE,             # 顯示下方風險表
  legend.labs = c("Male", "Female"),
  legend.title = "Sex",
  palette = c("dodgerblue2", "orchid2"),
  title = "Kaplan–Meier Curve for Lung Cancer Survival by Sex",
  risk.table.height = 0.15
)


# ===============================================================
# Log-rank 檢定（群組差異）
# ===============================================================

survdiff(Surv(time, status == 2) ~ sex, data = lung)


# ===============================================================
# Cox 比例風險模型
# ===============================================================

# 單變項 Cox（只看 sex）
fit_sex <- coxph(Surv(time, status == 2) ~ sex, data = lung)
fit_sex
summary(fit_sex)  # HR、信賴區間、z 與 p 值

# 多變項 Cox（加入臨床變數）
fit_multi <- coxph(
  Surv(time, status == 2) ~ sex + age + ph.ecog + ph.karno +
    pat.karno + meal.cal + wt.loss,
  data = lung
)
fit_multi
summary(fit_multi)

#（建議）檢查 PH 假設是否成立
# 若顯著違反，需考慮分層、交互作用或時間相依共變數等方法
cox.zph(fit_multi)


# ===============================================================
# 連續變數探索：以 age 為例
# ===============================================================

# 描述統計與分佈
mean(lung$age, na.rm = TRUE)
hist(lung$age)  # base R 直方圖
ggplot(lung, aes(age)) + geom_histogram(bins = 20)  # ggplot 直方圖


# ===============================================================
# 連續變數離散化分組（示範：依年齡切點分組）
# ===============================================================

# 方式一：Base R（切在 62）
lung$agecat <- cut(lung$age, breaks = c(0, 62, Inf), labels = c("young", "old"))

# 方式二：dplyr（同樣切在 62）
lung <- lung %>%
  mutate(agecat = cut(age, breaks = c(0, 62, Inf), labels = c("young", "old")))

head(lung)

# 依年齡分組的 KM 圖（cut at 62）
ggsurvplot(
  survfit(Surv(time, status == 2) ~ agecat, data = lung),
  pval = TRUE,
  title = "KM by Age Group (cut at 62)"
)

# 改另一個切點（70 歲）
lung <- lung %>%
  mutate(agecat = cut(age, breaks = c(0, 70, Inf), labels = c("young", "old")))

# 依年齡分組的 KM 圖（cut at 70）
ggsurvplot(
  survfit(Surv(time, status == 2) ~ agecat, data = lung),
  pval = TRUE,
  title = "KM by Age Group (cut at 70)"
)


# ===============================================================
# 自動尋找最佳切點（Optimal Cutpoint）分組
# ===============================================================

# surv_cutpoint()：
#   - 用於連續變數（此處為 age）
#   - 根據 log-rank 檢定最大化組間差異，找出最佳切點
#   - 參數：
#       time  = 存活時間欄位
#       event = 事件欄位（建議先轉為 0/1，這裡 lung$status=1/2 也能處理）
#       variables = 要尋找切點的連續變數名稱
cut <- surv_cutpoint(
  data = lung,
  time = "time",
  event = "status",
  variables = "age"
)

# 查看找到的最佳切點結果
print(cut)
# 輸出內容會包含：
#   cutpoint = 最佳分界值
#   statistics = 對應的 log-rank 檢定統計量與 p 值

# ===============================================================
# 將最佳切點應用到資料分組
# ===============================================================

# surv_categorize():
#   - 根據 surv_cutpoint 找到的 cutpoint，將連續變數轉為因子（Low/High）
lung_cut <- surv_categorize(cut)

# 查看前幾列（多了一個 age 分組欄位）
head(lung_cut)

# ===============================================================
# 用最佳切點分組畫 Kaplan–Meier 曲線
# ===============================================================

fit_cut <- survfit(Surv(time, status == 2) ~ age, data = lung_cut)

ggsurvplot(
  fit_cut,
  data = lung_cut,
  pval = TRUE,
  risk.table = TRUE,
  palette = c("#4DBBD5", "#E64B35"),
  legend.title = "Age group",
  legend.labs = c("Low", "High"),
  title = "KM Curve by Optimal Age Cutpoint"
)


# ===============================================================
# Cox 模型森林圖（Forest Plot）
# ===============================================================

# 為了讓森林圖顯示更友善，把 sex 轉成因子並重新擬合模型
lung_f <- lung %>%
  mutate(
    sex = factor(sex, levels = c(1, 2), labels = c("Male", "Female"))
  )

# -------- 單變項 Cox：只看 sex --------
fit_sex_f <- coxph(Surv(time, status == 2) ~ sex, data = lung_f)
summary(fit_sex_f)

# 畫森林圖（單變項）
p_forest_sex <- ggforest(
  fit_sex_f,
  data = lung_f,
  main = "Forest Plot: Univariate Cox (sex)",
  cpositions = c(0.02, 0.22, 0.4),  # 文字對齊位置：變數、HR、CI
  fontsize = 1.0,                    # 字體大小
  refLabel = "reference",            # 參考組標籤
  noDigits = 3                       # 小數位數
)
p_forest_sex  

# -------- 多變項 Cox：加入臨床變數 --------
fit_multi_f <- coxph(
  Surv(time, status == 2) ~ sex + age + ph.ecog + ph.karno +
    pat.karno + meal.cal + wt.loss,
  data = lung_f
)
summary(fit_multi_f)

# 畫森林圖（多變項）
p_forest_multi <- ggforest(
  fit_multi_f,
  data =  model.frame(fit_multi_f),
  main = "Forest Plot: Multivariable Cox",
  cpositions = c(0.02, 0.22, 0.4),
  fontsize = 1.0,
  refLabel = "reference",
  noDigits = 3
)
p_forest_multi  

#（選用）把森林圖存成檔案
# ggsave("forest_univariate_sex.png", plot = p_forest_sex, width = 6, height = 5, dpi = 300)
# ggsave("forest_multivariable.png",  plot = p_forest_multi, width = 7, height = 8, dpi = 300)

#（建議）畫森林圖前檢查 PH 假設
cox.zph(fit_multi_f)
# 若顯著違反 PH 假設，可考慮：
#   - 加入 time-varying effects（時間交互項）
#   - 分層（strata）模型
#   - 使用加權或替代模型（例如 AFT）

