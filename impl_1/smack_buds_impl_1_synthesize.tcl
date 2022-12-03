if {[catch {

# define run engine funtion
source [file join {C:/lscc/radiant/3.2} scripts tcl flow run_engine.tcl]
# define global variables
global para
set para(gui_mode) 1
set para(prj_dir) "C:/Users/noahs/my_designs/smash_buds"
# synthesize IPs
# synthesize VMs
# propgate constraints
file delete -force -- smack_buds_impl_1_cpe.ldc
run_engine_newmsg cpe -f "smack_buds_impl_1.cprj" "my_pll.cprj" -a "iCE40UP"  -o smack_buds_impl_1_cpe.ldc
# synthesize top design
file delete -force -- smack_buds_impl_1.vm smack_buds_impl_1.ldc
run_engine_newmsg synthesis -f "smack_buds_impl_1_lattice.synproj"
run_postsyn [list -a iCE40UP -p iCE40UP5K -t SG48 -sp High-Performance_1.2V -oc Industrial -top -w -o smack_buds_impl_1_syn.udb smack_buds_impl_1.vm] "C:/Users/noahs/my_designs/smash_buds/impl_1/smack_buds_impl_1.ldc"

} out]} {
   runtime_log $out
   exit 1
}
