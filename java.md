
java打包jar：
jar：

pom.xml：



<packaging>jar</packaging>
  
<build>    
   <plugins>
     <plugin>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-maven-plugin</artifactId>
     </plugin>
   </plugins>
</build>
其他不变

maven -> package

找到 jar 包，cmd -> java -jar xx.jar

war：

pom.xml：

1
<packaging>war</packaging>
启动类 继承 SpringBootServletInitializer，重写 configure


@SpringBootApplication
public class Application extends SpringBootServletInitializer {
  public static void main(String[] args) {
    SpringApplication.run(Application.class, args);
  }
 
  @Override
  protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
    return application.sources(Application.class);
  }
}
其他不变

maven -> package

找到 war 包，丢到 tomcat，启动、访问

优化
 mvn dependency:analyze


反射和动态代理（JDK Proxy和Cglib）
反射机制是 Java 语言提供的一种基础功能，赋予程序在运行时<strong>自省</strong>（introspect，官方用语）的能力。通过反射我们可以直接操作类或者对象，比如获取某个对象的类定义，获取类声明的属性和方法，调用方法或者构造对象，甚至可以运行时修改类定义。

动态代理是一种方便运行时动态构建代理、动态处理代理方法调用的机制，很多场景都是利用类似机制做到的，比如用来包装 RPC 调用、面向切面的编程（AOP）。
实现对类方法的拦截器



java 回调机制，通过注册函数，事件完成后，再调用该函数