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

### 3. Paradigma Reactivo

    2.1. Introducción
    2.2. Reactive Programming
    3.3. Streams

### 4. Programación funcional

     4.2. Principios

         4.2.1 Función matemàtica y sus propiedades
         4.2.2 Ejemplos de side effect
         4.2.3 Expresiones vs statemen
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

## **Parte 2**: Lenguaje Scala



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
        4.4 Monoide como ejemplo de álgebra
            4.4.1 Definición y propiedades
            4.4.2 Ejemplo con números enteros
            4.4.3 Ejemplo con imágenes

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

Entre 1960 y 1070 fueron creados los primeros lenguajes orientados a objetos. Sin embargo, Alan Kay, al que se le otorga el acuñamiento del término, lo definia de una forma que se asemeja más al modelo de actores a cómo se definie la OOP hoy en día.
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

#### 2.1- Qué es un actor

Carl Hewitt 1973 definió el modelo de actores.

El modelo de actores proporciona una abstracción única para concurrencia y escalabilidad.


***Actor***: El actor es la unidad básica de computación en el modelo de actores. 
  - Puede recibir mensajes que procesa secuencialmente según el orden de llegada. Los guarda en una cola
  - Contiene estado que puede ser modificado en base a los mmensajes recibidos.
  - Puede mandar mensajes a otros actores
  - Puede crear otros actores generando un árbol jerárquico y manejando su ciclo de vida. Si un actor peta, su supervisor es notificado y puede decidir qué acciones aplicar.
  
El modelo de concurrencia utilizado consiste en un único thread (o pool de threads) que mediante un scheduler va ejecutando cada actor.
Por ejecutar un actor se entiende comprovar si tiene mensajes en la cola y llamar a la lógica de proceso associada. Así pues, un solo thread es compartido por varios actores con lo que un actor no debe contener código bloqueante ya que bloquearía la ejecución de otros actores.

Location transparency: Un actor tiene una dirección tipo el path de un fichero que lo localiza en el árbol jerárquico y permite localizarlo para mandar-le mensajes. En el caso de un sistema distribuido formado con varios nodos en el que se ejecuta un sistema de actores, la localización de un actor en concreto en el cluster es transparente. Es decir, en el momento de mmandar un mensaje a un actor se utiliza la misma API tanto si el actor esta en la misma máquina o está en remoto.

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
    
Ejemplos: Banca, IoT



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
- Elasticidad que proporciona la configuración en cluster de akka
- Resiliencia: 
    - A nivel de actor: Jerarquía de actores con supervisor. Cuando hay una excepción en un Actor y este peta, su actor supervisor en la jerarquía determina qué haver. Normalmente poner en marxa otra instancia. Lo importante es que el fallo no se propaga. Let it crash.
    - A nivel de nodo del cluster: Actor Rebalancing en sistemas de actores con Actor   Sharding (Kubernetes como pareja de baile)

Vemos que la resiliencia va más allá de la toleráncia a fallos. No se trata de que ante fallos el sistema continue funcionando de forma degradada sino que el sistema se recupere.



**Implementaciones:** Akka/Pekko en Scala y Akka.Net en c# son implementaciones, Groovy GPars, Elixir/Erlang de un ReactiveSystem basado en el Modelo de Actores.
    Elixir/Erlang es monoparadigma, solo puedo hacer programas siguiendo el modelo de actores (procesos maquina virtual BEAM).
    Scala/C# son multiparadigma.
    Erlang es un lenguaje que se compila a bytecodes a ejecutar en la máquina virtual BEAM que es una implementacón del modelo ed actores.
    Una de las principales diferencias con Akka es que BEAM está optimizado para sistemas con baja laténcia. Shcheduler preemptivo limita la duración de ejecución de los procesos/actores en los threads de sistema operativo.
    Nació en Ericson para equipos de telecomunicaciones y ahora lo usan Whatsapp, Discord, RabbitMQ, etc...

                    
#### 3.3- Akka Streams


Un buen ejemplo de Reactive Programing es Akka Streams. 
Evento vs mensaje

### 4. Programación funcional
      
##### 4.1. Origen de la programación funcional

Lisp, el primer lenguage de programación funcional fué desarrollado en 1960 en el MIT.
Los primeros lenguajes de progamación funcional estuvieron inspirados en el Lambda Calculus (Alonzo Church 1930).
Lambda Calculus es un sistema formal matemático que permiten describir una compitación en base a la abstraccióne de funciones y su aplicación.
En otras palabras, el lambda calculus describe una computación como la aplicación de una función a sus argumentos. Las funciones son 'first-class citizen'. Pueden ser pasadas como argumentos y ser devueltas como valores.   


##### 4.2. Principios

##### 4.2.1 Función matemàtica y sus propiedades




##### 4.2.2 Ejemplos de side effect
##### 4.2.3 Expresiones vs statements
##### 4.2.4 Composabilidad

##### 4.3. Beneficios de la programación funcional

##### 4.3.1 Testing: Funciones deterministas sin contexto
##### 4.3.2 Local reasoning (7 items en mente)
    "The Magical Number Seven, Plus or Minus Two" by psychologist George A. Miller (1956). Miller suggested that the average human can hold about 7 ± 2 items in their short-term memory (STM) at one time.


##### 4.3.3 Composición, la escéncia de la computación


##### 4.4. Side Efffects

##### 4.4.1 Segregación de código puro. Aplicación en arquitectura hexagonal
##### 4.4.2 Concepto de sistema de efectos

##### 4.5. Immutabilidad

##### 4.5.1 Beneficios
##### 4.5.2 Path Copying y Structural Sharing


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
        4.4 Monoide como ejemplo de álgebra
            4.4.1 Definición y propiedades
            4.4.2 Ejemplo con números enteros
            4.4.3 Ejemplo con imágenes

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


