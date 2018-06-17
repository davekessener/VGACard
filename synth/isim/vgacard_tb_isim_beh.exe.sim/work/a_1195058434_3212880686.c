/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x7708f090 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "C:/Users/dave/fpga/VGACard/src/charset_mod.vhd";
extern char *IEEE_P_2592010699;
extern char *IEEE_P_1242562249;

int ieee_p_1242562249_sub_1657552908_1035706684(char *, char *, char *);
char *ieee_p_2592010699_sub_1837678034_503743352(char *, char *, char *, char *);
unsigned char ieee_p_2592010699_sub_2507238156_503743352(char *, unsigned char , unsigned char );


static void work_a_1195058434_3212880686_p_0(char *t0)
{
    char t3[16];
    char t6[16];
    char *t1;
    char *t2;
    char *t4;
    char *t5;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    int t11;
    int t12;
    unsigned int t13;
    unsigned int t14;
    char *t15;
    char *t16;
    int t17;
    int t18;
    unsigned int t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t22;
    char *t23;
    unsigned char t24;
    char *t25;
    char *t26;
    unsigned char t27;
    unsigned char t28;
    char *t29;
    char *t30;
    char *t31;
    char *t32;
    char *t33;

LAB0:    xsi_set_current_line(1182, ng0);

LAB3:    t1 = (t0 + 1968U);
    t2 = *((char **)t1);
    t1 = (t0 + 1512U);
    t4 = *((char **)t1);
    t1 = (t0 + 1352U);
    t5 = *((char **)t1);
    t7 = ((IEEE_P_2592010699) + 4024);
    t8 = (t0 + 5500U);
    t9 = (t0 + 5484U);
    t1 = xsi_base_array_concat(t1, t6, t7, (char)97, t4, t8, (char)97, t5, t9, (char)101);
    t10 = ieee_p_2592010699_sub_1837678034_503743352(IEEE_P_2592010699, t3, t1, t6);
    t11 = ieee_p_1242562249_sub_1657552908_1035706684(IEEE_P_1242562249, t10, t3);
    t12 = (t11 - 63);
    t13 = (t12 * -1);
    xsi_vhdl_check_range_of_index(63, 0, -1, t11);
    t14 = (1U * t13);
    t15 = (t0 + 1032U);
    t16 = *((char **)t15);
    t15 = (t0 + 5468U);
    t17 = ieee_p_1242562249_sub_1657552908_1035706684(IEEE_P_1242562249, t16, t15);
    t18 = (t17 - 0);
    t19 = (t18 * 1);
    xsi_vhdl_check_range_of_index(0, 127, 1, t17);
    t20 = (64U * t19);
    t21 = (0 + t20);
    t22 = (t21 + t14);
    t23 = (t2 + t22);
    t24 = *((unsigned char *)t23);
    t25 = (t0 + 1192U);
    t26 = *((char **)t25);
    t27 = *((unsigned char *)t26);
    t28 = ieee_p_2592010699_sub_2507238156_503743352(IEEE_P_2592010699, t24, t27);
    t25 = (t0 + 3352);
    t29 = (t25 + 56U);
    t30 = *((char **)t29);
    t31 = (t30 + 56U);
    t32 = *((char **)t31);
    *((unsigned char *)t32) = t28;
    xsi_driver_first_trans_fast_port(t25);

LAB2:    t33 = (t0 + 3272);
    *((int *)t33) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}


extern void work_a_1195058434_3212880686_init()
{
	static char *pe[] = {(void *)work_a_1195058434_3212880686_p_0};
	xsi_register_didat("work_a_1195058434_3212880686", "isim/vgacard_tb_isim_beh.exe.sim/work/a_1195058434_3212880686.didat");
	xsi_register_executes(pe);
}
