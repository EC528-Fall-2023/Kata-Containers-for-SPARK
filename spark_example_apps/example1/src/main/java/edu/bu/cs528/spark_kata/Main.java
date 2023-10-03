package edu.bu.cs528.spark_kata;

import java.io.IOException;

import org.apache.spark.api.java.function.FilterFunction;
import org.apache.spark.sql.SparkSession;

public class Main {
    public static void main(String[] args) throws IOException {
        var logFile = args[0];
        var spark = SparkSession.builder().appName("Example Spark Application").getOrCreate();
        var logData = spark.read().textFile(logFile).cache();

        var numAs = logData.filter((FilterFunction<String>)s -> s.contains("a")).count();
        var numBs = logData.filter((FilterFunction<String>)s -> s.contains("b")).count();

        System.out.println("##################### EXAMPLE1 RESULT - START #####################");
        
        System.out.println("Lines with a: " + numAs + ", lines with b: " + numBs);

        System.out.println("##################### EXAMPLE1 RESULT - END   #####################");

        spark.stop();
    }
}