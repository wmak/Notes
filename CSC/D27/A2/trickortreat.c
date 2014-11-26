#include <stdio.h>
#include <unistd.h>

/* do something nice and innocent */
int main_fun(int ac, char *av[]) {
	char buf[10];
	fprintf(stdout, "Hello, world!\n");
	fprintf(stdout, "Generating a random number!\n");
	sleep(1);
	fprintf(stdout, "4\n");
	fprintf(stdout, "\n(press enter to quit)");
	fflush(stdout);
	fgets(buf, 10, stdin);
	fprintf(stdout, "Derek Lai, 31 October 2014\n");
	fprintf(stdout, "William Mak, 31 October 2014\n");
	return 0;
}

/* do something not-so-nice */
int main_bad(int ac, char *av[]) {
	char buf[10];
	int i;
	fprintf(stdout, "I think you just made a big mistake!!!\n");
	for ( i = 0; i < 100; i++ ){
		fprintf(stdout, "SPAAAAAAAAM\n");
		fprintf(stdout, "SPAAAAAAAAM\n");
	}
	fprintf(stdout, "MUHAHAHAHAHAHHAA SPAAAM!!!");
	fprintf(stdout, "\n(press enter to quit)");
	fflush(stdout);
	fgets(buf, 10, stdin);
	fprintf(stdout, "Derek Lai, 31 October 2014\n");
	fprintf(stdout, "William Mak, 31 October 2014\n");
	return 0;
}
