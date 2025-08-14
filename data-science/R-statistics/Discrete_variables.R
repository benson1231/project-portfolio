# ===============================================================
# 載入套件
# ===============================================================
library(dplyr)
library(ggplot2)
library(broom)  # tidy() 可整理 chisq.test / fisher.test 的輸出

# ===============================================================
# 內建資料集：Titanic（乘客分層 × 性別 × 年齡 × 生還）
# 我們用它來示範列聯表：Sex × Survived、Class × Survived
# ===============================================================

data("Titanic")
titanic_df <- as.data.frame(Titanic)  # 含欄位 Class, Sex, Age, Survived, Freq

# ---------------------------------------------------------------
# 列聯表觀念速記
# ---------------------------------------------------------------
# 1) xtabs(): 依分類變數建立列聯表（可用 Freq 欄權重）
# 2) addmargins(): 加上行/列總計
# 3) prop.table(): 換算比例；margin=1 按行、margin=2 按列
# 4) chisq.test(): 檢定分類變數是否「獨立」
# 5) fisher.test(): 小樣本或期望次數過小時使用的精確檢定（2×2 常見）
# 6) mosaicplot(): 以面積視覺化列聯表

# ===============================================================
# 一、建立列聯表：Sex × Survived（2 × 2）
# ===============================================================

# 以 Freq 權重聚合
xt <- xtabs(Freq ~ Sex + Survived, data = titanic_df)
xt
#        Survived
# Sex       No  Yes
#   Male  1364  367
#   Female 126  344

# (A) 加總邊際
addmargins(xt)

# (B) 比例表
prop.table(xt)            # 佔總樣本比例
prop.table(xt, margin=1)  # 列（Sex）內比例：每種性別的生還機率分布
prop.table(xt, margin=2)  # 行（Survived）內比例：生還/未生還內的性別分布

# ===============================================================
# 二、獨立性檢定：卡方 & Fisher
# ===============================================================

# (A) 卡方檢定（含期望次數、標準化殘差）
chi_res <- chisq.test(xt, correct = TRUE)  # 2×2 預設含 Yates 連續性修正
chi_res
tidy(chi_res)  # p 值、統計量等（broom）

# 期望數與殘差（診斷哪格對差異貢獻大）
chi_res$expected
chi_res$stdres

# (B) Fisher 精確檢定（2×2 適用；小樣本尤其推薦）
fis_res <- fisher.test(xt, alternative = "two.sided")
fis_res
tidy(fis_res)  # p 值、odds ratio 及信賴區間

# ===============================================================
# 三、視覺化：馬賽克圖（內建繪圖）
# ===============================================================

mosaicplot(xt, main = "Mosaic: Sex × Survived", color = TRUE)

# ===============================================================
# 四、第二個例子：Class × Survived（4 × 2）
# ===============================================================

xt2 <- xtabs(Freq ~ Class + Survived, data = titanic_df)
xt2
addmargins(xt2)

# 行內比例（各艙等的生還率）
prop.table(xt2, margin = 1)

# 卡方檢定（艙等與生還是否獨立）
chi2_res <- chisq.test(xt2)
chi2_res
tidy(chi2_res)

# 視覺化
mosaicplot(xt2, main = "Mosaic: Class × Survived", color = TRUE)

# ===============================================================
# 五、補充：把列聯表轉為整潔資料框以便報表/繪圖
# ===============================================================

# 將行內比例轉為資料框（Sex × Survived）
row_prop <- as.data.frame(prop.table(xt, margin = 1)) %>%
  dplyr::rename(RowProp = Freq)

row_prop

# 也可以用 ggplot 長條圖呈現（非必要，但常見）
ggplot(row_prop, aes(x = Sex, y = RowProp, fill = Survived)) +
  geom_col(position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Row-wise proportions: Sex × Survived",
       x = "Sex", y = "Proportion within Sex") +
  theme_classic()

# ===============================================================
# 六、重要提醒
# ===============================================================
# 1) 卡方檢定前提：期望次數不應過小（常見建議：每格期望≥5），
#    若違反可合併類別、改用 Fisher，或用模擬 p 值（chisq.test(simulate.p.value=TRUE)）。
# 2) 2×2 表的卡方檢定預設會做 Yates 修正（較保守）；可視情關閉 correct=FALSE。
# 3) 觀察 standardized residuals（stdres）找出貢獻最大的格子（>|2| 常被視為顯著）。
# 4) 比例詮釋時請說清楚「行內」或「列內」比例（margin=1 vs margin=2）。
