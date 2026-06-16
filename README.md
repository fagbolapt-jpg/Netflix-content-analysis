# Netflix Content Catalog: SQL Exploratory Data Analysis

An end-to-end data cleaning and exploratory data analysis (EDA) project on Netflix's content catalog, built entirely in SQL within a Jupyter Notebook. This project covers data understanding, cleaning, transformation, analysis, and visualization of 8,807 Netflix titles.

Completed as part of my AnalystLab internship.

---

##  Project Overview

The goal of this project was to explore Netflix's content catalog to uncover patterns in content type, release trends, ratings, genres, and runtime — while practicing real-world SQL data cleaning on a genuinely messy dataset.

**Dataset:** [Netflix Movies and TV Shows](https://www.kaggle.com/datasets/shivamb/netflix-shows) (Kaggle)
**Size:** 8,807 rows × 12 columns
**Tools:** MySQL, Jupyter Notebook (`ipython-sql`), Excel (visualization)

---

##  Repository Structure

```
netflix-content-eda/
│
├── notebooks/
│   └── netflix_eda.ipynb          # Full analysis notebook (cleaning + EDA)
│
├── sql/
│   └── netflix_cleaning_eda.sql   # Standalone SQL script (cleaning + queries)
│
├── images/
│   ├── content_growth_over_time.png
│   ├── top_10_countries.png
│   ├── ratings_distribution.png
│   ├── top_genre_combinations.png
│   └── season_count_distribution.png
│
├── data/
│   └── netflix_titles_clean.csv         # cleaned dataset
│
├── Netflix_Summary_Report.docx    # One-page cleaning + insights summary
└── README.md
```

---

##  Data Cleaning Process

| Issue | Description | Fix |
|---|---|---|
| Missing values | `director`, `cast`, `country`, `rating` had blank/empty-string values, not true NULLs | Filled with `'Unknown'` placeholders to preserve row count |
| Shifted columns | A few rows had duration values (e.g. `"74 min"`) stored in the `rating` column | Moved values into `duration`, cleared `rating` for those rows |
| Inconsistent date format | `date_added` stored as text (`"September 25, 2021"`) | Converted with `STR_TO_DATE` using `%M %d, %Y`, then cast to `DATE` type |
| Mixed duration field | `duration` combined minutes (movies) and season counts (TV shows) in one text field | Split into `duration_value` (INT) and `duration_unit` (VARCHAR) |
| Suspected duplicates | 4 titles appeared twice under `title` + `type` | Investigated and confirmed these were legitimate re-additions to the catalog, not duplicates — left in dataset |

---

##  Key Questions Explored

- How has Netflix's content catalog grown year over year?
- What's the split between Movies and TV Shows?
- Which countries produce the most content?
- What's the distribution of content ratings?
- Which genre combinations are most common?
- What's the typical movie runtime and TV show season count?
- Who are the most prolific directors in the catalog?
- How long does it typically take content to be added after its original release?

---

##  Key Findings

- The catalog contains **8,807 titles** — **70% movies**, **30% TV shows**
- Content release years span **1925 to 2021**
- Content additions **peaked in 2019**, with TV shows showing a sharper spike than movies
- The **United States** produces significantly more content than any other country
- **TV-MA** is the most common content rating
- **"Dramas, International Movies"** is the most frequent genre combination
- Most TV shows run for **only 1–2 seasons**

---

##  Visualizations

| Chart | Insight |
|---|---|
| Content Growth Over Time | Tracks Movie vs TV Show additions by year |
| Top 10 Content-Producing Countries | Highlights US dominance in the catalog |
| Content Ratings Distribution | Shows skew toward mature-rated content |
| Top Genre Combinations | Most frequent genre tag pairings |
| TV Show Season Counts | Reveals steep drop-off after season 1–2 |

*(See `/images` folder for all chart exports)*

---

##  How to Reproduce

1. Clone this repository
2. Import `data/netflix_titles.csv` into a MySQL database
3. Run the cleaning + analysis script in `sql/netflix_cleaning_eda.sql`, or open `notebooks/netflix_eda.ipynb` in Jupyter with the `ipython-sql` extension installed
4. Connect to your local database using:
   ```
   %load_ext sql
   %sql mysql+pymysql://username:password@127.0.0.1:3306/netflix
   ```

---

##  Full Report

A one-page summary of cleaning challenges, key findings, and insights is available in [`Netflix_Summary_Report.docx`](./Netflix_Summary_Report.docx).

---

## Author

**Patricia Fagbola**
Data Analytics | SQL · Power BI · Python | 

fagbola.pt@gmail.com

LinkedIn : https://www.linkedin.com/in/patricia-fagbola-656566387?utm_source=share_via&utm_content=profile&utm_medium=member_android
