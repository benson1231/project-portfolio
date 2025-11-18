# 參考風格：Bioconnector workshops 的段落化模板
# 主題：Wilcoxon 檢定（rank-sum / signed-rank；一樣本、兩獨立樣本、成對樣本）
# 資料：R 內建 mtcars（兩獨立樣本、一樣本）、sleep（成對樣本）

# ===============================================================
# 載入套件
# ===============================================================

library(dplyr)
library(ggplot2)
# install.packages(c("broom","effectsize","effsize")) # 第一次使用先安裝
library(broom)        # 整理檢定輸出
library(effectsize)   # 非參數效果量：rank-biserial
library(effsize)      # 另一個非參數效果量：Cliff's delta

# ===============================================================
# 內建資料集一：mtcars（兩獨立樣本／一樣本示範）
# ===============================================================

data(mtcars)
mtcars2 <- as_tibble(mtcars) %>%
  mutate(am = factor(am, labels = c("automatic","manual")))  # 0/1 -> 因子

# 基本概覽與分布
summary(mtcars2$mpg)
ggplot(mtcars2, aes(mpg, fill = am)) +
  geom_histogram(bins = 12, alpha = 0.7, position = "identity") +
  labs(title = "MPG Distribution by Transmission", x = "MPG", fill = "Transmission")

# ---------------------------------------------------------------
# Wilcoxon 檢定觀念速記
# ---------------------------------------------------------------
# 1) 兩獨立樣本：Wilcoxon rank-sum test（= Mann–Whitney U）
#    - 不要求常態；比較兩群分布位置（常在對稱分布下解讀為「中位數差異」）
#    - R：wilcox.test(y ~ g, data=...)
# 2) 成對樣本或一樣本：Wilcoxon signed-rank test
#    - 不要求常態；比較配對差值的中位數是否為 0（或一樣本的中位數是否等於 mu）
#    - R：wilcox.test(x, y, paired=TRUE) 或 wilcox.test(x, mu = ...)
# 3) p 值/信賴區間：
#    - 小樣本與無 ties/零差時可用 exact 機率；否則採常態近似（可見連續性修正）
#    - conf.int=TRUE 可給出「位置差異（location shift）」的 CI（在兩樣本/成對情境）

# ===============================================================
# 一、兩獨立樣本：rank-sum（mpg ~ am）
#    H0：兩群分布位置相同（對稱時可視為中位數相等）
#    H1：兩群分布位置不同（雙尾）
# ===============================================================

# 注意方向與層級：
levels(mtcars2$am)   # "automatic" "manual"（第一層是 automatic）

# (A) 雙尾（預設）— 常用
w_rs <- wilcox.test(mpg ~ am, data = mtcars2,
                    alternative = "two.sided",
                    exact = FALSE,       # 含 ties/樣本較大時多半用常態近似
                    conf.int = TRUE,     # 給出位置差異的信賴區間
                    conf.level = 0.95)
w_rs
tidy(w_rs)

# (B) 單尾：假設「手排 mpg > 自排」。
# 方法1：維持層級不變（automatic 是第一層），等價於檢定 automatic - manual < 0
wilcox.test(mpg ~ am, data = mtcars2,
            alternative = "less", exact = FALSE)

# 方法2：把參考層改為 "manual"，再用 greater 檢定 manual - automatic > 0
mtcars3 <- mtcars2 %>% mutate(am = relevel(am, ref = "manual"))
wilcox.test(mpg ~ am, data = mtcars3,
            alternative = "greater", exact = FALSE)

# 效果量（建議與 p 值一起報告）
# 1) Rank-biserial correlation（-1 ~ 1，0=無效應；可直覺解讀為優於機率差）
rank_biserial(mpg ~ am, data = mtcars2)
# 2) Cliff's delta（-1 ~ 1；規模參考：0.147 小、0.33 中、0.474 大）
cliff.delta(mpg ~ am, data = mtcars2)

# ===============================================================
# 二、成對樣本：signed-rank（sleep：Drug 1 vs Drug 2）
#    H0：配對差值（Drug2 - Drug1）中位數 = 0
#    H1：配對差值 ≠ 0（雙尾）；或 >0 / <0（單尾）
# ===============================================================

data(sleep)
# sleep：extra（額外睡眠）、group（1/2）、ID（受試者）
# 轉寬，確保一對一配對：
sleep_wide <- reshape(sleep, idvar = "ID", timevar = "group", direction = "wide")
# 會得到 extra.1（Drug1）、extra.2（Drug2）

# 雙尾
w_paired <- wilcox.test(sleep_wide$extra.2, sleep_wide$extra.1,
                        paired = TRUE,
                        alternative = "two.sided",
                        exact = FALSE,      # 有零差/同值時常需關閉 exact
                        conf.int = TRUE)
w_paired
tidy(w_paired)

# 單尾：若事先假設「Drug2 > Drug1」（差值>0）
wilcox.test(sleep_wide$extra.2, sleep_wide$extra.1,
            paired = TRUE, alternative = "greater", exact = FALSE)

# 成對效果量：rank-biserial（paired=TRUE）
rank_biserial(sleep_wide$extra.2, sleep_wide$extra.1, paired = TRUE)

# ===============================================================
# 三、一樣本：signed-rank（mpg 的中位數是否 = 20）
#    H0：median(mpg) = 20
#    H1：median(mpg) ≠ 20（雙尾）
# ===============================================================

w_one <- wilcox.test(mtcars2$mpg,
                     mu = 20,
                     alternative = "two.sided",
                     exact = FALSE,
                     conf.int = TRUE,
                     conf.level = 0.95)
w_one
tidy(w_one)

# 單尾：若假設 median(mpg) > 20
wilcox.test(mtcars2$mpg, mu = 20, alternative = "greater", exact = FALSE)

# ===============================================================
# 常見訊息與參數說明
# ===============================================================
# 1) "with continuity correction"
#    - 兩獨立樣本的常態近似會做連續性修正（對離散統計量調整），可使近似更保守。
#
# 2) exact, correct（?wilcox.test）
#    - exact=TRUE：使用精確分布（小樣本、無 ties/零差較合適）
#    - exact=FALSE：使用常態近似（大多數實務情境；特別是有 ties/零差）
#    - correct=TRUE（預設）：做連續性修正；如要關掉可設 FALSE
#
# 3) conf.int
#    - 兩樣本/成對樣本時，可給出「位置差（location shift）」的 CI（如兩群中位數差）
#
# 4) 解讀
#    - Wilcoxon 檢定在「對稱分布」時，常被解讀為中位數差異檢定。
#      一般而言，它檢定的是「分布位置（stochastic dominance）是否不同」。
#
# 5) 報告建議（兩獨立樣本案例）
#    “A Wilcoxon rank-sum test indicated that manual cars had higher mpg than automatic cars
#     (W = 294, p < 0.001, two-sided). The rank-biserial correlation was 0.73
#     (95% CI …), suggesting a large effect.”
