CURRENT	= $(shell uname -r)
MDIR	= drivers/media/dvb/frontends
KDIR	:= /lib/modules/$(CURRENT)/build
SUBLEVEL= $(shell uname -r | cut -d '.' -f 3 | cut -d '.' -f 1 | cut -d '-' -f 1 | cut -d '_' -f 1)


EXTRA_CFLAGS += -DEXPORT_SYMTAB 

PWD = $(shell pwd)
DEST = /lib/modules/$(CURRENT)/kernel/$(MDIR)

obj-m      += tbs5921fe.o
tbs5921fe-objs += kmem_wrap.o tbs5921fe_driver.o
obj-m      += tbs5922fe.o
tbs5922fe-objs += kmem_wrap.o tbs5922fe_driver.o
obj-m      += tbs62x0fe.o
tbs62x0fe-objs += kmem_wrap.o tbs62x0fe_driver.o
obj-m      += tbs6921fe.o
tbs6921fe-objs += kmem_wrap.o tbs6921fe_driver.o
obj-m      += tbs6922fe.o
tbs6922fe-objs += kmem_wrap.o tbs6922fe_driver.o
obj-m      += tbs6925ctrl.o
tbs6925ctrl-objs += kmem_wrap.o tbs6925ctrl_driver.o
obj-m      += tbs6928fe.o
tbs6928fe-objs += kmem_wrap.o tbs6928fe_driver.o
obj-m      += tbs6980fe.o
tbs6980fe-objs += kmem_wrap.o tbs6980fe_driver.o
obj-m      += tbs6981fe.o
tbs6981fe-objs += kmem_wrap.o tbs6981fe_driver.o
obj-m      += tbs6984fe.o
tbs6984fe-objs += kmem_wrap.o tbs6984fe_driver.o
obj-m      += tbs6992.o
tbs6992-objs += kmem_wrap.o tbs6992_driver.o
obj-m      += tbs8921fe.o
tbs8921fe-objs += kmem_wrap.o tbs8921fe_driver.o
obj-m      += tbs8922fe.o
tbs8922fe-objs += kmem_wrap.o tbs8922fe_driver.o

default:
	make -C $(KDIR) SUBDIRS=$(PWD) modules

install:
	su -c "cp -v $(PWD)/*.ko $(DEST) && /sbin/depmod -a"

clean:
	$(MAKE) -C $(KDIR) SUBDIRS=$(PWD) clean

.PHONY: modules clean

-include $(KDIR)/Rules.make

