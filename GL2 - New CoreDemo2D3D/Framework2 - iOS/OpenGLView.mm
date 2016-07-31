//
//  OpenGLView.m
//  HelloOpenGL
//
//  Created by Ray Wenderlich on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//#import <GLKit/GLKit.h>
#import "OpenGLView.h"
#import "core_gfx.h"
#import "FApp.h"
#import "FMatrix.h"

@implementation OpenGLView

- (id)initWithFrame:(CGRect)frame
{
    //didTestLoad = false;
    //testRot = 0.0f;
    
    self = [super initWithFrame:frame];
    
    if(self)
    {
        _eaglLayer = (CAEAGLLayer*) self.layer;
        _eaglLayer.opaque = YES;
        
        EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES3;
        
        _context = [[EAGLContext alloc] initWithAPI:api];
        
        if(!_context)
        {
            NSLog(@"Failed to initialize OpenGLES 2.0 context");
            exit(1);
        }
        
        if(![EAGLContext setCurrentContext:_context])
        {
            NSLog(@"Failed to set current OpenGL context");
            exit(1);
        }
        
        glGenRenderbuffers(1, &gGLBufferDepth);
        glBindRenderbuffer(GL_RENDERBUFFER, gGLBufferDepth);
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.frame.size.width, self.frame.size.height);
        
        glGenRenderbuffers(1, &gGLBufferRender);
        glBindRenderbuffer(GL_RENDERBUFFER, gGLBufferRender);
        [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
        
        gfx_initialize();
        
        //[self testLoad];
    }
    
    return self;
}

/*
- (void)testLoad
{
    mSprite1.Load("snail_uvw");
    mSprite2.Load("sample_image_2");
    
    mSnail.LoadO("snail.obj");
    
    //LoadOBJIndexed(&mSnail, "snail.obj");
    
    mSnail.PrintOverview();
    
    int aXYZCount = mSnail.mXYZCount * 3;
    int aUVWCount = mSnail.mUVWCount * 3;
    
    mModelBufferData = new float[aXYZCount + aUVWCount];
    
    for(int i=0;i<aXYZCount;i++)
    {
        mModelBufferData[i] = mSnail.mXYZ[i];
    }
    for(int i=0;i<aUVWCount;i++)
    {
        mModelBufferData[i + aXYZCount] = mSnail.mUVW[i];
    }
    
    //for(int i=0;i<128;i++)
    //{
    //    mTest3DList += new TestObject3D();
    //}
    
    glGenBuffers(1, &mModelVertex);
    glBindBuffer(GL_ARRAY_BUFFER, mModelVertex);
    
    glBufferData(GL_ARRAY_BUFFER, 4 * (aXYZCount + aUVWCount), mModelBufferData, GL_STATIC_DRAW);
    
    glGenBuffers(1, &mModelIndex);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, mModelIndex);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, 4 * mSnail.mIndexCount, mSnail.mIndex, GL_STATIC_DRAW);
    
}
*/

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

-(void)render
{
    /*
    testRot += 0.0125f;
    if(testRot > (3.14159 * 2))testRot -= (3.14159 * 2);
    
    
    glEnableVertexAttribArray(gGLSlotPosition);
    glEnableVertexAttribArray(gGLSlotTexCoord);
    
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    
    glClearColor(0.4f, 0.0f, 0.0f, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glEnable(GL_DEPTH_TEST);
    
    
    glViewport(0, 0, gDeviceWidth, gDeviceHeight);
    
    
    FMatrix aFMatrix;
    
    //GLKMatrix4 aProjectionMatrix = GLKMatrix4Identity;
    //aProjectionMatrix = GLKMatrix4MakeOrtho(0.0f, gDeviceWidth, gDeviceHeight, 0.0f, 2048.0f, -2048.0f);
    
    
    
    FMatrix aDummy = FMatrixCreateOrtho(0.0f, gDeviceWidth, gDeviceHeight, 0.0f, 2048.0f, -2048.0f);
    glUniformMatrix4fv(gGLUniformProjection, 1, 0, aDummy.m);
    
    //GLKMatrix4 aModelMatrix = GLKMatrix4Identity;
    //aModelMatrix = GLKMatrix4Translate(aModelMatrix, 250.0f, 150.0f + sin(testRot) * 100.0f, 0.0f);
    
    FMatrix aTrannyMat = FMatrixCreateTranslation(250.0f, 150.0f + sin(testRot) * 100.0f, 0.0f);
    
    glUniformMatrix4fv(gGLUniformModelView, 1, 0, aTrannyMat.m);
    
    
    
    glBindBuffer(GL_ARRAY_BUFFER, mSprite1.mBufferSlotVertex);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, mSprite1.mBufferSlotIndex);
    
    glVertexAttribPointer(gGLSlotPosition, 2, GL_FLOAT, GL_FALSE, 0, 0);
    glVertexAttribPointer(gGLSlotTexCoord, 2, GL_FLOAT, GL_FALSE, 0, (GLvoid*)(8 * 4));//(GLvoid*)(mSnail.mXYZCount));
    
    //glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, mSprite1.mBindIndex);
    glUniform1i(gGLUniformTexture, 0);
    
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, 0);
    
    
    
    
    
    
    aDummy = FMatrixCreatePerspective(140.0f, ((float)gDeviceWidth) / ((float)gDeviceHeight), 0.1f, 255.0f);
    
    glUniformMatrix4fv(gGLUniformProjection, 1, 0, aDummy.m);
    
    glClear(GL_DEPTH_BUFFER_BIT);
    
    glBindBuffer(GL_ARRAY_BUFFER, mModelVertex);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, mModelIndex);
    
    glVertexAttribPointer(gGLSlotPosition, 3, GL_FLOAT, GL_FALSE, 0, 0);
    glVertexAttribPointer(gGLSlotTexCoord, 3, GL_FLOAT, GL_FALSE, 0, (GLvoid*)(mSnail.mXYZCount * 3 * 4));//(GLvoid*)(mSnail.mXYZCount));
    
    //glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, mSprite1.mBindIndex);
    glUniform1i(gGLUniformTexture, 0);
    
    FMatrix aLook = FMatrixCreateLookAt(sin(testRot) * 20.0f, cos(testRot) * 20.0f, sin(testRot) * 10.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, -1.0f);
    
    EnumList(TestObject3D, aObject, mTest3DList)
    {
        aObject->Draw();
        
        
        
        FMatrix aMat = aLook;//FMatrixCreateWithArray(aModelMatrix.m);
        
        aMat = FMatrixTranslate(aMat, aObject->mX, aObject->mY, aObject->mZ);
        
        aMat = FMatrixRotate(aMat, D_R * aObject->mRotX, 1, 0, 0);
        aMat = FMatrixRotate(aMat, D_R * aObject->mRotY, 0, 1, 0);
        aMat = FMatrixRotate(aMat, D_R * aObject->mRotZ, 0, 0, 1);
        
        glUniformMatrix4fv(gGLUniformModelView, 1, 0, aMat.m);
        
        glDrawElements(GL_TRIANGLES, mSnail.mIndexCount, GL_UNSIGNED_SHORT, 0);
    }
    
    glDisable(GL_DEPTH_TEST);
    
    */
    
    if(gAppBase)
    {
        
        gAppBase->BaseUpdate();
        gAppBase->BaseDraw();
    
    }
    
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    
	
	for(int i=0;i<[touches count];i++)
	{
		UITouch *aTouch = [[touches allObjects] objectAtIndex:i];
		if([aTouch phase] == UITouchPhaseBegan)
		{
			CGPoint aLocation = [aTouch locationInView:self];
            
            gAppBase->BaseTouchDown(aLocation.x, aLocation.y, (__bridge void*)aTouch);
		}
	}
    
    gAppBase->BaseMouseDown(location.x, location.y);
}


- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
	for(int i=0;i<[touches count];i++)
	{
		UITouch *aTouch = [[touches allObjects] objectAtIndex:i];
		
		
		if([aTouch phase] == UITouchPhaseMoved)
		{
			CGPoint aLocation = [aTouch locationInView:self];
			gAppBase->BaseTouchMove(aLocation.x, aLocation.y, (__bridge void*)aTouch);
		}
	}
    
    gAppBase->BaseMouseMove(location.x, location.y);
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
	for(int i=0;i<[touches count];i++)
	{
		UITouch *aTouch = [[touches allObjects] objectAtIndex:i];
		if([aTouch phase] == UITouchPhaseEnded || [aTouch phase]  == UITouchPhaseCancelled)
		{
			CGPoint aLocation = [aTouch locationInView:self];
			gAppBase->BaseTouchUp(aLocation.x, aLocation.y, (__bridge void*)aTouch);
		}
	}
    
    gAppBase->BaseMouseUp(location.x, location.y);
}

- (void)dealloc
{
    //[_context release];
    //_context = nil;
    //[super dealloc];
}

@end
