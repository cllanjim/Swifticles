//
//  FFile.cpp
//  CoreDemo
//
//  Created by Nick Raptis on 10/1/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#include "FFile.h"
#include "stdafx.h"
#include "core_os.h"

FFile::FFile()
{
	mLength=0;
	mSize=0;
	mReadCursor=0;
	mWriteCursor=0;
	mData=0;
	mPath=0;
}

FFile::~FFile()
{
	Clear();
}

void FFile::Clear()
{
	delete[]mData;
	mLength=0;
	mSize=0;
	mReadCursor=0;
	mWriteCursor=0;
	mData=0;
}

void FFile::Grow()
{
	int aSize=mLength+mLength/2+1;
	unsigned char *aNew=new unsigned char[aSize];
	unsigned char *aCopy=mData;
	unsigned char *aPaste=aNew;
	unsigned char *aShelf=mData+mSize;
	while(aCopy<aShelf)*aPaste++=*aCopy++;
	aShelf=aNew+aSize;
	while(aPaste<aShelf)*aPaste++=0;
	delete[]mData;
	mData=aNew;
	mSize=aSize;
}

void FFile::Size(int size)
{
	if(size<=0)
	{
		Clear();
		return;
	}
	if(mLength>size)mLength=size;
	unsigned char *aNew=new unsigned char[size];
	unsigned char *aCopy=mData;
	unsigned char *aPaste=aNew;
	unsigned char *aShelf=mData+mLength;
	while(aCopy<aShelf)*aPaste++=*aCopy++;
	aShelf=aNew+size;
	while(aPaste<aShelf)*aPaste++=0;
	mData=aNew;
	mSize=size;
	mReadCursor=0;
}

void FFile::Write(char *write, int theLength)
{
	if(mLength+theLength>mSize)Size(mLength+theLength);
	unsigned int aShift=mWriteCursor%8;
	unsigned int aIndex=(mWriteCursor)>>3;
	unsigned char *aCopy=(unsigned char*)write;
	unsigned char *aShelf=(unsigned char*)(write+theLength);
	if(aShift)
	{
		while(aCopy<aShelf)WriteChar(*aCopy++);
	}
	else
	{
		unsigned char *aPaste=mData+aIndex;
		while(aCopy<aShelf)*aPaste++=*aCopy++;
		mWriteCursor+=(theLength<<3);
		mLength=((mWriteCursor+7)>>3);
	}
}

void FFile::Write(char *write)
{
	char *aPtr=write;
	while(*aPtr)aPtr++;
	Write(write,(int)(aPtr-write));
}

void FFile::WriteInt(int write)
{
	WriteBits(write,32);
}

int FFile::ReadInt()
{
	return ReadBits(32);
}

void FFile::WriteShort(short write)
{
	WriteBits(write, 16);
}

short FFile::ReadShort()
{
	return ReadBits(16);
}

void FFile::PrintFile()
{
    printf("\n\n\n//FFile Start\n\n\n");
    
    printf("int aFFileSize = %d;\n", mLength);
    
    printf("unsigned char aFFileData[%d] = {\n", mLength);
    
    int aRow=0;
	int aIndex=0;
	while(aIndex<mLength)
	{
        unsigned int aInt = (unsigned int)((unsigned char)mData[aIndex]);
        
        printf("%d", aInt);
        if(aIndex < (mLength - 1))printf(", ");
        
        aRow++;
        if(aRow >= 20)
        {
            printf("\n");
            aRow=0;
        }
        aIndex++;
	}
    
    printf("};\n");
    
    
    
    printf("\n\n\n//FFile End\n\n\n");
    
}
int hax[3] = {0,402,5};


void FFile::Print(bool include_tail)
{
    /*
	int aRow=0;
	int aIndex=0;
	FString aPrint;
	printf("\n**FFile Print**\n");
	while(aIndex<mLength)
	{
		aPrint+=Sprintf("%2X", (int)mData[aIndex])+",";
		aIndex++;
		
		aRow++;
		if(aRow>=10)
		{
			aRow=0;
			printf("__[%s]\n", aPrint.c());
			aPrint="";
		}
	}
	printf("__[%s]\n", aPrint.c());
	aPrint="";
	
	
	while(aIndex<mSize)
	{
		aPrint+=Sprintf("%2X", (int)mData[aIndex])+",";
		aIndex++;
		
		aRow++;
		if(aRow>=10)
		{
			aRow=0;
			printf("++[%s]\n", aPrint.c());
			aPrint="";
		}
	}
    
	printf("++[%s]\n", aPrint.c());
    */
}


void FFile::WriteBool(bool write)
{
	mLength=(mWriteCursor+7+1)>>3;
	if(mLength>mSize)Grow();
	unsigned int aShift=mWriteCursor%8;
	unsigned int aIndex=(mWriteCursor)>>3;
	mWriteCursor++;
	if(write)mData[aIndex]|=(1<<aShift);
}

bool FFile::ReadBool()
{
	bool aReturn=false;
	unsigned int aShift=mReadCursor%8;
	unsigned int aIndex=mReadCursor/8;
	mReadCursor+=1;
	if(((mReadCursor+7)>>3)<=mLength)
	{
		aReturn=(mData[aIndex]&(1<<aShift))!=0;
	}
	return aReturn;
	
}

void FFile::WriteChar(unsigned char write)
{
	mLength=(mWriteCursor+7+8)>>3;
	if(mLength>mSize)Grow();
	unsigned int aShift=mWriteCursor%8;
	unsigned int aIndex=(mWriteCursor)>>3;
	mWriteCursor+=8;
	if(aShift)
	{
		mData[aIndex]|=(write<<aShift);
		mData[aIndex+1]=(write>>(8-aShift));
	}
	else
	{
		mData[aIndex]=write;
	}
}

char FFile::ReadChar()
{
	unsigned int aShift=mReadCursor%8;
	unsigned int aIndex=mReadCursor/8;
	mReadCursor+=8;
	unsigned char aReturn = 0;
	if(((mReadCursor+7)>>3)<=mLength)
	{
		if(aShift)
		{
			aReturn=((unsigned char)(mData[aIndex])>>aShift)|((unsigned char)(mData[aIndex+1])<<(8-aShift));
		}
		else
		{
			aReturn=mData[aIndex];
		}
	}
	return aReturn;
}

void FFile::WriteString(char *pString)
{
	int aLength=0;
	
	if(pString)
	{
		char *aPtr=pString;
		while(*aPtr)aPtr++;
		aLength=(int)(aPtr-pString);
		WriteInt(aLength);
        if(aLength>0)
        {
            aPtr=pString;
            while(*aPtr)
            {
                WriteChar(*aPtr);
                aPtr++;
            }
        }
	}
	else
	{
		WriteInt(0);
	}
}

FString FFile::ReadString()
{
	FString aReturn;
	int aLength=ReadInt();
	if(aLength>0)
	{
		char *aChar=new char[aLength+1];
		aChar[aLength]=0;
		char *aWrite=aChar;
		while(aLength>0)
		{
			*aWrite=ReadChar();
			aWrite++;
			aLength--;
		}
		aReturn=aChar;
		delete[]aChar;
	}
	return aReturn;
}

bool FFile::HasMoreData(int pBitCount)
{
	//unsigned int aCursor = mReadCursor+pBitCount;
	return (((mReadCursor+7)>>3)<=mLength);
}

unsigned int FFile::ReadBits(int pBitCount)
{
	if(pBitCount<0)pBitCount=0;
    
	unsigned int aShift=mReadCursor%8;
	unsigned int aIndex=(mReadCursor)>>3;
	
    mReadCursor+=pBitCount;
	
    unsigned int aReturn=0;
	
    if(((mReadCursor+7)>>3)<=mLength)
	{
		for(unsigned int i=0;i<pBitCount;i++)
		{
			if(mData[aIndex]&(1<<aShift))
			{
				aReturn|=(1<<i);
			}
			if(++aShift==8)
			{
				aIndex++;
				aShift=0;
			}
		}
	}
	return aReturn;
}

int FFile::ReadBits(int pBitCount, bool pSigned)
{
	if(pBitCount<0)pBitCount=0;
	unsigned int aShift=mReadCursor%8;
	unsigned int aIndex=(mReadCursor)>>3;
	mReadCursor+=pBitCount;
	unsigned int aReturn=0;
	if(((mReadCursor+7)>>3)<=mLength)
	{
		for(unsigned int i=0;i<pBitCount;i++)
		{
			if(mData[aIndex]&(1<<aShift))
			{
				aReturn|=(1<<i);
			}
			if(++aShift==8)
			{
				aIndex++;
				aShift=0;
			}
		}
	}
	if(pBitCount>0&&pBitCount<33&&pSigned)
	{
		if(aReturn&(1<<(pBitCount-1)))
		{
			for(int i=pBitCount;i<32;i++)aReturn|=(1<<i);
		}
	}
	return aReturn;
}

void FFile::WriteBits(unsigned int pWrite, int pBitCount)
{
	mLength=(mWriteCursor+pBitCount+7)>>3;
	if(mLength>mSize)Grow();
	unsigned int aShift=mWriteCursor%8;
	unsigned int aIndex=(mWriteCursor)>>3;
	mWriteCursor+=pBitCount;
	for(unsigned int i=0;i<pBitCount;i++)
	{
		if((pWrite>>i)&1)mData[aIndex]|=(0x1<<aShift);
		if(++aShift==8)
		{
			aIndex++;
			aShift=0;
		}
	}
}

void FFile::operator=(FFile &theFFile)
{
	Clear();
	mSize=theFFile.mLength;
	mLength=mSize;
	mWriteCursor=theFFile.mWriteCursor;
	mReadCursor=0;
	mData=theFFile.mData;
	theFFile.mData=0;
	theFFile.Clear();
}

void FFile::Save(char *pFile)
{
    os_write_file(pFile, mData, mLength);
    
    
    
    FString aPath = FString("/Users/nraptis/Desktop/Exports/") + pFile;
    
    os_write_file(aPath.c(), mData, mLength);
    
    /*
    aFile=creat(aPath.c(),S_IREAD|S_IWRITE);
    close(aFile);
    aFile=open(aPath.c(),O_BINARY|O_RDWR);
    if (aFile!=-1)
    {
        
        write(aFile,mData,mLength);
        close(aFile);
    }
    else {
        gDisableQuickSaveToDesktop = true;
    }
    */
    
    
    /*
	if(!pFile)return;
	
	//MakeDirectory(pFile);
	
	int aFile=creat(pFile,S_IREAD|S_IWRITE);
	close(aFile);
	aFile=open(pFile,O_BINARY|O_RDWR);
	if (aFile!=-1)
	{
		write(aFile,mData,mLength);
		close(aFile);
	}
    else
    {
        if(gDisableQuickSaveToDesktop == true)
        {
            //printf("[Disabling Attempted Export (%s)\n", pFile);
        }
        
        else
        {
            
            
            //printf("File Failed To Open???\n\n\n");
            FString aPath = FString("/Users/nraptis/Desktop/Exports/") + pFile;
            
            aFile=creat(aPath.c(),S_IREAD|S_IWRITE);
            close(aFile);
            aFile=open(aPath.c(),O_BINARY|O_RDWR);
            if (aFile!=-1)
            {
                write(aFile,mData,mLength);
                close(aFile);
            }
            else
            {
                gDisableQuickSaveToDesktop = true;
            }
        }
    }
    */
}

void FFile::Load(char *pFile)
{
    
    Clear();
    
    mData = os_read_file(pFile, mLength);
    mSize = mLength;
    
    if(mLength <= 0)
    {
        FString aPath = gDirBundle + FString(pFile);
        mData = os_read_file(aPath.c(), mLength);
        mSize = mLength;
    }
    
    if(mLength <= 0)
    {
        FString aPath = gDirDocuments + FString(pFile);
        mData = os_read_file(aPath.c(), mLength);
        mSize = mLength;
    }
    
    /*
	Clear();
	if(!pFile)return;
    
	int aFileLength=-1;
	int aFile=open(pFile,O_BINARY|O_RDONLY);
	
    if(aFile==-1)
    {
        aFile=open(FString(gSandbox + pFile).c(),O_BINARY|O_RDONLY);
    }
    
    if(aFile==-1)
    {
        aFile=open(FString(gDocuments + pFile).c(),O_BINARY|O_RDONLY);
    }
    
	if(aFile!=-1)
	{
		struct stat aFileStats;
		if(fstat(aFile,&aFileStats) == 0)aFileLength=aFileStats.st_size;
		if(aFileLength<1)return;
		mLength=aFileLength;
		mSize=mLength;
		mWriteCursor=(mLength<<3);
		mData=new unsigned char[mLength+256];
		read(aFile,mData,mLength);
		close(aFile);
	}
    else
    {
        FString aErrorString = FString(pFile);
        aErrorString.RemovePath(false);
    }
    */
}

int FloatToInt(float pFloat)
{
    return *((int*)(&pFloat));
}

float IntToFloat(int pInt)
{
    return *((float*)(&pInt));
}
