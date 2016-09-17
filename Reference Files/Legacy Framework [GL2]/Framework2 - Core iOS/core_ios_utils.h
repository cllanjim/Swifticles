//
//  core_ios_utils.h
//  AugmentedReality
//
//  Created by Nick Raptis on 1/8/14.
//  Copyright (c) 2014 Chrysler Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AssetsLibrary/AssetsLibrary.h>

void os_exportPNGImage(UIImage *pImage, const char *pPath);

void os_exportJPEGImage(UIImage *pImage, const char *pPath, float pQuality);

bool os_exportToPhotoLibrary(UIImage *pImage);
