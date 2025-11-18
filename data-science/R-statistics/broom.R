# ===============================================================
# 載入套件
# ===============================================================
library(dplyr)
library(ggplot2)
library(broom)   # tidy / augment / glance

# ===============================================================
# 內建資料集：mtcars / Titanic
# mtcars:
#   mpg: 油耗
#   hp : 馬力
#   wt : 車重 (1000 lbs)
#   am : 變速箱 (0 = 自排, 1 = 手排)
# Titanic:
#   Class, Sex, Age, Survived, Freq（次數）
# ===============================================================

data(mtcars)
data(Titanic)

df_mtcars <- as_tibble(mtcars) %>%
  mutate(am = factor(am, labels = c("automatic", "manual")))

df_titanic <- as.data.frame(Titanic)  # for fisher/chi-square demo

# ---------------------------------------------------------------
# broom 觀念速記
# ---------------------------------------------------------------
# tidy(model):    係數與推論統計（estimate, std.error, statistic, p.value）
# augment(model): 原始資料 + .fitted, .resid, .se.fit, .hat, .cooksd, ...
# glance(model):  單列模型摘要（R², adj.R², sigma, AIC, BIC, deviance, ...）

# ===============================================================
# 一、線性模型 lm：mpg ~ hp + wt
# ===============================================================

fit_lm <- lm(mpg ~ hp + wt, data = df_mtcars)
summary(fit_lm)

# (1) tidy：係數表（可直接 dplyr 操作）
tidy(fit_lm)

# 只看顯著變數（p < .05），且不含截距
tidy(fit_lm) %>%
  filter(term != "(Intercept)", p.value < 0.05) %>%
  arrange(p.value)

# (2) augment：把預測與殘差貼回到原資料（欄位以 . 開頭）
aug_lm <- augment(fit_lm)
head(aug_lm)

# 殘差 vs. 擬合值圖（diagnostics）
ggplot(aug_lm, aes(.fitted, .resid)) +
  geom_hline(yintercept = 0, linetype = 2) +
  geom_point() +
  labs(title = "Residuals vs Fitted (lm: mpg ~ hp + wt)",
       x = "Fitted values", y = "Residuals") +
  theme_classic()

# (3) glance：模型整體摘要
glance(fit_lm)

# ===============================================================
# 二、邏輯迴歸 glm (binomial)：手排機率 ~ hp + wt
# ===============================================================

fit_glm <- glm(am ~ hp + wt, data = df_mtcars, family = "binomial")
summary(fit_glm)

# (1) tidy：log-odds 係數與 p 值
tidy(fit_glm)

# 轉換成比值比（odds ratio）與 95% CI（以 broom + base exp()）
or_tbl <- tidy(fit_glm, conf.int = TRUE, conf.level = 0.95, exponentiate = TRUE)
or_tbl  # estimate/ conf.low/ conf.high 皆為 OR 尺度

# (2) augment：每筆資料的預測機率與殘差
aug_glm <- augment(fit_glm, type.predict = "response")  # .fitted = 預測機率
head(aug_glm)

# 視覺化：以 hp 為 x，畫預測機率（控制 wt 的影響：用擬合線展示平均趨勢）
ggplot(aug_glm, aes(hp, .fitted)) +
  geom_point(alpha = 0.5) +
  geom_smooth(se = TRUE) +
  labs(title = "Predicted probability of manual (glm: am ~ hp + wt)",
       x = "Horsepower", y = "Predicted P(manual)") +
  theme_classic()

# (3) glance：AIC, BIC, 偏差等
glance(fit_glm)

# ===============================================================
# 三、經典檢定物件也能 tidy：t-test / Wilcoxon / Fisher
# ===============================================================

# 1) t-test：mpg ~ am
tt <- t.test(mpg ~ am, data = df_mtcars, var.equal = TRUE)
tt
tidy(tt)   # estimate, statistic, p.value, conf.low/high, 方法等

# 2) Wilcoxon rank-sum：mpg ~ am（非參數）
ww <- wilcox.test(mpg ~ am, data = df_mtcars, exact = FALSE)
ww
tidy(ww)

# 3) Fisher exact：Titanic 的 Sex × Survived（2x2）
xt <- xtabs(Freq ~ Sex + Survived, data = df_titanic)
fis <- fisher.test(xt)
fis
tidy(fis)  # OR 與 CI、p 值

# ===============================================================
# 四、把 tidy/augment/glance 串進管線的示範
# ===============================================================

# 係數火山圖風味（lm）：顯著性（-log10 p） vs. 係數估計
tidy(fit_lm) %>%
  filter(term != "(Intercept)") %>%
  mutate(neglogp = -log10(p.value)) %>%
  ggplot(aes(estimate, neglogp, label = term)) +
  geom_point() +
  ggrepel::geom_text_repel() +
  labs(title = "Coefficient significance (lm: mpg ~ hp + wt)",
       x = "Estimate (beta)", y = "-log10(p-value)") +
  theme_classic()

# 注意：使用上面需要 ggrepel；若未安裝可改為簡單 geom_text：
# install.packages("ggrepel")
# 或改用：geom_text(vjust = -0.6, size = 3)

# ===============================================================
# 五、備忘錄（和 slides 對齊）
# ===============================================================
# - tidy：係數層級、p 值、CI；適合做表格/排名/顯著性標示
# - augment：逐筆的 .fitted / .resid / .hat / .cooksd；適合診斷圖
# - glance：單列整體指標（R2/adj.R2、AIC、BIC、deviance、df 等）
# - 幾乎所有常見模型（lm/glm/nls/survival/混合效應等）與檢定（t/wilcox/fisher）
#   都支援 broom；可以把模型結果「資料化」，接上 dplyr/ggplot2 流程
