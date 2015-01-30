/* BEGIN A3 SETUP */
/* This file existed for A1 and A2, but has been completely replaced for A3.
 * We have kept the dumb versions of sys_read and sys_write to support early
 * testing, but they should be replaced with proper implementations that 
 * use your open file table to find the correct vnode given a file descriptor
 * number.  All the "dumb console I/O" code should be deleted.
 */

#include <types.h>
#include <kern/errno.h>
#include <lib.h>
#include <thread.h>
#include <current.h>
#include <syscall.h>
#include <vfs.h>
#include <vnode.h>
#include <uio.h>
#include <kern/fcntl.h>
#include <kern/unistd.h>
#include <kern/limits.h>
#include <kern/stat.h>
#include <copyinout.h>
#include <synch.h>
#include <file.h>
#include <kern/seek.h>

/* This special-case global variable for the console vnode should be deleted 
 * when you have a proper open file table implementation.
 */
struct vnode *cons_vnode=NULL;
/* This function should be deleted, including the call in main.c, when you
 * have proper initialization of the first 3 file descriptors in your 
 * open file table implementation.
 * You may find it useful as an example of how to get a vnode for the 
 * console device.
 */
void dumb_consoleIO_bootstrap()
{
  int result;
  char path[5];

  /* The path passed to vfs_open must be mutable.
   * vfs_open may modify it.
   */

  strcpy(path, "con:");
  result = vfs_open(path, O_RDWR, 0, &cons_vnode);

  if (result) {
    /* Tough one... if there's no console, there's not
     * much point printing a warning...
     * but maybe the bootstrap was just called in the wrong place
     */
    kprintf("Warning: could not initialize console vnode\n");
    kprintf("User programs will not be able to read/write\n");
    cons_vnode = NULL;
  }
}

/*
 * mk_useruio
 * sets up the uio for a USERSPACE transfer. 
 */
static
void
mk_useruio(struct iovec *iov, struct uio *u, userptr_t buf, 
	   size_t len, off_t offset, enum uio_rw rw)
{

	iov->iov_ubase = buf;
	iov->iov_len = len;
	u->uio_iov = iov;
	u->uio_iovcnt = 1;
	u->uio_offset = offset;
	u->uio_resid = len;
	u->uio_segflg = UIO_USERSPACE;
	u->uio_rw = rw;
	u->uio_space = curthread->t_addrspace;
}

/*
 * sys_open
 * just copies in the filename, then passes work to file_open.
 * You have to write file_open.
 * 
 */

int
sys_open(userptr_t filename, int flags, int mode, int *retval)
{
	char *fname;
	int result;

	if ( (fname = (char *)kmalloc(__PATH_MAX)) == NULL) {
		return ENOMEM;
	}

	result = copyinstr(filename, fname, __PATH_MAX, NULL);
	if (result) {
		kfree(fname);
		return result;
	}

	result =  file_open(fname, flags, mode, retval);
	kfree(fname);
	return result;
}

/* 
 * sys_close
 * You have to write file_close.
 */
int
sys_close(int fd)
{
	return file_close(fd);
}

/* 
 * sys_dup2
 * 
 */
int
sys_dup2(int oldfd, int newfd, int *retval)
{
	int result = 0;
	
	// Call file_dup2, return if errored
	// Return set retval to newfd and return retval via reference
	result = file_dup2(oldfd, newfd);
	if (result)
		return result;
	else if (retval != NULL)
		*retval = newfd;

	return 0;
}

/*
 * sys_read
 * calls VOP_READ.
 * 
 * A3: This is the "dumb" implementation of sys_write:
 * it only deals with file descriptors 1 and 2, and 
 * assumes they are permanently associated with the 
 * console vnode (which must have been previously initialized).
 *
 * In your implementation, you should use the file descriptor
 * to find a vnode from your file table, and then read from it.
 *
 * Note that any problems with the address supplied by the
 * user as "buf" will be handled by the VOP_READ / uio code
 * so you do not have to try to verify "buf" yourself.
 *
 * Most of this code should be replaced.
 */
int
sys_read(int fd, userptr_t buf, size_t size, int *retval)
{
	struct uio user_uio;
	struct iovec user_iov;
	int result;
	off_t offset = 0;
	struct ft_file *file;

	if ((result = filetable_get_file(fd, &file))){
	  return result; // Error
	}

	lock_acquire(file->lock);
	offset = file->offset;

	/* set up a uio with the buffer, its size, and the current offset */
	mk_useruio(&user_iov, &user_uio, buf, size, offset, UIO_READ);

	/* does the read */
	result = VOP_READ(file->vn, &user_uio);
	if (result) {
		lock_release(file->lock);
		return result;
	}

	/*
	 * The amount read is the size of the buffer originally, minus
	 * how much is left in it.
	 */
	*retval = size - user_uio.uio_resid;

	file->offset += size;
	lock_release(file->lock);

	return 0;
}

/*
 * sys_write
 * calls VOP_WRITE.
 *
 * A3: This is the "dumb" implementation of sys_write:
 * it only deals with file descriptors 1 and 2, and 
 * assumes they are permanently associated with the 
 * console vnode (which must have been previously initialized).
 *
 * In your implementation, you should use the file descriptor
 * to find a vnode from your file table, and then read from it.
 *
 * Note that any problems with the address supplied by the
 * user as "buf" will be handled by the VOP_READ / uio code
 * so you do not have to try to verify "buf" yourself.
 *
 * Most of this code should be replaced.
 */

int
sys_write(int fd, userptr_t buf, size_t len, int *retval) 
{
        struct uio user_uio;
        struct iovec user_iov;
        int result;
        off_t offset = 0;
    	struct ft_file *file;

    	if ((result = filetable_get_file(fd, &file))){
    	  return result; // Error
    	}

    	lock_acquire(file->lock);
    	offset = file->offset;

        /* set up a uio with the buffer, its size, and the current offset */
        mk_useruio(&user_iov, &user_uio, buf, len, offset, UIO_WRITE);

        /* does the write */
        result = VOP_WRITE(file->vn, &user_uio);
        if (result) {
    		lock_release(file->lock);
            return result;
        }

        /*
         * the amount written is the size of the buffer originally,
         * minus how much is left in it.
         */
        *retval = len - user_uio.uio_resid;

    	file->offset += len;
    	lock_release(file->lock);

        return 0;
}

/*
 * sys_lseek
 * 
 */
int
sys_lseek(int fd, off_t offset, int whence, off_t *retval)
{
        int seekend;
    	struct ft_file *file;
    	int result;

    	off_t newoff;
        struct stat fileStat;

    	if ((result = filetable_get_file(fd, &file))){
    	  return result; // Error
    	}

    	lock_acquire(file->lock);


         switch (whence) {
             // The offset is set to offset bytes.
             case SEEK_SET:
            	 newoff = offset;
                 break;
             // The offset is set to its current location plus offset bytes.
             case SEEK_CUR:
            	 newoff = file->offset + offset;
                 break;
             //  The offset is set to the size of the file plus offset bytes.
             case SEEK_END:
                 if((seekend = VOP_STAT(file->vn, &fileStat))){
                     lock_release(file->lock);
                	 return result;
                 }
                 newoff = file->offset + seekend;
                 break;
             default:
                 // Error
                 lock_release(file->lock);
                 return EINVAL;
         }

     	// valid position?
     	if ((result = VOP_TRYSEEK(file->vn, newoff))) {
     		lock_release(file->lock);
     		return result;
     	}


         file->offset = newoff;
         *retval = newoff;

         lock_release(file->lock);

         return 0;
}


/* really not "file" calls, per se, but might as well put it here */

/*
 * sys_chdir
 * 
 */
int
sys_chdir(userptr_t path)
{
    int result;

	//Change Path
    if ((result = vfs_chdir((char*) path))) {
        return result;
    }

    return 0;
}

/*
 * sys___getcwd
 * 
 */
int
sys___getcwd(userptr_t buf, size_t buflen, int *retval)
{
	int result;
	struct uio user_uio;
	struct iovec user_iov;
	//char buf[__PATH_MAX];

	/* set up a uio with the buffer, its size, and the current offset */
	mk_useruio(&user_iov, &user_uio, buf, buflen, 0, UIO_READ);


	if ((result = vfs_getcwd(&user_uio))) {
		return result;
	}

    *retval = buflen - user_uio.uio_resid;

    return 0;
}

/*
 * sys_fstat
 */
int
sys_fstat(int fd, userptr_t statptr)
{
	struct ft_file *ftent;
	int location = filetable_get_file(fd, &ftent);
	if (location) {
		return location;
	}

	struct stat status;
	location = VOP_STAT(ftent->vn, &status);
	if (location) {
		return location;
	}

	location = copyout(&status, statptr, sizeof(statptr));
	if (location) {
		return location;
	}
	return 0;
}

/*
 * sys_getdirentry
 */
int
sys_getdirentry(int fd, userptr_t buf, size_t buflen, int *retval)
{
	struct ft_file	*ftent;

	int location = filetable_get_file(fd, &ftent);
	if (location) {
		return location;
	}

	struct uio		user_io;
	struct iovec	user_iovec;

	mk_useruio(&user_iovec, &user_io, buf, buflen, ftent->offset, UIO_READ);
	location = VOP_GETDIRENTRY(ftent->vn, &user_io);
	if (location) {
		return location;
	}

	if (retval) {
		*retval = buflen - user_io.uio_resid;
	}

	return 0;
}

/* END A3 SETUP */
