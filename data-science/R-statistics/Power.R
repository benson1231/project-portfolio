# ===============================================================
# 載入套件
# ===============================================================
library(dplyr)
library(ggplot2)
# install.packages("pwr")   # 第一次使用再安裝
library(pwr)

# ---------------------------------------------------------------
# 觀念速記
# ---------------------------------------------------------------
# Power（檢定力）= 當 H1 為真時，正確拒絕 H0 的機率（常用 80% 或 90%）
# 主要四要素：樣本量 n、效應量（差異大小）、標準差/變異、顯著水準 α
# 知道其中三個，就能解第四個（求 power / n / effect size / sd）
# Base R：power.t.test(), power.prop.test()
# pwr 套件：pwr.t.test(), pwr.2p.test(), pwr.anova.test(), pwr.chisq.test() 等

# ===============================================================
# 一、t 檢定（兩獨立樣本）— power / n / delta 的互算
# ===============================================================

# (A) 已知 n、sd、期望差異 delta → 算 power
pt_a <- power.t.test(n = 20, delta = 2, sd = 2.3,
                     sig.level = 0.05, type = "two.sample",
                     alternative = "two.sided")
pt_a

# (B) 目標 power=0.80、已知 sd=1.5、期望差異 delta=0.8 → 求每組 n
pt_b <- power.t.test(power = 0.80, delta = 0.8, sd = 1.5,
                     sig.level = 0.05, type = "two.sample",
                     alternative = "two.sided")
pt_b   # n 是「每組」所需樣本數

# (C) 已知 power 與 n、sd → 求「最小可檢出差異」delta
pt_c <- power.t.test(power = 0.80, n = 30, sd = 2.0,
                     sig.level = 0.05, type = "two.sample",
                     alternative = "two.sided")
pt_c$delta

# 小訣竅：
# - type = "two.sample"（兩獨立樣本）、"one.sample"（單樣本）、"paired"（成對）
# - alternative = "two.sided" / "one.sided"

# ===============================================================
# 二、兩比例比較（例如：感染率、合格率）— power / n 的互算
# ===============================================================

# (A) 已知每組 n、兩組比例 p1/p2 → 算 power
pp_a <- power.prop.test(n = 5, p1 = 0.8, p2 = 0.2,
                        sig.level = 0.05, alternative = "two.sided")
pp_a

# (B) 目標 power=0.90、已知 p1/p2 → 求每組 n
pp_b <- power.prop.test(power = 0.90, p1 = 0.8, p2 = 0.2,
                        sig.level = 0.05, alternative = "two.sided")
pp_b

# (C) 想用「差異 d = |p1 - p2|」的寫法（pwr 範式）
#     注意：power.prop.test 不直接用 Cohen's h；pwr.2p.test 用 h
#     Cohen's h = 2*asin(sqrt(p1)) - 2*asin(sqrt(p2))
cohen_h <- function(p1, p2) { 2*asin(sqrt(p1)) - 2*asin(sqrt(p2)) }
h <- abs(cohen_h(0.8, 0.6))
pwr.2p.test(h = h, power = 0.80, sig.level = 0.05)

# ===============================================================
# 三、pwr 套件：更多檢定的效能估計
# ===============================================================

# (A) t 檢定（與 base 類似；d = Cohen's d）
#     d ≈ 0.2(小), 0.5(中), 0.8(大)
pwr.t.test(d = 0.5, power = 0.80, sig.level = 0.05,
           type = "two.sample", alternative = "two.sided")

# (B) 單因子 ANOVA：k 組、效果量 f（Cohen’s f；0.10/0.25/0.40）
pwr.anova.test(k = 3, f = 0.25, sig.level = 0.05, power = 0.80)

# (C) 卡方適合度或獨立性：w = Cohen’s w（0.10/0.30/0.50）
#     df = 類別數-1（適合度）或 (r-1)*(c-1)（獨立性）
pwr.chisq.test(w = 0.3, df = 2, sig.level = 0.05, power = 0.80)

# (D) 相關係數：目標相關 r
pwr.r.test(r = 0.3, sig.level = 0.05, power = 0.80, alternative = "two.sided")

# (E) 一般線性模型（多重回歸整體）：f2 = Cohen’s f^2（0.02/0.15/0.35）
#     u = 自由度（解釋變數個數），v = 殘差自由度（樣本量減去參數數）
#     若未知 v，可先試探 n，再反推 v 或用公式轉換
pwr.f2.test(u = 3, f2 = 0.15, sig.level = 0.05, power = 0.80)

# ===============================================================
# 四、功效曲線：樣本量 n 或效應量 vs. 檢定力（可放投影片）
# ===============================================================

# (A) 兩樣本 t 檢定：固定 sd、delta，畫「n 對 power」
make_power_curve_t <- function(sd = 2.0, delta = 0.8,
                               n_min = 5, n_max = 100, alpha = 0.05) {
  ns <- seq(n_min, n_max, by = 1)
  pw <- sapply(ns, function(n)
    power.t.test(n = n, delta = delta, sd = sd,
                 sig.level = alpha, type = "two.sample")$power)
  tibble(n = ns, power = pw)
}

pc_t <- make_power_curve_t(sd = 1.5, delta = 0.8, n_min = 5, n_max = 120)
ggplot(pc_t, aes(n, power)) +
  geom_line() +
  geom_hline(yintercept = 0.8, linetype = 2) +
  labs(title = "Power curve (Two-sample t-test)",
       x = "Per-group sample size (n)", y = "Power") +
  theme_classic()

# (B) 兩比例比較：固定 n，畫「差異 d=|p1-p2| 對 power」
make_power_curve_prop <- function(n = 20, p1_grid = seq(0.1, 0.9, by = 0.02),
                                  base_p = 0.5, alpha = 0.05) {
  # 比較 base_p vs p1_grid
  tibble(
    p1 = p1_grid,
    power = sapply(p1_grid, function(p1)
      power.prop.test(n = n, p1 = base_p, p2 = p1,
                      sig.level = alpha)$power),
    diff = abs(p1_grid - base_p)
  )
}

pc_p <- make_power_curve_prop(n = 30, base_p = 0.5)
ggplot(pc_p, aes(diff, power)) +
  geom_line() +
  geom_hline(yintercept = 0.8, linetype = 2) +
  labs(title = "Power vs. proportion difference (n=30 per group)",
       x = "|p1 - p2|", y = "Power") +
  theme_classic()

# ===============================================================
# 五、實務備忘（放在講義的最後一頁很實用）
# ===============================================================
# 1) 先界定「研究上有意義」的效應量（不只統計顯著），再倒推出 n。
# 2) 變異（sd / w / f / f2）可用前測或文獻估計；估得太小 → n 會被低估。
# 3) 多重比較需調整 α（Bonferroni、BH 等），power 會下降。
# 4) 非常態或等變異假設不滿足：效能可能偏離；必要時用穩健/非參數方法並做模擬。
# 5) 遺漏值與掉隊（attrition）會降低有效樣本量：設計時預留 buffer。
# 6) 方向性假設（單尾）在確有事前理據時可提升 power，但不可事後改單尾。
