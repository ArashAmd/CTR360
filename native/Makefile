TARGET := ctr360_boot_test
OUTPUT := $(TARGET).elf32

include $(DEVKITXENON)/rules

all: $(OUTPUT)

$(OUTPUT): source/main.c
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ $< $(LDFLAGS) $(LIBS)

clean:
	rm -f $(OUTPUT) *.o

.PHONY: all clean
