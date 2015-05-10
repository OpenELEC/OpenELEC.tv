OBJS = bgra2rgb565_neon.S framebuffer.c newinput.c vncserver.c
CFLAGS += -Wall -std=c11
LIBS := -lvncserver -lpng -ljpeg -lpthread -lssl -lcrypto -lz -lresolv

all: aml-vnc

aml-vnc: $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^ $(LIBS)

clean:
	$(RM) -rf
