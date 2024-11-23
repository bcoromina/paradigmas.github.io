# Paradigmas de programación

**Enfoque del curso**

<div style="text-align: justify;">
Des de los orígenes de la ciencia de la computación, se han creado distintos paradigmas de programación que han proporcionado soluciones y puntos de vista diferentes a los problemas y retos que plantea la construción de programas informáticos. El presente curso pretende dar a conocer algunos de los paradigmas de mayor relevancia más allá de la orientación a objetos que se utilizará como punto de partida para su exploración. El objetivo del curso es enriquecer la visión y recursos del alumno para que adquiera el criterio que le permita utilizar el paradigma adecuado para cada problema. Se hará especial atención en el paradigma funcional con lenguage Scala, ya que al ser
multiparadigma se erige como ideal para que el alumno pueda realizar una transición suave de OOP a Programación Funcional.
</div>


## **Parte 1**: Introducción a otros paradigmas de programación



### 1. Qué es un paradigma de programación


### 2. Modelo de actores

    2.1. Saliendo del paradigma convencional
    2.2. Qué es un actor
    2.3. Sistemas resilientes
    2.4. Ejemplos
    2.5. Contra ejemplos

### 3. Paradigma Reactivo

    2.1. Introducción
    2.2. Reactive Programming
    3.3. Streams

### 4. Programación funcional

     4.1 Origen de la programación funcional

     4.2. Principios

         4.2.1 Función matemàtica y sus propiedades
         4.2.2 Ejemplos de side effect
         4.2.3 Expresiones vs statement
         4.2.4 Composabilidad

    4.3. Beneficios de la programación funcional

        4.3.1 Testing: Funciones deterministas sin contexto
        4.3.2 Local reasoning (7 items en mente)
        4.3.3 Composición, la escéncia de la computación


    4.4. Side Efffects

        4.4.1 Segregación de código puro. Aplicación en arquitectura hexagonal
        4.4.2 Concepto de sistema de efectos

    4.5. Immutabilidad

        4.5.1 Beneficios
        4.5.2 Path Copying y Structural Sharing

    4.6 Álgebra

    4.7 Características de un lenguaje funcional
    

## **Parte 2**: Lenguaje Scala

    1. Porqué Scala
        
        1.1.1 Multiparadigma: OOP, FP, actores ...
        1.1.2 Killer Apps: Spark, Akka, Play Framework....

    2 Algebraic Data Types
        2.1 Product Types
        2.2 Union Types        
        2.3 Case Classes y Pattern matching
    
    3. Manejo de side effects

        3.1 Option vs null
        3,2 Try vs Exceptions
        3.3 Either
        3.4 List

    4 High Order Functions
        4.1 Currying
        4.2 Partially applied functions

    5 Genéricos

    6 Colecciones
        6.1 Definición recursiva de tipos
        6.2 Operaciones con fluent API

    7 For comprehension (map, flatten, flatMap)

    8. Herencia vs Type Classes

    9 Recursividad

    10 Mónada
        10.1 Definición
        10.2 Ejemplos: Option, Try, List...
        10.3 Mónadas para efectos
        10.4 Ejercicio: Programación de una IO monad
    
        




### 1. Qué es un paradigma de programación

<div style="text-align: justify;">
Ante el reto que presenta construir programas informáticos han ido apaerciendo distintos paradigmas de programación. Cada uno pone el foco en diferentes dimensiones del problema proporcionando un punto de vista o enfoque particular. 

Ejemplos de dimensiones pueden ser:

- modelo de ejecución: Cómo ejecuto los Side Effects? 
- organización del código: OOP agrupa estado y comportamiento en una classe.
- modelo de concurrencia: Threads con código bloqueante, Green Threads, Actores... 


Cada paradigma tiene, de una manera más o menos formal, un conjunto de reglas o de principios que constituyen el fundamento teórico. Ej OOP: abstracción, encapsulamiento, herencia y polimorfismo


Los paradigmas de programación proporcionan al desarrollador o arquitecto de software del conjunto de herramientas necesarias para abordar un problema de la mejor manera possible. 
</div>

Ejemplos:
- **Imperativo**: 
    - Procedural: C
    - Object Oriented Programming
- **Logic programming**: Basados en logica formal como Prolog 
- **Reactive Programming**: El resultado deseado es descrito como la propagación de elementos a traves de un flujo de datos. 
- **Funcional programming**

**Definición pragmática**
    Ante dos programas que resuelven el mismo problema (equivalentes funcionalmente) se puede detectar que se ha seguido un paradigma de programación distinto en cada uno de ellos cuando presentan diferéncias conceptuales significativas más allá de la sintaxi. Si simplemente podemos traducir un programa al otro traduciendo la sintaxis y poco más, estamos dentro del mismo paradigma. Si por el contrario tenemos que reescribir-lo usando abstracciones y conceptos nuevos, hemos cambiado de paradigma. 
        



 
 




### 2. Modelo de actores

#### 2.1- Saliendo del paradigma convencional

Entre 1960 y 1070 fueron creados los primeros lenguajes orientados a objetos. Sin embargo, Alan Kay, al que se le otorga el acuñamiento del término, lo definía de una forma que se asemeja más al modelo de actores a cómo se definie la OOP hoy en día.
Alan Kay definia la comunicación entre objetos como un intercambio de mensajes, no como una llamada a un método.
https://adabeat.com/fp/the-history-of-functional-programming/

El paradigma de programación más extendido es el de OOP con un modelo de concurrencia basado en Threads ( o light threads/fibers) y utilizando RPC.

El problema de esta combinación viene con la escalabilidad. Definimos escalabilidad como la capacidad de una aplicación o sistema de hacer frente a un incremento de demanda manteniendo el tiempo de respuesta.
Un sistema puede escalar a dos niveles:
- *scale up*(vertical): utilización de más CPUs dentro de la misma máquina
- *scale out*(horizontal): añadiendo máquinas o nodos al sistema distribuido

La concurrencia es un medio para conseguir escalabilidad. Si tengo que ejecutar dos compuntaciones incorreladas, las ejecuto "al mismo tiempo" (en paralelo o de forma entrelazada).

Ante un incremento de la demanda es deseable un augmento de los recursos requeridos con una relación lineal o inferior. Además, la relación entre demanda y complejidad de la aplicación queremos que mantenga un buen equilibrio.

El paradigma convencional utiliza Threads para scale up y RPC para scale down.
RPC parte de la base que una llamada a través de la red no és diferente a una llamada en la misma máquina. Si se realiza en modo síncrono va a bloquear el thread que hace la llamada con lo que vamos a hacer un uso poco eficiente de los recursos. Si hacemos una llamada asíncrona, tendremos que especificar una función de callback lo que añade complejidad a la aplicación. Puedes acabar con un callback hell si en la callback hacer otra llamada que necesita su callback, etc...

Otro problema de este paradigma es que obtenemos un código en el que se mezclan contínuamente las dos abstracciones dirigidas a cada tipo de scalabilidad. Acabas hardcodeando qué partes de tu aplicación van a utilizar Threads para scale up y cuales van a utilizar RPC para scale out.

#### 2.2- Qué es un actor

Carl Hewitt 1973 definió el modelo de actores.

El modelo de actores proporciona una abstracción única para concurrencia y escalabilidad.


***Actor***: El actor es la unidad básica de computación en el modelo de actores. 
  - Puede recibir mensajes que procesa secuencialmente según el orden de llegada. Los guarda en una cola
  - Contiene estado que puede ser modificado en base a los mensajes recibidos.
  - Puede mandar mensajes a otros actores
  - Puede crear otros actores generando un árbol jerárquico y manejando su ciclo de vida. Si un actor peta, su supervisor es notificado y puede decidir qué acciones aplicar.
  
El modelo de concurrencia utilizado consiste en un único thread (o pool de threads, uno por core) que mediante un scheduler va ejecutando cada actor.
Por ejecutar un actor se entiende comprobar si tiene mensajes en la cola y llamar a la lógica de proceso associada. Así pues, un solo thread es compartido por varios actores con lo que un actor no debe contener código bloqueante ya que bloquearía la ejecución de otros actores.

Location transparency: Un actor tiene una dirección similar al path de un fichero que lo localiza en el árbol jerárquico y permite localizarlo para mandarle mensajes. En el caso de un sistema distribuido formado por varios nodos en el que se ejecuta un sistema de actores, la localización de un actor en concreto en el cluster es transparente. Es decir, en el momento de mandar un mensaje a un actor se utiliza la misma API tanto si el actor esta en la misma máquina o está en remoto.

Ya no tenemos una doble API para scale up y scale out.


***Aislamiento de fallos****: Al ser el actor la unidad básica de computación, pueden ocurrir fallos o excepciones en su lógica. Un fallo no controlado en un actor lo para y notifica a su supervisor que aplicará la lógica de gestión de errores. El fallo queda, sin embargo aislado, no se propaga por el sistema como una excepción a través de la pila de llamadas.

***Bajo acoplamiento***: El intercambio de mensajes de forma asíncrona entre las unidades de computacón da lugar a sistemas mucho menos acoplados que los que produce la orientación a objetos donde un objeto ejecuta el método de otro a través de una instancia.


#### 2.3- Sistemas resilientes

Un sistema resiliente es el que, ante una petición del usuario, puede dar una respuesta en un tiempo razonable. Manteniendo esta capacidad en las siguientes situaciones:

- Situaciones de alta demanda. Ya sean picos o niveles sostenidos
- Errores en el sistema
- Self healing. Si un componente se para por un error, se le hace un restart automáticamente.
- ...


La escalabilidad es la propiedad del sistema que permite le permite ser resiliente ante incrementos de demanda.
Aislamiento de fallos es la propiedad del sistema que permite ser resiliente ante errores.

El modelo de programación de actores (concurrencia y location transparency) permite escribir "código escalable". Para scale out hay que utilizar un sistema de autoescalado como el de K8S o AWS. 

Escalabilidad en cluster és muy potente pero implica tener un sistema distribuido y los sistemas distribuidos vienen con sus propias complejidades. Ejemplo: split brain.


#### 2.4- Ejemplos



2.4.1. IoT


Nuestra aplicación recibe datos de sensores. Pongamos que los sensores miden distintos parámetros relacionados con la agricultura: PH de la tierra, humedad, lluvia, viento, luz, nutrientes del suelo, etc..
Nuestra empresa es una multinacional que distribuye millones y millones de sensores por todo el mundo. Los sensores envian periódicamente
información a nuestro data center. Cada dato es guardado en un histórico para el análisis posterior y también se generan alármas si se superan determinados umbrales.

Con millones de sensores enviando datos periódicamente tenemos un nivel de concurrencia que no se puede manejar con threads. Además cada petición 
requiere una potencia de cómputo muy baja con lo que los ciclos de CPU debidos al context switching entre thread respeto a los ciclos de CPU requeridos 
para procesar el dato harían nuestra aplicación altamente ineficiente.

Con el modelo de actores, cada sensor sería un actor que procesaría los mensajes en el orden recibido gracias a su cola de mensajes. El corto tiempo 
de proccesado de los mensajes permite no bloquear el thread de ejecución.



2.4.2. Banca

Un Ledger es un componente del un sistema bancario encargado de llevar la cuanta de cuandto dinero hay en cada cuenta. El ledger recibe transacciones que va a ejecutar o no en función de una serie de reglas de negocio. La regla de negocio mas sencilla es que para substraer dinero de una cuenta tiene que haber suficiente. Podemos pensar en una transacción como la orden de traspasar dinero de una cuenta a la otra.

Tanto el volumen de cuentas de usuarios como el número de transacciones pueden crecer enormemente a medida que nuestro banco se expande mundialmente.

- Diseño en un paradigma de concurrencia con Threads y estado centralizado:

  Cada transacción es procesada por un Thread y el estado se guarda en una base de datos relacional.

    - Se recibe la petición/transacción financiera en un thread
    - Se inicia una transacción de base de datos
    - Se lee el estadod de las cuentas
    - Se aplica la lógica de negocio
    - Se escribe el nuevo estado en la BD
    - Se cierra la tranbsacción de base de datos
    - Se manda una respuesta a la petición

    **Cuál es la unidad de concurrencia? La petición. Si tengo un solo procesador, este va ejecutando alternativamente las peticiones en curso.


  De entrada el número de transacciones concurrentes en una instancia de nuestro servicio viene limitado por el número de threads que podamos guardar     en memória y, si hay muchas, el rendimiento de nuestra aplicación se va a ver mermado por el desperdicio de CPU causado por el context switching.
    
  Si además le añadimos una base de datos relacional que escala con un modelo de líder y réplicas, donde las escrituras se hacen en el leader y se        replican asíncronamente en las réplicas estamos creando un cuello de botella en el líder. Escalar por data sharding no funcionaria debido a las         transacciones entre cuentas de distintos shards.
    
  Una cuenta puede estar involucrada en varias transacciones simultaneas, por lo que parece ideal que nuestra base de datos sea relacional y que          cumpla con las reglas ACID en las transacciones. Sinembargo los bloqueos en base de datos que de ello se derivan van también a limitar la             
  escalabilidad de nuestro sistema.


Litte's law (teoría de colas):

L=λ⋅W

L: Número medio de peticiones en el sistema en un momento determinado
λ: Request per second
W: Tiempo medio en cursar una petición


2 000 000 transacciones simultaneas
duración media 200 ms
10 000 000 tx / sec

- Diseño con el paradigma de actores y estado distribuido:

Aplicando el modelo de actores vamos a crear un actor para cada cuenta. El actor será el único encargado de mantener el estado de la cuenta y a modificarlo en base a las reglas de negocio. 

**Cuál es la unidad de concurréncia? La cuenta. Si tengo un solo procesador, este va ejecutando alternativammente cada cuenta, es decir, los
comandos de cada cuenta.

Cuando se reciba una transacción transfiriendo dinero de la cuenta A a la cuenta B, nuestro sistema va a enviar un comando al actor A y un comando actor B. Vamos a substituir lo que antes hacíamos con una transacción ACID por una implementación própia de transacción siguiendo el patró 2PC o Saga.
Como un actor ejecuta los comandos recibidos por orden de llegada no habrá poroblemas de concurrencia. No hay estado compartido, no hay problemas de concurrencia.

![image](https://github.com/user-attachments/assets/cc3a9e1c-9587-48b9-9c65-c46e57d7e8ad)

Las librerías de actores más potentes proporcionan las funcionalidades de sharding y clustering.
El clustering nos permite formar un conjunto de nodos de forma coordinada compartiendo el mismo sistema de actores.
El sharding distribuye instancias de actor entre los nodos del cluster.

Ulitizando el sistema de actores junto con las técnicas de sharding y clustering obtenemos un sistema altamente escalable.

Qué hay de la base de datos? Cuando el actor se crea se carga el estado de la base de datos y se escribe cada vez que se modifica.
Observese que no necesitamos las garantias ACID a la hora de interactuar con la base de datos. 
Entonces podemos utilizar una base de datos no relacional optimizada para escrituras como Cassandra.
Además Cassandra tiene un cluster de topología en anillo altamente escalable.

Así pues tenemos un sistema stateful, el actor de la cuenta A está en un determminado nodo.

Location transparency: el actor de la cuenta A y el actor de la cuenta B pueden estar en distintos nodos pero la comunicación con estos actores 
se realiza de forma transparente.

Hace fala un actor que coordine la transacción. Este actor se va a crear al vuelo y va a implementar el 2PC o Saga, enviando los comandos a los
actores-cuenta y esperando sus resultados para componer el resultado final.

En cierta forma, el listado de acciones a realizar para una transacción, se trocea en actores y su ejecución se controla a través de los comandos o mensajes que se intercanvian los actores. Equivalente al trozeo "descontrolado" que haría un thread de un listado de acciones al ejecutarlo de forma entrelazada con otros threads. Equiavlente también al trozeo que hacen las corutinas de Kotlin.


#### 2.4- Contra Ejemplos y conclusiones


El modelo de actores encaja bien para sistemas de alta concurrencia o computaciones que se puedan paralelizar. Por lo tanto no encaja bien cuando:

- Algoritmos lineales no paralelizables. Fibonacci cada elemento nuevo depende del anterior
- Batch processing monotarea no paralelizable
- Systemas que necesitan con frequencia sincronización mediante un estado global (sistemas de edición colectiva.Ej: Google Docs)
- Systemas con relaciones jerárquicas profundas (mejor OOP que actores)
- Aplicaciones que necesitan comunicaciones síncronas. Los actores van con un sistema de mensajes asíncrono. (R&F en banca)
- Hard real time systems. El intercambio de mensajes asíncrono no promete un tiempo de ejecución determinista


  El modelo de actores es un modelo de concurrencia. Cuando la concurrencia no es tu principal problema, el modelo de actores no encaja bien.

  Descomponer un secuéncia de pasos en comandos que van a ejecutar actores de forma asíncrona hace que los programas se estructuren de forma muy diferente. Es una cambio de paradigma.




### 3. Paradigma Reactivo

#### 3.1- Introducción

La primera formalización del paradigma reactivo la encontramos en la publicación del Reactive Manifesto en 2013. En él se exponen los principios de diseño para un sistema reactivo o Reactive System que, a nivel de implementación, se concreta con el paradigma Reactive Programing. El target de los sistemas reactivos son sistemas distribuidos con alta concurrencia.


- Reactive Systems: Arquitectura y diseño
- Reactive Programming: Declarativo y vasado en eventos


El driver principal de los sistemas reactivos es la responsividad Responsiveness: Capacidad de respuesta. Para conseguir esta capacidad de respuesta, el sistema tiene que solucionar las siguientes cuestiones:

- Responsive en fallo (Resiliente): El sistema debe mantener la capacidad de respuesta incluso ante fallos.
- Responsive bajo carga (Elástico): El sistema debe mantener la capacidad de respuesta con altas cargas de trabajo.

El Reactive Manifesto prescribe que para conseguir estas propiedades, necesitamos que el sistema sea Message-driven.


#### 3.2- Reactive Programming

Es un subconjunto de Asynchronous Programming.

Asynchronous Programming: Modelo de concurrencia donde un conjunto de instrucciones, como una llamada a una función, se ejecutan de forma que no bloqueen el flujo de ejecución principal esperando su finalización. Por el contrario, la finalización de una ejecución asíncrona impactará en el flujo principal mediante la ejecución de una función de callback.

Asynchronous Programing simplemente hace énfasis en la ejecución asíncrona (no bloqueante) de computaciones dentro de un programa. 


***Asincronía vs concurrencia:***

La **concurrencia** és habilidad para ejecutar tareas "simultaneamente". Las tareas se trocean y se ejecutan los trozos de forma entrelazada.
Modelos de concurrencia: 

- Threads: Un thread por tarea. Trozeado de tareas en el tiempo: Cada thread ejecuta un subconjunto de instrucciones en su turno de CPU.

- Corutinas (Kotlin): El compilador trozea nuestra función en trozos etiquetados y los ejecuta de forma concurrente con otras corrutinas. Dentro de una misma corutina el control de ejecución de los trozes se realiza por continuations.

- Go routines, JVM Virtual threads,....

La **asincronía** es una forma de implementar un sistema concurrente. Hace referéncia a la habilidad de un sistema para ejecutar una tarea y continuar con la ejecución de otra sin que la primera haya acabado. La ejecución de tareas se ejecuta de forma no bloqueante.



Así pues Reactive Programing se basa en la programación asíncrona y orientada a mensajes: Modelo de Actores

- Elasticidad que proporciona la configuración en cluster
- Resiliencia: 
    - A nivel de actor: Jerarquía de actores con supervisor. Cuando hay una excepción en un Actor y este peta, su actor supervisor en la jerarquía determina qué hacer. Normalmente poner en marcha otra instancia. Lo importante es que el fallo no se propaga. Let it crash.
    - A nivel de nodo del cluster: Actor Rebalancing en sistemas de actores con Actor   Sharding (Kubernetes como pareja de baile)

Vemos que la resiliencia va más allá de la toleráncia a fallos. No se trata de que ante fallos el sistema continue funcionando de forma degradada sino que el sistema se recupere.



**Implementaciones:** Akka/Pekko en Scala, Groovy GPars, Elixir/Erlang y Akka.Net en c# son implementaciones, de un ReactiveSystem basado en el Modelo de Actores.
    Elixir/Erlang es monoparadigma, solo puedo hacer programas siguiendo el modelo de actores (procesos maquina virtual BEAM).
    Scala/C# son multiparadigma.
    Erlang es un lenguaje que se compila a bytecodes a ejecutar en la máquina virtual BEAM que es una implementacón del modelo de actores.
    Una de las principales diferencias con Akka es que BEAM está optimizado para sistemas con baja laténcia. Shcheduler preemptivo limita la duración de ejecución de los procesos/actores en los threads de sistema operativo.
    Nació en Ericson para equipos de telecomunicaciones y ahora lo usan Whatsapp, Discord, RabbitMQ, etc...

                    
#### 3.3- Akka Streams


Un buen ejemplo de Reactive Programing es Akka Streams. 
Programación declarativa.
Evento vs mensaje

### 4. Programación funcional
      
##### 4.1. Origen de la programación funcional

Lisp, el primer lenguage de programación funcional fué desarrollado en 1960 en el MIT.
Los primeros lenguajes de progamación funcional estuvieron inspirados en el Lambda Calculus (Alonzo Church 1930).
Lambda Calculus es un sistema formal matemático que permiten describir una computación en base a la abstracción de funciones y su aplicación.
En otras palabras, el lambda calculus describe una computación como la aplicación de una función a sus argumentos. Las funciones son 'first-class citizens'. Pueden ser pasadas como argumentos y ser devueltas como valores.   


##### 4.2. Principios

##### 4.2.1 Función matemàtica y sus propiedades

Una función matemàtica calcula un resultado en base a unos valores de entrada, nada más.

Esto implica que la función tiene un comportamiento determinista: dados los mismos valores de entrada, el resultado va a ser el mismo.
De hecho, si ya se ha calculado el resultado para una determinada entrada, la función puede memoizar el resultado y simplemente devolverlo en sucesivas ejecuciones de la función con la misma entrada.

Notese que una función matemática o función pura no puede hacer side effects. Es decir, no puede alterar ni interactuar con el mundo exterior, no puede hacer nada más que calcular el resultado en función de la entrada. 


##### 4.2.2 Ejemplos de side effect

- Leer o escribir a una fuente de datos externa: base de datos, RPC, etc...
- Lanzar una excepción
- Concurrencia. Efecto de que dos computaciones ocurren de forma concurrente. Ej: en threads diferentes
- No determinismo intrínseco. Generación de números aleatórios.
- Modificar una variable externa
  ```scala
    var globalCounter: Int = 0

    def incrementCounter(): Unit = {
      globalCounter += 1  // Modifies global state
    }
  ```
- Mutar un objeto o estructura de datos

```scala
class Person(var name: String)

def changeName(person: Person, newName: String): Unit = {
  person.name = newName  // Mutating the object
}
```
Es un side effect mutar una variable dentro de la misma función?



##### 4.2.3 Expresiones vs statements


Statement: Línea de código o fragmento que tiene como objetivo realizar una acción (Side effect).
        Estilo imperativo:
            doThis();
            doThat;

Expresión: Línea de código o fragmento que tiene como ojetivo ser evaluado a un valor.

Las expresiones tienen la propiedad 'referencial transparancy': Se puede substituir la expresión por el valor resultado de su evaluación:

```scala
 def getNumberFive(): Int = 5
  
  val result = (getNumberFive() * 2, getNumberFive() * 2)
  
  //es qquivalente a 
  
  val result2 = (10, 10)
  
  //pero los side effects lo rompen

  def getNumberFive2(): Int = {
    println("5")
    5
  }
  
  //esto ejecuta dos veces el println
  val result3 = (getNumberFive2() * 2, getNumberFive2() * 2)
  
  //No es quivalente a 
  val ten = getNumberFive2() * 5
  val result4 = (ten, ten)
```

Las funciones puras nos permiten construir expresiones referencial transaparent con las cuales nos es mucho mas fácil razonar y refacctorizar nuestro código como una expresión matemática.

##### 4.2.4 Composabilidad

Los side effects no se pueden componer. Las funciones puras sí.

Dada la función addOne del siguiente listado, es posible construir la función addTwo como composición de addOne.
addOneWithSideEffect es una función que realiza una operación e imprime el resultado por pantalla.
Sinembargo, dada la función addOneWithSideEffect no es posible construir addTwoWithSideEffect como una función que suma 2 e imprime el resultado
por pantalla. Si lo intentamos, al ejecutar la función resultatante hay dos println, una con el resultado parcial y otro con el resultado final.

Los side effects se ejecutan de forma no controlada, entrelazada con el resto de la funcionalidad. 

```scala
  def addOne(x: Int): Int = x + 1
  def addOneWithSideEffect(x: Int): Int = {
    val result = x + 1
    println(s"Result: $result")
    result
  }

  def addTwo(x: Int): Int = (addOne _ andThen addOne _)(x) //addOne(addOne(x))
  
  def addTwoWithSideEffect(x: Int): Int = {
    ???
  }
```

Para controlar la ejecución de los side effects vamos a refactorizar la función addOne para que, en lugar de ejecutar el side effect,
devuelva los datos necesarios para ejecutarlo. El side effect lo vamos a ejecutar de forma diferida (deferred) respecto a la evaluación
de la función.


```scala 
  def addOnePure(x: Int): (Int, String) = {
    val result = x + 1
    (result, s"Result: $result")
  }

  def addTwoComposed(x: Int): Int = {
    val r = addOnePure(x)
    val result = addOnePure(r._1)
    println(result._2)
    result._1
  }

  addTwoComposed(4)
```
addOnePure es pues una función pura, libre de side effects y esto nos permite combinarla para construir addTwoComposed.

En este caso, en addTwoComposed, obtenemos los String a printar correspondientes a la primera y a la segunda llamada a addOnePure y
sólo ejecutamos el side effect de la segunda llamada porque contiene el resultado final.

Cómo sería una versión más genérica de esta composición de enteros? (Writer Monad)

Podría acumular todos mis side effects en una List[String] y tener una función para ejecutarlos que printara solo el último como ahora,
que printara los resultados intermedios, que printara los resultados pares, etc...

Nótese que en este punto me resulta muy fácil cambiar la ejecución de side effects de un println a un write a base de datos.

El hecho de separar el cálculo de la ejecución de los side effects me permite componer mis funciones y me permite controlar de forma independiente
la ejecución de estos side effects.



##### 4.3. Beneficios de la programación funcional

##### 4.3.1 Testing

El testing de funciones puras, deterministas y sin side effects, es el sueño de cualquier tester.

No hay que construir un contexto para el testing de una función, al ser determinista la función va a dar la misma salida para la misma entrada.
Al no generar side effects no hay que chequear ni mockear componentes externos.

Facilita el empleo de tecnicas como el Property-Based Testing. Consiste en definir una propiedad de una o varias funciones y el framework se encarga 
de generar un conjunto pseudoaleatorio de datos de entrada para nuestra función y para cada una de ellas chequear que se cumple dicha propiedad.

Por ejemplo, se desea testear que desserialización de un objeto tras su serialización coincide con el objeto original.
O que una función que devuelve la longitud de una estructura de datos simpre de >= 0.

Separo el testing del cálculo de la lógica de negocio de la ejecución de los side effects.




##### 4.3.2 Local reasoning (7 items en mente)
    "The Magical Number Seven, Plus or Minus Two" by psychologist 
    George A. Miller (1956). 
    Miller suggested that the average human can hold about 
    7 ± 2 items in their short-term memory (STM) at one time.

La carga cognitiva de un programa cuyo comportamiento depende de estados internos del propio programa en su conjunto i/o de un contexto externo de sistemas dependientes es muy grande. 

Ejemplo: Falla una función porque un memória compartida de forma asíncrona esta en un estado inesperado. Quién y porqué ha puesto la memória en aquel estado?

Las funciones puras permiten al programador razonar de forma aislada, local, permitiendo su comprensión sin tener en cuenta el resto del sistema.
Compo las funciones puras son altamente composables, se trata de reducir su tamaño de forma que su responsabilidad quede claramente definida.




##### 4.3.3 Composición, la escéncia de la computación?


Necesita un computador un programa escrito de forma funcional pura?

La respuesta es: no. Un computador necesita un lista de operaciones a ejecutar una detras de otra sin mayor estructura. 
Como una máquina de Turing.

Quién necesita funciones puras y pqueñas, y entodo caso construir sistemas complejos a partir de su composición? Los humanos.

Entonces el código lo escribimos no para la máquina si no para un humano. Ya sea un compañero o un yo del futuro que necesita entender lo que se hizo en su día.

Un lenguaje de programación es un lenguage de comunicación entre humanos especializado en formalizar determinado tipo de problemas relacionados con el procesado de información.

Por otra parte, la composición tiene raíces profundas en las matemàticas, especialmente en la teoría de categorias que formaliza la idea de que la composición es una operación fundamental en casi todas las ramas de las matemáticas.


##### 4.4. Side Efffects

##### 4.4.1 Segregación de código puro. Aplicación en arquitectura hexagonal


El concepto de función pura se puede aplicar sin mas. A pesar de que existen sistemas de efectos que permiten manejar los side effects como computaciones puras, se pueden aplicar conceptos de programación funcional en cualquier code base.

Una forma de empezar es el de tener mi lógica de negocio en funciones puras aprovechando las ventajas de testeo que esto implica.
En arquitectura hexagonal, por ejemplo, esto implicaria tener un dominio puro y la ejecución de side effects a los puertos y adaptadores.

Ejemplo:

Función que recibe un json complejo y tiene que parsearlo y calcular las operaciones a base de datos a realizar. Pero que en lugar de ejecutarlas, devuelve una descripción de ellas, como una lista operaciones. Así puedo separar por una parte el cálculo de qué se debe hacer (descripción de la computación) del hecho de hacerlo (side effect).

Se puede pensar que la computación pura es la descripción de la computación y la parte que recibe la lista de operaciones a base de datos y las ejecuta es nuestro runtime.

Ventajas: 
    - Separation of concerns. No tengo que manejar la conexión de base de datos y la transacción donde no es necesario
    - Testeabilidad: La lógica se puede testear sin base de datos
    - Esta separación permitiría, por ejemplo, añadir un optimizador entre las dos fases con el fin de optimizar las operaciones de base de dados,            eliminando dupllicados, juntando operaciones relacionadas, etc...

En general, se puede aplicar el concepto de función pura y composabilidad como buena práctica y cuando sea más factible, de forma gradual y sin que sea un imperativo absoluto.


##### 4.4.2 Concepto de sistema de efectos

El objetivo de un sistema de efectos es manejar los side effects de una forma 100% functional. Se trata pues de describir y controlar la ejecución de los side effects.

Para la descripción de los efectos podemos empezar clasificándolos en las siguientes categorías:

- I/O: Leer o escribir de un fichero, base de datos, red...
- State Effects: Mutar un estado
- Concurrency Effects: Ejecución código en paralelo, gestión de threads,....
- Error Effects: Manejo de errores y excepciones, reintentos, etc...

Cada typo de efecto tiene su propio typo que hace de contenedor del código que ejecuta el side effect. Sin embargo, cuando se construye el effect no se ejecuta el side effect si no que la ejecución queda diferida.
Una vez más, describimos una computación como un dato tipado en lugar de ejecutarla. 

Ejemplo de signatura:

```scala
def leeNombreDeBaseDeDatos(): IO[String] = ???
```

En lugar de conectarse a la base de datos, leer el valor y devolverlo como resultado, esta función devuelve un tipo IO en cuyo valor contiene el código a ejecutar para la objención del valor.
De esta forma, he convertido la función en una función pura.

```scala
case class ToyIO[A](value: () => A){
    def run(): A = value()
  }
```

Un sistema de efectos permite al programador combinar efectos como por ejemplo: 

si tengo  f: A => IO[B] y g: B => IO[C], puedo construir h: A => IO[C]

Entonces puedo combinar mis efectos sin ejecutarlos!! Así, mi programa devuelve como resultado una estructura de datos enorme que describe
la ajecución compuesta y condicionada de efectos. Una vex obtengo este objeto final, solo tengo que llamar al metoto 'run' y el runtime del sistema de efectos
va a recorrer la estructura de datos y va a ir ejecutando cada trozo de código con efectos que lo compone.
Una vez mas, he separado mi programa en dos partes, una que contiene mi lógica de negocio, que es totalmente pura y que da como resultado una descripción de
los side effects a ejecutar. Y luego un runtime que ejecuta de forma ordenada todos los side effects.




##### 4.5. Immutabilidad

##### 4.5.1 Beneficios

Thread safety: Si no tengo un estado compartido y modificable de forma concurrente me ahorro un buen conjunto de problemas.
- Race conditions
- Dead locks
- ...

El hecho de guardar versiones de una estructura de datos a lo largo del tiempo, facilita la implementación de funionalidades como:
- undo/redo
- history tracking
- time traveling debugging

 

##### 4.5.2 Path Copying y Structural Sharing

Convertimos nuestros datos mutables en inmutables y le añadimos un "sistema de control de versiones".

![image](https://github.com/user-attachments/assets/0a14253f-e771-4fad-ad58-e15eca615351)


##### 4.6. Álgebra

La programación funcional invita a separar los datos de las funciones puras que operan con ellos. Por contra, OOP empuja mas a tener una objeto que empaqueta datos y funciones.

Al definir unos tipos de datos y unas funciones puras que operan con ellos emerge el concepto de álgebra si le añadimos unas leyes.

Ejemplos:
 - El tipo de datos Int, una operació asociativa + , un elemento neutro para la operació asociativa 0.
   Ley associativa: (a + b) + c = a + (b + c)
   Ley de identidad: a + 0 = 0 + a = a
   Ya tengo un álgebra definida que se llama Monoide
 - Monoide con imágenes.
   Tipo: Imagenes con fondo transparente
   Operación: Superposición (pintar encima como las capas de un mapa)
   Elemento neutro: Imagen transparente

 Qué interés tiene un Monoide? Los monoides van perfecto para paralelizar: Particiono mis datos en grupos de imagenes, los distribuyo entre los workers 
 (threads, nodos en un cluster, ...), compongo los resultados parciales con la operación asociativa. La computación tardará tanto como tarde el grupo 
 mas lento aprox. 
    
 - Repositorio Clave-Valor
   Tipo de datos: clase Cliente
   Operaciones: get y put
   Ley: si hago un put y después un get, el get tiene que darme el mismo elemento que he puesto en el put.

   Puedo definir el repositorio como una interfaz y testear que sus implementaciones cumplen las leyes.
   Este caso es simple y obvio pero con interfaces más complejas tiene todo el sentido asegurar que las implementaciones cumplen con el contrato 
   especificado en el interfaz (+ leyes).
   Normalmente no se especifican leyes pero existen de forma implícita y confiamos que quien realice una implementación de la interfaz deduzca las 
   leyes a partir de los nombres de las funciones como put y get.

   Liskov Substitution Principle: Si B es subtipo de A, debo poder substituir los objetos tipo A por los tipo B sin alterar el funcionamiento del 
   programa. En el ejemplo: debo poder substituir IKeyValueRepo por RedisRepo sin alterar el funcionamiento del programa. Sin alterar el funcionamiento 
   del programa significa: cumpliendo las leyes del álgebra (sean explícitas o implícitas)

   El programador debe valorar según el caso si vale la pena hacer las leyes explícitas y comprobar su cumplimiento con test unitarios.

Para definir tipos complejos se utiliza la composición de tipos: Algebraic Data Types

- Product Types:
      case class Person(name: String, age: Int)
- Union Type:
      sealed trait Fruit
      case object Orange extends Fruit
      case object Apple  extends Fruit
    
##### 4.7. Características de un lenguaje funcional   
- Funciones como ciudadanos de primera: Las puedo tratar como valores
   - Asignarlas a un valor
   - Recibirlas en una función como parámetro
   - Devolverlas como resultadode una función
   - lambdas
   - ...
      
- Immutabilidad
- ADT's y pattern matching
- Usa recursividad sobre iteración
- Lazy evaluation: Permite definir estructuras de datos infinitas

Lenguajes:

- Programación funcional pura: Haskell, Elixir/Erlang, F#
- FP & OOP: Scala
- Functional first: Clojure
- OOP pero con elementos de FP
      - Java: HoF, Optional, 'final' fuerza immutabilidad, Records como product types, lambdas..
      - c#: readonly, Linq API funcional, pattern matching
      - python: HoF, lambdas, 'frozenset' para immutabilidad, pattern matching 

## **Parte 2**: Lenguaje Scala


```scala
trait LivingCreature

case class Person(name: String, age: Int)
val persion = Person
```

    1. Porqué Scala
        
        1.1.1 Multiparadigma: OOP, FP, actores ...
        1.1.2 Killer Apps: Spark, Akka, PLay Framework....

    2. Manejo de side effects

        2.1 Option vs null
        2,2 Try vs Exceptions
        2.3 Either
        2.4 List

    3 Case Classes y Pattern matching

    4 Algebraic Data Types
        4.1 Product Types
        4.2 Union Types
        4.3 De OOP a Algebra: Datos + transaformaciones (funciones puras)
       

    5 High Order Functions

    6 Genéricos

    7 Colecciones
        7.1 Definición recursiva de tipos
        7.2 Operaciones con fluent API

    8 For comprehension (map, flatten, flatMap)

    9. Herencia vs Type Classes

    10 Recursividad

    11 Mónada
        11.1 Definición
        11.2 Ejemplos: Option, Try, List...
        11.3 Mónadas para efectos
        11.4 Ejercicio: Programación de una IO monad




11.4 Programación de una IO monad

```scala
     case class IO[A](f: () => A){

        def runUnsafe: A = f()
        def map[B](g: A => B): IO[B] = IO(() => g(runUnsafe))

        def flatMap[B](g: A => IO[B]): IO[B] = IO( () => g(runUnsafe).runUnsafe )
      }
      
      val l: IO[Unit] = IO(() => println("Name: "))
        .flatMap( _ =>
          IO( () => readLine() )
            .flatMap( name =>
              IO( () => println("Hello: " + name) )
            ).map( _ =>
              ()
            )
      )

      val program = for{
        _ <- IO( () => println("Name: ") )
        name <- IO( () => readLine())
        _ <- IO( () => println("Hello: " + name) )
      }yield ()

      println("")

      program.runUnsafe
```

Más ergonómico:

```scala
class IO[A](f: => A){
      def runUnsafe: A = f
      def map[B](g: A => B): IO[B] = new IO(g(runUnsafe))

      def flatMap[B](g: A => IO[B]): IO[B] = new IO( g(runUnsafe).runUnsafe )
    }

    object IO{
      def apply[A](f: => A) = new IO(f)
    }


    val program = for{
      _ <- IO( println("Name: ") )
      name <- IO( readLine() )
      _ <- IO( println("Hello: " + name) )
    }yield ()


    program.runUnsafe
```
