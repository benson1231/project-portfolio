# 主題：t 檢定（one-sample, two-sample, paired；雙尾/單尾；Welch/等變異）
# 資料：R 內建 mtcars（兩獨立樣本）、sleep（成對樣本）

# ===============================================================
# 載入套件
# ===============================================================

library(dplyr)     # 資料處理
library(ggplot2)   # 視覺化（基本分布檢視）
# install.packages(c("broom","effsize","car")) # 第一次使用請先安裝
library(broom)     # 整理檢定結果成資料框
library(effsize)   # 效果量（Cohen's d / Hedges g）
library(car)       # Levene's Test（變異數齊一性）

# ===============================================================
# 內建資料集一：mtcars（車輛性能）
# ===============================================================

data(mtcars)

# 轉為 tibble、建立分組因子（變速系統：0=automatic, 1=manual）
mtcars2 <- as_tibble(mtcars) %>%
  mutate(am = factor(am, labels = c("automatic", "manual")))

# 基本概覽
dim(mtcars2)     # 列數、欄數
summary(mtcars2) # 數值摘要（了解分佈與缺失）

# ---------------------------------------------------------------
# 欄位說明（擷取示範用到的變數）
# ---------------------------------------------------------------
# mpg : 每加侖英里數（油耗效能）
# am  : 變速系統（0=automatic, 1=manual；此處已轉為 "automatic"/"manual" 因子）


# ===============================================================
# 一、One-sample t-test（單一樣本 t 檢定）
# ===============================================================

# 問題：全體車款的平均油耗（mpg）是否等於 20？
# H0: mu_mpg = 20
# H1: mu_mpg != 20（雙尾）

one_sample <- t.test(mtcars2$mpg, mu = 20, alternative = "two.sided")
one_sample
tidy(one_sample)  # 整理後輸出（便於表格化）

# （單尾示範）若事先假設「平均油耗 > 20」：
# H1: mu_mpg > 20
t.test(mtcars2$mpg, mu = 20, alternative = "greater")

# 解讀指引：
# - p < 0.05：拒絕 H0，代表母體平均 ≠ 20（雙尾）或 > 20（單尾 greater）
# - conf.int：母體平均的 95% 信賴區間（雙尾）


# ===============================================================
# 二、Two-sample t-test（兩獨立樣本）
#    比較：automatic vs manual 的 mpg
# ===============================================================

# 重要：方向與層級
levels(mtcars2$am)  # "automatic" "manual"
# t.test(y ~ g, alternative="greater") 檢定的是 mean(g第一層) - mean(g第二層) > 0
# 以目前層級而言，"greater" 表示 mean(automatic) > mean(manual)

# （A）Welch 兩樣本 t 檢定（預設；不假設等變異；較穩健，推薦）
welch_res <- t.test(mpg ~ am, data = mtcars2, var.equal = FALSE, alternative = "two.sided")
welch_res
tidy(welch_res)

# 單尾示範：若假設「手排 mpg > 自排」
# 方法1：維持層級不變，檢定 automatic - manual < 0（用 alternative="less"）
t.test(mpg ~ am, data = mtcars2, alternative = "less")

# 方法2：把參考層設為 "manual"，再用 greater（檢定 manual - automatic > 0）
mtcars3 <- mtcars2 %>% mutate(am = relevel(am, ref = "manual"))
t.test(mpg ~ am, data = mtcars3, alternative = "greater")

# （B）等變異 t 檢定（Student’s t-test；只有在變異數近似相等時使用）
equalvar_res <- t.test(mpg ~ am, data = mtcars2, var.equal = TRUE)
equalvar_res

# 變異數齊一性檢查（Levene’s Test；H0：兩組變異數相等）
leveneTest(mpg ~ am, data = mtcars2)

# 常態性檢查（各組內；n 不大時可參考，並輔以 QQ plot）
by(mtcars2$mpg, mtcars2$am, function(x) shapiro.test(x)$p.value)
# QQ plot（視覺檢查）
qqnorm(mtcars2$mpg[mtcars2$am=="automatic"]); qqline(mtcars2$mpg[mtcars2$am=="automatic"])
qqnorm(mtcars2$mpg[mtcars2$am=="manual"]);    qqline(mtcars2$mpg[mtcars2$am=="manual"])

# 效果量（Cohen's d；Hedges 校正建議開啟）
cohen.d(mpg ~ am, data = mtcars2, hedges.correction = TRUE)
# 參考解讀：d ≈ 0.2（小）、0.5（中）、0.8（大）


# ===============================================================
# 三、Paired t-test（成對樣本）
#    內建資料：sleep（同一受試者在兩種藥物下的額外睡眠時間）
# ===============================================================

data(sleep)
# 欄位：
# extra : 額外睡眠時間
# group : 藥物（1 / 2）
# ID    : 受試者編號

# 為確保一一配對，先轉寬（每位受試者一列，兩藥物作兩欄）
sleep_wide <- reshape(sleep, idvar = "ID", timevar = "group", direction = "wide")
# 會得到 extra.1（藥1）與 extra.2（藥2）
head(sleep_wide)

# 成對 t 檢定（雙尾）
# H0: mean(diff) = 0；H1: mean(diff) != 0；其中 diff = extra.2 - extra.1
paired_res <- t.test(sleep_wide$extra.2, sleep_wide$extra.1,
                     paired = TRUE, alternative = "two.sided")
paired_res
tidy(paired_res)

# （單尾示範）若假設「藥2 效果更好」→ extra.2 - extra.1 > 0
t.test(sleep_wide$extra.2, sleep_wide$extra.1, paired = TRUE, alternative = "greater")

# 成對 t 檢定的常態性前提：檢查「差值」的常態
diff_vec <- sleep_wide$extra.2 - sleep_wide$extra.1
shapiro.test(diff_vec)
# 視覺化：
# hist(diff_vec); qqnorm(diff_vec); qqline(diff_vec)

# 成對效果量（Cohen's d，以差值/差值的 sd；加 Hedges 校正）
cohen.d(sleep_wide$extra.2, sleep_wide$extra.1, paired = TRUE, hedges.correction = TRUE)


# ===============================================================
# 四、補充：以 ggplot 查看分布（示範）
# ===============================================================

# mtcars：mpg 直方圖＋以變速系統分色
ggplot(mtcars2, aes(mpg, fill = am)) +
  geom_histogram(bins = 12, alpha = 0.7, position = "identity") +
  labs(title = "Distribution of MPG by Transmission", x = "MPG", y = "Count", fill = "Transmission")

# sleep：兩藥物的額外睡眠時間盒鬚圖（非 t 檢定必要，用於探索）
sleep_long <- sleep # 原本就是 long 格式
sleep_long$group <- factor(sleep_long$group, labels = c("drug1", "drug2"))
ggplot(sleep_long, aes(group, extra)) +
  geom_boxplot() +
  labs(title = "Extra Sleep by Drug (Paired Design)", x = "Drug", y = "Extra Sleep (hours)")


# ===============================================================
# 五、重點總結
# ===============================================================

# 1) 雙尾 vs 單尾：單尾需事先訂方向，並留意因子層級（who - who）。
# 2) Welch 優先：兩群比較預設用 Welch（var.equal=FALSE）；等變異版在有證據時才用。
# 3) 成對檢定看「差值」常態；獨立樣本看各組常態與變異數齊一。
# 4) 效果量與 p 值一起報：p 值=顯著性；Cohen's d/ Hedges g=差異大小。
