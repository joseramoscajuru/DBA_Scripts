
-- delete online of disks from ASM (after have dropped database in decomm)

SQL> alter diskgroup DATA drop disk DATA_0002, DATA_0003 rebalance power 10;

acompanhar o rebalance:

select group_number, operation, state, est_minutes 
from v$asm_operation;