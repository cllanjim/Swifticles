//
//  core_os.h
//  CoreDemo
//
//  Created by Nick Raptis on 9/26/13.
//  Copyright (c) 2013 Union AdWorks Inc. All rights reserved.
//

#ifndef FRAMEWORK_CORE_OS
#define FRAMEWORK_CORE_OS

#include "FString.h"

extern float gOSVersion;

extern int gDeviceWidth;
extern int gDeviceHeight;

extern float gDeviceWidth2;
extern float gDeviceHeight2;

extern int gScreenWidth;
extern int gScreenHeight;

extern float gScreenWidth2;
extern float gScreenHeight2;

extern FString gDirBundle;
extern FString gDirDocuments;

void os_initialize();

float os_getVersion();

int os_device_width();
int os_device_height();

int os_screen_width();
int os_screen_height();

bool os_fileExists(const char *pPath);
bool os_fileExists(FString pPath);

bool os_is_portrait();

void os_log(const char *pMessage);

unsigned long os_system_time();

unsigned char *os_read_file(const char *pFileName, unsigned int &pLength);
bool os_write_file(const unsigned char *pData, unsigned int pLength);

FString os_getBundleDirectory();
FString os_getDocumentsDirectory();

unsigned int *os_load_image(char *pFile,int &pWidth, int &pHeight);

#endif
