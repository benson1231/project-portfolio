# ===============================================================
# 載入套件
# ===============================================================

library(dplyr)
library(ggplot2)
library(broom)   # 整理模型/ANOVA/Tukey輸出

# ===============================================================
# 內建資料集：mtcars（示範單因子／多因子 ANOVA）
# ===============================================================

data(mtcars)
mtcars2 <- as_tibble(mtcars) %>%
  mutate(
    cyl = factor(cyl),                         # 4/6/8 三組 → 分組因子
    am  = factor(am, labels = c("automatic","manual"))
  )

# 基本概覽與分布（目標：比較三組 cyl 的 mpg 平均數差異）
summary(mtcars2[, c("mpg","cyl")])
ggplot(mtcars2, aes(x = cyl, y = mpg, fill = cyl)) +
  geom_boxplot(alpha = 0.8) +
  labs(title = "MPG by Cylinder Group", x = "Cylinders", y = "MPG") +
  theme_classic()

# ---------------------------------------------------------------
# 變異數分析（ANOVA）觀念速記
# ---------------------------------------------------------------
# 1) 目的：比較多組（≥2）平均數是否相等（至少有一組不同）
# 2) 等價關係：
#    - 二組時：ANOVA 的 F 與（等變異）t 檢定的 t^2 完全一致
#    - ANOVA 是線性模型（lm）的特例（類別自變數）
# 3) ANOVA 表：F = 組間均方 / 組內均方；Pr(>F) 是整體多組檢定 p 值
# 4) 事後比較：TukeyHSD 比對所有成對組別差異並控制整體第一類錯誤率

# ===============================================================
# 一、單因子 ANOVA（單因子線性模型）
#    y = mpg，因子 x = cyl（三組）
# ===============================================================

# 以 lm 擬合（ANOVA 是 lm 的特例）
fit <- lm(mpg ~ cyl, data = mtcars2)

# (A) ANOVA 表（整體多組比較）
anova_tbl <- anova(fit)
anova_tbl
tidy(anova_tbl)  # 整理成乾淨表格

# (B) 線性模型摘要（係數以「基準組」為參考差異）
summary(fit)

# (C) aov 等價寫法（方便直接做 TukeyHSD）
aov_fit <- aov(mpg ~ cyl, data = mtcars2)

# ===============================================================
# 二、變更因子基準（relevel）：解讀不同「基準組」的係數
# ===============================================================

levels(mtcars2$cyl)                 # 目前基準是字母序第一層（"4"）
mtcars3 <- mtcars2 %>% mutate(cyl = relevel(cyl, ref = "8"))  # 改成以 8 缸為基準
levels(mtcars3$cyl)                 # 目前基準是字母序第一層（"8"）
summary(lm(mpg ~ cyl, data = mtcars3))  # 截距=8缸平均；其餘係數=相對 8 缸的平均差

# ===============================================================
# 三、Tukey 事後比較（多重比較校正）
# ===============================================================

tuk <- TukeyHSD(aov_fit)  # 對所有成對組別做比較（含CI與調整後p值）
tuk
tidy(tuk)

# 可視化 Tukey 結果（基於 aov 物件）
plot(tuk, las = 1, col = "gray25")

# ===============================================================
# 四、結果視覺化（箱型圖 + 平均點/誤差棒可加強）
# ===============================================================

ggplot(mtcars2, aes(cyl, mpg, fill = cyl)) +
  geom_boxplot(alpha = 0.85, outlier.colour = "gray40") +
  stat_summary(fun = mean, geom = "point", size = 2.8, color = "black") +
  labs(title = "ANOVA: MPG across Cylinder Groups",
       x = "Cylinders", y = "MPG") +
  theme_classic()

# ===============================================================
# 五、延伸：雙因子 ANOVA（含交互作用）
#    y = mpg；因子 x1 = cyl，因子 x2 = am（自排/手排）
# ===============================================================

fit2 <- lm(mpg ~ cyl * am, data = mtcars2)  # 主效應 + 交互作用
anova(fit2)       # Type I ANOVA（逐步平方和）
summary(fit2)     # 係數解讀：基準組 + 各主效應 + 交互作用項

# （需要 Type II / III 時，可使用 car::Anova）
# install.packages("car")
# library(car)
# Anova(fit2, type = 2)   # Type II
# Anova(fit2, type = 3)   # Type III（需檢查對比設定）

