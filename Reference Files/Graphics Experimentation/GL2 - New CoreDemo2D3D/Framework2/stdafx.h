//
//  stdafx.h
//  CoreDemo
//
//  Created by Nick Raptis on 9/26/13.
//  Copyright (c) 2013 Union AdWorks Inc. All rights reserved.
//

#ifndef FRAMEWORK_STDAFX_H
#define FRAMEWORK_STDAFX_H

#define D_R 0.01745329251994329576923690768488
#define R_D 57.2957795130823208767981548141052
#define PI 3.1415926535897932384626433832795028841968
#define PI2 (2 * PI)
#define PI_2 (PI / 2.0f)

#define SQRT_EPSILON 0.001f

#include <algorithm>
#include <vector>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <cstdlib>
#include <sys/time.h>

#include "core_gfx.h"
#include "core_os.h"
#include "core_social.h"

#include <sys/stat.h>

#include "FRandomizer.h"
#include "FList.h"
#include "FString.h"
#include "FSprite.h"
#include "FMatrix.h"
#include "FView.h"
#include "FRect.h"
#include "FFile.h"
#include "FVec2.h"
#include "FVec3.h"
#include "FMath.h"

extern FRandomizer gRand;

#endif
