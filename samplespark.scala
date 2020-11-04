package org.apache.sparksample

import org.apache.spark.sql.SparkSession
import org.apache.spark.sql.{Row, SaveMode, SparkSession}
import org.apache.log4j.{Level, Logger}
import org.apache.spark.storage.StorageLevel


object samples {
   def main(args: Array[String]) = {

     val start_time = System.nanoTime()
    
    // Use this if you are passing any arguments from the spark submit
    val src_db:String = args(0)
    val src_hdfs_path = args(1)
    val tgt_db:String = args(2)
    val tgt_hdfs_path = args(3)
    val prcs_dt:String =args(4)
     
     
    // Use this section if you wish to use the arguments to parameterizze the soruce and targets
    println("Source Database name = "+ src_db)
    println("Target Database name ="+ tgt_db)
    println("Target hdfs path="+ tgt_hdfs_path)
    println("Running the Target load job for process date="+ prcs_dt)
     
     //defaulted few values , please check with your admins or resource engineer to optimize the configurations
    val spark = SparkSession.builder()
      .config("hive.metastore.warehouse.dir", s"$tgt_hdfs_path/target_table")
      .config("hive.exec.dynamic.partition.mode", "nonstrict") //use this if you have a partition on your target and perform dynamic partition writes
      .config("hive.exec.dynamic.partition","true") //use this if you have a partition on your target and perform dynamic partition writes
      .config("spark.sql.sources.partitionOverwriteMode", "DYNAMIC") //use this if you have a partition on your target and perform dynamic partition writes
      .config("spark.sql.codegen", "True") 
      .config("spark.sql.shuffle.partitions", "75") //use this only when you wish to override default values
      .config("spark.executor.memory", "5g")   //optimize this by contacting respective resource admins
      .config("spark.debug.maxToStringFields", 200)
      .config("spark.sql.hive.convertMetastoreOrc","True") //required when you need to write the files to hive compatible hdfs files
      .config("spark.sql.crossJoin.enabled","true")
      .enableHiveSupport() //required if you are using hive tables and data writes
      .getOrCreate()
      
      
    import spark.implicits._

//   Set the Logger to WARN, default is INFO
    val sparkLogger = Logger.getRootLogger().setLevel(Level.WARN)
    
    val src_df = spark.table(s"$src_db.sample_table")
    //val df_out = spark.table("sourceDB.sample_table") //creating a dataframe using a hive table
      
    
    
    //println(s"writing into $tgt_hdfs_path/dnc_preferences and $tgt_db.dnc_preferences ")
    
        //writing data into another table with partition key - state; dynamic partition write
        src_df.write.format("orc").partitionBy("state").mode(SaveMode.Append).save(s"$tgt_hdfs_path/transaction_statewise_summary")
    
    spark.sql(s"msck repair table $tgt_db.dnc_preferences"); //Required to sync all new partitions and updates the hive metastore
    
    spark.sql(s"msck repair table $src_db.dnc_preferences_dupl");
    
    val duration_seconds = ((System.nanoTime - start_time) / (1e9d * 3600)).toString()
     
    println("Script completed in "+ duration_seconds.substring(0, 4)+" HH.MM")
   
    
    
   }
}
