from pyspark.sql import SparkSession, DataFrame


def main():
    spark = SparkSession.builder.appName("SparkTest").getOrCreate()

    df = spark.createDataFrame(
        data=[(1, "Alice"), (2, "Bob"), (3, "Cathy")],
        schema=["id", "name"],
    )
    df.show()


if __name__ == "__main__":
    main()
