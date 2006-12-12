#*******************************************************************************
# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at 
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
#     IBM Corporation - initial API and implementation
#     Kevin Cornell (Rational Software Corporation)
#     Tom Tromey (Red Hat, Inc.)
#*******************************************************************************
include ../make_version.mak
# Makefile for creating the GTK eclipse launcher program.
#
# This makefile expects the utility "pkg-config" to be in the PATH.

# This makefile expects the following environment variables set:
#
# PROGRAM_OUTPUT  - the filename of the output executable
# DEFAULT_OS      - the default value of the "-os" switch
# DEFAULT_OS_ARCH - the default value of the "-arch" switch
# DEFAULT_WS      - the default value of the "-ws" switch
# JAVA_JNI        
#default value for PROGRAM_OUTPUT
ifeq ($(PROGRAM_OUTPUT),)
  PROGRAM_OUTPUT=eclipse
endif

PROGRAM_LIBRARY=$(PROGRAM_OUTPUT)_$(LIB_VERSION).so

# Define the object modules to be compiled and flags.
CC=gcc
MAIN_OBJS = eclipseMain.o
COMMON_OBJS = eclipseConfig.o eclipseCommon.o eclipseGtkCommon.o
DLL_OBJS	= eclipse.o eclipseGtk.o eclipseUtil.o eclipseJNI.o eclipseMozilla.o

EXEC = $(PROGRAM_OUTPUT)
DLL = $(PROGRAM_LIBRARY)
LIBS = `pkg-config --libs-only-L gtk+-2.0` -lgtk-x11-2.0 -lgdk_pixbuf-2.0 -lgobject-2.0 -lgdk-x11-2.0 -lpthread
LFLAGS = -shared -fpic -Wl,--export-dynamic 
CFLAGS = -g -s -Wall\
	-fpic \
	-DLINUX \
	-DMOZILLA_FIX \
	-DDEFAULT_OS="\"$(DEFAULT_OS)\"" \
	-DDEFAULT_OS_ARCH="\"$(DEFAULT_OS_ARCH)\"" \
	-DDEFAULT_WS="\"$(DEFAULT_WS)\"" \
	-I. \
	-I.. \
	-I$(JAVA_JNI) \
	`pkg-config --cflags gtk+-2.0`

all: $(EXEC) $(DLL)

eclipse.o: ../eclipse.c ../eclipseOS.h ../eclipseCommon.h ../eclipseJNI.h
	$(CC) $(CFLAGS) -c ../eclipse.c -o eclipse.o

eclipseMain.o: ../eclipseUnicode.h ../eclipseCommon.h ../eclipseMain.c 
	$(CC) $(CFLAGS) -c ../eclipseMain.c -o eclipseMain.o
	
eclipseCommon.o: ../eclipseCommon.h ../eclipseUnicode.h ../eclipseCommon.c
	$(CC) $(CFLAGS) -c ../eclipseCommon.c

eclipseGtkCommon.o: ../eclipseCommon.h ../eclipseOS.h eclipseGtkCommon.c
	$(CC) $(CFLAGS) -c eclipseGtkCommon.c -o eclipseGtkCommon.o
	
eclipseUtil.o: ../eclipseUtil.c ../eclipseUtil.h ../eclipseOS.h
	$(CC) $(CFLAGS) -c ../eclipseUtil.c -o eclipseUtil.o

eclipseJNI.o: ../eclipseJNI.c ../eclipseCommon.h ../eclipseOS.h ../eclipseJNI.h
	$(CC) $(CFLAGS) -c ../eclipseJNI.c -o eclipseJNI.o
	
eclipseConfig.o: ../eclipseConfig.c ../eclipseConfig.h ../eclipseOS.h
	$(CC) $(CFLAGS) -c ../eclipseConfig.c -o eclipseConfig.o
	
eclipseMozilla.o: ../eclipseMozilla.c ../eclipseMozilla.h ../eclipseOS.h
	$(CC) $(CFLAGS) -c ../eclipseMozilla.c -o eclipseMozilla.o

$(EXEC): $(MAIN_OBJS) $(COMMON_OBJS)
	$(CC) -o $(EXEC) $(MAIN_OBJS) $(COMMON_OBJS) $(LIBS)
	
$(DLL): $(DLL_OBJS) $(COMMON_OBJS)
	$(CC) $(LFLAGS) -o $(DLL) $(DLL_OBJS) $(COMMON_OBJS) $(LIBS)

install: all
	cp $(EXEC) $(DLL) $(OUTPUT_DIR)
	rm -f $(EXEC) $(DLL) $(MAIN_OBJS) $(COMMON_OBJS) $(DLL_OBJS)

clean:
	rm -f $(EXEC) $(MAIN_OBJS) $(COMMON_OBJS) $(DLL_OBJS)
