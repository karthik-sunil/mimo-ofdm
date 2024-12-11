// file = 0; split type = patterns; threshold = 100000; total count = 0.
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include "rmapats.h"

void  schedNewEvent (struct dummyq_struct * I1460, EBLK  * I1455, U  I627);
void  schedNewEvent (struct dummyq_struct * I1460, EBLK  * I1455, U  I627)
{
    U  I1744;
    U  I1745;
    U  I1746;
    struct futq * I1747;
    struct dummyq_struct * pQ = I1460;
    I1744 = ((U )vcs_clocks) + I627;
    I1746 = I1744 & ((1 << fHashTableSize) - 1);
    I1455->I673 = (EBLK  *)(-1);
    I1455->I674 = I1744;
    if (0 && rmaProfEvtProp) {
        vcs_simpSetEBlkEvtID(I1455);
    }
    if (I1744 < (U )vcs_clocks) {
        I1745 = ((U  *)&vcs_clocks)[1];
        sched_millenium(pQ, I1455, I1745 + 1, I1744);
    }
    else if ((peblkFutQ1Head != ((void *)0)) && (I627 == 1)) {
        I1455->I676 = (struct eblk *)peblkFutQ1Tail;
        peblkFutQ1Tail->I673 = I1455;
        peblkFutQ1Tail = I1455;
    }
    else if ((I1747 = pQ->I1361[I1746].I696)) {
        I1455->I676 = (struct eblk *)I1747->I694;
        I1747->I694->I673 = (RP )I1455;
        I1747->I694 = (RmaEblk  *)I1455;
    }
    else {
        sched_hsopt(pQ, I1455, I1744);
    }
}
void  rmaPropagate12 (UB  * pcode, scalar  val)
{
    UB  * I1812;
    scalar  I1606;
    scalar  I1607;
    scalar  I1184;
    scalar  I1608;
    scalar  * I1609;
    UB  * I1610;
    U  I1611 = 0;
    U  I1612;
    U  I1613 = 0;
    scalar  I1614;
    US  * I1615;
    US  I1616 = 0;
    UB  * I1129;
    UB  * I1617;
    RP  I1618 = 0;
    I1612 = (U )*(pcode + 24 + 3);
    *(pcode + 24 + 3) = 0;
    I1617 = pcode + 24;
    if (I1612) {
        *I1617 = val;
    }
    else {
        I1607 = *(pcode + 24 + 2);
        I1606 = val;
        if (I1606 != I1607) {
            I1611 = 1;
        }
        if (I1607 == 0xff) {
            I1607 = 0;
            I1613 = 1;
        }
        I1129 = pcode + 24 + 1U;
        *I1129 = I1606;
        if (!I1611) {
            return  ;
        }
        *(pcode + 24 + 2) = I1606;
    }
    if (!I1612) {
        I1609 = *(scalar  **)((*(RP  **)(pcode + 32)));
        I1184 = *(I1609 + I1606);
        *I1617 = I1184;
        val = I1184;
        I1608 = *(I1609 + I1607);
        I1614 = *(I1609 + (28));
        I1610 = (UB  *)(*((*(RP  **)(pcode + 32)) + 1));
        I1615 = edgeActionT + (9 * ((I1607 << 7U) + (I1606 << 2U) + I1614));
        I1616 = I1615[0];
    }
    {
        U  I991;
        U  I1346;
        I991 = *(U  *)(pcode + 40);
        I1346 = *(U  *)(pcode + 40 + sizeof(U ));
        if (I1611) {
            U  I1477;
            RP  * I634 = (RP  *)(pcode + 40 + (2 * sizeof(U )));
            RP  I1859 = (RP )(I1609 + I1606);
            for (I1477 = 0; I1477 < I991; I1477++) {
                *(RP  *)(I634[2 * I1477]) = I1859;
            }
            I634 = (RP  *)(pcode + 40 + (2 * I991 * sizeof(RP )) + (2 * sizeof(U )));
            for (I1477 = 0; I1477 < I1346; I1477++) {
                *(RP  *)(I634[I1477]) = I1859;
            }
        }
        pcode += (40 + (2 * sizeof(U )) + (((2 * I991) + I1346) * sizeof(RP )));
    }
    {
        RmaEblk  * I1455 = (RmaEblk  *)(pcode + 0);
        if (I1611) {
            RmaChildXpropLoadHdr  * I1025 = (RmaChildXpropLoadHdr  *)I1455->I671;
            I1618 = *(RP  *)((UB  *)I1025 + 24U);
            rmaScheduleChildXpropEblk((EBLK  *)I1455, I1606, I1607, I1609, I1608);
        }
    }
    {
        U  I991;
        U  I1876 = 0;
        U  I1877 = 0;
        I991 = *(U  *)(pcode + 48);
        if (I1611) {
            if (I1618) {
                EBLK  * I1455 = (EBLK  *)I1618;
                RP  I1681 = (RP )I1455->I671;
                RmaMasterXpropLoadHdr  * I1025 = (RmaMasterXpropLoadHdr  *)(I1681 & ~0x3);
                I1876 = I1025->I1335 || (I1455->I673 != ((void *)0));
            }
            U  I1477;
            UB  * I1833 = (UB  *)(pcode + 48 + sizeof(RP ));
            for (I1477 = 0; I1477 < I991; I1477++) {
                rmaScheduleGatedClockEdgeLoadNew(I1833, I1615, (I1876 << 1) | (I1877 << 3), I1610, I1610, I1606, I1607);
                I1833 = I1833 + 168U;
            }
        }
        pcode += (48 + (sizeof(RP ) + I991 * 168U));
    }
    if (!I1612 && !(I1616 & ~33825) && !I1613) {
        return  ;
    }
    if (I1616 & ~33825) {
        {
            scalar  I1627;
            scalar  I1184;
            U  I1654;
            US  I235;
            I1184 = X3val[val];
            I1627 = I1608;
            *(pcode + 0) = I1627;
            I235 = (I1627 << 2) + I1184;
            I1654 = 1 << I235;
            if (I1654 & 18) {
                if (I1654 & 2) {
                    (*(FP  *)(pcode + 8))(*(void **)(pcode + 16), I235);
                }
            }
            else {
                U  I1552;
                U  I657;
                U  I1733;
                U  * I1735;
                UB  * pcode1;
                pcode1 = (UB  *)(*(UP  *)(pcode + 16) & ~3);
                I657 = *(U  *)pcode1;
                I1735 = (U  *)(pcode1 + sizeof(U ));
                I1733 = (I657 + 31) >> 5;
                pcode1 += sizeof(U ) * (1 + I1733);
                for (I1552 = 0; I1552 < I1733; I1552++) {
                    if (I1552 == I1733 - 1 && (I657 % 32)) {
                        I1735[I1552] = (1 << (I657 % 32)) - 1;
                    }
                    else {
                        I1735[I1552] = (U )-1;
                    }
                }
                pcode1 = (UB  *)((((RP )pcode1) + 7) & (~7));
                for (; I657 > 0; I657--) {
                    (*(FP  *)(pcode1))(*(void **)(pcode1 + 8LU), I235);
                    pcode1 += 16;
                }
            }
            *(pcode + 0U) = I1184;
        }
    }
}
void  rmaPropagate12_t0 (UB  * pcode, UB  val)
{
    val = *(pcode + 24 + 1U);
    *(pcode + 24 + 1U) = 24;
    rmaPropagate12(pcode, val);
}
void  rmaPropagate23 (UB  * pcode, scalar  val)
{
    UB  * I1812;
    scalar  I1606;
    scalar  I1607;
    scalar  I1184;
    scalar  I1608;
    scalar  * I1609;
    UB  * I1610;
    U  I1611 = 0;
    U  I1612;
    U  I1613 = 0;
    scalar  I1614;
    US  * I1615;
    US  I1616 = 0;
    UB  * I1129;
    UB  * I1617;
    RP  I1618 = 0;
    I1612 = (U )*(pcode + 24 + 3);
    *(pcode + 24 + 3) = 0;
    I1617 = pcode + 24;
    if (I1612) {
        *I1617 = val;
    }
    else {
        I1607 = *(pcode + 24 + 2);
        I1606 = val;
        if (I1606 != I1607) {
            I1611 = 1;
        }
        if (I1607 == 0xff) {
            I1607 = 0;
            I1613 = 1;
        }
        I1129 = pcode + 24 + 1U;
        *I1129 = I1606;
        if (!I1611) {
            return  ;
        }
        *(pcode + 24 + 2) = I1606;
    }
    if (!I1612) {
        I1609 = *(scalar  **)((*(RP  **)(pcode + 32)));
        I1184 = *(I1609 + I1606);
        *I1617 = I1184;
        val = I1184;
        I1608 = *(I1609 + I1607);
        I1614 = *(I1609 + (28));
        I1610 = (UB  *)(*((*(RP  **)(pcode + 32)) + 1));
        I1615 = edgeActionT + (9 * ((I1607 << 7U) + (I1606 << 2U) + I1614));
        I1616 = I1615[0];
    }
    {
        U  I991;
        U  I1346;
        I991 = *(U  *)(pcode + 40);
        I1346 = *(U  *)(pcode + 40 + sizeof(U ));
        if (I1611) {
            U  I1477;
            RP  * I634 = (RP  *)(pcode + 40 + (2 * sizeof(U )));
            RP  I1859 = (RP )(I1609 + I1606);
            for (I1477 = 0; I1477 < I991; I1477++) {
                *(RP  *)(I634[2 * I1477]) = I1859;
            }
            I634 = (RP  *)(pcode + 40 + (2 * I991 * sizeof(RP )) + (2 * sizeof(U )));
            for (I1477 = 0; I1477 < I1346; I1477++) {
                *(RP  *)(I634[I1477]) = I1859;
            }
        }
        pcode += (40 + (2 * sizeof(U )) + (((2 * I991) + I1346) * sizeof(RP )));
    }
    {
        RmaEblk  * I1455 = (RmaEblk  *)(pcode + 0);
        if (I1611) {
            RmaChildXpropLoadHdr  * I1025 = (RmaChildXpropLoadHdr  *)I1455->I671;
            I1618 = *(RP  *)((UB  *)I1025 + 24U);
            rmaScheduleChildXpropEblk((EBLK  *)I1455, I1606, I1607, I1609, I1608);
        }
    }
    {
        U  I991;
        U  I1876 = 0;
        U  I1877 = 0;
        I991 = *(U  *)(pcode + 48);
        if (I1611) {
            if (I1618) {
                EBLK  * I1455 = (EBLK  *)I1618;
                RP  I1681 = (RP )I1455->I671;
                RmaMasterXpropLoadHdr  * I1025 = (RmaMasterXpropLoadHdr  *)(I1681 & ~0x3);
                I1876 = I1025->I1335 || (I1455->I673 != ((void *)0));
            }
            U  I1477;
            UB  * I1833 = (UB  *)(pcode + 48 + sizeof(RP ));
            for (I1477 = 0; I1477 < I991; I1477++) {
                rmaScheduleGatedClockEdgeLoadNew(I1833, I1615, (I1876 << 1) | (I1877 << 3), I1610, I1610, I1606, I1607);
                I1833 = I1833 + 168U;
            }
        }
        pcode += (48 + (sizeof(RP ) + I991 * 168U));
    }
    if (!I1612 && !(I1616 & ~33825) && !I1613) {
        return  ;
    }
    if (I1616 & ~33825) {
        {
            scalar  I1627;
            scalar  I1184;
            U  I1654;
            US  I235;
            I1184 = X3val[val];
            I1627 = I1608;
            *(pcode + 0) = I1627;
            I235 = (I1627 << 2) + I1184;
            I1654 = 1 << I235;
            if (I1654 & 18) {
                if (I1654 & 16) {
                    (*(FP  *)(pcode + 8))(*(void **)(pcode + 16), I235);
                }
            }
            else {
                U  I1552;
                U  I657;
                U  I1733;
                U  * I1735;
                UB  * pcode1;
                pcode1 = (UB  *)(*(UP  *)(pcode + 16) & ~3);
                I657 = *(U  *)pcode1;
                I1735 = (U  *)(pcode1 + sizeof(U ));
                I1733 = (I657 + 31) >> 5;
                pcode1 += sizeof(U ) * (1 + I1733);
                for (I1552 = 0; I1552 < I1733; I1552++) {
                    if (I1552 == I1733 - 1 && (I657 % 32)) {
                        I1735[I1552] = (1 << (I657 % 32)) - 1;
                    }
                    else {
                        I1735[I1552] = (U )-1;
                    }
                }
                pcode1 = (UB  *)((((RP )pcode1) + 7) & (~7));
                for (; I657 > 0; I657--) {
                    (*(FP  *)(pcode1))(*(void **)(pcode1 + 8LU), I235);
                    pcode1 += 16;
                }
            }
            *(pcode + 0U) = I1184;
        }
    }
}
void  rmaPropagate23_t0 (UB  * pcode, UB  val)
{
    val = *(pcode + 24 + 1U);
    *(pcode + 24 + 1U) = 24;
    rmaPropagate23(pcode, val);
}
void  rmaPropagate29 (UB  * pcode, scalar  val)
{
    UB  * I1812;
    scalar  I1606;
    scalar  I1607;
    scalar  I1184;
    scalar  I1608;
    scalar  * I1609;
    UB  * I1610;
    U  I1611 = 0;
    U  I1612;
    U  I1613 = 0;
    scalar  I1614;
    US  * I1615;
    US  I1616 = 0;
    UB  * I1129;
    UB  * I1617;
    RP  I1618 = 0;
    I1612 = (U )*(pcode + 24 + 3);
    *(pcode + 24 + 3) = 0;
    I1617 = pcode + 24;
    if (I1612) {
        *I1617 = val;
    }
    else {
        I1607 = *(pcode + 24 + 2);
        I1606 = val;
        if (I1606 != I1607) {
            I1611 = 1;
        }
        if (I1607 == 0xff) {
            I1607 = 0;
            I1613 = 1;
        }
        I1129 = pcode + 24 + 1U;
        *I1129 = I1606;
        if (!I1611) {
            return  ;
        }
        *(pcode + 24 + 2) = I1606;
    }
    if (!I1612) {
        I1609 = *(scalar  **)((*(RP  **)(pcode + 32)));
        I1184 = *(I1609 + I1606);
        *I1617 = I1184;
        val = I1184;
        I1608 = *(I1609 + I1607);
        I1614 = *(I1609 + (28));
        I1610 = (UB  *)(*((*(RP  **)(pcode + 32)) + 1));
        I1615 = edgeActionT + (9 * ((I1607 << 7U) + (I1606 << 2U) + I1614));
        I1616 = I1615[0];
    }
    {
        U  I991;
        U  I1346;
        I991 = *(U  *)(pcode + 40);
        I1346 = *(U  *)(pcode + 40 + sizeof(U ));
        if (I1611) {
            U  I1477;
            RP  * I634 = (RP  *)(pcode + 40 + (2 * sizeof(U )));
            RP  I1859 = (RP )(I1609 + I1606);
            for (I1477 = 0; I1477 < I991; I1477++) {
                *(RP  *)(I634[2 * I1477]) = I1859;
            }
            I634 = (RP  *)(pcode + 40 + (2 * I991 * sizeof(RP )) + (2 * sizeof(U )));
            for (I1477 = 0; I1477 < I1346; I1477++) {
                *(RP  *)(I634[I1477]) = I1859;
            }
        }
        pcode += (40 + (2 * sizeof(U )) + (((2 * I991) + I1346) * sizeof(RP )));
    }
    {
        RmaEblk  * I1455 = (RmaEblk  *)(pcode + 0);
        if (I1611) {
            RmaChildXpropLoadHdr  * I1025 = (RmaChildXpropLoadHdr  *)I1455->I671;
            I1618 = *(RP  *)((UB  *)I1025 + 24U);
            rmaScheduleChildXpropEblk((EBLK  *)I1455, I1606, I1607, I1609, I1608);
        }
    }
    {
        U  I991;
        U  I1876 = 0;
        U  I1877 = 0;
        I991 = *(U  *)(pcode + 48);
        if (I1611) {
            if (I1618) {
                EBLK  * I1455 = (EBLK  *)I1618;
                RP  I1681 = (RP )I1455->I671;
                RmaMasterXpropLoadHdr  * I1025 = (RmaMasterXpropLoadHdr  *)(I1681 & ~0x3);
                I1876 = I1025->I1335 || (I1455->I673 != ((void *)0));
            }
            U  I1477;
            UB  * I1833 = (UB  *)(pcode + 48 + sizeof(RP ));
            for (I1477 = 0; I1477 < I991; I1477++) {
                rmaScheduleGatedClockEdgeLoadNew(I1833, I1615, (I1876 << 1) | (I1877 << 3), I1610, I1610, I1606, I1607);
                I1833 = I1833 + 168U;
            }
        }
        pcode += (48 + (sizeof(RP ) + I991 * 168U));
    }
    if (!I1612 && !(I1616 & ~33825) && !I1613) {
        return  ;
    }
    if (I1616 & ~33825) {
        {
            scalar  I1627;
            scalar  I1184;
            U  I1654;
            US  I235;
            I1184 = X3val[val];
            I1627 = I1608;
            *(pcode + 0) = I1627;
            I235 = (I1627 << 2) + I1184;
            I1654 = 1 << I235;
            if (I1654 & 18) {
                if (I1654 & 2) {
                    (*(FP  *)(pcode + 8))(*(void **)(pcode + 16), I235);
                }
                if (I1654 & 16) {
                    (*(FP  *)(pcode + 24))(*(void **)(pcode + 32), I235);
                }
            }
            else {
                U  I1552;
                U  I657;
                U  I1733;
                U  * I1735;
                UB  * pcode1;
                pcode1 = (UB  *)(*(UP  *)(pcode + 16) & ~3);
                I657 = *(U  *)pcode1;
                I1735 = (U  *)(pcode1 + sizeof(U ));
                I1733 = (I657 + 31) >> 5;
                pcode1 += sizeof(U ) * (1 + I1733);
                for (I1552 = 0; I1552 < I1733; I1552++) {
                    if (I1552 == I1733 - 1 && (I657 % 32)) {
                        I1735[I1552] = (1 << (I657 % 32)) - 1;
                    }
                    else {
                        I1735[I1552] = (U )-1;
                    }
                }
                pcode1 = (UB  *)((((RP )pcode1) + 7) & (~7));
                for (; I657 > 0; I657--) {
                    (*(FP  *)(pcode1))(*(void **)(pcode1 + 8LU), I235);
                    pcode1 += 16;
                }
                pcode1 = (UB  *)(*(UP  *)(pcode + 32) & ~3);
                I657 = *(U  *)pcode1;
                I1735 = (U  *)(pcode1 + sizeof(U ));
                I1733 = (I657 + 31) >> 5;
                pcode1 += sizeof(U ) * (1 + I1733);
                for (I1552 = 0; I1552 < I1733; I1552++) {
                    if (I1552 == I1733 - 1 && (I657 % 32)) {
                        I1735[I1552] = (1 << (I657 % 32)) - 1;
                    }
                    else {
                        I1735[I1552] = (U )-1;
                    }
                }
                pcode1 = (UB  *)((((RP )pcode1) + 7) & (~7));
                for (; I657 > 0; I657--) {
                    (*(FP  *)(pcode1))(*(void **)(pcode1 + 8LU), I235);
                    pcode1 += 16;
                }
            }
            *(pcode + 0U) = I1184;
        }
    }
}
void  rmaPropagate29_t0 (UB  * pcode, UB  val)
{
    val = *(pcode + 24 + 1U);
    *(pcode + 24 + 1U) = 24;
    rmaPropagate29(pcode, val);
}
#ifdef __cplusplus
extern "C" {
#endif
void SinitHsimPats(void);
#ifdef __cplusplus
}
#endif
