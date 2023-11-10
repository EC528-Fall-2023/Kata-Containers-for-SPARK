## End to end benchmark: TPCH-SPARK

generates tables with extension `.tbl` with scale 1 (default) for a total of roughly 1GB size across all tables.

set current project to Spark TPC-H Queries, and run all 22 queries based on TPC-H



if you want to launch end to end benchmark test:

enter kata1, go to tpch-spark directory, and submit jar package

```shell
cd tpch-spark/
spark-submit --class "main.scala.TpchQuery" target/scala-2.12/spark-tpc-h-queries_2.12-1.0.jar
```

### Query result

> Query   Time (seconds)
> Q01     8.24247742
> Q02     3.45321774
> Q03     6.38394976
> Q04     5.66550303
> Q05     6.10160494
> Q06     3.94709706
> Q07     6.25620985
> Q08     5.88419056
> Q09     8.04950333
> Q10     5.98689461
> Q11     2.11859703
> Q12     4.86904621
> Q13     2.93724298
> Q14     4.54878807
> Q15     4.32781935
> Q16     1.87171900
> Q17     8.68846512
> Q18     10.41210747
> Q19     4.35127401
> Q20     5.74984026
> Q21     19.27814484
> Q22     1.92593896



reference: [GitHub - ssavvides/tpch-spark: TPC-H queries in Apache Spark SQL using native DataFrames API](https://github.com/ssavvides/tpch-spark)


