//
//  core_os.m
//  CoreDemo
//
//  Created by Nick Raptis on 9/26/13.
//  Copyright (c) 2013 Union AdWorks Inc. All rights reserved.
//


#import "core_os.h"
#import "stdafx.h"
#import <UIKit/UIKit.h>

float gOSVersion;

FString gDirBundle;
FString gDirDocuments;

int gDeviceWidth = 800;
int gDeviceHeight = 600;

float gDeviceWidth2 = 400.0f;
float gDeviceHeight2 = 300.0f;

int gScreenWidth = 800;
int gScreenHeight = 600;

float gScreenWidth2 = 400.0f;
float gScreenHeight2 = 300.0f;

void os_initialize()
{
    gOSVersion = os_getVersion();

    gDeviceWidth = os_device_width();
    gDeviceHeight = os_device_height();
    
    gDeviceWidth2 = (float)gDeviceWidth / 2.0f;
    gDeviceHeight2 = (float)gDeviceHeight / 2.0f;
    
    gScreenWidth = os_screen_width();
    gScreenHeight = os_screen_height();
    
    gScreenWidth2 = (float)gScreenWidth / 2.0f;
    gScreenHeight2 = (float)gScreenHeight / 2.0f;
    
    gDirBundle = os_getBundleDirectory();
    gDirDocuments = os_getDocumentsDirectory();
    
    printf("Device [%d x %d] Screen [%d x %d] Ver[%f]\n", gDeviceWidth, gDeviceHeight, gScreenWidth, gScreenHeight, gOSVersion);
}

float os_getVersion()
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

int os_device_width()
{
    int aReturn = 0;
    
    if(os_is_portrait())
    {
        //aReturn = [[UIScreen mainScreen] applicationFrame].size.width;
        aReturn = [UIScreen mainScreen].bounds.size.width;
    }
    else
    {
        //aReturn = [[UIScreen mainScreen] applicationFrame].size.height;
        aReturn = [UIScreen mainScreen].bounds.size.height;
    }
    
    return aReturn;
}

int os_device_height()
{
    int aReturn = 0;
    
    if(os_is_portrait())
    {
        //aReturn = [[UIScreen mainScreen] applicationFrame].size.height;
        aReturn = [UIScreen mainScreen].bounds.size.height;
    }
    else
    {
        //aReturn = [[UIScreen mainScreen] applicationFrame].size.width;
        aReturn = [UIScreen mainScreen].bounds.size.width;
    }
    
    return aReturn;
}

int os_screen_width()
{
    int aReturn = 0;
    
    if(os_is_portrait())
    {
        aReturn = [UIScreen mainScreen].currentMode.size.width;
    }
    else
    {
        aReturn = [UIScreen mainScreen].currentMode.size.height;
    }
    
    return aReturn;
}

int os_screen_height()
{
    int aReturn = 0;
    
    if(os_is_portrait())
    {
        aReturn = [UIScreen mainScreen].currentMode.size.height;
    }
    else
    {
        aReturn = [UIScreen mainScreen].currentMode.size.width;
    }
    
    return aReturn;
}

bool os_fileExists(const char *pPath)
{
    bool aReturn = false;
    if(pPath)aReturn = access(pPath,0)==0;
    
    if(aReturn)
    {
        NSLog(@"Exists!!! [%s]", pPath);
    }
    else
    {
        NSLog(@"File Doesn't Exist [%s]", pPath);
    }
    
    return aReturn;
}

bool os_fileExists(FString pPath)
{
    return os_fileExists((const char *)(pPath.c()));
}

bool os_is_portrait()
{
    return true;
}

void os_log(const char *pMessage)
{
    NSLog(@"%s", pMessage);
}

unsigned long os_system_time()
{
	struct timeval aTime;
	gettimeofday(&aTime,NULL);
	return aTime.tv_sec*1000000+aTime.tv_usec;
}

unsigned char *os_read_file(const char *pFileName, unsigned int &pLength)
{
    unsigned char *aReturn = nil;
    pLength = 0;
    if(pFileName)
    {
        int aFile=open(pFileName, O_RDONLY);
        
        if(aFile==-1)aFile=open(FString(gDirBundle + pFileName).c(),O_RDONLY);
        if(aFile==-1)aFile=open(FString(gDirDocuments + pFileName).c(),O_RDONLY);
        if(aFile!=-1)
        {
            struct stat aFileStats;
            if(fstat(aFile,&aFileStats) == 0)pLength=(unsigned int)aFileStats.st_size;
            if(pLength >= 1)
            {
                aReturn = new unsigned char[pLength+32];
                read(aFile, aReturn, pLength);
            }
            else
            {
                pLength = 0;
            }
            close(aFile);
        }
    }
    
    return aReturn;
}

bool os_write_file(const unsigned char *pData, unsigned int pLength)
{
    //Todo:
    //This...
    
    return true;
}

FString os_getBundleDirectory()
{
    FString aPath;
    
	CFURLRef aResourceURL = CFBundleCopyBundleURL(CFBundleGetMainBundle());
	CFStringRef aStringRef = CFURLCopyFileSystemPath(aResourceURL, kCFURLPOSIXPathStyle);
	CFRelease(aResourceURL);
	char aCharPath[1024];
	CFStringGetCString(aStringRef,aCharPath,FILENAME_MAX,kCFStringEncodingASCII);
	CFRelease(aStringRef);
    
    aPath = aCharPath;
    
    aPath += "/";
    
    printf("Bundle: [%s]\n", aPath.c());
    
    return aPath;
}

FString os_getDocumentsDirectory()
{
    FString aPath;
    
    NSArray *aPathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *aDocumentDirectory = [aPathArray objectAtIndex:0];
	//char aCharPath[1024];
    //[docDir getCString:aCharPath maxLength:PATH_MAX encoding:NSASCIIStringEncoding];
    aPath = [aDocumentDirectory UTF8String];
    
    aPath += "/";
    
    printf("Documents: [%s]\n", aPath.c());
    
    return aPath;
}



unsigned int *os_load_image(char *pFile,int &pWidth, int &pHeight)
{
    UIImage *aImage;
    NSString *aPath=[NSString stringWithUTF8String:pFile];
    
    aImage = [UIImage imageWithContentsOfFile:aPath];
    
    if(aImage == nil)aImage = [UIImage imageNamed:aPath];
    
    pWidth=0;
    pHeight=0;
    
    unsigned int *aData=0;
    
    if(aImage)
    {
        if(aImage.size.width>0&&aImage.size.height>0)
        {
            pWidth=aImage.size.width;
            pHeight=aImage.size.height;
            
            CGImageRef aCGImage=aImage.CGImage;
            aData = new unsigned int[(unsigned int)(pWidth*pHeight)];
            CGColorSpaceRef aColorSpace=CGColorSpaceCreateDeviceRGB();
            CGContextRef aCGContext=CGBitmapContextCreate(aData, pWidth, pHeight, 8, pWidth*4, aColorSpace, kCGImageAlphaPremultipliedLast);
            CGContextClearRect(aCGContext, CGRectMake(0, 0, pWidth, pHeight));
            CGContextDrawImage(aCGContext,CGRectMake(0, 0, pWidth, pHeight),aCGImage);
            CGContextRelease(aCGContext);
            CGColorSpaceRelease(aColorSpace);
        }
    }
    return aData;
}

