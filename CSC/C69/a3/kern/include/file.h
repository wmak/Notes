/* BEGIN A3 SETUP */
/*
 * Declarations for file handle and file table management.
 * New for A3.
 */

#ifndef _FILE_H_
#define _FILE_H_

#include <kern/limits.h>

struct vnode;

struct ft_file {
	struct vnode *vn; // node that is being referenced
	off_t offset; // offset within the node
	int refcount;
	int flags;
	struct lock *lock;
};

/*
 * filetable struct
 * just an array, nice and simple.  
 * It is up to you to design what goes into the array.  The current
 * array of ints is just intended to make the compiler happy.
 */
struct filetable {
	struct ft_file *files[__OPEN_MAX];
	struct lock *lock;
};

/* these all have an implicit arg of the curthread's filetable */
int filetable_init(void);
void filetable_destroy(struct filetable *ft);

/* opens a file (must be kernel pointers in the args) */
int file_open(char *filename, int flags, int mode, int *retfd);

/* closes a file */
int file_close(int fd);

/* A3: You should add additional functions that operate on
 * the filetable to help implement some of the filetable-related
 * system calls.
 */
 int file_dup2(int oldfd, int newfd);
 
 int filetable_insert_file(struct ft_file *file, int *fd);
 
 int filetable_get_file(int fd, struct ft_file **file);
 
 int filetable_copy(struct filetable **target);

#endif /* _FILE_H_ */

/* END A3 SETUP */
