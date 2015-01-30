/*
 * Copyright (c) 2004, 2008
 *	The President and Fellows of Harvard College.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE UNIVERSITY AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE UNIVERSITY OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */
#define    SIGHUP        1    /* terminate process */
#define    SIGINT        2    /* terminate process */
#define    SIGQUIT        3    /* unimplemented */
#define    SIGILL        4    /* unimplemented */
#define    SIGTRAP        5    /* unimplemented */
#define    SIGABRT        6    /* unimplemented */
#define    SIGEMT        7    /* unimplemented */
#define    SIGFPE        8    /* unimplemented */
#define    SIGKILL        9    /* terminate process */
#define    SIGBUS        10    /* unimplemented */
#define    SIGSEGV        11    /* unimplemented */
#define    SIGSYS        12    /* unimplemented */
#define    SIGPIPE        13    /* unimplemented */
#define    SIGALRM        14    /* unimplemented */
#define    SIGTERM        15    /* terminate process */
#define    SIGURG        16    /* unimplemented */
#define    SIGSTOP        17    /* stop process from executing until SIGCONT received */
#define    SIGTSTP        18    /* unimplemented */
#define    SIGCONT        19    /* continue after SIGSTOP received */
#define    SIGCHLD        20    /* unimplemented */
#define    SIGTTIN        21    /* unimplemented */
#define    SIGTTOU        22    /* unimplemented */
#define    SIGIO        23    /* unimplemented */
#define    SIGXCPU        24    /* unimplemented */
#define    SIGXFSZ        25    /* unimplemented */
#define    SIGVTALRM        26    /* unimplemented */
#define    SIGPROF        27    /* unimplemented */
#define    SIGWINCH        28    /* ignore signal */
#define    SIGINFO        29    /* ignore signal */
#define    SIGUSR1        30    /* unimplemented */
#define    SIGUSR2        31    /* unimplemented */

#ifndef _SIGNAL_H_
#define _SIGNAL_H_

/* In-kernel signal definitions. Get both the MD and MI parts. */

#include <kern/machine/signal.h>
#include <kern/signal.h>


#endif /* _SIGNAL_H_ */
