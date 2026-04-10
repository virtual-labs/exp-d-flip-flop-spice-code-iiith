* D_Flip-Flop *
.include PTM_45nm.txt

.PARAM supply= 1.2
.PARAM Lmin=45nm
.PARAM Wmin=45nm
.PARAM Wp={2*Wmin}

vvdd vdd 0 supply
.global vdd gnd

.subckt inverter in out 
MP1 out in vdd vdd pmos w={Wp} L={Lmin}
Mn1 out in 0 0 NMOS W={Wmin} L={Lmin}
.ends inverter

.subckt pass_transistor control in out
Xinv control not inverter
MP1 out not in vdd pmos w={Wp} L={Lmin}
MN1 out control in 0 nmos W={Wmin} L={Lmin}
.ends

.subckt mux a b s out
Xinvs s s_ inverter

Xpt1 s_ a out pass_transistor
Xpt2 s b out pass_transistor
.ends

.subckt d_latch in clk out
Xinv1 out neg inverter
Xmux neg in clk temp mux
Xinv2 temp out inverter
.ends

.subckt d_flipflop in clk out
Xinv1 clk neg inverter
Xdl1 in clk out1 d_latch
Xdl2 out1 neg out d_latch
.ends

Xn a clk out d_flipflop

*USE '*' for commenting

.PARAM trfin=10p
.PARAM t1 = 10n
.PARAM t2 = 20n
.PARAM t3 = 30n
.PARAM t4 = 40n
.PARAM t5 = 50n
.PARAM t6 = 60n
.PARAM t7 = 70n
.PARAM half = 5n
.PARAM quarter = 2.5n
.tran 6p 70n

V1 a 0 PWL (0 0 'half' 0 'half+trfin' 'supply' 't1' 'supply' 't1+half' 'supply' 't1+half+trfin' 0 't2' 0 't2+half' 0 't2+half+trfin' 'supply' 't3' 'supply' 't3+half' 'supply' 't3+half+trfin' 0 't4' 0 't5' 0 't5+quarter' 0 't5+quarter+trfin' 'supply' 't5+(3*quarter)' 'supply' 't5+(3*quarter)+trfin' 0 't6' 0 't7' 0 )
V2 clk 0 PWL (0 0 't1' 0 't1+trfin' 'supply' 't2' 'supply' 't2+trfin' 0 't3' 0 't3+trfin' 'supply' 't4' 'supply' 't4+trfin' 0 't5' 0 't5+trfin' 'supply' 't6' 'supply' 't6+trfin' 0 't7' 0)


.control
run
*sets background color of plot, comment below line for black background
*plots input
plot v(a) v(clk)
*plots output
plot v(out) 

.endc
.end
    