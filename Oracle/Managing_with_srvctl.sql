
################################################################
# Adding/Removing/Managing the configuration of ASM instances
################################################################

--Use the following syntax to add configuration information about an existing ASM instance:
srvctl add asm -n node_name -i +asm_instance_name -o oracle_home

--Use the following syntax to remove an ASM instance:
srvctl remove asm -n node_name [-i +asm_instance_name]

--Use the following syntax to enable an ASM instance:
srvctl enable asm -n node_name [-i ] +asm_instance_name

--Use the following syntax to disable an ASM instance:
srvctl disable asm -n node_name [-i +asm_instance_name]

--Use the following syntax to start an ASM instance:
srvctl start asm -n node_name [-i +asm_instance_name] [-o start_options]

--Use the following syntax to stop an ASM instance:
srvctl stop asm -n node_name [-i +asm_instance_name] [-o stop_options]

--Use the following syntax to show the configuration of an ASM instance:
srvctl config asm -n node_name

--Use the following syntax to obtain the status of an ASM instance:
srvctl status asm -n node_name

--P.S.:
--For all of the SRVCTL commands in this section for which the
--option is not required, if you do not specify an instance name, then -i
--the command applies to all of the ASM instances on the node.