extern int write(int fd, char *str, int len);
extern void exit(int code);

int main(int argc, char *argv[]) {
	write(1,"hello\n",6);
	write(1,"world\n",6);
	exit(12);
}
