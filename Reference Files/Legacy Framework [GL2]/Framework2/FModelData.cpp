//
//  FModelData.cpp
//  Chrysler300ReLoadDataed
//
//  Created by Nick Raptis on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "stdafx.h"
#include "FModelData.h"
#include "FModelDataOptimizer.h"
#include "FApp.h"

bool gModelDiscardNormals = false;
bool gModelDiscardUVW = false;

FModelData::FModelData()
{
    mBindIndex=-1;
    mXYZ=0;mUVW=0;mNormal=0;
    mXYZCount=0;mXYZSize=0;
    mUVWCount=0;mUVWSize=0;
    mNormalCount=0;mNormalSize=0;
}

FModelData::~FModelData()
{
    Free();
    
    if(mBindIndex != -1)
    {
        if(gAppBase)
        {
            gAppBase->BindRemove(mBindIndex);
        }
    }
    
    mBindIndex = -1;
}

void FModelData::Free()
{
    DiscardXYZ();
    DiscardUVW();
    DiscardNormal();
}

void FModelData::DiscardXYZ()
{
    delete[]mXYZ;
    mXYZ=0;
    mXYZCount=0;
    mXYZSize=0;
}

void FModelData::DiscardUVW()
{
    delete[]mUVW;
    mUVW=0;
    mUVWCount=0;
    mUVWSize=0;
}

void FModelData::DiscardNormal()
{
    delete[]mNormal;
    mNormal=0;
    mNormalCount=0;
    mNormalSize=0;
}

float *FModelData::ResizeTriple(float *pData, int pCount, int pSize)
{
    int aDataSize = (pSize * 3);
    int aDataCount = (pCount * 3);
    
    float *aNew = new float[aDataSize+1];
    for(int i=0;i<aDataCount;i++)
    {
        aNew[i] = pData[i];
    }
    for(int i=aDataCount;i<aDataSize;i++)
    {
        aNew[i] = 0;
    }
    delete[]pData;
    
    return aNew;
}

void FModelData::SetTriple(unsigned int pIndex, float *pArray, float pValue1, float pValue2, float pValue3)
{
    unsigned int aIndex = pIndex * 3;
    pArray[aIndex]=pValue1;
    pArray[aIndex+1]=pValue2;
    pArray[aIndex+2]=pValue3;
}

void FModelData::AddXYZ(float pX, float pY, float pZ)
{
    if(mXYZCount >= mXYZSize)SizeXYZ(mXYZCount + mXYZCount / 2 + 1);
    SetTriple(mXYZCount, mXYZ, pX, pY, pZ);
    mXYZCount++;
}

void FModelData::SizeXYZ(int pSize)
{
    if(pSize != 0)mXYZ = ResizeTriple(mXYZ, mXYZCount, pSize);
    mXYZSize = pSize;
}

void FModelData::AddUVW(float pU, float pV, float pW)
{
    if(mUVWCount >= mUVWSize)SizeUVW(mUVWCount + mUVWCount / 2 + 1);
    SetTriple(mUVWCount, mUVW, pU, pV, pW);
    mUVWCount++;
}

void FModelData::SizeUVW(int pSize)
{
    if(pSize != 0)mUVW = ResizeTriple(mUVW, mUVWCount, pSize);
    mUVWSize = pSize;
}

void FModelData::AddNormal(float pNormX, float pNormY, float pNormZ)
{
    if(mNormalCount >= mNormalSize)SizeNormal(mNormalCount + mNormalCount / 2 + 1);
    SetTriple(mNormalCount, mNormal, pNormX, pNormY, pNormZ);
    mNormalCount++;
}

void FModelData::SizeNormal(int pSize)
{
    if(pSize != 0)mNormal = ResizeTriple(mNormal, mNormalCount, pSize);
    mNormalSize = pSize;
}

float FModelData::GetX(int pIndex)
{
    //if(pIndex>=0 && pIndex<mXYZCount)
    return mXYZ[pIndex*3];
    //printf("Error Fetching X [%d / %d]\n", pIndex, mXYZCount);
    //return 0;
}

float FModelData::GetY(int pIndex)
{
    //if(pIndex>=0 && pIndex<mXYZCount)
    return mXYZ[pIndex*3+1];
    //return 0;
}

float FModelData::GetZ(int pIndex)
{
    //if(pIndex>=0 && pIndex<mXYZCount)
    return mXYZ[pIndex*3+2];
    //return 0;
}


float FModelData::GetU(int pIndex)
{
    //if(pIndex>=0 && pIndex<mUVWCount)
    return mUVW[pIndex*3];
    //return 0;
}

float FModelData::GetV(int pIndex)
{
    //if(pIndex>=0 && pIndex<mUVWCount)
    return mUVW[pIndex*3+1];
    //return 0;
}

float FModelData::GetW(int pIndex)
{
    //if(pIndex>=0 && pIndex<mUVWCount)
    return mUVW[pIndex*3+2];
    //return 0;
}

float FModelData::GetNormX(int pIndex)
{
    //if(pIndex>=0 && pIndex<mNormalCount)
    return mNormal[pIndex*3];
    //return 0;
}

float FModelData::GetNormY(int pIndex)
{
    //if(pIndex>=0 && pIndex<mNormalCount)
    return mNormal[pIndex*3+1];
    //return 0;
}

float FModelData::GetNormZ(int pIndex)
{
    //if(pIndex>=0 && pIndex<mNormalCount)
    return mNormal[pIndex*3+2];
    //return 0;
}

void FModelData::InvertU()
{
    int aCount = mUVWCount * 3;
    for(int i=0;i<aCount;i+=3)mUVW[i]=(1-mUVW[i]);
}

void FModelData::InvertV()
{
    int aCount = mUVWCount * 3;
    for(int i=1;i<aCount;i+=3)mUVW[i]=(1-mUVW[i]);
}

void FModelData::InvertW()
{
    int aCount = mUVWCount * 3;
    for(int i=2;i<aCount;i+=3)mUVW[i]=(1-mUVW[i]);
}

void FModelData::FlipXY()
{
    
    float aHold=0;
    int aCount = mXYZCount * 3;
    for(int i=0;i<aCount;i+=3)
    {
        aHold=mXYZ[i];
        mXYZ[i]=mXYZ[i+1];
        mXYZ[i+1]=aHold;
    }
    
    aCount = mNormalCount * 3;
    for(int i=0;i<aCount;i+=3)
    {
        aHold=mNormal[i];
        mNormal[i]=mNormal[i+1];
        mNormal[i+1]=aHold;
    }
}

void FModelData::FlipYZ()
{
    float aHold=0;
    int aCount = mXYZCount * 3;
    for(int i=0;i<aCount;i+=3)
    {
        aHold=mXYZ[i+1];
        mXYZ[i+1]=mXYZ[i+2];
        mXYZ[i+2]=aHold;
    }
    
    aCount = mNormalCount * 3;
    for(int i=0;i<aCount;i+=3)
    {
        aHold=mNormal[i];
        mNormal[i]=-mNormal[i+2];
        mNormal[i+2]=aHold;
    }
}

void FModelData::FlipZX()
{
    float aHold=0;
    int aCount = mXYZCount * 3;
    for(int i=0;i<aCount;i+=3)
    {
        aHold=mXYZ[i];
        mXYZ[i]=mXYZ[i+2];
        mXYZ[i+2]=aHold;
    }
    
    aCount = mNormalCount * 3;
    for(int i=0;i<aCount;i+=3)
    {
        aHold= mNormal[i];
        mNormal[i]=mNormal[i+2];
        mNormal[i+2]=aHold;
    }
}


void FModelData::NegateX()
{
    int aCount = mXYZCount * 3;
    for(int i=0;i<aCount;i+=3)
    {
        mXYZ[i] = (-mXYZ[i]);
    }
}

void FModelData::NegateY()
{
    int aCount = mXYZCount * 3;
    for(int i=1;i<aCount;i+=3)
    {
        mXYZ[i] = (-mXYZ[i]);
    }
}

void FModelData::NegateZ()
{
    int aCount = mXYZCount * 3;
    for(int i=2;i<aCount;i+=3)
    {
        mXYZ[i] = (-mXYZ[i]);
    }
}

/*
void FModelData::SetSprite(Sprite *pSprite, bool pFixUVW)
{
    
    if(pSprite)
    {
        
        mBindIndex = pSprite->mBindIndex;
        
        if(pFixUVW)
        {
            
            
             float aStartU = pSprite->GetStartU();
             float aStartV = pSprite->GetStartV();
             
             float aEndU = pSprite->GetEndU();
             float aEndV = pSprite->GetEndV();
 
            
            FitUVW(aStartU, aEndU, aStartV, aEndV);
            
            //printf("\n\nUVW Fitting TO: [%f %f %f %f]\n\n", aStartU, aEndU, aStartV, aEndV);
            //printf("\n...\n");
        }
    }
    
}
*/

void FModelData::FitUVW(float pStartU, float pEndU, float pStartV, float pEndV)
{
    //float aRangeU = pMaxU - pMinU;
    
    if((pStartU == 0) && (pStartV == 0) && (pEndU == 1) && (pEndV == 1))
    {
        return;
    }
    
    if(mUVWCount <= 0)return;
    
    float aSpanU = pEndU - pStartU;
    float aSpanV = pEndV - pStartV;
    
    int aIndex = 0;
    float aU, aV;
    for(int i=0;i<mUVWCount;i++)
    {
        aIndex = i * 3;
        
        aU = mUVW[aIndex];
        aV = mUVW[aIndex+1];
        
        //printf("UVW Was [%f %f]\n", aU, aV);
        
        aU = (pStartU + aSpanU * aU);
        aV = (pStartV + aSpanV * aV);
        
        //printf("UVW Now [%f %f]\n", aU, aV);
        
        mUVW[aIndex] = aU;
        mUVW[aIndex+1] = aV;
        
        
    }    
    
    /*
    float aStartU = pSprite->GetStartU();
    float aStartV = pSprite->GetStartV();
    float aEndU = pSprite->GetEndU();
    float aEndV = pSprite->GetEndV();
    
    if(aStartU == 0 && aEndU == 1 && aStartV == 0 && aEndV == 1)
    {
        
    }
    else
    {
        if(mUVW == 0)
        {
            
        }
        else
        {
            int aCount = mNodeCount;
            if(mIndexCount != 0)aCount = mIndexCount;
            
            
        }
    }
     
    */
}


void FModelData::CopyXYZ(float *pXYZ, int pCount)
{
    delete[]mXYZ;
    mXYZCount=0;
    mXYZSize=0;
    if((pXYZ!=0) && (pCount>0))
    {
        SizeXYZ(pCount);
        int aCount3 = (pCount * 3);
        mXYZ = new float[aCount3];
        for(int i=0;i<aCount3;i++)mXYZ[i] = pXYZ[i];
        mXYZCount = pCount;
    }
}

void FModelData::CopyUVW(float *pUVW, int pCount)
{
    delete[]mUVW;
    mUVWCount=0;
    mUVWSize=0;
    if((pUVW!=0) && (pCount>0))
    {
        SizeUVW(pCount);
        int aCount3 = (pCount * 3);
        mUVW = new float[aCount3];
        for(int i=0;i<aCount3;i++)mUVW[i] = pUVW[i];
        mUVWCount = pCount;
    }
}

void FModelData::CopyNorm(float *pNorm, int pCount)
{
    delete[]mNormal;
    mNormalCount=0;
    mNormalSize=0;
    if((pNorm!=0) && (pCount>0))
    {
        SizeNormal(pCount);
        int aCount3 = (pCount * 3);
        mNormal = new float[aCount3];
        for(int i=0;i<aCount3;i++)mNormal[i] = pNorm[i];
        mNormalCount = pCount;
    }
}

FModelData *FModelData::Clone()
{
    FModelData *aClone=new FModelData();
    aClone->CopyXYZ(mXYZ, mXYZCount);
    aClone->CopyUVW(mUVW, mUVWCount);
    aClone->CopyNorm(mNormal, mNormalCount);
    return aClone;
}

void FModelData::Print()
{
    
}

void FModelData::Save(const char *pFile)
{
    FFile aFFile;
    Save(&aFFile);
    aFFile.Save(pFile);
}

void FModelData::Save(FFile *pFile)
{
    if(!pFile)return;
    
    pFile->WriteInt(mXYZCount);
    pFile->WriteInt(mUVWCount);
    pFile->WriteInt(mNormalCount);
    
    int aXYZCount = mXYZCount * 3;
    int aUVWCount = mUVWCount * 3;
    int aNormalCount = mNormalCount * 3;
    
    for(int i=0;i<aXYZCount;i++)pFile->WriteFloat(mXYZ[i]);
    for(int i=0;i<aUVWCount;i++)pFile->WriteFloat(mUVW[i]);
    for(int i=0;i<aNormalCount;i++)pFile->WriteFloat(mNormal[i]);
}

void FModelData::LoadData(FFile *pFile)
{
    if(!pFile)return;
    
    int aXYZCount=pFile->ReadInt();
    int aUVWCount=pFile->ReadInt();
    int aNormalCount=pFile->ReadInt();
    
    DiscardXYZ();
    DiscardUVW();
    DiscardNormal();
    
    //mXYZCount=0;
    //mUVWCount=0;
    //mNormalCount=0;
    
    SizeXYZ(aXYZCount);
    SizeUVW(aUVWCount);
    SizeNormal(aNormalCount);
    
    mXYZCount=aXYZCount;
    mUVWCount=aUVWCount;
    mNormalCount=aNormalCount;
    
    aXYZCount *= 3;
    aUVWCount *= 3;
    aNormalCount *= 3;
    
    for(int i=0;i<aXYZCount;i++)mXYZ[i] = pFile->ReadFloat();
    for(int i=0;i<aUVWCount;i++)mUVW[i] = pFile->ReadFloat();
    for(int i=0;i<aNormalCount;i++)mNormal[i] = pFile->ReadFloat();
}

void FModelData::LoadData(const char *pFile)
{
    printf("LoadDataingFModelData[%s]\n", pFile);
    FFile aFFile;
    aFFile.Load(pFile);
    LoadData(&aFFile);
}


void FModelData::LoadOBJ(FFile *pFile)
{
    Free();
    
    if(pFile == 0)return;
    if(pFile->mLength <= 0)return;
    
    //FModelData *aReturn = new FModelData();
    
    FModelDataIndexed *aTemp = new FModelDataIndexed();
    
    //int aPreviousIndexStart = 0;
    int aError=0;
    
    float aX, aY, aZ,
    aU, aV, aW,
    aNX, aNY, aNZ;
    
    int aXYZIndex = 0;
    int aUVWIndex = 0;
    int aNormalIndex = 0;
    
	char *aData=(char*)pFile->mData;
	int aLength=pFile->mLength;
	
	char *aEnd=&aData[aLength];
	char *aLineStart=aData;
	char *aLineEnd=aData;
    
    int aLineLength;
    int aWriteIndex;
    int aNumberCount;
    
    char *aSeek;
    char aNumberString[128];
    float aFloat[32];
    int aFace[4][3];
    int aFaceIndex;
    int aFaceCol;
    
    bool aContinue;
    int aLine=1;
    
	while((aLineStart<aEnd)&&(aError==0))
	{
		while(*aLineStart <= 32 && aLineStart < aEnd)
		{
			aLineStart++;
		}
        
		aLineEnd=aLineStart;
        
		while(*aLineEnd >= 32 && aLineEnd < aEnd)
		{
			aLineEnd++;
		}
        
		if((aLineEnd>aLineStart)&&(aError==0))
		{
            aLineLength = (int)(aLineEnd - aLineStart);
            if(aLineLength > 1)
            {
                if(aLineStart[0] == 'g')
                {
                    /*
                    if(pList != 0)
                    {
                        if(aTemp->mIndexCount != aPreviousIndexStart)
                        {
                            FModelData *aModel = new FModelData();
                            
                            for(int i=aPreviousIndexStart;i<aTemp->mIndexCount;i+=3)
                            {
                                aXYZIndex = aTemp->mIndex[i];
                                aUVWIndex = aTemp->mIndex[i+1];
                                aNormalIndex = aTemp->mIndex[i+2];
                                
                                aX = aTemp->GetX(aXYZIndex);
                                aY = aTemp->GetY(aXYZIndex);
                                aZ = aTemp->GetZ(aXYZIndex);
                                
                                aU = aTemp->GetU(aUVWIndex);
                                aV = aTemp->GetV(aUVWIndex);
                                aW = aTemp->GetW(aUVWIndex);
                                
                                aNX = aTemp->GetNormX(aNormalIndex);
                                aNY = aTemp->GetNormY(aNormalIndex);
                                aNZ = aTemp->GetNormZ(aNormalIndex);
                                
                                aModel->AddXYZ(aX, aY, aZ);
                                aModel->AddUVW(aU, aV, aW);
                                aModel->AddNormal(aNX, aNY, aNZ);
                            }
                            
                            aModel->InvertV();
                            pList->Add(aModel);
                            aPreviousIndexStart = aTemp->mIndexCount;
                        }
                    }
                    */
                }
            }
            
            if(aLineLength > 5)
            {
                if(aLineStart[0] == 'v')
                {
                    aNumberCount=0;
                    aSeek=aLineStart;
                    while((aNumberCount < 3) && (aSeek < aLineEnd))
                    {
                        while(aSeek < aLineEnd)
                        {
                            if((*aSeek >= '0' && *aSeek <= '9') || (*aSeek == '.'))
                            {
                                aWriteIndex=0;
                                if(aSeek > aLineStart)
                                {
                                    if(*(aSeek-1)=='-')
                                    {
                                        aNumberString[aWriteIndex++]='-';
                                    }
                                }
                                while(((*aSeek >= '0' && *aSeek <= '9') || (*aSeek == '.')) && (aSeek < aEnd))
                                {
                                    aNumberString[aWriteIndex++]=*aSeek;
                                    aSeek++;
                                }
                                aNumberString[aWriteIndex]=0;
                                aFloat[aNumberCount] = atof(aNumberString);
                                aNumberCount++;
                                break;
                            }
                            else
                            {
                                aSeek++;
                            }
                        }
                    }
                    
                    if(aLineStart[1] <= ' ')
                    {
                        if(aNumberCount < 3)aError=2;
                        else aTemp->AddXYZ(aFloat[0], aFloat[1], aFloat[2]);
                    }
                    
                    if(aLineStart[1] == 't')
                    {
                        if(aNumberCount < 2)aError=3;
                        else if(aNumberCount == 2)aTemp->AddUVW(aFloat[0], aFloat[1], 0);
                        else aTemp->AddUVW(aFloat[0], aFloat[1], aFloat[2]);
                    }
                    
                    if(aLineStart[1] == 'n')
                    {
                        if(aNumberCount < 3)aError=4;
                        else aTemp->AddNormal(aFloat[0], aFloat[1], aFloat[2]);
                    }
                }
                
                if(aLineStart[0] == 'f' && aLineStart[1] <= ' ')
                {
                    
                    for(int i=0;i<4;i++)
                    {
                        for(int n=0;n<3;n++)
                        {
                            aFace[i][n]=-1;
                        }
                    }
                    
                    aFaceCol=0;
                    aFaceIndex=0;
                    aContinue=false;
                    aSeek=aLineStart;
                    
                    while((aSeek < aLineEnd) && (aError == 0))
                    {
                        if(aFaceCol > 4)
                        {
                            aError=9;
                            break;
                        }
                        else if(*aSeek >= '0' && *aSeek <= '9')
                        {
                            if(aFaceIndex > 3)
                            {
                                aError=10;
                            }
                            
                            aWriteIndex=0;
                            
                            while(*aSeek >= '0' && *aSeek <= '9')
                            {
                                aNumberString[aWriteIndex++]=*aSeek;
                                aSeek++;
                            }
                            
                            aNumberString[aWriteIndex]=0;
                            aFace[aFaceCol][aFaceIndex]=(atoi(aNumberString) - 1);
                            
                            if(*aSeek=='/')
                            {
                                if(*(aSeek+1)=='/')
                                {
                                    aSeek++;
                                    aFaceIndex++;
                                }
                                aFaceIndex++;
                            }
                            else
                            {
                                aFaceIndex=0;
                                aFaceCol++;
                            }
                        }
                        else
                        {
                            aSeek++;
                        }
                    }
                    
                    if(aFaceCol == 3)
                    {
                        aTemp->AddIndex(aFace[0][0]);
                        aTemp->AddIndex(aFace[0][1]);
                        aTemp->AddIndex(aFace[0][2]);
                        
                        aTemp->AddIndex(aFace[1][0]);
                        aTemp->AddIndex(aFace[1][1]);
                        aTemp->AddIndex(aFace[1][2]);
                        
                        aTemp->AddIndex(aFace[2][0]);
                        aTemp->AddIndex(aFace[2][1]);
                        aTemp->AddIndex(aFace[2][2]);
                    }
                }
                aSeek=aLineStart;
            }
		}
        aLine++;
		aLineStart = aLineEnd + 1;
	}
    
    /*
    if(pList != 0)
    {
        if(aTemp->mIndexCount != aPreviousIndexStart)
        {
            FModelData *aModel = new FModelData();
            
            for(int i=aPreviousIndexStart;i<aTemp->mIndexCount;i+=3)
            {
                aXYZIndex = aTemp->mIndex[i];
                aUVWIndex = aTemp->mIndex[i+1];
                aNormalIndex = aTemp->mIndex[i+2];
                
                aX = aTemp->GetX(aXYZIndex);
                aY = aTemp->GetY(aXYZIndex);
                aZ = aTemp->GetZ(aXYZIndex);
                
                aU = aTemp->GetU(aUVWIndex);
                aV = aTemp->GetV(aUVWIndex);
                aW = aTemp->GetW(aUVWIndex);
                
                aNX = aTemp->GetNormX(aNormalIndex);
                aNY = aTemp->GetNormY(aNormalIndex);
                aNZ = aTemp->GetNormZ(aNormalIndex);
                
                aModel->AddXYZ(aX, aY, aZ);
                aModel->AddUVW(aU, aV, aW);
                aModel->AddNormal(aNX, aNY, aNZ);
            }
            
            aModel->InvertV();
            
            pList->Add(aModel);
            
            aPreviousIndexStart = aTemp->mIndexCount;
            
        }
    }
    */
    
    int aIndexCount = aTemp->mIndexCount;
    for(int i=0;i<aIndexCount;i+=3)
    {
        aXYZIndex = aTemp->mIndex[i];
        aUVWIndex = aTemp->mIndex[i+1];
        aNormalIndex = aTemp->mIndex[i+2];
        
        aX = aTemp->GetX(aXYZIndex);
        aY = aTemp->GetY(aXYZIndex);
        aZ = aTemp->GetZ(aXYZIndex);
        
        aU = aTemp->GetU(aUVWIndex);
        aV = aTemp->GetV(aUVWIndex);
        aW = aTemp->GetW(aUVWIndex);
        
        aNX = aTemp->GetNormX(aNormalIndex);
        aNY = aTemp->GetNormY(aNormalIndex);
        aNZ = aTemp->GetNormZ(aNormalIndex);
        
        AddXYZ(aX, aY, aZ);
        AddUVW(aU, aV, aW);
        AddNormal(aNX, aNY, aNZ);
    }
    delete aTemp;
    
    if(gModelDiscardNormals)DiscardNormal();
    if(gModelDiscardUVW)DiscardUVW();
    
    //TODO: Now why is this?
    InvertV();
}

void FModelData::LoadOBJ(const char *pFile)
{
    FFile aFFile;
    aFFile.Load(pFile);
    LoadOBJ(&aFFile);
}

void FModelData::SetImage(FImage *pImage)
{
    if(mBindIndex > 0)
    {
        if(gAppBase)gAppBase->BindRemove(mBindIndex);
        mBindIndex = -1;
    }
    
    if(pImage)
    {
        pImage->Bind();
        
        if(pImage->mBindIndex > 0)
        {
            mBindIndex = pImage->mBindIndex;
            if(gAppBase)gAppBase->BindAdd(mBindIndex);
        }
    }
}

void FModelData::SetImage(const char *pImagePath)
{
    FImage aImage;
    aImage.Load(pImagePath);
    SetImage(&aImage);
}

void FModelData::GetCentroid(float &pCentroidX, float &pCentroidY, float &pCentroidZ)
{
    pCentroidX=0.0f;
    pCentroidY=0.0f;
    pCentroidZ=0.0f;
    
    int aCap = mXYZCount * 3;
    
    for(int i=0;i<aCap;)
    {
        pCentroidX += mXYZ[i++];
        pCentroidY += mXYZ[i++];
        pCentroidZ += mXYZ[i++];
    }
    
    if(mXYZCount > 1)
    {
        pCentroidX /= (float)mXYZCount;
        pCentroidY /= (float)mXYZCount;
        pCentroidZ /= (float)mXYZCount;
    }
}

void FModelData::PrintOverview()
{
    printf("FModelDataOverview: XYZ(%d/%d) UVW(%d/%d) NORM(%d/%d)\n", mXYZCount, mXYZSize, mUVWCount, mUVWSize, mNormalCount, mNormalSize);
}

//////////////////////////////////////////
//////////////////////////////////////////
////                                  ////
////                                  ////
////         Indexed Version          ////
////                                  ////
////                                  ////
//////////////////////////////////////////
//////////////////////////////////////////

FModelDataIndexed::FModelDataIndexed()
{
    FModelData::FModelData();
    
    mRenderer = 0;
    
    mIndex=0;
    mIndexCount=0;
    mIndexSize=0;
}

FModelDataIndexed::~FModelDataIndexed()
{
    Free();
}

void FModelDataIndexed::Free()
{
    FModelData::Free();
    
    delete mRenderer;
    mRenderer = 0;
    
    delete[]mIndex;
    mIndex=0;
    mIndexCount=0;
    mIndexSize=0;
}

void FModelDataIndexed::AddIndex(GFX_MODEL_INDEX_TYPE pIndex)
{
    if(mIndexCount >= mIndexSize)SizeIndex(mIndexCount + (mIndexCount / 2) + 1);
    mIndex[mIndexCount]=pIndex;
    mIndexCount++;
}

void FModelDataIndexed::SizeIndex(int pSize)
{
    mIndexSize = pSize;
    
    GFX_MODEL_INDEX_TYPE *aNew = new GFX_MODEL_INDEX_TYPE[mIndexSize + 1];
    
    for(int i=0;i<mIndexCount;i++)aNew[i] = mIndex[i];
    for(int i=mIndexCount;i<mIndexSize;i++)aNew[i] = 0;
    
    delete [] mIndex;
    mIndex = aNew;
}

void FModelDataIndexed::CopyIndex(GFX_MODEL_INDEX_TYPE *pIndex, int pCount)
{
    delete[]mIndex;
    mIndex=0;
    mIndexCount=0;
    mIndexSize=0;
    
    if((pIndex == 0) || (pCount <= 0))
    {
        return;
    }
    
    SizeIndex(pCount);
    for(int i=0;i<pCount;i++)
    {
        mIndex[i]=pIndex[i];
    }
    mIndexCount=pCount;
}

void FModelDataIndexed::GetCentroid(float &pCentroidX, float &pCentroidY, float &pCentroidZ)
{
    pCentroidX=0.0f;
    pCentroidY=0.0f;
    pCentroidZ=0.0f;
    
    int aIndex;
    
    for(int i=0;i<mIndexCount;i++)
    {            
        aIndex = mIndex[i] * 3;
        pCentroidX += mXYZ[aIndex + 0];
        pCentroidY += mXYZ[aIndex + 1];
        pCentroidZ += mXYZ[aIndex + 2];
    }
    
    if(mIndexCount > 1)
    {
        pCentroidX /= (float)mIndexCount;
        pCentroidY /= (float)mIndexCount;
        pCentroidZ /= (float)mIndexCount;
    }
}



FModelData *FModelDataIndexed::GetData()
{
    FModelData *aReturn = new FModelData();
    
    if(mIndexCount > 0)
    {
        int aIndex;
        
        if(mXYZCount)
        {
            for(int i=0;i<mIndexCount;i++)
            {            
                aIndex = mIndex[i] * 3;
                float aX = mXYZ[aIndex + 0];
                float aY = mXYZ[aIndex + 1];
                float aZ = mXYZ[aIndex + 2];
                aReturn->AddXYZ(aX, aY, aZ);
            }
        }
        
        if(mUVWCount)
        {
            for(int i=0;i<mIndexCount;i++)
            {            
                aIndex = mIndex[i] * 3;
                float aU = mUVW[aIndex + 0];
                float aV = mUVW[aIndex + 1];
                float aW = mUVW[aIndex + 2];
                aReturn->AddUVW(aU, aV, aW);
            }
        }
        
        if(mNormalCount)
        {
            for(int i=0;i<mIndexCount;i++)
            {            
                aIndex = mIndex[i] * 3;
                float aNormX = mNormal[aIndex + 0];
                float aNormY = mNormal[aIndex + 1];
                float aNormZ = mNormal[aIndex + 2];
                aReturn->AddNormal(aNormX, aNormY, aNormZ);
            }
        }
        
    }
    else
    {
        aReturn->CopyXYZ(mXYZ, mXYZCount);
        aReturn->CopyXYZ(mUVW, mUVWCount);
        aReturn->CopyXYZ(mNormal, mNormalCount);
        
        
    }
    
    return aReturn;
}

void FModelDataIndexed::DiscardIndeces()
{
    if(mIndexCount > 0)
    {
        FModelData *aData = GetData();
        
        Free();
        
        CopyXYZ(aData->mXYZ, aData->mXYZCount);
        CopyUVW(aData->mUVW, aData->mUVWCount);
        CopyNorm(aData->mNormal, aData->mNormalCount);
        
        delete aData;
    }
    mIndex=0;
}

FModelDataIndexed *FModelDataIndexed::Clone()
{
    FModelDataIndexed *aClone=new FModelDataIndexed();
    aClone->CopyXYZ(mXYZ, mXYZCount);
    aClone->CopyUVW(mUVW, mUVWCount);
    aClone->CopyNorm(mNormal, mNormalCount);
    aClone->CopyIndex(mIndex, mIndexCount);
    return aClone;
}

void FModelDataIndexed::Clone(FModelDataIndexed *pTarget)
{
    Free();
    if(pTarget)
    {
        CopyXYZ(pTarget->mXYZ, pTarget->mXYZCount);
        CopyUVW(pTarget->mUVW, pTarget->mUVWCount);
        CopyNorm(pTarget->mNormal, pTarget->mNormalCount);
        CopyIndex(pTarget->mIndex, pTarget->mIndexCount);
    }
}



void FModelDataIndexed::Save(const char *pFile)
{
    FFile aFFile;
    Save(&aFFile);
    aFFile.Save(pFile);
}

void FModelDataIndexed::Save(FFile *pFile)
{
    if(!pFile)return;
    
    FModelData::Save(pFile);
    
    pFile->WriteInt(mIndexCount);
    
    for(int i=0;i<mIndexCount;i++)
    {
        pFile->WriteShort(mIndex[i]);
    }
}

void FModelDataIndexed::LoadData(FFile *pFile)
{
    if(!pFile)return;
    
    FModelData::LoadData(pFile);
    
    int aIndexCount = pFile->ReadInt();

    DiscardIndeces();
    
    if(aIndexCount > 0)
    {
        SizeIndex(aIndexCount);
        
        mIndexCount = aIndexCount;
        
        for(int i=0;i<mIndexCount;i++)
        {
            mIndex[i] = pFile->ReadShort();
        }
    }
}

void FModelDataIndexed::LoadData(const char *pFile)
{
    FFile aFFile;
    aFFile.Load(pFile);
    LoadData(&aFFile);
}

void FModelDataIndexed::Draw()
{
    
    if(mRenderer == 0)
    {
        
        mRenderer = new FModelDataRenderer();
        
        mRenderer->SetIndex(mIndex, mIndexCount);
        mRenderer->SetData(mXYZ, mUVW, mNormal, mXYZCount);
        
    }
    
    if(mRenderer)
    {
        mRenderer->mBindIndex = mBindIndex;
        mRenderer->Draw();
    }
    
    /*
    
    gfx_bufferVertexBind(mBufferSlotVertex);
    gfx_bufferIndexBind(mBufferSlotIndex);
    
    gfx_positionSetPointer(3, mBufferVertexOffsetXYZ);
    gfx_texCoordSetPointer(3, mBufferVertexOffsetUVW);
    
    gfx_bindTexture(mBindIndex);
    gfx_drawElementsTriangle(mIndexCount, 0);
    
    
    glBindBuffer(GL_ARRAY_BUFFER, mBufferSlotVertex);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, mBufferSlotIndex);
    
    glVertexAttribPointer(gGLSlotPosition, 3, GL_FLOAT, GL_FALSE, 0, 0);
    glVertexAttribPointer(gGLSlotTexCoord, 3, GL_FLOAT, GL_FALSE, 0, (GLvoid*)(mXYZCount * 3 * 4));
    
    glBindTexture(GL_TEXTURE_2D, mBindIndex);
    glDrawElements(GL_TRIANGLES, mIndexCount, GL_UNSIGNED_SHORT, 0);
    
    //GenerateRenderingBuffers();
     
    */
}

void FModelDataIndexed::PrintCode()
{
    //float aXYZ[5] = {5.0f, 1.25f, 0.5f, 0.5f, 1.0f};
    
    int aCount;
    
    aCount = mXYZCount * 3;
    printf("static float aXYZ[%d]={", aCount);
    for(int i=0;i<aCount;i++)
    {
        printf("%.1f", mXYZ[i]);
        if(i != (aCount - 1))
        {
            printf(",");
        }
        else
        {
            printf("};\n");
        }
    }
    
    aCount = mUVWCount * 3;
    printf("static float aUVW[%d]={", aCount);
    for(int i=0;i<aCount;i++)
    {
        printf("%.2f", mUVW[i]);
        if(i != (aCount - 1))
        {
            printf(",");
        }
        else
        {
            printf("};\n");
        }
    }
    
    aCount = mNormalCount * 3;
    printf("static float aNormal[%d]={", aCount);
    for(int i=0;i<aCount;i++)
    {
        printf("%f", mNormal[i]);
        if(i != (aCount - 1))
        {
            printf(",");
        }
        else
        {
            printf("};\n");
        }
    }
    
    printf("static unsigned short aIndex[%d]={", mIndexCount);
    for(int i=0;i<mIndexCount;i++)
    {
        printf("%d", mIndex[i]);
        if(i != (mIndexCount - 1))
        {
            printf(",");
        }
        else
        {
            printf("};\n");
        }
    }
}

void FModelDataIndexed::Load(const char *pFile)
{
    
    FString aBasePath = pFile;
    aBasePath.RemoveExtension();
    
    FString aPath = aBasePath + FString(".3di");
    
    LoadData(aPath.c());
    
    if(mXYZCount <= 0)
    {
        aPath = aBasePath + FString(".3DI");
        LoadData(aPath.c());
    }
    
    if(mXYZCount <= 0)
    {
        aPath = aBasePath + FString(".obj");
        LoadOBJ(aPath.c());
    }
    
    if(mXYZCount <= 0)
    {
        aPath = aBasePath + FString(".OBJ");
        LoadOBJ(aPath.c());
    }
    
}

/*
void FModelDataIndexed::Load(const char *pFileStart, int pIndex, const char *pFileEnd)
{
    FString aPath = FString(pFileStart) + FString(pIndex) + FString(pFileEnd);
    Load(aPath.c());
}
*/


void FModelDataIndexed::LoadOBJ(FFile *pFile)
{
    Free();
    
    FModelData aTemp;// = LoadOBJ(pFile);
    aTemp.LoadOBJ(pFile);
    FModelDataOptimizer *aOptimizer = new FModelDataOptimizer();
    aOptimizer->Convert(&aTemp, this);
    
    /*
    FString aExport = FString("Exports\\") + FString(pFile);
        aExport.RemovePath(true);
        aExport += ".3di";
        
        if((pData->mXYZCount > 0) || (pData->mUVWCount > 0) || (pData->mNormalCount > 0) || pData->mIndexCount > 0)
        {
            pData->Save(aExport.c());
        }
        */
    
}

void FModelDataIndexed::LoadOBJ(const char *pFile)
{
    FFile aFFile;
    aFFile.Load(pFile);
    LoadOBJ(&aFFile);
}

/*
void FModelDataIndexed::GenerateRenderingBuffers(bool pDiscardLoadData)
{
    int aXYZCount = mXYZCount * 3;
    int aUVWCount = mUVWCount * 3;
    int aNormalCount = mNormalCount * 3;
    
    int aVertexBufferSize = aXYZCount + aUVWCount + aNormalCount;
    int aIndexBufferSize = mIndexCount;
    
    if(aVertexBufferSize <= 0)
    {
        //printf("Generate Model Render Buffer Fail!\n(Empty Vertex Buffer)\n");
        return;
    }
    
    if(aIndexBufferSize <= 0)
    {
        //printf("Generate Model Render Buffer Fail!\n(Empty Index Buffer)\n");
        return;
    }
    
    
    
    int aOffset = 0;
    
    if(mXYZCount > 0)
    {
        mBufferVertexOffsetXYZ = aOffset;
        aOffset += aXYZCount;
    }
    else
    {
        mBufferVertexOffsetXYZ = -1;
    }
    
    if(mUVWCount > 0)
    {
        mBufferVertexOffsetUVW = aOffset;
        aOffset += aUVWCount;
    }
    else
    {
        mBufferVertexOffsetUVW = -1;
    }
    
    if(mNormalCount > 0)
    {
        mBufferVertexOffsetNormal = aOffset;
        aOffset += aNormalCount;
    }
    else
    {
        mBufferVertexOffsetNormal = -1;
    }
    
    
    
    
    mBufferVertex = new float[aVertexBufferSize];
    
    int aBufferWriteIndex = 0;
    
    for(int i=0;i<aXYZCount;i++)
    {
        mBufferVertex[aBufferWriteIndex] = mXYZ[i];
        aBufferWriteIndex++;
    }
    
    for(int i=0;i<aUVWCount;i++)
    {
        mBufferVertex[aBufferWriteIndex] = mUVW[i];
        aBufferWriteIndex++;
    }
    
    for(int i=0;i<aNormalCount;i++)
    {
        mBufferVertex[aBufferWriteIndex] = mNormal[i];
        aBufferWriteIndex++;
    }
    
    mBufferSlotVertex = gfx_bufferVertexGenerate(mBufferVertex, aVertexBufferSize);
    mBufferSlotIndex = gfx_bufferIndexGenerate(mIndex, mIndexCount);
    
    if(pDiscardLoadData)
    {
        DiscardXYZ();
        DiscardUVW();
        DiscardNormal();
    }
}
*/




