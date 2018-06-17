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
static const char *ng0 = "C:/Users/dave/fpga/VGACard/src/cursor_mod.vhd";
extern char *IEEE_P_1242562249;
extern char *IEEE_P_2592010699;

int ieee_p_1242562249_sub_1657552908_1035706684(char *, char *, char *);
char *ieee_p_1242562249_sub_180853171_1035706684(char *, char *, int , int );
unsigned char ieee_p_2592010699_sub_1744673427_503743352(char *, char *, unsigned int , unsigned int );


static void work_a_4292770613_3212880686_p_0(char *t0)
{
    char t1[16];
    char t5[16];
    char t10[16];
    char *t2;
    char *t3;
    int t4;
    char *t6;
    char *t7;
    int t8;
    char *t9;
    char *t11;
    char *t12;
    unsigned int t13;
    char *t14;
    unsigned int t15;
    unsigned int t16;
    unsigned char t17;
    char *t18;
    char *t19;
    char *t20;
    char *t21;
    char *t22;
    char *t23;

LAB0:    xsi_set_current_line(56, ng0);

LAB3:    t2 = (t0 + 4072U);
    t3 = *((char **)t2);
    t4 = *((int *)t3);
    t2 = ieee_p_1242562249_sub_180853171_1035706684(IEEE_P_1242562249, t1, t4, 8);
    t6 = (t0 + 3912U);
    t7 = *((char **)t6);
    t8 = *((int *)t7);
    t6 = ieee_p_1242562249_sub_180853171_1035706684(IEEE_P_1242562249, t5, t8, 8);
    t11 = ((IEEE_P_2592010699) + 4024);
    t9 = xsi_base_array_concat(t9, t10, t11, (char)97, t2, t1, (char)97, t6, t5, (char)101);
    t12 = (t1 + 12U);
    t13 = *((unsigned int *)t12);
    t13 = (t13 * 1U);
    t14 = (t5 + 12U);
    t15 = *((unsigned int *)t14);
    t15 = (t15 * 1U);
    t16 = (t13 + t15);
    t17 = (16U != t16);
    if (t17 == 1)
        goto LAB5;

LAB6:    t18 = (t0 + 7560);
    t19 = (t18 + 56U);
    t20 = *((char **)t19);
    t21 = (t20 + 56U);
    t22 = *((char **)t21);
    memcpy(t22, t9, 16U);
    xsi_driver_first_trans_fast_port(t18);

LAB2:    t23 = (t0 + 7448);
    *((int *)t23) = 1;

LAB1:    return;
LAB4:    goto LAB2;

LAB5:    xsi_size_not_matching(16U, t16, 0);
    goto LAB6;

}

static void work_a_4292770613_3212880686_p_1(char *t0)
{
    unsigned char t1;
    char *t2;
    char *t3;
    unsigned char t4;
    unsigned char t5;
    char *t6;
    int t7;
    char *t8;
    int t9;
    int t10;
    unsigned char t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;
    char *t20;
    char *t21;

LAB0:    xsi_set_current_line(57, ng0);
    t2 = (t0 + 3432U);
    t3 = *((char **)t2);
    t4 = *((unsigned char *)t3);
    t5 = (t4 == (unsigned char)3);
    if (t5 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB3;

LAB4:
LAB8:    t16 = (t0 + 7624);
    t17 = (t16 + 56U);
    t18 = *((char **)t17);
    t19 = (t18 + 56U);
    t20 = *((char **)t19);
    *((unsigned char *)t20) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t16);

LAB2:    t21 = (t0 + 7464);
    *((int *)t21) = 1;

LAB1:    return;
LAB3:    t2 = (t0 + 7624);
    t12 = (t2 + 56U);
    t13 = *((char **)t12);
    t14 = (t13 + 56U);
    t15 = *((char **)t14);
    *((unsigned char *)t15) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t2);
    goto LAB2;

LAB5:    t2 = (t0 + 4232U);
    t6 = *((char **)t2);
    t7 = *((int *)t6);
    t2 = (t0 + 5528U);
    t8 = *((char **)t2);
    t9 = *((int *)t8);
    t10 = (t9 / 2);
    t11 = (t7 >= t10);
    t1 = t11;
    goto LAB7;

LAB9:    goto LAB2;

}

static void work_a_4292770613_3212880686_p_2(char *t0)
{
    char *t1;
    unsigned char t2;
    char *t3;
    char *t4;
    unsigned char t5;
    unsigned char t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    int t11;
    int t12;
    int t13;
    char *t14;
    unsigned char t15;
    unsigned char t16;
    char *t17;
    char *t18;
    char *t19;
    int t20;
    char *t21;
    char *t22;
    int t23;
    unsigned char t24;
    char *t25;
    int t26;
    int t27;
    char *t28;
    char *t29;
    char *t30;
    char *t31;
    unsigned char t32;
    unsigned char t33;
    unsigned char t34;
    unsigned char t35;

LAB0:    xsi_set_current_line(62, ng0);
    t1 = (t0 + 992U);
    t2 = ieee_p_2592010699_sub_1744673427_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 7480);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(63, ng0);
    t3 = (t0 + 1192U);
    t4 = *((char **)t3);
    t5 = *((unsigned char *)t4);
    t6 = (t5 == (unsigned char)3);
    if (t6 != 0)
        goto LAB5;

LAB7:    xsi_set_current_line(73, ng0);
    t1 = (t0 + 7880);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t1);
    xsi_set_current_line(75, ng0);
    t1 = (t0 + 1672U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t5 = (t2 == (unsigned char)3);
    if (t5 != 0)
        goto LAB8;

LAB10:    t1 = (t0 + 1832U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t5 = (t2 == (unsigned char)3);
    if (t5 != 0)
        goto LAB14;

LAB15:    t1 = (t0 + 2472U);
    t3 = *((char **)t1);
    t5 = *((unsigned char *)t3);
    t6 = (t5 == (unsigned char)3);
    if (t6 == 1)
        goto LAB21;

LAB22:    t2 = (unsigned char)0;

LAB23:    if (t2 != 0)
        goto LAB19;

LAB20:    t1 = (t0 + 1992U);
    t3 = *((char **)t1);
    t5 = *((unsigned char *)t3);
    t6 = (t5 == (unsigned char)3);
    if (t6 == 1)
        goto LAB49;

LAB50:    t2 = (unsigned char)0;

LAB51:    if (t2 != 0)
        goto LAB47;

LAB48:    t1 = (t0 + 2152U);
    t3 = *((char **)t1);
    t5 = *((unsigned char *)t3);
    t6 = (t5 == (unsigned char)3);
    if (t6 == 1)
        goto LAB72;

LAB73:    t2 = (unsigned char)0;

LAB74:    if (t2 != 0)
        goto LAB70;

LAB71:    t1 = (t0 + 2312U);
    t3 = *((char **)t1);
    t5 = *((unsigned char *)t3);
    t6 = (t5 == (unsigned char)3);
    if (t6 == 1)
        goto LAB83;

LAB84:    t2 = (unsigned char)0;

LAB85:    if (t2 != 0)
        goto LAB81;

LAB82:
LAB9:    xsi_set_current_line(147, ng0);
    t1 = (t0 + 1992U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t1 = (t0 + 7944);
    t4 = (t1 + 56U);
    t7 = *((char **)t4);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    *((unsigned char *)t9) = t2;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(148, ng0);
    t1 = (t0 + 2472U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t1 = (t0 + 8136);
    t4 = (t1 + 56U);
    t7 = *((char **)t4);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    *((unsigned char *)t9) = t2;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(149, ng0);
    t1 = (t0 + 2312U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t1 = (t0 + 8008);
    t4 = (t1 + 56U);
    t7 = *((char **)t4);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    *((unsigned char *)t9) = t2;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(150, ng0);
    t1 = (t0 + 2152U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t1 = (t0 + 8072);
    t4 = (t1 + 56U);
    t7 = *((char **)t4);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    *((unsigned char *)t9) = t2;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(152, ng0);
    t1 = (t0 + 4232U);
    t3 = *((char **)t1);
    t11 = *((int *)t3);
    t1 = (t0 + 5528U);
    t4 = *((char **)t1);
    t12 = *((int *)t4);
    t13 = (t12 - 1);
    t2 = (t11 < t13);
    if (t2 != 0)
        goto LAB89;

LAB91:    xsi_set_current_line(155, ng0);
    t1 = (t0 + 7816);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((int *)t8) = 0;
    xsi_driver_first_trans_fast(t1);

LAB90:
LAB6:    goto LAB3;

LAB5:    xsi_set_current_line(64, ng0);
    t3 = (t0 + 7688);
    t7 = (t3 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    *((int *)t10) = 0;
    xsi_driver_first_trans_fast(t3);
    xsi_set_current_line(65, ng0);
    t1 = (t0 + 7752);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((int *)t8) = 0;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(66, ng0);
    t1 = (t0 + 7816);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((int *)t8) = 0;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(67, ng0);
    t1 = (t0 + 7880);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t1);
    xsi_set_current_line(68, ng0);
    t1 = (t0 + 7944);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)2;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(69, ng0);
    t1 = (t0 + 8008);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)2;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(70, ng0);
    t1 = (t0 + 8072);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)2;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(71, ng0);
    t1 = (t0 + 8136);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)2;
    xsi_driver_first_trans_fast(t1);
    goto LAB6;

LAB8:    xsi_set_current_line(76, ng0);
    t1 = (t0 + 1512U);
    t4 = *((char **)t1);
    t1 = (t0 + 11760U);
    t11 = ieee_p_1242562249_sub_1657552908_1035706684(IEEE_P_1242562249, t4, t1);
    t7 = (t0 + 5648U);
    t8 = *((char **)t7);
    t7 = (t8 + 0);
    *((int *)t7) = t11;
    xsi_set_current_line(77, ng0);
    t1 = (t0 + 5648U);
    t3 = *((char **)t1);
    t11 = *((int *)t3);
    t1 = (t0 + 5288U);
    t4 = *((char **)t1);
    t12 = *((int *)t4);
    t2 = (t11 < t12);
    if (t2 != 0)
        goto LAB11;

LAB13:    xsi_set_current_line(80, ng0);
    t1 = (t0 + 5288U);
    t3 = *((char **)t1);
    t11 = *((int *)t3);
    t12 = (t11 - 1);
    t1 = (t0 + 7688);
    t4 = (t1 + 56U);
    t7 = *((char **)t4);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    *((int *)t9) = t12;
    xsi_driver_first_trans_fast(t1);

LAB12:    goto LAB9;

LAB11:    xsi_set_current_line(78, ng0);
    t1 = (t0 + 5648U);
    t7 = *((char **)t1);
    t13 = *((int *)t7);
    t1 = (t0 + 7688);
    t8 = (t1 + 56U);
    t9 = *((char **)t8);
    t10 = (t9 + 56U);
    t14 = *((char **)t10);
    *((int *)t14) = t13;
    xsi_driver_first_trans_fast(t1);
    goto LAB12;

LAB14:    xsi_set_current_line(83, ng0);
    t1 = (t0 + 1512U);
    t4 = *((char **)t1);
    t1 = (t0 + 11760U);
    t11 = ieee_p_1242562249_sub_1657552908_1035706684(IEEE_P_1242562249, t4, t1);
    t7 = (t0 + 5648U);
    t8 = *((char **)t7);
    t7 = (t8 + 0);
    *((int *)t7) = t11;
    xsi_set_current_line(84, ng0);
    t1 = (t0 + 5648U);
    t3 = *((char **)t1);
    t11 = *((int *)t3);
    t1 = (t0 + 5168U);
    t4 = *((char **)t1);
    t12 = *((int *)t4);
    t2 = (t11 < t12);
    if (t2 != 0)
        goto LAB16;

LAB18:    xsi_set_current_line(87, ng0);
    t1 = (t0 + 5168U);
    t3 = *((char **)t1);
    t11 = *((int *)t3);
    t12 = (t11 - 1);
    t1 = (t0 + 7752);
    t4 = (t1 + 56U);
    t7 = *((char **)t4);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    *((int *)t9) = t12;
    xsi_driver_first_trans_fast(t1);

LAB17:    goto LAB9;

LAB16:    xsi_set_current_line(85, ng0);
    t1 = (t0 + 5648U);
    t7 = *((char **)t1);
    t13 = *((int *)t7);
    t1 = (t0 + 7752);
    t8 = (t1 + 56U);
    t9 = *((char **)t8);
    t10 = (t9 + 56U);
    t14 = *((char **)t10);
    *((int *)t14) = t13;
    xsi_driver_first_trans_fast(t1);
    goto LAB17;

LAB19:    xsi_set_current_line(90, ng0);
    t1 = (t0 + 2632U);
    t7 = *((char **)t1);
    t1 = (t0 + 11908);
    t11 = xsi_mem_cmp(t1, t7, 2U);
    if (t11 == 1)
        goto LAB25;

LAB30:    t9 = (t0 + 11910);
    t12 = xsi_mem_cmp(t9, t7, 2U);
    if (t12 == 1)
        goto LAB26;

LAB31:    t14 = (t0 + 11912);
    t13 = xsi_mem_cmp(t14, t7, 2U);
    if (t13 == 1)
        goto LAB27;

LAB32:    t18 = (t0 + 11914);
    t20 = xsi_mem_cmp(t18, t7, 2U);
    if (t20 == 1)
        goto LAB28;

LAB33:
LAB29:
LAB24:    goto LAB9;

LAB21:    t1 = (t0 + 4872U);
    t4 = *((char **)t1);
    t15 = *((unsigned char *)t4);
    t16 = (t15 == (unsigned char)2);
    t2 = t16;
    goto LAB23;

LAB25:    xsi_set_current_line(92, ng0);
    t21 = (t0 + 3912U);
    t22 = *((char **)t21);
    t23 = *((int *)t22);
    t24 = (t23 > 0);
    if (t24 != 0)
        goto LAB35;

LAB37:
LAB36:    goto LAB24;

LAB26:    xsi_set_current_line(96, ng0);
    t1 = (t0 + 3912U);
    t3 = *((char **)t1);
    t11 = *((int *)t3);
    t1 = (t0 + 5288U);
    t4 = *((char **)t1);
    t12 = *((int *)t4);
    t13 = (t12 - 1);
    t2 = (t11 < t13);
    if (t2 != 0)
        goto LAB38;

LAB40:
LAB39:    goto LAB24;

LAB27:    xsi_set_current_line(100, ng0);
    t1 = (t0 + 4072U);
    t3 = *((char **)t1);
    t11 = *((int *)t3);
    t2 = (t11 > 0);
    if (t2 != 0)
        goto LAB41;

LAB43:
LAB42:    goto LAB24;

LAB28:    xsi_set_current_line(104, ng0);
    t1 = (t0 + 4072U);
    t3 = *((char **)t1);
    t11 = *((int *)t3);
    t1 = (t0 + 5168U);
    t4 = *((char **)t1);
    t12 = *((int *)t4);
    t13 = (t12 - 1);
    t2 = (t11 < t13);
    if (t2 != 0)
        goto LAB44;

LAB46:
LAB45:    goto LAB24;

LAB34:;
LAB35:    xsi_set_current_line(93, ng0);
    t21 = (t0 + 3912U);
    t25 = *((char **)t21);
    t26 = *((int *)t25);
    t27 = (t26 - 1);
    t21 = (t0 + 7688);
    t28 = (t21 + 56U);
    t29 = *((char **)t28);
    t30 = (t29 + 56U);
    t31 = *((char **)t30);
    *((int *)t31) = t27;
    xsi_driver_first_trans_fast(t21);
    goto LAB36;

LAB38:    xsi_set_current_line(97, ng0);
    t1 = (t0 + 3912U);
    t7 = *((char **)t1);
    t20 = *((int *)t7);
    t23 = (t20 + 1);
    t1 = (t0 + 7688);
    t8 = (t1 + 56U);
    t9 = *((char **)t8);
    t10 = (t9 + 56U);
    t14 = *((char **)t10);
    *((int *)t14) = t23;
    xsi_driver_first_trans_fast(t1);
    goto LAB39;

LAB41:    xsi_set_current_line(101, ng0);
    t1 = (t0 + 4072U);
    t4 = *((char **)t1);
    t12 = *((int *)t4);
    t13 = (t12 - 1);
    t1 = (t0 + 7752);
    t7 = (t1 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    *((int *)t10) = t13;
    xsi_driver_first_trans_fast(t1);
    goto LAB42;

LAB44:    xsi_set_current_line(105, ng0);
    t1 = (t0 + 4072U);
    t7 = *((char **)t1);
    t20 = *((int *)t7);
    t23 = (t20 + 1);
    t1 = (t0 + 7752);
    t8 = (t1 + 56U);
    t9 = *((char **)t8);
    t10 = (t9 + 56U);
    t14 = *((char **)t10);
    *((int *)t14) = t23;
    xsi_driver_first_trans_fast(t1);
    goto LAB45;

LAB47:    xsi_set_current_line(110, ng0);
    t1 = (t0 + 2792U);
    t7 = *((char **)t1);
    t24 = *((unsigned char *)t7);
    t32 = (t24 == (unsigned char)3);
    if (t32 != 0)
        goto LAB52;

LAB54:
LAB53:    goto LAB9;

LAB49:    t1 = (t0 + 4392U);
    t4 = *((char **)t1);
    t15 = *((unsigned char *)t4);
    t16 = (t15 == (unsigned char)2);
    t2 = t16;
    goto LAB51;

LAB52:    xsi_set_current_line(111, ng0);
    t1 = (t0 + 3912U);
    t8 = *((char **)t1);
    t11 = *((int *)t8);
    t1 = (t0 + 5288U);
    t9 = *((char **)t1);
    t12 = *((int *)t9);
    t13 = (t12 - 1);
    t33 = (t11 == t13);
    if (t33 != 0)
        goto LAB55;

LAB57:    xsi_set_current_line(126, ng0);
    t1 = (t0 + 3912U);
    t3 = *((char **)t1);
    t11 = *((int *)t3);
    t12 = (t11 + 1);
    t1 = (t0 + 7688);
    t4 = (t1 + 56U);
    t7 = *((char **)t4);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    *((int *)t9) = t12;
    xsi_driver_first_trans_fast(t1);

LAB56:    goto LAB53;

LAB55:    xsi_set_current_line(112, ng0);
    t1 = (t0 + 3112U);
    t10 = *((char **)t1);
    t34 = *((unsigned char *)t10);
    t35 = (t34 == (unsigned char)3);
    if (t35 != 0)
        goto LAB58;

LAB60:
LAB59:    xsi_set_current_line(116, ng0);
    t1 = (t0 + 2952U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t5 = (t2 == (unsigned char)3);
    if (t5 != 0)
        goto LAB61;

LAB63:
LAB62:    goto LAB56;

LAB58:    xsi_set_current_line(113, ng0);
    t1 = (t0 + 7688);
    t14 = (t1 + 56U);
    t17 = *((char **)t14);
    t18 = (t17 + 56U);
    t19 = *((char **)t18);
    *((int *)t19) = 0;
    xsi_driver_first_trans_fast(t1);
    goto LAB59;

LAB61:    xsi_set_current_line(117, ng0);
    t1 = (t0 + 4072U);
    t4 = *((char **)t1);
    t11 = *((int *)t4);
    t1 = (t0 + 5168U);
    t7 = *((char **)t1);
    t12 = *((int *)t7);
    t13 = (t12 - 1);
    t6 = (t11 == t13);
    if (t6 != 0)
        goto LAB64;

LAB66:    xsi_set_current_line(122, ng0);
    t1 = (t0 + 4072U);
    t3 = *((char **)t1);
    t11 = *((int *)t3);
    t12 = (t11 + 1);
    t1 = (t0 + 7752);
    t4 = (t1 + 56U);
    t7 = *((char **)t4);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    *((int *)t9) = t12;
    xsi_driver_first_trans_fast(t1);

LAB65:    goto LAB62;

LAB64:    xsi_set_current_line(118, ng0);
    t1 = (t0 + 3272U);
    t8 = *((char **)t1);
    t15 = *((unsigned char *)t8);
    t16 = (t15 == (unsigned char)3);
    if (t16 != 0)
        goto LAB67;

LAB69:
LAB68:    goto LAB65;

LAB67:    xsi_set_current_line(119, ng0);
    t1 = (t0 + 7880);
    t9 = (t1 + 56U);
    t10 = *((char **)t9);
    t14 = (t10 + 56U);
    t17 = *((char **)t14);
    *((unsigned char *)t17) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t1);
    goto LAB68;

LAB70:    xsi_set_current_line(130, ng0);
    t1 = (t0 + 7688);
    t7 = (t1 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    *((int *)t10) = 0;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(132, ng0);
    t1 = (t0 + 4072U);
    t3 = *((char **)t1);
    t11 = *((int *)t3);
    t1 = (t0 + 5168U);
    t4 = *((char **)t1);
    t12 = *((int *)t4);
    t13 = (t12 - 1);
    t2 = (t11 == t13);
    if (t2 != 0)
        goto LAB75;

LAB77:    xsi_set_current_line(137, ng0);
    t1 = (t0 + 4072U);
    t3 = *((char **)t1);
    t11 = *((int *)t3);
    t12 = (t11 + 1);
    t1 = (t0 + 7752);
    t4 = (t1 + 56U);
    t7 = *((char **)t4);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    *((int *)t9) = t12;
    xsi_driver_first_trans_fast(t1);

LAB76:    goto LAB9;

LAB72:    t1 = (t0 + 4712U);
    t4 = *((char **)t1);
    t15 = *((unsigned char *)t4);
    t16 = (t15 == (unsigned char)2);
    t2 = t16;
    goto LAB74;

LAB75:    xsi_set_current_line(133, ng0);
    t1 = (t0 + 3272U);
    t7 = *((char **)t1);
    t5 = *((unsigned char *)t7);
    t6 = (t5 == (unsigned char)3);
    if (t6 != 0)
        goto LAB78;

LAB80:
LAB79:    goto LAB76;

LAB78:    xsi_set_current_line(134, ng0);
    t1 = (t0 + 7880);
    t8 = (t1 + 56U);
    t9 = *((char **)t8);
    t10 = (t9 + 56U);
    t14 = *((char **)t10);
    *((unsigned char *)t14) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t1);
    goto LAB79;

LAB81:    xsi_set_current_line(140, ng0);
    t1 = (t0 + 4072U);
    t7 = *((char **)t1);
    t11 = *((int *)t7);
    t24 = (t11 > 0);
    if (t24 != 0)
        goto LAB86;

LAB88:
LAB87:    xsi_set_current_line(144, ng0);
    t1 = (t0 + 7880);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t1);
    goto LAB9;

LAB83:    t1 = (t0 + 4552U);
    t4 = *((char **)t1);
    t15 = *((unsigned char *)t4);
    t16 = (t15 == (unsigned char)2);
    t2 = t16;
    goto LAB85;

LAB86:    xsi_set_current_line(141, ng0);
    t1 = (t0 + 4072U);
    t8 = *((char **)t1);
    t12 = *((int *)t8);
    t13 = (t12 - 1);
    t1 = (t0 + 7752);
    t9 = (t1 + 56U);
    t10 = *((char **)t9);
    t14 = (t10 + 56U);
    t17 = *((char **)t14);
    *((int *)t17) = t13;
    xsi_driver_first_trans_fast(t1);
    goto LAB87;

LAB89:    xsi_set_current_line(153, ng0);
    t1 = (t0 + 4232U);
    t7 = *((char **)t1);
    t20 = *((int *)t7);
    t23 = (t20 + 1);
    t1 = (t0 + 7816);
    t8 = (t1 + 56U);
    t9 = *((char **)t8);
    t10 = (t9 + 56U);
    t14 = *((char **)t10);
    *((int *)t14) = t23;
    xsi_driver_first_trans_fast(t1);
    goto LAB90;

}


extern void work_a_4292770613_3212880686_init()
{
	static char *pe[] = {(void *)work_a_4292770613_3212880686_p_0,(void *)work_a_4292770613_3212880686_p_1,(void *)work_a_4292770613_3212880686_p_2};
	xsi_register_didat("work_a_4292770613_3212880686", "isim/vgacard_tb_isim_beh.exe.sim/work/a_4292770613_3212880686.didat");
	xsi_register_executes(pe);
}
