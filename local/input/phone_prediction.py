#imports
import pyspark
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, isnan, count, sqrt, round
from pyspark.ml import Pipeline
from pyspark.ml.feature import VectorAssembler, MinMaxScaler
from pyspark.ml.classification import LogisticRegression
from pyspark.ml.evaluation import MulticlassClassificationEvaluator
from pyspark2pmml import PMMLBuilder
from pyspark2pmml import toPMMLBytes

#Initialiaze spark session and associate to context
spark = SparkSession.builder.appName("PhonePrediction").config("spark.jars.packages","org.jpmml:jpmml-sparkml:2.2.0").getOrCreate()
sc = spark.sparkContext

#read train.csv from hdfs system
path = "hdfs://localhost:9000/train.csv"
df = spark.read.csv(path, inferSchema=True, header=True)

#Remove useless features
df = df.drop("id", "blue", "wifi", "dual_sim", "three_g", "clock_speed", "fc", "m_dep", "touch_screen", "talk_time")
df.show(5)

# Check nan values
for c in df.columns:
    print(f' for {c} null or nan values are: {df.select(col(c)).where(col(c).isNull()| isnan(c)).count()}')

#adding features inch from existing features sc_w and sc_h
df = df.withColumn("inch", round(sqrt(col("sc_w")**2 + col("sc_h")**2)/2.55, 2))
df.show(5)

df = df.drop("sc_h", "sc_w")
df.show(5)

#adding features ppi from existing features px_width and inch
df = df.withColumn("ppi", round(col("px_width") / col("inch")).cast("int"))
df = df.drop("px_height", "px_width")
df.show(5)

#Creating pipeline
feature_to_scale = ['battery_power', 'int_memory','mobile_wt', 'n_cores', "pc", "ram", "inch", "ppi"]
assemblers = VectorAssembler(inputCols=feature_to_scale, outputCol="features_vec")
scalers = MinMaxScaler(inputCol="features_vec", outputCol="features_scaled")
features = ["features_scaled"]
features.append("four_g")
final_assembler = VectorAssembler(inputCols=features,outputCol="features")

softmax_regression = LogisticRegression(featuresCol="features", labelCol="price_range")
pipeline = Pipeline(stages = [assemblers, scalers, final_assembler, softmax_regression])

#training and testing 
train_set, test_set=df.randomSplit([0.7,0.3])
train = pipeline.fit(train_set)
predict = train.transform(test_set)

predict.select("prediction", "price_range", "features").show(10)

#evaluation
evaluator = MulticlassClassificationEvaluator(labelCol="price_range", predictionCol="prediction", metricName="accuracy")
accuracy = evaluator.evaluate(predict)
print("Test Error = %g" % (1.0 - accuracy))

pipeline_model = pipeline.fit(df)

#building PMML model for openscoring compatibility
pmmlBuilder = PMMLBuilder(sc, df, pipeline_model).buildByteArray()

output = sc.parallelize([pmmlBuilder])

output.saveAsTextFile("hdfs://localhost:9000/trained_model/model")

#closing Spark session & context
sc.stop()

