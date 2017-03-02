import akka.actor.ActorSystem
import akka.http.scaladsl.Http
import akka.http.scaladsl.model.{ContentTypes, HttpEntity}
import akka.http.scaladsl.server.Directives._
import akka.stream.ActorMaterializer
import org.apache.spark.{SparkConf, SparkContext}

import scala.collection.JavaConversions._
import scala.io.StdIn

object DockerSpark {
  def main(args: Array[String]): Unit = {
    implicit val system = ActorSystem()
    implicit val materializer = ActorMaterializer()
    implicit val executionContext = system.dispatcher

    // reading listening port from the environment
    val port: Int = System.getenv("DSPARK_PORT").toInt
    val itf: String = System.getenv("DSPARK_LISTENING_IP")
    val master: String = System.getenv("SPARK_MASTER")

    // Setup Spark configuration
    val conf = new SparkConf()
      .setAppName("dspark")
      .setMaster(master)

    val eVars = System.getenv()
    for ((k: String, v: String) <- eVars) {
      if (k.startsWith("spark_")) {
        val key: String = k.replace("_", ".")
        println(s"Setting $key => $v")
        conf.set(key, v)
      }
    }

    // creating spark context
    val sc = new SparkContext(conf)

    // Setup HTTP server
    val route =
    post {
      pathSingleSlash
      path("job") {
        parameters('input.as[String], 'output.as[String]) { (input, output) =>
          complete {
            runJob(sc, input, output)
          }
        }
      }
    } ~
      get {
        pathSingleSlash {
          complete(HttpEntity(ContentTypes.`text/html(UTF-8)`, "<html><body>Hello world!</body></html>"))
        } ~
          path("ping") {
            complete("PONG!")
          }
      }

    val bindingFuture = Http().bindAndHandle(route, itf, port)
    println(s"Server started at $port")

    StdIn.readLine()
    println("shutting down server")
    bindingFuture.flatMap(_.unbind()).onComplete(_ ⇒ system.terminate())
    println("server is down")
  }

  def runJob(sc: SparkContext, input_file: String, output_file: String): String = {
    try {
      val textFile = sc.textFile(input_file)
      val counts = textFile.flatMap(line => line.split(" "))
        .map(word => (word, 1))
        .reduceByKey(_ + _)
      counts.saveAsTextFile(output_file)
      String.format("Job output saved at %s\n", output_file)
    } catch {
      case e: Throwable => String.format("Error occurred: %s\n", e)
    }
  }
}
