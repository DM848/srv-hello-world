include "srv-interface.iol"
include "service-mesh.iol"
include "time.iol"
include "console.iol"
include "runtime.iol"

// single is the default execution modality (so the execution construct can be omitted),
// which runs the program behaviour once. sequential, instead, causes the program behaviour
// to be made available again after the current instance has terminated. This is useful,
// for instance, for modelling services that need to guarantee exclusive access to a resource.
// Finally, concurrent causes a program behaviour to be instantiated and executed whenever its
// first input statement can receive a message.
//
// execution { single | concurrent | sequential }
execution { sequential }

// The input port specifies how your service can be reached. However, since we use
// Docker containers, the port here should not be set as it is exposed in the Dockerfile.
inputPort HelloWorldInput {
  Location: "socket://localhost:8888/"
  Protocol: http
  Interfaces: 
    HelloWorldInterface, 
    ServiceMeshInterface
}

// The init{} scope allows the specification of initialisation procedures (before the web server
// goes public). All the code specified within the init{} scope is executed only once, when
// the service is started.
init
{
    println@Console( "initialising hello-world")()
}

// incomming requests
main
{
    [ health() ( resp ) {
        resp = "Service alive and reachable"
    }]
    [ about()( resp ) {
        resp = "
            The service hello-world was created at 2018-12-20 23:33:45.593103355 +0000 UTC m=+100.593970075 by my name.
            The source code can be found at https://github.com/dm848/srv-hello-world
            While other services in the cluster (in the same namespace) can access it using the DNS name hello-world.
            Remember to specify the cluster namespace, if you are in a different namespace: hello-world.default

            Service Description
            
        "
    }]
}
