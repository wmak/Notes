/* BEGIN A3 SETUP */
/*
 * File handles and file tables.
 * New for ASST3
 */

#include <types.h>
#include <kern/errno.h>
#include <kern/limits.h>
#include <kern/stat.h>
#include <kern/unistd.h>
#include <file.h>
#include <syscall.h>
#include <vfs.h>
#include <synch.h>
#include <vnode.h>
#include <current.h>
#include <lib.h>
#include <kern/fcntl.h>

/*** openfile functions ***/

/*
 * file_open
 * opens a file, places it in the filetable, sets RETFD to the file
 * descriptor. the pointer arguments must be kernel pointers.
 * NOTE -- the passed in filename must be a mutable string.
 * 
 * A3: As per the OS/161 man page for open(), you do not need 
 * to do anything with the "mode" argument.
 */
int
file_open(char *filename, int flags, int mode, int *retfd)
{
	(void) mode;

	struct vnode *vn;
	struct ft_file *file;
	
	int result = 0;
	
	// check the file isn't already opened
	result = vfs_open(filename, flags, 0, &vn);
	if (result)
		return result;	
		
	// malloc space for the filetable entry
	file = kmalloc(sizeof(struct ft_file));
	if (file == NULL) {
		vfs_close(vn);
		return ENOMEM;
	}
	
	// create the lock
	file->lock = lock_create("filetable entry lock");
	if (file->lock == NULL) {
		vfs_close(vn);
		kfree(file);
		return ENOMEM;
	}
	
	// fill the ft_file object
	file->vn = vn;
	file->offset = 0;
	file->refcount = 0;
	file->flags = flags;
	
	// insert into filetable
	result = filetable_insert_file(file, retfd);
	if (result) {
		lock_destroy(file->lock);
		vfs_close(vn);
		kfree(file);
		return result;
	}

	return 0;
}


/* 
 * file_close
 * Called when a process closes a file descriptor.  Think about how you plan
 * to handle fork, and what (if anything) is shared between parent/child after
 * fork.  Your design decisions will affect what you should do for close.
 */
int
file_close(int fd)
{
	struct ft_file *file;

	// Get the file
	int result = filetable_get_file(fd, &file);
	if (result)
		return result;
	
	// 1 less reference
	lock_acquire(file->lock);
	file->refcount--;
	
	// If no one is referencing, free the file
	if (file->refcount <= 0) {
		vfs_close(file->vn);
		lock_release(file->lock);
		lock_destroy(file->lock);
		kfree(file);
	}
	else
		lock_release(file->lock);

	// Replace the file with NULL in the filetable
	lock_acquire(curthread->t_filetable->lock);
	curthread->t_filetable->files[fd] = NULL;
	lock_release(curthread->t_filetable->lock);

	return 0;
}

/* 
 * A3 implementation of dup2().
 * Makes newfd be the copy of oldfd, closing newfd first if necessary, but note the following:
 *	 - If oldfd is not a valid file descriptor, then the call fails, and newfd is not closed.
 *	 - If oldfd is a valid file descriptor, and newfd has the same value as oldfd, then dup2() 
 *	   does nothing, and returns newfd
 * Return 0 for success, else error code.
 */
int 
file_dup2(int oldfd, int newfd) {
	struct filetable *ft = curthread->t_filetable;
	struct ft_file *file;
	int result = 0;
	
	if (newfd < 0 || newfd >= __OPEN_MAX)
		return EBADF;
	if (oldfd < 0 || oldfd >= __OPEN_MAX)
		return EBADF;
	
	result = filetable_get_file(oldfd, &file);
	if (result)
		return result;

	// newfd has the same value as oldfd, do nothing
	if (file == ft->files[newfd])
		return 0;

	// If newfd is already being used, close that file and set it to the new file
	// Also increment the refcount
	if (ft->files[newfd] != NULL)
		file_close(newfd);
	
	lock_acquire(file->lock);
	file->refcount++;
	lock_release(file->lock);
	
	lock_acquire(ft->lock);
	ft->files[newfd] = file;
	lock_release(ft->lock);

	return 0;
}

/*** filetable functions ***/

/* 
 * filetable_init
 * pretty straightforward -- allocate the space, set up 
 * first 3 file descriptors for stdin, stdout and stderr,
 * and initialize all other entries to NULL.
 * 
 * Should set curthread->t_filetable to point to the
 * newly-initialized filetable.
 * 
 * Should return non-zero error code on failure.  Currently
 * does nothing but returns success so that loading a user
 * program will succeed even if you haven't written the
 * filetable initialization yet.
 */

int
filetable_init(void)
{
	struct filetable *ft;
	int fd, flag, result, error;
	char con[5] = "con:";
	
	// Allocate space
	ft = kmalloc(sizeof(struct filetable));
	if (ft == NULL)
		return ENOMEM;
	
	// Create the lock
	ft->lock = lock_create("filetable lock");
	if (ft->lock == NULL) {
		kfree(ft);
		return ENOMEM;
	}
	
	// Set up stdin, stdout, stderr
	// where they have fd 0, 1, 2 respectively
	// stdin flag is O_RDONLY, stdout and stderr are O_WRONLY
	error = 0;
	for (int i = 0; i < 3; i++) {
		if (i == 0)
			flag = O_RDONLY;
		else
			flag = O_WRONLY;
		result = file_open(con, flag, 0, &fd);
		if (result) {
			error = result;
			break;
		}
		KASSERT(i == fd);
	}
	
	if (error) {
		for (int i = 0; i < 3; i++)
			file_close(i);
		lock_destroy(ft->lock);
		kfree(ft);
		return error;
	}
	
	// Initiate all entries to NULL
	lock_acquire(ft->lock);
	for (int i = 0; i < __OPEN_MAX; i++) {
		ft->files[i] = NULL;
	}
	lock_release(ft->lock);
	
	// Set curthread->t_filetable
	curthread->t_filetable = ft;

	return 0;
}	

/*
 * filetable_destroy
 * closes the files in the file table, frees the table.
 * This should be called as part of cleaning up a process (after kill
 * or exit).
 */
void
filetable_destroy(struct filetable *ft)
{
	KASSERT(ft != NULL);
	
	// Close all files in table
	lock_acquire(ft->lock);
	for (int i = 0; i < __OPEN_MAX; i++) {
		if (ft->files[i] != NULL)
			file_close(i);
	}
	lock_release(ft->lock);
	
	// Free the table
	lock_destroy(ft->lock);
	kfree(ft);
}	


/* 
 * You should add additional filetable utility functions here as needed
 * to support the system calls.  For example, given a file descriptor
 * you will want some sort of lookup function that will check if the fd is 
 * valid and return the associated vnode (and possibly other information like
 * the current file position) associated with that open file.
 */
 
/*
 * Insert the given file into the filetable, return the file descriptor
 * by reference in fd
 */
int
filetable_insert_file(struct ft_file *file, int *fd) {
	struct filetable *table = curthread->t_filetable;
	
	// Create lock
	lock_acquire(table->lock);
	
	// Find a slot in the filetable to insert into
	// Insert it and return 0
	for (int i = 0; i < __OPEN_MAX; i++) {
		if (table->files[i] == NULL) {
			lock_acquire(file->lock);
			file->refcount++;
			lock_release(file->lock);
			
			table->files[i] = file;
			if (fd)
				*fd = i;
			lock_release(table->lock);
			return 0;
		}
	}
	
	// The filetable is full
	
	lock_release(table->lock);
	return EMFILE;
}

/*
 * Given a file descriptor, try to find it in the filetable
 * If it exists, return the file by reference.
 * The function itself will return 0 if successful, or an error code if not.
 */
int
filetable_get_file(int fd, struct ft_file **file) {
	// First, make sure fd is even in a valid range
	if (fd < 0 || fd > __OPEN_MAX)
		return EBADF;
		
	// Check filetable at this index is not null
	if (curthread->t_filetable->files[fd] == NULL)
		return EBADF;
		
	// All is good, return the file
	*file = curthread->t_filetable->files[fd];
	return 0;
}


/*
 * Shallow clone a filetable (don't clone each of the individual ft_file)
 */
int
filetable_copy(struct filetable **target) {
	struct filetable *ft = curthread->t_filetable;
	
	// Copy the NULL
	if (ft == NULL) {
		*target = NULL;
		return 0;
	}
	
	struct filetable *table = kmalloc(sizeof(struct filetable));
	if (table == NULL)
		return ENOMEM;

	table->lock = lock_create("filetable lock");
	if (table->lock == NULL) {
		kfree(table);
		return ENOMEM;
	}

	// Since we'll be reading and modifying the two filetables, lock them
	lock_acquire(table->lock);
	lock_acquire(ft->lock);

	for (int i = 0; i < __OPEN_MAX; i++) {
		if (ft->files[i] != NULL) {
			lock_acquire(ft->files[i]->lock);
			ft->files[i]->refcount++;
			lock_release(ft->files[i]->lock);
			table->files[i] = ft->files[i];
		}
		else
			ft->files[i] = NULL;
	}
	lock_release(ft->lock);
	lock_release(table->lock);
	*target = ft;
	
	return 0;
}

/* END A3 SETUP */
