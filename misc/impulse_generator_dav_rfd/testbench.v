#! /usr/bin/vvp
:ivl_version "12.0 (stable)" "(v12_0-dirty)";
:ivl_delay_selection "TYPICAL";
:vpi_time_precision + 0;
:vpi_module "/usr/lib/ivl/system.vpi";
:vpi_module "/usr/lib/ivl/vhdl_sys.vpi";
:vpi_module "/usr/lib/ivl/vhdl_textio.vpi";
:vpi_module "/usr/lib/ivl/v2005_math.vpi";
:vpi_module "/usr/lib/ivl/va_math.vpi";
S_0x561637f95980 .scope module, "impulse_generator" "impulse_generator" 2 3;
 .timescale 0 0;
    .port_info 0 /INPUT 1 "reset_";
    .port_info 1 /INPUT 1 "clock";
    .port_info 2 /INPUT 8 "numero";
    .port_info 3 /OUTPUT 1 "out";
    .port_info 4 /INPUT 1 "dav_";
    .port_info 5 /OUTPUT 1 "rfd";
v0x561637fba8f0_0 .net "b1_b0", 1 0, L_0x561637fcbda0;  1 drivers
v0x561637fba9d0_0 .net "c1_c0", 1 0, L_0x561637fcb4c0;  1 drivers
o0x71bb542a72e8 .functor BUFZ 1, C4<z>; HiZ drive
v0x561637fbaae0_0 .net "clock", 0 0, o0x71bb542a72e8;  0 drivers
o0x71bb542a76d8 .functor BUFZ 1, C4<z>; HiZ drive
v0x561637fbabd0_0 .net "dav_", 0 0, o0x71bb542a76d8;  0 drivers
o0x71bb542a7708 .functor BUFZ 8, C4<zzzzzzzz>; HiZ drive
v0x561637fbac70_0 .net "numero", 7 0, o0x71bb542a7708;  0 drivers
v0x561637fbad60_0 .net "out", 0 0, L_0x561637fbb0b0;  1 drivers
o0x71bb542a7318 .functor BUFZ 1, C4<z>; HiZ drive
v0x561637fbae00_0 .net "reset_", 0 0, o0x71bb542a7318;  0 drivers
v0x561637fbaef0_0 .net "rfd", 0 0, L_0x561637fbafd0;  1 drivers
S_0x561637f95b10 .scope module, "cu" "control_unit" 2 15, 2 58 0, S_0x561637f95980;
 .timescale 0 0;
    .port_info 0 /INPUT 1 "reset_";
    .port_info 1 /INPUT 1 "clock";
    .port_info 2 /OUTPUT 2 "b1_b0";
    .port_info 3 /INPUT 2 "c1_c0";
P_0x561637f95ca0 .param/l "s0" 1 2 65, C4<00000000000000000000000000000000>;
P_0x561637f95ce0 .param/l "s1" 1 2 66, C4<00000000000000000000000000000001>;
P_0x561637f95d20 .param/l "s2" 1 2 67, C4<00000000000000000000000000000010>;
v0x561637f5b470_0 .var "STAR", 1 0;
v0x561637fb8490_0 .net *"_ivl_13", 31 0, L_0x561637fcbe90;  1 drivers
L_0x71bb53dc6258 .functor BUFT 1, C4<000000000000000000000000000000>, C4<0>, C4<0>, C4<0>;
v0x561637fb8570_0 .net *"_ivl_16", 29 0, L_0x71bb53dc6258;  1 drivers
L_0x71bb53dc62a0 .functor BUFT 1, C4<00000000000000000000000000000000>, C4<0>, C4<0>, C4<0>;
v0x561637fb8630_0 .net/2u *"_ivl_17", 31 0, L_0x71bb53dc62a0;  1 drivers
v0x561637fb8710_0 .net *"_ivl_19", 0 0, L_0x561637fcc000;  1 drivers
v0x561637fb8820_0 .net *"_ivl_2", 31 0, L_0x561637fcbb70;  1 drivers
v0x561637fb8900_0 .net *"_ivl_22", 31 0, L_0x561637fcc140;  1 drivers
L_0x71bb53dc62e8 .functor BUFT 1, C4<0000000000000000000000000000000>, C4<0>, C4<0>, C4<0>;
v0x561637fb89e0_0 .net *"_ivl_25", 30 0, L_0x71bb53dc62e8;  1 drivers
L_0x71bb53dc6330 .functor BUFT 1, C4<00000000000000000000000000000000>, C4<0>, C4<0>, C4<0>;
v0x561637fb8ac0_0 .net/2u *"_ivl_26", 31 0, L_0x71bb53dc6330;  1 drivers
v0x561637fb8ba0_0 .net *"_ivl_28", 0 0, L_0x561637fcc220;  1 drivers
L_0x71bb53dc61c8 .functor BUFT 1, C4<000000000000000000000000000000>, C4<0>, C4<0>, C4<0>;
v0x561637fb8c60_0 .net *"_ivl_5", 29 0, L_0x71bb53dc61c8;  1 drivers
L_0x71bb53dc6210 .functor BUFT 1, C4<00000000000000000000000000000001>, C4<0>, C4<0>, C4<0>;
v0x561637fb8d40_0 .net/2u *"_ivl_6", 31 0, L_0x71bb53dc6210;  1 drivers
v0x561637fb8e20_0 .net *"_ivl_8", 0 0, L_0x561637fcbc60;  1 drivers
v0x561637fb8ee0_0 .net "b1_b0", 1 0, L_0x561637fcbda0;  alias, 1 drivers
v0x561637fb8fc0_0 .net "c1_c0", 1 0, L_0x561637fcb4c0;  alias, 1 drivers
v0x561637fb90a0_0 .net "clock", 0 0, o0x71bb542a72e8;  alias, 0 drivers
v0x561637fb9160_0 .net "reset_", 0 0, o0x71bb542a7318;  alias, 0 drivers
E_0x561637f9b3d0 .event posedge, v0x561637fb90a0_0;
E_0x561637f9b270 .event anyedge, L_0x561637fcc220;
L_0x561637fcbb70 .concat [ 2 30 0 0], v0x561637f5b470_0, L_0x71bb53dc61c8;
L_0x561637fcbc60 .cmp/eq 32, L_0x561637fcbb70, L_0x71bb53dc6210;
L_0x561637fcbda0 .concat8 [ 1 1 0 0], L_0x561637fcc000, L_0x561637fcbc60;
L_0x561637fcbe90 .concat [ 2 30 0 0], v0x561637f5b470_0, L_0x71bb53dc6258;
L_0x561637fcc000 .cmp/eq 32, L_0x561637fcbe90, L_0x71bb53dc62a0;
L_0x561637fcc140 .concat [ 1 31 0 0], o0x71bb542a7318, L_0x71bb53dc62e8;
L_0x561637fcc220 .cmp/eq 32, L_0x561637fcc140, L_0x71bb53dc6330;
S_0x561637fb92a0 .scope module, "dp" "data_path" 2 14, 2 18 0, S_0x561637f95980;
 .timescale 0 0;
    .port_info 0 /INPUT 1 "reset_";
    .port_info 1 /INPUT 1 "clock";
    .port_info 2 /INPUT 8 "numero";
    .port_info 3 /OUTPUT 1 "out";
    .port_info 4 /INPUT 1 "dav_";
    .port_info 5 /OUTPUT 1 "rfd";
    .port_info 6 /INPUT 2 "b1_b0";
    .port_info 7 /OUTPUT 2 "c1_c0";
L_0x561637fbafd0 .functor BUFZ 1, v0x561637fb9750_0, C4<0>, C4<0>, C4<0>;
L_0x561637fbb0b0 .functor BUFZ 1, v0x561637fb9690_0, C4<0>, C4<0>, C4<0>;
v0x561637fb9590_0 .var "COUNT", 7 0;
v0x561637fb9690_0 .var "OUT", 0 0;
v0x561637fb9750_0 .var "RFD", 0 0;
L_0x71bb53dc6060 .functor BUFT 1, C4<00000000000000000000000000000001>, C4<0>, C4<0>, C4<0>;
v0x561637fb97f0_0 .net/2u *"_ivl_10", 31 0, L_0x71bb53dc6060;  1 drivers
v0x561637fb98d0_0 .net *"_ivl_12", 0 0, L_0x561637fcb350;  1 drivers
v0x561637fb99e0_0 .net *"_ivl_17", 31 0, L_0x561637fcb5b0;  1 drivers
L_0x71bb53dc60a8 .functor BUFT 1, C4<0000000000000000000000000000000>, C4<0>, C4<0>, C4<0>;
v0x561637fb9ac0_0 .net *"_ivl_20", 30 0, L_0x71bb53dc60a8;  1 drivers
L_0x71bb53dc60f0 .functor BUFT 1, C4<00000000000000000000000000000001>, C4<0>, C4<0>, C4<0>;
v0x561637fb9ba0_0 .net/2u *"_ivl_21", 31 0, L_0x71bb53dc60f0;  1 drivers
v0x561637fb9c80_0 .net *"_ivl_23", 0 0, L_0x561637fcb720;  1 drivers
v0x561637fb9d40_0 .net *"_ivl_26", 31 0, L_0x561637fcb8b0;  1 drivers
L_0x71bb53dc6138 .functor BUFT 1, C4<0000000000000000000000000000000>, C4<0>, C4<0>, C4<0>;
v0x561637fb9e20_0 .net *"_ivl_29", 30 0, L_0x71bb53dc6138;  1 drivers
L_0x71bb53dc6180 .functor BUFT 1, C4<00000000000000000000000000000000>, C4<0>, C4<0>, C4<0>;
v0x561637fb9f00_0 .net/2u *"_ivl_30", 31 0, L_0x71bb53dc6180;  1 drivers
v0x561637fb9fe0_0 .net *"_ivl_32", 0 0, L_0x561637fcba30;  1 drivers
v0x561637fba0a0_0 .net *"_ivl_6", 31 0, L_0x561637fbb190;  1 drivers
L_0x71bb53dc6018 .functor BUFT 1, C4<000000000000000000000000>, C4<0>, C4<0>, C4<0>;
v0x561637fba180_0 .net *"_ivl_9", 23 0, L_0x71bb53dc6018;  1 drivers
v0x561637fba260_0 .net "b1_b0", 1 0, L_0x561637fcbda0;  alias, 1 drivers
v0x561637fba320_0 .net "c1_c0", 1 0, L_0x561637fcb4c0;  alias, 1 drivers
v0x561637fba3c0_0 .net "clock", 0 0, o0x71bb542a72e8;  alias, 0 drivers
v0x561637fba460_0 .net "dav_", 0 0, o0x71bb542a76d8;  alias, 0 drivers
v0x561637fba500_0 .net "numero", 7 0, o0x71bb542a7708;  alias, 0 drivers
v0x561637fba5c0_0 .net "out", 0 0, L_0x561637fbb0b0;  alias, 1 drivers
v0x561637fba680_0 .net "reset_", 0 0, o0x71bb542a7318;  alias, 0 drivers
v0x561637fba750_0 .net "rfd", 0 0, L_0x561637fbafd0;  alias, 1 drivers
E_0x561637f7f250 .event anyedge, L_0x561637fcba30;
L_0x561637fbb190 .concat [ 8 24 0 0], v0x561637fb9590_0, L_0x71bb53dc6018;
L_0x561637fcb350 .cmp/eq 32, L_0x561637fbb190, L_0x71bb53dc6060;
L_0x561637fcb4c0 .concat8 [ 1 1 0 0], L_0x561637fcb720, L_0x561637fcb350;
L_0x561637fcb5b0 .concat [ 1 31 0 0], o0x71bb542a76d8, L_0x71bb53dc60a8;
L_0x561637fcb720 .cmp/eq 32, L_0x561637fcb5b0, L_0x71bb53dc60f0;
L_0x561637fcb8b0 .concat [ 1 31 0 0], o0x71bb542a7318, L_0x71bb53dc6138;
L_0x561637fcba30 .cmp/eq 32, L_0x561637fcb8b0, L_0x71bb53dc6180;
    .scope S_0x561637fb92a0;
T_0 ;
    %wait E_0x561637f7f250;
    %delay 1, 0;
    %pushi/vec4 1, 0, 1;
    %assign/vec4 v0x561637fb9750_0, 0;
    %pushi/vec4 0, 0, 1;
    %assign/vec4 v0x561637fb9690_0, 0;
    %jmp T_0;
    .thread T_0, $push;
    .scope S_0x561637fb92a0;
T_1 ;
    %wait E_0x561637f9b3d0;
    %load/vec4 v0x561637fba680_0;
    %pad/u 32;
    %cmpi/e 1, 0, 32;
    %jmp/0xz  T_1.0, 4;
    %delay 3, 0;
    %load/vec4 v0x561637fba260_0;
    %parti/s 1, 0, 2;
    %assign/vec4 v0x561637fb9750_0, 0;
    %load/vec4 v0x561637fba260_0;
    %parti/s 1, 1, 2;
    %dup/vec4;
    %pushi/vec4 0, 0, 1;
    %cmp/u;
    %jmp/1 T_1.2, 6;
    %dup/vec4;
    %pushi/vec4 1, 0, 1;
    %cmp/u;
    %jmp/1 T_1.3, 6;
    %jmp T_1.4;
T_1.2 ;
    %load/vec4 v0x561637fba500_0;
    %assign/vec4 v0x561637fb9590_0, 0;
    %jmp T_1.4;
T_1.3 ;
    %load/vec4 v0x561637fb9590_0;
    %subi 1, 0, 8;
    %assign/vec4 v0x561637fb9590_0, 0;
    %jmp T_1.4;
T_1.4 ;
    %pop/vec4 1;
    %load/vec4 v0x561637fba260_0;
    %parti/s 1, 1, 2;
    %assign/vec4 v0x561637fb9690_0, 0;
T_1.0 ;
    %jmp T_1;
    .thread T_1;
    .scope S_0x561637f95b10;
T_2 ;
    %wait E_0x561637f9b270;
    %delay 1, 0;
    %pushi/vec4 0, 0, 2;
    %assign/vec4 v0x561637f5b470_0, 0;
    %jmp T_2;
    .thread T_2, $push;
    .scope S_0x561637f95b10;
T_3 ;
    %wait E_0x561637f9b3d0;
    %load/vec4 v0x561637fb9160_0;
    %pad/u 32;
    %cmpi/e 1, 0, 32;
    %jmp/0xz  T_3.0, 4;
    %delay 3, 0;
    %load/vec4 v0x561637f5b470_0;
    %dup/vec4;
    %pushi/vec4 0, 0, 2;
    %cmp/u;
    %jmp/1 T_3.2, 6;
    %dup/vec4;
    %pushi/vec4 1, 0, 2;
    %cmp/u;
    %jmp/1 T_3.3, 6;
    %dup/vec4;
    %pushi/vec4 2, 0, 2;
    %cmp/u;
    %jmp/1 T_3.4, 6;
    %jmp T_3.5;
T_3.2 ;
    %load/vec4 v0x561637fb8fc0_0;
    %parti/s 1, 0, 2;
    %flag_set/vec4 8;
    %jmp/0 T_3.6, 8;
    %pushi/vec4 0, 0, 32;
    %jmp/1 T_3.7, 8;
T_3.6 ; End of true expr.
    %pushi/vec4 1, 0, 32;
    %jmp/0 T_3.7, 8;
 ; End of false expr.
    %blend;
T_3.7;
    %pad/u 2;
    %assign/vec4 v0x561637f5b470_0, 0;
    %jmp T_3.5;
T_3.3 ;
    %load/vec4 v0x561637fb8fc0_0;
    %parti/s 1, 1, 2;
    %flag_set/vec4 8;
    %jmp/0 T_3.8, 8;
    %pushi/vec4 2, 0, 32;
    %jmp/1 T_3.9, 8;
T_3.8 ; End of true expr.
    %pushi/vec4 1, 0, 32;
    %jmp/0 T_3.9, 8;
 ; End of false expr.
    %blend;
T_3.9;
    %pad/u 2;
    %assign/vec4 v0x561637f5b470_0, 0;
    %jmp T_3.5;
T_3.4 ;
    %load/vec4 v0x561637fb8fc0_0;
    %parti/s 1, 0, 2;
    %flag_set/vec4 8;
    %jmp/0 T_3.10, 8;
    %pushi/vec4 0, 0, 32;
    %jmp/1 T_3.11, 8;
T_3.10 ; End of true expr.
    %pushi/vec4 2, 0, 32;
    %jmp/0 T_3.11, 8;
 ; End of false expr.
    %blend;
T_3.11;
    %pad/u 2;
    %assign/vec4 v0x561637f5b470_0, 0;
    %jmp T_3.5;
T_3.5 ;
    %pop/vec4 1;
T_3.0 ;
    %jmp T_3;
    .thread T_3;
# The file index is used to find the file name in the following table.
:file_names 3;
    "N/A";
    "<interactive>";
    "dp_cu_synthesis.v";
