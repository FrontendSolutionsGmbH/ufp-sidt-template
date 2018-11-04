 # ufp-sidt-template
 
 this repository serves as the example repository and template for SIDT worldview microservice development


# Prerequisites

	- Docker >15 Requires Docker Multistage functionality
	- bash 
	
	
	
	         
# Quickstart

Build and test 
	
	./sidt-helm.sh -m -t 
	
keep alive after run 

	./sidt-helm.sh -t -b
	
after that, the debug entry point localhost:8080 redirects to all relevant informations
	
more info type, for individual stack start commands

	./sidt-helm.sh -i
	
	
	
	
WIP: Schema graps
 
@startuml
 
node "$SIDT_AREA=componenttest"
node "$SIDT_APP=Dockerfile"

           
package "/$SIDT_AREA=componenttest"as package1 {
 
  [docker-compose-infra.yml]  as infra1
  note top: sidt.sh -u infra -c 
  [docker-compose-debug.yml]  as debug1     
  note top: sidt.sh -u debug -c 
  [docker-compose-service.yml]   as service1   
  note top: sidt.sh -u service -c 
   
  
  [docker-compose-test.yml]  as test1
  note top: sidt.sh -u test -c 
        
}  
         
package "/$SIDT_AREA=integrationtest" as package2 {
 
  [docker-compose-infra.yml] as infra2  
  [docker-compose-debug.yml] as debug2
  [docker-compose-service.yml]    as service2
  [docker-compose-test.yml]      as test2
      
}      
 
package "Supplementary Service" { 
  [Dockerfile.$SIDT_APP2] -> [Dockerfile.$SIDT_APP] 
  note right: Dockerfile in same folder but alternate name, \nBuild using sidt.sh:\n\nexport SIDT_APP=Dockerfile.supplementary\nsidt.sh -u service -c\n # Reset App Name\nexport SIDT_APP=Dockerfile 
  }       
package "Service1 $SIDT_APP=" {
  [Service] as ServiceName
   note left: sidt.sh -u service -c \n Builds and starts service \n Environment SIDT_APP contains the Dockerfilename, \n default: Dockerfile
  [Dockerfile.$SIDT_APP] -->ServiceName :Builds the Service Binary
  ServiceName-->service1:Is Deployed to service stack
  ServiceName--->service2:Is Deployed to service stack    
   
                
       
@enduml

@startuml

    
     
node "-u Up" as up
node "-d Down" as down
node "-p Pull" as pull
node "-c Create" as create
node "-s State" as state
node "-l Logs" as logs
  component APP_NAME1  as app1
 component  APP_NAME2 as app2
 component APP_NAME3 as app3
 (AREA_NAME) as area
 (STACK_NAME \n Service Infra Debug Test All *) as stack
          
node "-m Make1" as make1
node "-m Make2" as make2
node "-m Make3" as make3
SIDT-->create
SIDT-->up

SIDT-->down
SIDT-->make1 
SIDT->make2
SIDT->make3

SIDT-->pull

 app1<.. app2


up-->stack
down-->stack
pull-->stack
create-->stack
state-->stack
logs-->stack

stack-->area 
               
make1-->app1 
make2->app2 
make3-->app3 


area-->componenttest
area-->integrationtests
area-->end2endtests


@enduml

@startuml

    
     
node "-u Up" as up
node "-d Down" as down
node "-p Pull" as pull
node "-c Create" as create
node "-s State" as state
node "-l Logs" as logs
  component APP_NAME1  as app1
 component  APP_NAME2 as app2
 component APP_NAME3 as app3
 (AREA_NAME) as area
 (STACK_NAME \n Service Infra Debug Test All *) as stack
          
          
 start->make         
 start->run         
 

@enduml
@startuml
|build|
 
 |area|
 |stack| 
 
|build|  
start
        
|build|
if (-m [name]) then  (MAKE)
  :${SID_APP:-[name];
  :Docker build -f Dockerfile[.[name]];
   
 |area| 
else (RUNTIME)
        
 |area|
if (-a AREA) then  
  :CHOOSE $SID_AREA; 
else (default: componenttest) 
endif
            
 |stack|
:CHOOSE $SID_STACK (service infra debug test all *); 
if ( -p PULL -l LOGS -s STATS ) then (yes)
  :CHOOSE $SID_STACK; 
else (default) 
 
if (-u UP  ) then (yes)
if(-c CREATE) then (recreate)

|build|  
:create stack;
       
  
else (reuse)
endif
        |stack|
        if (-b BACKGROUND) then (yes)  
          :DO THE RUN IN BACKGROUND;
        else (default) 
          :DO THE RUN;
        endif

else if(-d DOWN) 
:Teardown Stack;
endif   
endif  
  
  
endif

   
:exit program;  

stop
 

@enduml


@startuml 

           



database registry  


frame "Application" {
      [Unit Test]->[Dockerfile]
      [Dockerfile]->[Image]
      [Image]->registry
}
       
     

package "Integration Test" as area1 {
frame "Service" as serviceFrame1{
		
      [Service] as service1
      [Infra] as infra1
      service1.infra1
      }          
      [Debug] as debug1
            [Test] as test1
      debug1-->service1
      debug1-->infra1
      test1--service1
      test1--infra1
      registry--->service1
}
  

package "Component Test" as area2 {
frame "Service" as serviceFrame2{
		
      [Service] as service2
      [Infra] as infra2
      service2.infra2
      }          
      [Debug] as debug2
      [Test] as test2
      debug2-->service2
      debug2-->infra2
      test2--service2
      test2--infra2
      registry--->service2
}
      
     

@enduml
