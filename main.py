from pyspark.sql import SparkSession, DataFrame


def main():
    spark = SparkSession.builder.appName("SparkTest").getOrCreate()

    df = spark.createDataFrame(
        data=[(1, "Alice"), (2, "Bob"), (3, "Cathy")],
        schema=["id", "name"],
    )
    df.show()


def transform(df: DataFrame) -> DataFrame:
    return df.withColumn("sum", df["c1"] + df["c2"] + df["c3"])


if __name__ == "__main__":
    main()
