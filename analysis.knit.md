---
title: "内在能力建模"
author: "Ruifu Kang & Yirou Niu"
date: "2024-12-26"
format: docx
---



# 建模步骤
## 数据初步清洗

1. 读取并合并数据
2. 变量重命名：内在能力及其相关变量，包括出生年份、性别等都重命名
3. 年龄数据清洗：去掉非老年人的个体之后9982人

## 内在能力赋值
### 1.  运动
- 2.5米步行速度≥ 1米/秒得1分；
- 重复坐下5次≤12秒得1分；
- 平衡：3个10秒完成2个及以上得1分。
- 满分3分

### 2.  认知：
- 情景记忆（基于延迟回忆得分）：0-10分；
- 减7测试：5分；
- 日期、月份、年份和季节：5分；
- 绘画：1分。
- 满分21分 
- 进一步：范围18-20：得3分；范围14-17：得2分；范围7-13：得1分；范围0-6：得0分。
- 满分3分

### 3. 心理
- CES-D评分为0到9分：得1分；
- 总睡眠时间在5到10.5小时之间，得1分；
- 睡眠质量：一周内睡眠不安的频率0到2天之间得1分。
- 满分3分

### 4.  感官
- 听力回答非常好、好、一般：得1分；
- 视力回答非常好、好、一般：得1分（远和近两项）
- 满分3分

### 5.  活力
- 握力：男性≥ 35kg得1分，女性≥ 25kg得1分；
- FEV：男性≥ 400得1分，女性≥ 290得1分;
- 血红蛋白：男性≥ 130g/L得1分，女性≥ 120g/L得1分。
- 满分3分

## 内在能力筛选
- 根据内在能力计算情况筛选出覆盖内在能力指标范围大于100%的个体
- 保存筛选后的数据到一个新的数据框中
## 自变量筛选与清洗

## 数据拆分

## 模型构建

## 模型验证



# 代码
## 读取并合并数据

-   读取所有老年人的个人数据（暂不考虑家庭数据和整体数据权重）
-   将所有数据以ID为键值进行匹配合并到一个数据框中



::: {.cell}

```{.r .cell-code}
# 安装并加载所需要的包
if (!requireNamespace("haven", quietly = TRUE)) {
    install.packages("haven")
}
if (!requireNamespace("dplyr", quietly = TRUE)) {
    install.packages("dplyr")
}
library(haven)
library(dplyr)
```

::: {.cell-output .cell-output-stderr}

```

Attaching package: 'dplyr'
```


:::

::: {.cell-output .cell-output-stderr}

```
The following objects are masked from 'package:stats':

    filter, lag
```


:::

::: {.cell-output .cell-output-stderr}

```
The following objects are masked from 'package:base':

    intersect, setdiff, setequal, union
```


:::

```{.r .cell-code}
# 读取并合并数据
files <- list.files("data_raw/self",
    pattern = "\\.dta$",
    full.names = TRUE
)
data_list <- lapply(files, read_dta)
my_data_raw <- Reduce(function(x, y) full_join(x, y, by = "ID"), data_list)
print(my_data_raw)
```

::: {.cell-output .cell-output-stdout}

```
# A tibble: 21,805 × 7,595
   ID        householdID.x communityID.x pa001   pa002   qa001s1 qa001s2 qa001s3
   <chr>     <chr>         <chr>         <dbl+l> <dbl+l> <dbl+l> <dbl+l> <dbl+l>
 1 09400410… 0940041030    0940041       5 [5 N… 1 [1 Y… NA      NA      NA     
 2 09400411… 0940041100    0940041       5 [5 N… 1 [1 Y… NA      NA      NA     
 3 09400410… 0940041080    0940041       5 [5 N… 1 [1 Y… NA      NA      NA     
 4 09400411… 0940041120    0940041       5 [5 N… 1 [1 Y… NA      NA      NA     
 5 09400411… 0940041120    0940041       5 [5 N… 1 [1 Y… NA      NA      NA     
 6 09400411… 0940041140    0940041       5 [5 N… 1 [1 Y… NA      NA      NA     
 7 09400411… 0940041190    0940041       5 [5 N… 1 [1 Y… NA      NA      NA     
 8 09400411… 0940041170    0940041       5 [5 N… 1 [1 Y… NA      NA      NA     
 9 09400411… 0940041170    0940041       5 [5 N… 1 [1 Y… NA      NA      NA     
10 09400431… 0940043100    0940043       5 [5 N… 1 [1 Y… NA      NA      NA     
# ℹ 21,795 more rows
# ℹ 7,587 more variables: qa001s4 <dbl+lbl>, qa001s5 <dbl+lbl>,
#   qa001s6 <dbl+lbl>, qa001s7 <dbl+lbl>, qa001s8 <dbl+lbl>,
#   qa001s97 <dbl+lbl>, qa002 <chr>, qa002_1 <chr>, qa003 <dbl>, qa004 <dbl>,
#   qa005 <dbl>, qa006 <chr>, qa006_1 <chr>, qa007 <dbl>, qa008 <dbl>,
#   qa009 <dbl>, qa010 <chr>, qa010_1 <chr>, qa011 <dbl>, qa012 <dbl>,
#   qa013 <dbl>, qa014 <dbl+lbl>, qa015 <dbl+lbl>, qa016 <dbl+lbl>, …
```


:::
:::



## 变量重命名

-   将所有的变量重命名为可读性更好的名称
-   重命名后的变量名保存在一个新的数据框中



::: {.cell}

```{.r .cell-code}
# 变量重命名
my_data_rename <- my_data_raw %>%
    rename(
        # 基本信息重命名
        id_birth_year = ba004_w3_1,   # ID出生年份
        actual_birth_year = ba002_1,  # 实际出生年份 
        death = died,                 # 是否死亡
        gender = ba000_w2_3,          # 性别

        # 内在能力运动维度重命名
        stand_test_semi_tandem_reason_1 = qd001s1,  # 未完成双脚半前后站立测试的第一个原因
        stand_test_semi_tandem_reason_2 = qd001s2,  # 未完成双脚半前后站立测试的第二个原因
        stand_test_semi_tandem_reason_3 = qd001s3,  # 未完成双脚半前后站立测试的第三个原因
        stand_test_semi_tandem_reason_4 = qd001s4,  # 未完成双脚半前后站立测试的第四个原因
        stand_test_semi_tandem_reason_5 = qd001s5,  # 未完成双脚半前后站立测试的第五个原因
        stand_test_semi_tandem_reason_6 = qd001s6,  # 未完成双脚半前后站立测试的第六个原因
        stand_test_semi_tandem_reason_7 = qd001s7,  # 未完成双脚半前后站立测试的第七个原因
        stand_test_semi_tandem_reason_8 = qd001s8,  # 未完成双脚半前后站立测试的第八个原因
        stand_test_semi_tandem_reason_other = qd001s97,  # 未完成双脚半前后站立测试的其他原因
        stand_test_semi_tandem = qd002,  # 是否完成双脚半前后站立测试

        stand_test_tandem_reason_1 = qe001s1,  # 未完成双脚一条线站立测试的第一个原因
        stand_test_tandem_reason_2 = qe001s2,  # 未完成双脚一条线站立测试的第二个原因
        stand_test_tandem_reason_3 = qe001s3,  # 未完成双脚一条线站立测试的第三个原因
        stand_test_tandem_reason_4 = qe001s4,  # 未完成双脚一条线站立测试的第四个原因
        stand_test_tandem_reason_5 = qe001s5,  # 未完成双脚一条线站立测试的第五个原因
        stand_test_tandem_reason_6 = qe001s6,  # 未完成双脚一条线站立测试的第六个原因
        stand_test_tandem_reason_7 = qe001s7,  # 未完成双脚一条线站立测试的第七个原因
        stand_test_tandem_reason_8 = qe001s8,  # 未完成双脚一条线站立测试的第八个原因
        stand_test_tandem_reason_other = qe001s97,  # 未完成双脚一条线站立测试的其他原因
        stand_test_tandem = qe002,       # 双脚一条线站立测试
        stand_test_tandem_time = qe003,  # 双脚一条线站立测试时间

        stand_test_feet_together_reason_1 = qf001s1,  # 未完成双脚并拢站立测试的第一个原因
        stand_test_feet_together_reason_2 = qf001s2,  # 未完成双脚并拢站立测试的第二个原因
        stand_test_feet_together_reason_3 = qf001s3,  # 未完成双脚并拢站立测试的第三个原因
        stand_test_feet_together_reason_4 = qf001s4,  # 未完成双脚并拢站立测试的第四个原因
        stand_test_feet_together_reason_5 = qf001s5,  # 未完成双脚并拢站立测试的第五个原因
        stand_test_feet_together_reason_6 = qf001s6,  # 未完成双脚并拢站立测试的第六个原因
        stand_test_feet_together_reason_7 = qf001s7,  # 未完成双脚并拢站立测试的第七个原因
        stand_test_feet_together_reason_8 = qf001s8,  # 未完成双脚并拢站立测试的第八个原因
        stand_test_feet_together_reason_other = qf001s97,  # 未完成双脚并拢站立测试的其他原因
        stand_test_feet_together = qf002, # 双脚并拢站立测试

        walk_test_reason_1 = qg001s1,  # 未完成步行测试的第一个原因
        walk_test_reason_2 = qg001s2,  # 未完成步行测试的第二个原因
        walk_test_reason_3 = qg001s3,  # 未完成步行测试的第三个原因
        walk_test_reason_4 = qg001s4,  # 未完成步行测试的第四个原因
        walk_test_reason_5 = qg001s5,  # 未完成步行测试的第五个原因
        walk_test_reason_6 = qg001s6,  # 未完成步行测试的第六个原因
        walk_test_reason_7 = qg001s7,  # 未完成步行测试的第七个原因
        walk_test_reason_8 = qg001s8,  # 未完成步行测试的第八个原因
        walk_test_reason_other = qg001s97,  # 未完成步行测试的其他原因
        walk_time_first = qg002,       # 步行测试时间1
        walk_time_second = qg003,      # 步行测试时间2
        walk_test_aid = qg005,       # 步行测试使用辅具情况

        sit_stand_test_reason_1 = qh001s1,  # 未完成五次坐下起来测试的第一个原因
        sit_stand_test_reason_2 = qh001s2,  # 未完成五次坐下起来测试的第二个原因
        sit_stand_test_reason_3 = qh001s3,  # 未完成五次坐下起来测试的第三个原因
        sit_stand_test_reason_4 = qh001s4,  # 未完成五次坐下起来测试的第四个原因
        sit_stand_test_reason_5 = qh001s5,  # 未完成五次坐下起来测试的第五个原因
        sit_stand_test_reason_6 = qh001s6,  # 未完成五次坐下起来测试的第六个原因
        sit_stand_test_reason_7 = qh001s7,  # 未完成五次坐下起来测试的第七个原因
        sit_stand_test_reason_8 = qh001s8,  # 未完成五次坐下起来测试的第八个原因
        sit_stand_test_reason_other = qh001s97,  # 未完成五次坐下起来测试的其他原因
        sit_stand_test_completed = qh002,  # 是否完成五次坐下起来测试
        sit_stand_test_time = qh003,  # 完成五次坐下起来测试的时间
        sit_stand_test_arm_use = qh007,  # 坐起测试中使用手臂的情况

        

        # 内在能力认知维度重命名
        recall_word_1 = dc006s1,       # 回忆词汇1
        recall_word_2 = dc006s2,       # 回忆词汇2
        recall_word_3 = dc006s3,       # 回忆词汇3
        recall_word_4 = dc006s4,       # 回忆词汇4
        recall_word_5 = dc006s5,       # 回忆词汇5
        recall_word_6 = dc006s6,       # 回忆词汇6
        recall_word_7 = dc006s7,       # 回忆词汇7
        recall_word_8 = dc006s8,       # 回忆词汇8
        recall_word_9 = dc006s9,       # 回忆词汇9
        recall_word_10 = dc006s10,     # 回忆词汇10
        recall_none = dc006s11,        # 是否一个都没回忆起来
        recall_refused = dc006s12,     # 是否拒绝回忆

        recall_year = dc001s1,         # 回忆年份
        recall_month = dc001s2,        # 回忆月份
        recall_day = dc001s3,          # 回忆日期
        recall_weekday = dc002,        # 回忆星期
        recall_season = dc003,         # 回忆季节

        subtraction_test_1 = dc019,    # 减法测试1
        subtraction_test_2 = dc020,    # 减法测试2
        subtraction_test_3 = dc021,    # 减法测试3
        subtraction_test_4 = dc022,    # 减法测试4
        subtraction_test_5 = dc023,    # 减法测试5
        subtraction_tool_use = dc024,  # 是否使用工具计算

        drawing_test = dc025,          # 画图测试

        # 内在能力心理维度重命名
        depression_scale_1 = dc009,    # 心理量表问题1
        depression_scale_2 = dc010,    # 心理量表问题2
        depression_scale_3 = dc011,    # 心理量表问题3
        depression_scale_4 = dc012,    # 心理量表问题4
        depression_scale_5 = dc013,    # 心理量表问题5
        depression_scale_6 = dc014,    # 心理量表问题6
        depression_scale_7 = dc016,    # 心理量表问题7
        depression_scale_8 = dc017,    # 心理量表问题8
        depression_scale_9 = dc018,    # 心理量表问题9
        night_sleep_time = da049,      # 夜晚睡眠时间
        poor_sleep_frequency = dc015,  # 睡眠不佳频率
        nap_time = da050,              # 午睡时间

        # 内在能力感官维度重命名
        wearing_glasses = da032,       # 是否佩戴眼镜
        far_vision = da033,            # 看远处视力情况
        near_vision = da034,           # 看近处视力情况
        hearing_aid = da038,           # 是否佩戴助听器
        hearing_status = da039,        # 听力情况
        
        
        # 内在能力活力维度重命名
        grip_test_reason_1 = qc001s1,  # 未完成握力测量的第一个原因
        grip_test_reason_2 = qc001s2,  # 未完成握力测量的第二个原因
        grip_test_reason_3 = qc001s3,  # 未完成握力测量的第三个原因
        grip_test_reason_4 = qc001s4,  # 未完成握力测量的第四个原因
        grip_test_reason_5 = qc001s5,  # 未完成握力测量的第五个原因
        grip_test_reason_6 = qc001s6,  # 未完成握力测量的第六个原因
        grip_test_reason_7 = qc001s7,  # 未完成握力测量的第七个原因
        grip_test_reason_8 = qc001s8,  # 未完成握力测量的第八个原因
        grip_test_reason_other = qc001s97,  # 未完成握力测量的其他原因
        left_hand_grip_1 = qc003,      # 第一次左手握力测量
        right_hand_grip_1 = qc004,     # 第一次右手握力测量
        left_hand_grip_2 = qc005,      # 第二次左手握力测量
        right_hand_grip_2 = qc006,     # 第二次右手握力测量

        breath_test_reason_1 = qb001s1,  # 未完成呼吸测试的第一个原因
        breath_test_reason_2 = qb001s2,  # 未完成呼吸测试的第二个原因
        breath_test_reason_3 = qb001s3,  # 未完成呼吸测试的第三个原因
        breath_test_reason_4 = qb001s4,  # 未完成呼吸测试的第四个原因
        breath_test_reason_5 = qb001s5,  # 未完成呼吸测试的第五个原因
        breath_test_reason_6 = qb001s6,  # 未完成呼吸测试的第六个原因
        breath_test_reason_7 = qb001s7,  # 未完成呼吸测试的第七个原因
        breath_test_reason_8 = qb001s8,  # 未完成呼吸测试的第八个原因
        breath_test_reason_other = qb001s97,  # 未完成呼吸测试的其他原因
        breath_test_1 = qb002,         # 第一次呼吸功能测定
        breath_test_2 = qb003,         # 第二次呼吸功能测定
        breath_test_3 = qb004,         # 第三次呼吸功能测定

        hemoglobin = bl_hgb          # 血红蛋白含量
    )
    # 导出包含所有重命名列的数据
    renamed_columns <- names(my_data_rename)
    original_columns <- names(my_data_raw)
    renamed_only_columns <- setdiff(renamed_columns, original_columns)
    my_data_renamed_only <- my_data_rename %>%
        select(all_of(renamed_only_columns))
    write.csv(my_data_renamed_only, "renamed_data.csv", row.names = FALSE)
```
:::



## 年龄数据清洗

-   计算年龄
-   按照年龄筛选出60岁及以上的老年人



::: {.cell}

```{.r .cell-code}
# 去除实际出生年份和ID出生年份同时缺失的数据
my_data_year_na <- my_data_rename %>%
    filter(!(is.na(actual_birth_year) & is.na(id_birth_year)))

# 计算年龄值
my_data_age <- my_data_year_na %>%
    mutate(age = 2015 - coalesce(actual_birth_year, id_birth_year))

# 年龄清洗
my_data_elder <- my_data_age %>%
    filter(age >= 60)
    # 输出现在总共多少人
total_individuals <- nrow(my_data_elder)
print(paste("总共人数:", total_individuals))
```

::: {.cell-output .cell-output-stdout}

```
[1] "总共人数: 9982"
```


:::
:::



# 内在能力分数计算
## 运动维度计算


::: {.cell}

```{.r .cell-code}
# 计算步行测试时间
my_data_wash <- my_data_elder %>%
    mutate(
        final_walk_time = case_when(
            walk_time_first %in% c(993, 999, NA) ~ case_when(
                rowSums(select(., starts_with("walk_test_reason_")) == 4, na.rm = TRUE) > 0 ~ 0,
                rowSums(select(., starts_with("walk_test_reason_")) == 6, na.rm = TRUE) > 0 ~ 0,
                TRUE ~ NA_real_
            ),
            TRUE ~ case_when(
                walk_test_aid != 1 ~ 0,
                walk_time_second %in% c(993, 999, NA) ~ if_else(2.5 / walk_time_first >= 1, 1, 0),
                TRUE ~ if_else(2.5 / pmin(walk_time_first, walk_time_second) >= 1, 1, 0)
            )
        )
    )

# 计算双脚半前后站立时间分数
my_data_wash <- my_data_wash %>%
    mutate(
        final_semi_tandem_time = case_when(
            stand_test_semi_tandem %in% c(993, 999, NA) ~ case_when(
                rowSums(select(., starts_with("stand_test_semi_tandem_reason_")) == 4, na.rm = TRUE) > 0 ~ 0,
                rowSums(select(., starts_with("stand_test_semi_tandem_reason_")) == 6, na.rm = TRUE) > 0 ~ 0,
                TRUE ~ NA_real_
            ),
            TRUE ~ if_else(stand_test_semi_tandem == 1, 1, 0)
        )
    )
# 计算双脚前后一条线站立时间分数
my_data_wash <- my_data_wash %>%
    mutate(
        final_tandem_time = case_when(
            stand_test_tandem %in% c(993, 999, NA) ~ case_when(
                rowSums(select(., starts_with("stand_test_tandem_reason_")) == 4, na.rm = TRUE) > 0 ~ 0,
                rowSums(select(., starts_with("stand_test_tandem_reason_")) == 6, na.rm = TRUE) > 0 ~ 0,
                TRUE ~ NA_real_
            ),
            stand_test_tandem == 1 ~ 1,
            stand_test_tandem == 5 ~ if_else(stand_test_tandem_time >= 10, 1, 0),
            TRUE ~ 0
        )
    )
# 计算双脚并拢站立时间分数
my_data_wash <- my_data_wash %>%
    mutate(
        final_feet_together_time = case_when(
            stand_test_feet_together %in% c(993, 999, NA) ~ case_when(
                rowSums(select(., starts_with("stand_test_feet_together_reason_")) == 4, na.rm = TRUE) > 0 ~ 0,
                rowSums(select(., starts_with("stand_test_feet_together_reason_")) == 6, na.rm = TRUE) > 0 ~ 0,
                TRUE ~ NA_real_
            ),
            stand_test_feet_together == 1 ~ 1,
            TRUE ~ 0
        )
    )
# 计算平衡总分
# 计算最终平衡得分
my_data_wash <- my_data_wash %>%
    mutate(
        final_balance_score = case_when(
            rowSums(select(., final_semi_tandem_time, final_tandem_time, final_feet_together_time) == 1, na.rm = TRUE) >= 2 ~ 1,
            rowSums(is.na(select(., final_semi_tandem_time, final_tandem_time, final_feet_together_time))) == 3 ~ NA_real_,
            TRUE ~ 0
        )
    )
# 计算坐起测试时间
my_data_wash <- my_data_wash %>%
    mutate(
        final_sit_stand_time = case_when(
            sit_stand_test_completed %in% c(993, 999, NA) ~ case_when(
                rowSums(select(., starts_with("sit_stand_test_reason_")) == 4, na.rm = TRUE) > 0 ~ 0,
                rowSums(select(., starts_with("sit_stand_test_reason_")) == 6, na.rm = TRUE) > 0 ~ 0,
                TRUE ~ NA_real_
            ),
            TRUE ~ if_else(sit_stand_test_time <= 12, 1, 0)
        )
    )
# 计算运动维度总分
my_data_wash <- my_data_wash %>%
    mutate(
        final_physical_score = rowSums(select(., final_walk_time, final_balance_score, final_sit_stand_time), na.rm = TRUE)
    )
# 导出运动维度所有变量和ID，去除其他所有变量，导出一个csv
required_columns <- c(
    "ID", "final_walk_time", "final_semi_tandem_time", "final_tandem_time", "final_feet_together_time", "final_balance_score", "final_sit_stand_time", "final_physical_score"
)
my_data_physical <- my_data_wash %>%
    select(all_of(required_columns))

write.csv(my_data_physical, "physical_dimension_data.csv", row.names = FALSE)
```
:::



## 认知维度计算


::: {.cell}

```{.r .cell-code}
# 计算最终回忆分数
my_data_wash <- my_data_wash %>%
    mutate(
        final_recall_score = case_when(
            !is.na(recall_refused) ~ NA_real_,
            !is.na(recall_none) ~ 0,
            TRUE ~ rowSums(select(., starts_with("recall_word_")) %>% mutate_all(~ if_else(!is.na(.), 1, 0)), na.rm = TRUE)
        )
    )

# 计算减法测试总分
my_data_wash <- my_data_wash %>%
    mutate(
        total_subtraction_score = case_when(
            rowSums(is.na(select(., starts_with("subtraction_test_")))) == 5 ~ 0,
            !is.na(subtraction_tool_use) & subtraction_tool_use == 1 ~ 0,
            TRUE ~ rowSums(
                cbind(
                    if_else(subtraction_test_1 == 93, 1, 0),
                    if_else(subtraction_test_2 == 86, 1, 0),
                    if_else(subtraction_test_3 == 79, 1, 0),
                    if_else(subtraction_test_4 == 72, 1, 0),
                    if_else(subtraction_test_5 == 65, 1, 0)
                ),
                na.rm = TRUE
            )
        )
    )

# 计算时间感知总分
my_data_wash <- my_data_wash %>%
    mutate(
        final_time_perception_score = rowSums(
            cbind(
                if_else(!is.na(recall_year), 1, 0),
                if_else(!is.na(recall_month), 1, 0),
                if_else(!is.na(recall_day), 1, 0),
                if_else(recall_weekday == 1, 1, 0),
                if_else(recall_season == 1, 1, 0)
            ),
            na.rm = TRUE
        )
    )

# 计算最终绘画得分
my_data_wash <- my_data_wash %>%
    mutate(
        final_drawing_score = case_when(
            drawing_test == 1 ~ 1,
            drawing_test == 2 ~ 0,
            is.na(drawing_test) ~ 0,
            TRUE ~ NA_real_
        )
    )
# 认知维度总分计算
my_data_wash <- my_data_wash %>%
    mutate(
        final_cognitive_score = case_when(
            final_recall_score + total_subtraction_score + final_time_perception_score + final_drawing_score > 21 ~ 21,
            TRUE ~ final_recall_score + total_subtraction_score + final_time_perception_score + final_drawing_score
        )
    )
# 导出认知维度所有变量和ID，去除其他所有变量，导出一个csv
required_columns <- c(
    "ID", "final_recall_score", "total_subtraction_score", "final_time_perception_score", "final_drawing_score", "final_cognitive_score"
)
my_data_cognitive <- my_data_wash %>%
    select(all_of(required_columns))

write.csv(my_data_cognitive, "cognitive_dimension_data.csv", row.names = FALSE)
```
:::


## 心理维度计算


::: {.cell}

```{.r .cell-code}
# 计算抑郁总分
my_data_wash <- my_data_wash %>%
    mutate(
        total_depression_score = if_else(
            rowSums(select(., starts_with("depression_scale_")), na.rm = TRUE) == 0 & 
            rowSums(is.na(select(., starts_with("depression_scale_")))) == 9,
            NA_real_,
            rowSums(select(., starts_with("depression_scale_")), na.rm = TRUE) + 
            rowSums(is.na(select(., starts_with("depression_scale_"))))
        )
    )

# 计算总睡眠时间
my_data_wash <- my_data_wash %>%
    mutate(
        total_sleep_time = case_when(
            is.na(night_sleep_time) & is.na(nap_time) ~ NA_real_,
            TRUE ~ coalesce(night_sleep_time, 0) + coalesce(nap_time, 0)
        )
    )
# 计算睡眠时间分数
my_data_wash <- my_data_wash %>%
    mutate(
        final_sleep_time_score = case_when(
            is.na(total_sleep_time) ~ NA_real_,
            total_sleep_time >= 5 & total_sleep_time <= 10.5 ~ 1,
            TRUE ~ 0
        )
    )

# 计算不良睡眠频率分数
my_data_wash <- my_data_wash %>%
    mutate(
        final_poor_sleep_score = case_when(
            is.na(poor_sleep_frequency) ~ NA_real_,
            poor_sleep_frequency %in% c(1, 2) ~ 1,
            poor_sleep_frequency %in% c(3, 4) ~ 0,
            TRUE ~ NA_real_
        )
    )

# 计算抑郁总分
my_data_wash <- my_data_wash %>%
    mutate(
        total_depression_score = if_else(
            rowSums(is.na(select(., starts_with("depression_scale_")))) == 9,
            NA_real_,
            rowSums(
                select(., starts_with("depression_scale_")) %>%
                    mutate_all(~ case_when(
                        . == 1 ~ 0,
                        . == 2 ~ 1,
                        . == 3 ~ 2,
                        . == 4 ~ 3,
                        TRUE ~ 0
                    )) %>%
                    mutate(
                        depression_scale_5 = case_when(
                            depression_scale_5 == 1 ~ 3,
                            depression_scale_5 == 2 ~ 2,
                            depression_scale_5 == 3 ~ 1,
                            depression_scale_5 == 4 ~ 0,
                            TRUE ~ 0
                        ),
                        depression_scale_8 = case_when(
                            depression_scale_8 == 1 ~ 3,
                            depression_scale_8 == 2 ~ 2,
                            depression_scale_8 == 3 ~ 1,
                            depression_scale_8 == 4 ~ 0,
                            TRUE ~ 0
                        )
                    ),
                na.rm = TRUE
            ) / 3
        )
    ) %>%
    mutate(
        final_depression_score = if_else(total_depression_score >= 12, 0, 1)
    )
# 心理维度总分计算
my_data_wash <- my_data_wash %>%
    mutate(
        final_psychological_score = rowSums(select(., final_sleep_time_score, final_poor_sleep_score, final_depression_score), na.rm = TRUE)
    )
# 导出心理维度所有变量和ID，去除其他所有变量，导出一个csv
required_columns <- c(
    "ID", "total_sleep_time", "final_sleep_time_score", "final_poor_sleep_score", "final_depression_score", "final_psychological_score",
    "depression_scale_1", "depression_scale_2", "depression_scale_3", "depression_scale_4", "depression_scale_5", "depression_scale_6",
    "depression_scale_7", "depression_scale_8", "depression_scale_9"
)
my_data_psychological <- my_data_wash %>%
    select(all_of(required_columns))

write.csv(my_data_psychological, "psychological_dimension_data.csv", row.names = FALSE)
```
:::



## 感官维度计算


::: {.cell}

```{.r .cell-code}
# 计算视力总分
my_data_wash <- my_data_wash %>%
    mutate(
        final_far_vision = case_when(
            wearing_glasses %in% c(1, 2) ~ 0,
            wearing_glasses %in% c(3, 4) ~ case_when(
                far_vision %in% c(1, 2, 3, 4) ~ 1,
                far_vision == 5 ~ 0,
                TRUE ~ NA_real_
            ),
            TRUE ~ NA_real_
        ),
        final_near_vision = case_when(
            wearing_glasses %in% c(1, 2) ~ 0,
            wearing_glasses %in% c(3, 4) ~ case_when(
                near_vision %in% c(1, 2, 3, 4) ~ 1,
                near_vision == 5 ~ 0,
                TRUE ~ NA_real_
            ),
            TRUE ~ NA_real_
        )
    )
# 计算听力总分
my_data_wash <- my_data_wash %>%
    mutate(
        final_hearing_score = case_when(
            hearing_aid == 1 ~ 0,
            hearing_aid == 2 ~ case_when(
                hearing_status %in% c(1, 2, 3, 4) ~ 1,
                hearing_status == 5 ~ 0,
                TRUE ~ NA_real_
            ),
            TRUE ~ NA_real_
        )
    )
# 计算感官维度总分
my_data_wash <- my_data_wash %>%
    mutate(
        final_sensory_score = rowSums(select(., final_far_vision, final_near_vision, final_hearing_score), na.rm = TRUE)
    )
# 导出感官维度所有变量和ID，去除其他所有变量，导出一个csv
required_columns <- c(
    "ID", "final_far_vision", "final_near_vision", "final_hearing_score", "final_sensory_score"
)
my_data_sensory <- my_data_wash %>%
    select(all_of(required_columns))

write.csv(my_data_sensory, "sensory_dimension_data.csv", row.names = FALSE)
```
:::



## 活力维度计算


::: {.cell}

```{.r .cell-code}
# 计算左手握力分数
my_data_wash <- my_data_wash %>%
    mutate(
        final_left_hand_grip = case_when(
            rowSums(select(., starts_with("grip_test_reason_")) == 4, na.rm = TRUE) > 0 ~ 0,
            rowSums(select(., starts_with("grip_test_reason_")) == 6, na.rm = TRUE) > 0 ~ 0,
            TRUE ~ pmax(left_hand_grip_1, left_hand_grip_2, na.rm = TRUE)
        )
    )

# 计算右手握力分数
my_data_wash <- my_data_wash %>%
    mutate(
        final_right_hand_grip = case_when(
            rowSums(select(., starts_with("grip_test_reason_")) == 4, na.rm = TRUE) > 0 ~ 0,
            rowSums(select(., starts_with("grip_test_reason_")) == 6, na.rm = TRUE) > 0 ~ 0,
            TRUE ~ pmax(right_hand_grip_1, right_hand_grip_2, na.rm = TRUE)
        )
    )

# 计算最终握力分数
my_data_wash <- my_data_wash %>%
    mutate(
        final_grip_score = case_when(
            gender == 1 ~ if_else(pmax(final_left_hand_grip, final_right_hand_grip, na.rm = TRUE) >= 35, 1, 0),
            gender == 2 ~ if_else(pmax(final_left_hand_grip, final_right_hand_grip, na.rm = TRUE) >= 25, 1, 0),
            TRUE ~ NA_real_
        )
    )
# 计算呼吸功能总分
my_data_wash <- my_data_wash %>%
    mutate(
        final_breath_test = case_when(
            rowSums(select(., starts_with("breath_test_")) == 993, na.rm = TRUE) == 3 |
            rowSums(select(., starts_with("breath_test_")) == 999, na.rm = TRUE) == 3 |
            rowSums(is.na(select(., starts_with("breath_test_"))), na.rm = TRUE) == 3 ~ case_when(
                rowSums(select(., starts_with("breath_test_reason_")) == 4, na.rm = TRUE) > 0 ~ 0,
                rowSums(select(., starts_with("breath_test_reason_")) == 6, na.rm = TRUE) > 0 ~ 0,
                TRUE ~ NA_real_
            ),
            gender == 1 ~ if_else(pmax(breath_test_1, breath_test_2, breath_test_3, na.rm = TRUE) >= 400, 1, 0),
            gender == 2 ~ if_else(pmax(breath_test_1, breath_test_2, breath_test_3, na.rm = TRUE) >= 290, 1, 0),
            TRUE ~ NA_real_
        )
    )
# 计算血红蛋白
my_data_wash <- my_data_wash %>%
    mutate(
        final_hemoglobin = hemoglobin * 10
    )
# 计算血红蛋白分数
my_data_wash <- my_data_wash %>%
    mutate(
        final_hemoglobin_score = case_when(
            is.na(hemoglobin) ~ NA_real_,
            gender == 1 & hemoglobin >= 120 ~ 1,
            gender == 1 & hemoglobin < 120 ~ 0,
            gender == 2 & hemoglobin >= 110 ~ 1,
            gender == 2 & hemoglobin < 110 ~ 0,
            TRUE ~ NA_real_
        )
    )
# 计算活力维度总分
my_data_wash <- my_data_wash %>%
    mutate(
        final_vitality_score = rowSums(select(., final_grip_score, final_breath_test, final_hemoglobin_score), na.rm = TRUE)
    )
# 导出活力维度所有变量和ID，去除其他所有变量，导出一个csv
required_columns <- c(
    "ID", "final_left_hand_grip", "final_right_hand_grip", "final_grip_score", "final_breath_test", "final_hemoglobin_score", "final_vitality_score"
)
my_data_vitality <- my_data_wash %>%select(all_of(required_columns))
write.csv(my_data_vitality, "vitality_dimension_data.csv", row.names = FALSE)
```
:::



# 内在能力清洗


::: {.cell}

```{.r .cell-code}
# 挑出只包含ID和五个内在能力维度总分的变量
my_data_final <- my_data_wash %>%
    select(ID, final_physical_score, final_cognitive_score, final_psychological_score, final_sensory_score, final_vitality_score)

# 计算覆盖百分之百内在能力变量的个体数量
covered_individuals <- my_data_final %>%
    filter(!is.na(final_physical_score) & !is.na(final_cognitive_score) & !is.na(final_psychological_score) & !is.na(final_sensory_score) & !is.na(final_vitality_score))

# 输出覆盖百分之百内在能力变量的个体数量
covered_count <- nrow(covered_individuals)
print(paste("覆盖百分之百内在能力变量的个体数量:", covered_count))
```

::: {.cell-output .cell-output-stdout}

```
[1] "覆盖百分之百内在能力变量的个体数量: 9846"
```


:::

```{.r .cell-code}
# 导出成一个新的数据框
write.csv(my_data_final, "final_data.csv", row.names = FALSE)
```
:::



# 模型建立

# 模型验证
