LDVERSION= $(shell $(PIC_LD) -v | grep -q 2.30 ;echo $$?)
ifeq ($(LDVERSION), 0)
     LD_NORELAX_FLAG= --no-relax
endif

ARCHIVE_OBJS=
ARCHIVE_OBJS += _3924405_archive_1.so
_3924405_archive_1.so : archive.1/_3924405_archive_1.a
	@$(AR) -s $<
	@$(PIC_LD) -shared  -Bsymbolic $(LD_NORELAX_FLAG)  -o .//../syn_simv.daidir//_3924405_archive_1.so --whole-archive $< --no-whole-archive
	@rm -f $@
	@ln -sf .//../syn_simv.daidir//_3924405_archive_1.so $@




VCS_CU_ARC_OBJS = 


O0_OBJS =

$(O0_OBJS) : %.o: %.c
	$(CC_CG) $(CFLAGS_O0) -c -o $@ $<


%.o: %.c
	$(CC_CG) $(CFLAGS_CG) -c -o $@ $<

CU_UDP_OBJS = \
objs/udps/ZycYe.o objs/udps/Hz6M0.o objs/udps/cfY91.o objs/udps/E3u6e.o objs/udps/c8ZbZ.o  \
objs/udps/YffJQ.o objs/udps/JzzcM.o objs/udps/KQQ1H.o objs/udps/Aw1WF.o objs/udps/Z0bgF.o  \
objs/udps/mTxzr.o objs/udps/BcyNP.o objs/udps/CZfJ6.o objs/udps/u96GI.o objs/udps/mSfbM.o  \
objs/udps/cdUtU.o objs/udps/LSJP2.o objs/udps/Ux6u8.o objs/udps/e37Qb.o objs/udps/K0FAD.o  \
objs/udps/Gjg4Z.o objs/udps/hg6Rm.o objs/udps/Z0GwU.o objs/udps/JgPNT.o objs/udps/pNeY8.o  \
objs/udps/y4a7N.o 

CU_UDP_OBJS += 
CU_LVL_OBJS = \
SIM_l.o 

MAIN_OBJS = \
objs/amcQw_d.o 

CU_OBJS = $(MAIN_OBJS) $(ARCHIVE_OBJS) $(CU_UDP_OBJS) $(CU_LVL_OBJS)

