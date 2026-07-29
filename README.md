# 老年人内在能力评估系统 · Intrinsic Capacity Assessment

> 基于机器学习（XGBoost）与交互式 Web 应用（R Shiny）的老年人内在能力评估工具。数据 → 预测模型 → 可交互应用，全流程开源。

## 项目背景

「内在能力（Intrinsic Capacity, IC）」是世界卫生组织（WHO）老龄友好照护框架的核心概念，指个体在所有领域中**能动组合**的心理与生理能力，涵盖认知、行动、感官、心理、活力五大域。随着年龄增长，内在能力下滑往往是失能的前兆。

本项目以中国健康与养老追踪调查（CHARLS）多波次数据为基础，构建可解释的机器学习模型，帮助研究者与临床工作者快速评估老年人的内在能力水平，并定位关键影响因素。

## 功能特性

- **内在能力评估**：输入个体健康指标，输出内在能力预测结果
- **可解释性**：基于 SHAP（`shapviz`）给出每个特征对预测的贡献，避免"黑箱"
- **中英双语界面**：UI 支持中英文切换，便于跨语境使用
- **交互式 Web 应用**：基于 R Shiny + bslib，开箱即用

## 技术栈

- **建模**：R + XGBoost（梯度提升树）
- **应用**：R Shiny（`ui.R` / `server.R` / `global.R`）+ bslib（Bootstrap 5 / flatly 主题）
- **可视化**：ggplot2 + shapviz + showtext（中文渲染）
- **分析文档**：Quarto（`analysis.qmd`）、Jupyter（`analysis.ipynb`）、Python（`analysis.py`）
- **部署**：rsconnect → ShinyApps.io

## 目录结构

```
analysis-ic-model/
├── analysis.qmd / analysis.ipynb / analysis.py   # 数据分析（Quarto / Notebook / Python）
├── deploy_helper.R                              # ShinyApps.io 部署辅助脚本
├── shiny_app_ic_model/                          # 主 Shiny 应用
│   ├── global.R                                 # 加载模型、特征字典、中文字体
│   ├── ui.R                                     # UI 布局
│   ├── server.R                                 # 服务端逻辑
│   ├── model/                                   # 训练好的模型 (xgb_booster.rds)
│   └── rsconnect/                               # 部署配置
├── shiny_app_documentation.qmd / .pptx          # 应用说明文档
├── shiny_share/                                 # 分享版 Shiny 配置
├── data_raw/                                    # 原始数据（CHARLS 2011 / 2013 / 2015 / 2018）
├── data_export/                                 # 加工导出数据（多阶段）
│   ├── data_auto_filter/  data_calculated/  data_ic/
│   ├── data_manual_filter/  data_second_manual_filter/
│   ├── model_data/  model_results/  models/
│   └── descriptive_stats/
├── 备份/                                         # 历史版本备份
└── analysis-ic-model.Rproj                       # RStudio 项目文件
```

## 数据来源

原始数据来自 **中国健康与养老追踪调查（CHARLS）**，覆盖 2011、2013、2015、2018 多个调查波次（`data_raw/`）并经多阶段清洗与衍生变量构建（`data_export/`）。

> 注意：原始数据因调查授权协议不在仓库内（`.gitignore` 已忽略 `*.csv` / `*.xlsx`），仓库仅保留加工脚本与导出结果。

## 模型说明

- **模型类型**：XGBoost 梯度提升树，保存为 `shiny_app_ic_model/model/xgb_booster.rds`
- **输入特征**：35 个与健康相关的变量，涵盖人口学、体格测量、生活方式、慢性病、社会心理等维度（完整特征及其中文 / 英文标签见 `shiny_app_ic_model/global.R`）
- **可解释性**：使用 SHAP 值（`shapviz`）可视化每个特征对个体预测的贡献

## 本地运行

```r
# 1. 安装依赖
install.packages(c("shiny", "xgboost", "ggplot2", "bslib", "shapviz", "showtext"))

# 2. 在 R / RStudio 中运行
shiny::runApp("shiny_app_ic_model")
```

浏览器将自动打开应用。

## 部署到 ShinyApps.io

在 `deploy_helper.R` 中填入你的 shinyapps.io 账号 token 后运行：

```r
source("deploy_helper.R")
# 脚本执行：rsconnect::deployApp(
#   appDir  = "shiny_app_ic_model",
#   appName = "intrinsic-capacity-predictor")
```

在线应用：https://kiriny1999.shinyapps.io/intrinsic-capacity-predictor/

## 文档

- 应用说明：`shiny_app_documentation.qmd`（可渲染为 `shiny_app_documentation.pptx`）
- 分析过程：`analysis.qmd`

## 开源与许可

本项目以开源方式发布，欢迎学习、复用与二次开发。建议补充 `LICENSE` 文件以明确授权条款（如 MIT）。

> 本项目已获计算机软件著作权。

## 相关链接

- 在线应用：https://kiriny1999.shinyapps.io/intrinsic-capacity-predictor/
- 配套文章：公众号「康康不想康康」—《用 AI 做护理预测模型》（Vibe Coding 全流程实践，含本项目的完整建模到部署过程）
