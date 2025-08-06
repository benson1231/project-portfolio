CC = gcc
CFLAGS = -Wall -Wextra -I/usr/local/include
LDFLAGS = -L/usr/local/lib -lcs50

all: hello

hello: hello.c
	$(CC) $(CFLAGS) hello.c -o hello $(LDFLAGS)

clean:
	rm -f hello
