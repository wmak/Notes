/*
 * Process-related syscalls.
 * New for ASST1.
 */

#include <types.h>
#include <kern/errno.h>
#include <lib.h>
#include <thread.h>
#include <current.h>
#include <pid.h>
#include <machine/trapframe.h>
#include <syscall.h>
#include <kern/wait.h>
#include <copyinout.h>

/*
 * sys_fork
 * 
 * create a new process, which begins executing in md_forkentry().
 */


int
sys_fork(struct trapframe *tf, pid_t *retval)
{
	struct trapframe *ntf; /* new trapframe, copy of tf */
	int result;

	/*
	 * Copy the trapframe to the heap, because we might return to
	 * userlevel and make another syscall (changing the trapframe)
	 * before the child runs. The child will free the copy.
	 */

	ntf = kmalloc(sizeof(struct trapframe));
	if (ntf==NULL) {
		return ENOMEM;
	}
	*ntf = *tf; /* copy the trapframe */

	result = thread_fork(curthread->t_name, enter_forked_process, 
			     ntf, 0, retval);
	if (result) {
		kfree(ntf);
		return result;
	}

	return 0;
}

/*
 * sys_getpid
 * 
 * Return the pid through reference instead so that we can return error code
 */
int
sys_getpid(pid_t *retval) 
{
	// Set the return value
	if (retval) // check NULL wasn't passed
		*retval = curthread->t_pid;

	// Return 0 for success (-1 for fail)
	return 0;
}



/*
 * sys_waitpid
 * Wait by calling pid_join based on the following:
 * -pid/returncode/flags invalid we return error
 * -If the process exists
 * 		-pid NOT a child of calling process -
 * 		-pid the child of the calling process
 */
int
sys_waitpid(pid_t pid, userptr_t returncode, int flags, int *retval)
{
	pid_t ret;
	
	//pid doesnt exist return error
	if (pid == INVALID_PID){
		*retval = EINVAL;
		return -1;
	}
	//Bad pointer value for returncode return error
	if (returncode == NULL){
		*retval = EINVAL;
		return -1;
	}
	//flags supported are 0 and WNOHANG ONLY! return error otherwise
	if (flags != 0 && flags != WNOHANG){
		*retval = EINVAL;
		return -1;
	}

	//Create pidinfo struct to check if child
//	struct pidinfo *mypi = pi_get(pid);

//	//pid exists and not child return error
//	if (mypi->pi_ppid != curthread->t_pid){
//		return ECHILD;
//	}
//	else{//otherwise pid exists and Child we call pid_join
//		return pid_join(pid, returncode, flags);
//	}
	//error otherwise
	//return -1;

	int kstatus;
	copyin(returncode, &kstatus, sizeof(int));
	ret = pid_join(pid, &kstatus, flags);
	copyout(&kstatus, returncode, sizeof(int));
	
	if (retval && ret < 0)
		*retval = -ret; // convert the negative error code back to normal
	else if (retval)
		*retval = ret;

	if (ret < 0)
		return -1;
	return 0;

}


/*
 * sys_kill
 * Placeholder comment to remind you to implement this.
 */
int
sys_kill(pid_t pid, int sig, int *retval){
	int result = pid_kill(pid, sig);

	if (retval) 
		*retval = result;
	
	if (result)
		return 0;
	return -1;
}
