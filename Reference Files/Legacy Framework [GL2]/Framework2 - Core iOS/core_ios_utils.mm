//
//  core_ios_utils.m
//  AugmentedReality
//
//  Created by Nick Raptis on 1/8/14.
//  Copyright (c) 2014 Chrysler Group LLC. All rights reserved.
//

#import "core_ios_utils.h"



void os_exportPNGImage(UIImage *pImage, const char *pPath)
{
	NSData *aImageData = UIImagePNGRepresentation(pImage);
	[aImageData writeToFile:[[NSString alloc] initWithUTF8String:(pPath)] atomically:YES];
}

void os_exportJPEGImage(UIImage *pImage, const char *pPath, float pQuality)
{
	NSData *aImageData = UIImageJPEGRepresentation(pImage, pQuality);
	[aImageData writeToFile:[[NSString alloc] initWithUTF8String:(pPath)] atomically:YES];
}

bool os_exportToPhotoLibrary(UIImage *pImage)
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:[pImage CGImage]
                              orientation:(ALAssetOrientation)[pImage imageOrientation]
                          completionBlock:^(NSURL *assetURL, NSError *error)
     {
         NSLog(@"Image Export Error[ %@ ]", error);
         
         if(error)
         {
             
         }
     }];
    
    return true;
}

