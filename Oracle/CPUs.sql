lsdev -Cc processor will show the number of physical processors (or virtual processors in a shared processor LPAR.

   1. lsdev -Cc processor

proc0 Available 00-00 Processor
proc2 Available 00-02 Processor
SMT thread processors are seen with bindprocessor

   1. 	

The available processors are: 0 1 2 3

lparstat -i will show the virtual and logical processors.

   1. lparstat -i | grep CPU

Online Virtual CPUs : 2
Maximum Virtual CPUs : 15
Minimum Virtual CPUs : 1
Maximum Physical CPUs in system : 2
Active Physical CPUs in system : 2
Active CPUs in Pool : 2
Physical CPU Percentage : 25.00%

topas -L shows logical processors,
mpstat shows virtual

h1ibmdbecc01:oracle 8> mpstat

System configuration: lcpu=36 ent=4.2 mode=Uncapped 


   1. lsattr -El proc0

frequency 1498500000 Processor Speed False
smt_enabled true Processor SMT enabled False
smt_threads 2 Processor SMT threads False
state enable Processor state False
type PowerPC_POWER5 Processor type False

   1.   

Model Implementation: Multiple Processor, PCI bus
proc0 Processor
proc2 Processor

   1. prtconf | pg

System Model: IBM,9111-520
Machine Serial Number: 10EE6FE
Processor Type: PowerPC_POWER5
Number Of Processors: 2
Processor Clock Speed: 1499 MHz
CPU Type: 64-bit
Kernel Type: 64-bit