#include "FImage.h"
#include "FFile.h"
#include "FApp.h"

FImage::FImage()
{
	mData=0;
	mExpandedWidth=0;
	mExpandedHeight=0;
	mWidth=0;
	mHeight=0;
	mOffsetX=0;
	mOffsetY=0;
	mBindIndex=-1;
    mScale=1.0f;
}

FImage::~FImage()
{
	Kill();
}


void FImage::LoadDirect(char *pFile)
{
	Kill();
	
	mPath = pFile;
    mScale = 1.0f;
	
	FString aPath = pFile;
	mData = os_load_image(aPath.c(),mWidth,mHeight);//,mScale);
    
	mExpandedWidth = mWidth;
	mExpandedHeight=mHeight;
    
	mOffsetX = 0;
	mOffsetY = 0;
}

void FImage::Load(char *pFile)
{
    FString aFile=pFile;
    FString aExtension = aFile.RemoveExtension();
    mPath=aFile;
    
    /*
    if(gIsIpad)
    {
        if(mWidth==0)LoadDirect(gDirBundle + aFile + FString("@2x.png"));
        if(mWidth==0)LoadDirect(gDirBundle + aFile + FString("@2x.jpg"));
        if(mWidth==0)LoadDirect(gDirBundle + aFile + FString("@2x.jpeg"));
        
        if(mWidth==0)LoadDirect(gDirBundle + aFile + FString("@2x.PNG"));
        if(mWidth==0)LoadDirect(gDirBundle + aFile + FString("@2x.JPG"));
        if(mWidth==0)LoadDirect(gDirBundle + aFile + FString("@2x.JPEG"));
    }
    */
    
    if(mWidth == 0)LoadDirect(gDirBundle + aFile + FString(".png"));
    if(mWidth == 0)LoadDirect(gDirBundle + aFile + FString(".jpg"));
    if(mWidth == 0)LoadDirect(gDirBundle + aFile + FString(".jpeg"));
    if(mWidth == 0)LoadDirect(gDirBundle + aFile + FString(".PNG"));
    if(mWidth == 0)LoadDirect(gDirBundle + aFile + FString(".JPG"));
    if(mWidth == 0)LoadDirect(gDirBundle + aFile + FString(".JPEG"));
    
    
    if(mWidth == 0)LoadDirect(gDirDocuments + aFile + FString(".png"));
    if(mWidth == 0)LoadDirect(gDirDocuments + aFile + FString(".jpg"));
    if(mWidth == 0)LoadDirect(gDirDocuments + aFile + FString(".jpeg"));
    if(mWidth == 0)LoadDirect(gDirDocuments + aFile + FString(".PNG"));
    if(mWidth == 0)LoadDirect(gDirDocuments + aFile + FString(".JPG"));
    if(mWidth == 0)LoadDirect(gDirDocuments + aFile + FString(".JPEG"));
    
    /*
    if(gFImageBundler.mAutoBundle)
    {
        if(mWidth > 0 && mHeight > 0)
        {
            FImage *aBundled = new FImage();
            
            aBundled->Make(mWidth, mHeight);
            aBundled->Stamp(this);
            aBundled->mPath=mPath;
            gFImageBundler.AddFImage(aBundled);
            
            delete aBundled;
        }
    }
    */
}

void FImage::Kill()
{
	delete[]mData;
	mData=0;
	mExpandedWidth=0;
	mExpandedHeight=0;
	mWidth=0;
	mHeight=0;
	mOffsetX=0;
	mOffsetY=0;
	if((mBindIndex > 0) && (gAppBase != 0))gAppBase->BindRemove(mBindIndex);
	mBindIndex=-1;
}

void FImage::ExportACompressed(char *pFile)
{
	unsigned int *aData=mData;
	unsigned int *aCap=&aData[mExpandedWidth*mExpandedHeight];
	
	FFile aFFile;
	while(aData<aCap)
	{
		unsigned char aRead=(unsigned char)(*aData);
		if(aRead==0||aRead==255)
		{
			int aCount=1;
			aData++;
			while(aCount<255 && (aData<aCap) && ((unsigned char)(*aData))==aRead)
			{
				aData++;
				aCount++;
			}
			aFFile.WriteChar(aRead);
			aFFile.WriteChar(aCount);
			
		}
		else
		{
			aFFile.WriteChar(aRead);
			aData++;
		}
	}
	//aFFile.Save(gDocuments+pFile);
}
void FImage::ExportRGB(char *pFile)
{
	FFile aFFile;
	int aArea=mExpandedWidth*mExpandedHeight;
	aFFile.WriteChar('B');
	aFFile.WriteChar('M');
	int aFileSize = 54 + aArea * 3;
	aFFile.WriteInt(aFileSize);
	aFFile.WriteInt(0);
	aFFile.WriteInt(0x36);
	aFFile.WriteInt(0x28);
	aFFile.WriteInt(mWidth);
	aFFile.WriteInt(mHeight);
	aFFile.WriteShort(1);
	//Color Bits
	aFFile.WriteShort(24);
	aFFile.WriteInt(0);
	aFFile.WriteInt(0x10);
	aFFile.WriteInt(0x130B);
	aFFile.WriteInt(0x130B);
	aFFile.WriteInt(0);
	aFFile.WriteInt(0);
	for(int aY=mExpandedHeight-1;aY>=0;aY--)
	{
		for(int aX=mExpandedWidth-1;aX>=0;aX--)
		{
			int i=(aY)*mExpandedWidth+(mExpandedWidth-1-aX);
			
			aFFile.WriteChar((mData[i]>>16)&0xFF);
			
			aFFile.WriteChar((mData[i]>>8)&0xFF);
			aFFile.WriteChar((mData[i]>>0)&0xFF);
			
			//aFFile.WriteChar((mData[i]>>24)&0xFF);
		}
	}
	//aFFile.Save(gDocuments + pFile);
}

void FImage::ExportA(char *pFile)
{
	FFile aFFile;
	int aArea=mExpandedWidth*mExpandedHeight;
	aFFile.WriteChar('B');
	aFFile.WriteChar('M');
	int aFileSize = 54 + aArea * 3;
	aFFile.WriteInt(aFileSize);
	aFFile.WriteInt(0);
	aFFile.WriteInt(0x36);
	aFFile.WriteInt(0x28);
	aFFile.WriteInt(mWidth);
	aFFile.WriteInt(mHeight);
	aFFile.WriteShort(1);
	//Color Bits
	aFFile.WriteShort(24);
	aFFile.WriteInt(0);
	aFFile.WriteInt(0x10);
	aFFile.WriteInt(0x130B);
	aFFile.WriteInt(0x130B);
	aFFile.WriteInt(0);
	aFFile.WriteInt(0);
	for(int aY=mExpandedHeight-1;aY>=0;aY--)
	{
		for(int aX=mExpandedWidth-1;aX>=0;aX--)
		{
			int i=(aY)*mExpandedWidth+(mExpandedWidth-1-aX);
			int aAlpha=(mData[i]>>24)&0xFF;
			
			aFFile.WriteChar(aAlpha);
			aFFile.WriteChar(aAlpha);
			aFFile.WriteChar(aAlpha);
			
			//aFFile.WriteChar((mData[i]>>24)&0xFF);
		}
	}
	//aFFile.Save(gDocuments + pFile);
}

void FImage::ExportSlices(int pWidth, int pHeight, char *pFileRoot, bool namedWithRowAndColumn, bool ignoreBlanks)
{
    /*
	int aIndex=0;
	
	int aCol=0;
	for(int n=0;n<mHeight;n+=pHeight)
	{
	int aRow=0;
	for(int i=0;i<mWidth;i+=pWidth)
	{
		
			FImage aFImage;
			aFImage.MakeBlank(pWidth,pHeight);
			aFImage.Stamp(this,0,0,i,n,pWidth,pHeight);
			bool aBlank=aFImage.IsBlank();
			FString aFile = gDocuments + FString(pFileRoot) + FString("_");
			if(namedWithRowAndColumn)
			{
				aFile += FString(aRow);
				aFile += FString("_");
				aFile += FString(aCol);
			}
			else aFile += FString(aIndex+1);
			aFile += ".png";
			if(!(aBlank && ignoreBlanks))
			{
				ExportPNGFImage(aFImage.mData,aFile.c(),aFImage.mWidth,aFImage.mHeight);
			}
			aIndex++;
			aCol++;
		}
		aRow++;
	}
    */
}

void FImage::ApplyGreyscaleAlpha(FImage *pFImage)
{
	if(!pFImage)return;
	if(mWidth==0 || mHeight==0 || pFImage->mWidth!=mWidth || pFImage->mHeight!=mHeight)
	{
		printf("Fail @ Greyscale: %s\n", mPath.c());
		return;
	}
	unsigned int *aPaste=mData;
	unsigned int *aCopy=pFImage->mData;
	unsigned int *aShelf=&aCopy[mWidth*mHeight];
	while(aCopy<aShelf)
	{
		(*aPaste)&=((0x00FFFFFF)|((*aCopy)<<24));
		aCopy++;
		aPaste++;
	}
}

void FImage::ExportBMP(char *pFile)
{
	FFile aFFile;
	
	int aArea=mExpandedWidth*mExpandedHeight;
	//Magic Number 2 bytes
	aFFile.WriteChar('B');
	aFFile.WriteChar('M');
	
	int aFileSize = 54 + aArea * 4;
	//Size of the BMP file 4 bytes
	aFFile.WriteInt(aFileSize);
	
	//4 bytes app specific..
	aFFile.WriteInt(0);
	
	//The offset where the bitmap data (pixels) can be found.
	aFFile.WriteInt(0x36);
	//The number of bytes in the header (from this point).
	aFFile.WriteInt(0x28);
	
	//The width of the bitmap in pixels
	aFFile.WriteInt(mExpandedWidth);
	//The height of the bitmap in pixels
	aFFile.WriteInt(mExpandedHeight);
	
	//Color Planes
	aFFile.WriteShort(1);
	
	//Color Bits
	aFFile.WriteShort(32);
	
	//BI_RGB, No compression used
	aFFile.WriteInt(0);
	
	aFFile.WriteInt(0x10);
	
	
	aFFile.WriteInt(0x130B);
	aFFile.WriteInt(0x130B);
	
	
	aFFile.WriteInt(0);
	aFFile.WriteInt(0);
	
	
	for(int aY=mExpandedHeight-1;aY>=0;aY--)
	{
		for(int aX=mExpandedWidth-1;aX>=0;aX--)
		{
			int i=(aY)*mExpandedWidth+(mExpandedWidth-1-aX);
			
			aFFile.WriteChar((mData[i]>>16)&0xFF);
			
			aFFile.WriteChar((mData[i]>>8)&0xFF);
			aFFile.WriteChar((mData[i]>>0)&0xFF);
			
			aFFile.WriteChar((mData[i]>>24)&0xFF);
		}
	}
	
	//aFFile.Save(gDocuments + pFile);
}

void FImage::MakeBlank(int pWidth, int pHeight)
{
	Make(pWidth,pHeight,0);
}
	   
void FImage::Make(int pWidth, int pHeight, int pColor)
{
	if(pWidth<=0||pHeight<=0)
	{
		Kill();
		return;
	}
	if((pWidth!=mExpandedWidth)||(pHeight!=mExpandedHeight))
	{
		Kill();
		mWidth=pWidth;
		mHeight=pHeight;
		mData=new unsigned int[pWidth*pHeight];
	}
	mWidth=pWidth;
	mHeight=pHeight;
	mExpandedWidth=pWidth;
	mExpandedHeight=pHeight;
	mOffsetX=0;
	mOffsetY=0;
	
	unsigned int aColor=pColor;
	unsigned int *aPaste=mData;
	unsigned int *aShelf=mData+(mExpandedWidth*mExpandedHeight);
	while(aPaste<aShelf)*aPaste++=aColor;
	//memset(mData,pColor,((pWidth*pHeight)<<2));
}

unsigned int FImage::GetColor(int x, int y)
{
	x+=mOffsetX;
	y+=mOffsetY;
	int aReturn=0;
	int aIndex=x+y*mExpandedWidth;
	if(aIndex>=0&&aIndex<mExpandedWidth*mExpandedHeight)aReturn=mData[aIndex];
	return aReturn;
}

void FImage::WhiteToAlpha()
{
	unsigned int *aPtr=mData;
	unsigned int *aCap=&mData[mExpandedWidth*mExpandedHeight];
	while(aPtr<aCap)
	{
		*aPtr=(*aPtr<<16)|0x00FFFFFF;
		
		//*aPtr&=0x00FFFFFF;
		//*aPtr|=(*aPtr)<<24;
		//*aPtr|=0x00FFFFFF;
		aPtr++;
	}
}

void FImage::FlipV()
{
	if(mExpandedWidth>0&&mExpandedHeight>0)
	{
	unsigned int **aData=new unsigned int*[mExpandedHeight];
	unsigned int *aPtr=mData;
	int i, n;
	for(n=0;n<mExpandedHeight;n++)
	{
		aData[n]=aPtr;
		aPtr+=mExpandedWidth;
	}
	
	int aTop=0;
	int aBottom=mExpandedHeight-1;
	unsigned int aHold;
	while(aTop<aBottom)
	{
		for(i=0;i<mExpandedWidth;i++)
		{
			aHold=aData[aTop][i];
			aData[aTop][i]=aData[aBottom][i];
			aData[aBottom][i]=aHold;
		}
		aTop++;
		aBottom--;
	}
	delete[]aData;
	}
}

void FImage::GetColorCentroid(int pRed, int pGreen, int pBlue, int &x, int &y, int pTolerance)
{
	x=-1;
	y=-1;
	
	int i=0;
	int n=0;
	
	if(mExpandedWidth>0&&mExpandedHeight>0)
	{
		unsigned int **aData=new unsigned int*[mExpandedHeight];
		unsigned int *aPtr=mData;
		
		for(n=0;n<mExpandedHeight;n++)
		{
			aData[n]=aPtr;
			aPtr+=mExpandedWidth;
		}
		
		int aCount=0;
		
        int aRed, aGreen, aBlue;
        int aRedDiff, aGreenDiff, aBlueDiff;
		
		for(i=0;i<mWidth;i++)
		{
			for(n=0;n<mHeight;n++)
			{
                aRed=(IMAGE_RED(aData[n][i]));
                aGreen=(IMAGE_GREEN(aData[n][i]));
                aBlue=(IMAGE_BLUE(aData[n][i]));
                
                aRedDiff = aRed - pRed;
				if(aRedDiff<0)aRedDiff=-aRedDiff;
                
                aGreenDiff = aGreen - pGreen;
                if(aGreenDiff<0)aGreenDiff=-aGreenDiff;
				
                aBlueDiff = aBlue - pBlue;
                if(aBlueDiff<0)aBlueDiff=-aBlueDiff;
				
                if(aRedDiff <= pTolerance && aGreenDiff <= pTolerance && aBlueDiff <= pTolerance)
                {
                    x+=i;
					y+=n;
					aCount++;
                }
			}
		}
		
		if(aCount >=1)
		{
			x /= aCount;
			y /= aCount;
		}
        
		delete[]aData;
	}
}

void FImage::BufferEdges(int pSize)
{
    //printf("FFile Edges! [%d]\n", pSize);
    
    int aX = pSize;
    int aY = pSize;
    int aWidth = mExpandedWidth;
    int aHeight = mExpandedHeight;
    
    ExpandCanvas(pSize);
    
    for(int i=0;i<pSize;i++)
    {
        FixTileBorders(aX, aY, aWidth, aHeight);
        
        aX --;
        aY --;
        aWidth += 2;
        aHeight += 2;
    }
}

void FImage::ExpandCanvas(int pSize)
{
    
    
    
    unsigned int *aOldData = mData;
    
    int aOldWidth = mExpandedWidth;
    int aOldHeight = mExpandedHeight;
    
    int aNewWidth = (mExpandedWidth + (pSize * 2));
    int aNewHeight = (mExpandedHeight + (pSize * 2));
    
    mData = 0;
    
    mOffsetX = 0;
	mOffsetY = 0;
    
    mWidth = 0;
    mHeight = 0;
    
    mExpandedWidth = 0;
	mExpandedHeight = 0;
    
    MakeBlank(aNewWidth, aNewHeight);
    
    Stamp(aOldData, pSize, pSize, aOldWidth, aOldHeight);
    
    //Stamp(<#unsigned int *pData#>, <#int x#>, <#int y#>, <#int pWidth#>, <#int pHeight#>)
    
    delete[]aOldData;
}

void FImage::FixTileBorders(int pBorderSize)
{
    
    if(pBorderSize <= 0)return;
    if(pBorderSize > 100)pBorderSize=100;
    
    //int i=0;
	//int n=0;
	
	if(mExpandedWidth>0&&mExpandedHeight>0)
	{
        unsigned int *aOldData = mData;
        
        int aOldWidth=mExpandedWidth;
        int aOldHeight=mExpandedHeight;
        
        int aNewWidth = mExpandedWidth + pBorderSize * 2;
        int aNewHeight = mExpandedHeight + pBorderSize * 2;
        
        MakeBlank(aNewWidth, aNewHeight);
        
        Stamp(aOldData,pBorderSize,pBorderSize,aOldWidth,aOldHeight);
        FixTileBorders(pBorderSize, pBorderSize, aOldWidth, aOldHeight);
        
        
	}
}

void FImage::FixTileBorders(int pX, int pY, int pWidth, int pHeight)
{
	//int i=0;
	int n=0;
	
	if(mExpandedWidth>0&&mExpandedHeight>0)
	{
		unsigned int **aData=new unsigned int*[mExpandedHeight];
		unsigned int *aPtr=mData;
		
		int aLeft = pX;
		if(aLeft < 0)aLeft = 0;
		
		int aRight = pX+pWidth-1;
		if(aRight >= mExpandedWidth)aRight = mExpandedWidth-1;
		
		int aTop = pY;
		if(aTop < 0)aTop = 0;
		
		int aBottom = pY+pHeight-1;
		if(aBottom >= mExpandedHeight)aBottom = mExpandedHeight-1;
		
		
		
		
		for(n=0;n<mExpandedHeight;n++)
		{
			aData[n]=aPtr;
			aPtr+=mExpandedWidth;
		}
		
		
		//Fix the top...
		
		for(int aY = aTop-1;aY>=0;aY--)
		{
			for(int aX = aLeft;aX <= aRight;aX ++)
			{
                //aData[aY][aX]=IMAGE_RGBA(gRand.Get(255), gRand.Get(255), gRand.Get(255), 200);
				aData[aY][aX]=aData[aY+1][aX];
			}
		}
		
		for(int aY = aBottom+1;aY<mExpandedHeight;aY++)
		{
			for(int aX = aLeft;aX <= aRight;aX ++)
			{
                //aData[aY][aX]=IMAGE_RGBA(gRand.Get(255), gRand.Get(255), gRand.Get(255), 200);
				aData[aY][aX]=aData[aY-1][aX];
			}
		}
		
		for(int aX = aLeft-1;aX >=0;aX --)
		{
			for(int aY = aTop;aY<=aBottom;aY++)
			{
                //aData[aY][aX]=IMAGE_RGBA(gRand.Get(255), gRand.Get(255), gRand.Get(255), 200);
				aData[aY][aX]=aData[aY][aX+1];
			}
		}
		
		for(int aX = aRight+1;aX <mExpandedWidth;aX++)
		{
			for(int aY = aTop;aY<=aBottom;aY++)
			{
                //aData[aY][aX]=IMAGE_RGBA(gRand.Get(255), gRand.Get(255), gRand.Get(255), 200);
				aData[aY][aX]=aData[aY][aX-1];
			}
		}
		
		unsigned int aColor;
		
		
		aColor = aData[aTop][aLeft];//AverageColors(aData[aTop-1][aLeft], aData[aTop][aLeft-1]);
		for(int i=0;i<aLeft;i++)
		{
			for(int n=0;n<aTop;n++)
			{
				aData[n][i] = aColor;
			}
		}
		
		aColor = aData[aTop][aRight];//AverageColors(aData[aTop-1][aRight], aData[aTop][aRight+1]);
		for(int i=aRight+1;i<mExpandedWidth;i++)
		{
			for(int n=0;n<aTop;n++)
			{
				aData[n][i] = aColor;
			}
		}
		
		
		aColor = aData[aBottom][aRight];
		for(int i=aRight+1;i<mExpandedWidth;i++)
		{
			for(int n=aBottom+1;n<mExpandedHeight;n++)
			{
				aData[n][i] = aColor;
			}
		}
		 
		
		aColor = aData[aBottom][aLeft];//AverageColors(aData[aBottom+1][aLeft], aData[aTop][aLeft-1]);
		for(int i=0;i<aLeft;i++)
		{
			for(int n=aBottom+1;n<mExpandedHeight;n++)
			{
				aData[n][i] = aColor;
			}
		}
		
		
		
		delete[]aData;
	}
}

void FImage::ShiftPixels(int x, int y)
{
	x=0;
	y=0;
	
	int i=0;
	int n=0;
	
	if(mExpandedWidth>0&&mExpandedHeight>0)
	{
		unsigned int **aData=new unsigned int*[mExpandedHeight];
		unsigned int *aPtr=mData;
		
		for(n=0;n<mExpandedHeight;n++)
		{
			aData[n]=aPtr;
			aPtr+=mExpandedWidth;
		}
		
		
		for(i=0;i<mWidth;i++)
		{
			for(n=256;n<512;n++)
			{
				aData[n-256][i]=aData[n][i];
				//aData[i][n]=0xFFFF00FF;
			}
		}
		
		
		delete[]aData;
	}
}

unsigned int **FImage::Get2DGrid()
{
    int n;
    unsigned int **aData=new unsigned int*[mExpandedHeight+1];

		unsigned int *aPtr=mData;
		for(n=0;n<mExpandedHeight;n++)
		{
			aData[n]=aPtr;
			aPtr+=mExpandedWidth;
		}
    
    return aData;
}

void FImage::RotateRight()
{
	int n,i;
	if(mExpandedWidth>0&&mExpandedHeight>0)
	{
		unsigned int **aData=new unsigned int*[mExpandedHeight];
		unsigned int *aPtr=mData;
		
		unsigned int **aNew=new unsigned int*[mExpandedWidth];
		unsigned int *aNewData=new unsigned int[mExpandedWidth * mExpandedHeight];
		
		
		for(n=0;n<mExpandedHeight;n++)
		{
			aData[n]=aPtr;
			aPtr+=mExpandedWidth;
		}
		
		aPtr=aNewData;
		for(i=0;i<mExpandedWidth;i++)
		{
			aNew[i]=aPtr;
			aPtr+=mExpandedHeight;
		}
		
		for(i=0;i<mExpandedWidth;i++)
		{
			for(n=0;n<mExpandedHeight;n++)
			{
				aNew[i][mExpandedHeight - n - 1]=aData[n][i];//mExpandedWidth-i-1];
				
				//aNew[mExpandedWidth-i-1][n]=aData[n][i];
			}
		}
		
		delete[]aData;
		delete[]mData;
		delete[]aNew;
		mData=aNewData;
		
		int aWidth=mWidth;
		mWidth=mHeight;
		mHeight=aWidth;
        
        mExpandedWidth = mWidth;
        mExpandedHeight = mHeight;
	}
}



void FImage::RotateLeft()
{
	int n,i;
	if(mExpandedWidth>0&&mExpandedHeight>0)
	{
		unsigned int **aData=new unsigned int*[mExpandedHeight];
		unsigned int *aPtr=mData;
		
		unsigned int **aNew=new unsigned int*[mExpandedWidth];
		unsigned int *aNewData=new unsigned int[mExpandedWidth * mExpandedHeight];
		
		
		for(n=0;n<mExpandedHeight;n++)
		{
			aData[n]=aPtr;
			aPtr+=mExpandedWidth;
		}
		
		aPtr=aNewData;
		for(i=0;i<mExpandedWidth;i++)
		{
			aNew[i]=aPtr;
			aPtr+=mExpandedHeight;
		}
		
		for(i=0;i<mExpandedWidth;i++)
		{
			for(n=0;n<mExpandedHeight;n++)
			{
				aNew[mExpandedWidth-i-1][n]=aData[n][i];
			}
		}

		delete[]aData;
		delete[]mData;
		delete[]aNew;
		mData=aNewData;
		
		int aWidth=mWidth;
		mWidth=mHeight;
		mHeight=aWidth;
		
		aWidth=mExpandedWidth;
		mExpandedWidth=mExpandedHeight;
		mExpandedHeight=aWidth;
	}
}

int FImage::GetRight(int pCol)
{
	int aReturn = -1;
	if(pCol>=0&&pCol<mHeight)
	{
		unsigned int*aStart=&mData[pCol*mWidth];
		unsigned int*aSeek=aStart;
		unsigned int*aCap=aStart+mWidth;
		
		while (aSeek<aCap)
		{
			if((*aSeek & IMAGE_ALPHA_BITS)!=0)
			{
				aReturn=(int)(aSeek-aStart);
			}
			aSeek++;
		}
	}
	return aReturn;
}

int FImage::GetLeft(int pCol)
{
	int aReturn = -1;
	if(pCol>=0&&pCol<mHeight)
	{
		unsigned int*aStart=&mData[pCol*mWidth];
		unsigned int*aSeek=aStart;
		unsigned int*aCap=aStart+mWidth;
		
		while (aSeek<aCap)
		{
			if(((*aSeek & IMAGE_ALPHA_BITS)!=0)&&(aReturn==-1))
			{
				aReturn=(int)(aSeek-aStart);
			}
			aSeek++;
		}
		
	}
	return aReturn;
}

void FImage::GetEdges(int &pLeft, int &pRight, int &pTop, int &pBottom)
{
	int aLeft=0, aRight=0, aTop=0, aBottom=0;
	int aContinue;
	int n,i;
	if(mExpandedWidth>0&&mExpandedHeight>0)
	{
		unsigned int **aData=new unsigned int*[mExpandedHeight];
		unsigned int *aPtr=mData;
		for(n=0;n<mExpandedHeight;n++)
		{
			aData[n]=aPtr;
			aPtr+=mExpandedWidth;
		}
		
		//Left
		aContinue=1;
		aLeft=0;
		while(aContinue==1&&aLeft<mExpandedWidth)
		{
			for(n=0;n<mExpandedHeight;n++)
			{
				if((aData[n][aLeft] & IMAGE_ALPHA_BITS)!=0)aContinue=0;
			}
			if(aContinue)aLeft++;
		}
		
		aContinue=1;
		aRight=mExpandedWidth-1;
		while(aContinue==1&&aRight>=0)
		{
			for(n=0;n<mExpandedHeight;n++)
			{
				if((aData[n][aRight] & IMAGE_ALPHA_BITS)!=0)aContinue=0;
			}
			if(aContinue)aRight--;
		}
		
		aContinue=1;
		aTop=0;
		while(aContinue==1&&aTop<mExpandedHeight)
		{
			for(i=0;i<mExpandedWidth;i++)
			{
				if((aData[aTop][i] & IMAGE_ALPHA_BITS)!=0)aContinue=0;
			}
			if(aContinue)aTop++;
		}
		
		aContinue=1;
		aBottom=mExpandedHeight-1;
		while(aContinue==1&&aBottom>=0)
		{
			for(i=0;i<mExpandedWidth;i++)
			{
				if((aData[aBottom][i] & IMAGE_ALPHA_BITS)!=0)aContinue=0;
			}
			if(aContinue)aBottom--;
		}

		delete[]aData;
	}
	
	if(aLeft>=aRight||aTop>aBottom)
	{
		pLeft=0;
		pRight=0;
		pTop=0;
		pBottom=0;
	}
	else
	{
		pLeft=aLeft+mOffsetX;
		pRight=aRight+mOffsetX;
		pTop=aTop+mOffsetY;
		pBottom=aBottom+mOffsetY;
	}
}

void FImage::Stroke(unsigned int pColor, unsigned int pAlpha, int pSize, int pFade)
{
	if(mExpandedWidth<=0||mExpandedHeight<=0||pSize<=0)return;
	
	unsigned int **aData=new unsigned int*[mExpandedHeight];
	unsigned int **aVisited=new unsigned int*[mExpandedHeight];
	unsigned int *aVisitedPtr=new unsigned int[(mExpandedWidth)*(mExpandedHeight)];
	unsigned int *aPtr=mData;
	
	int i, n, aX, aY;
	int aSize=pSize;
	int aSizeWeight=aSize;
	
	for(n=0;n<mExpandedHeight;n++)
	{
		//aVisited[n]=aVisitedPtr;
		aData[n]=aPtr;
		
		aPtr+=mExpandedWidth;
		//aVisitedPtr+=mExpandedWidth;
	}
	
	aPtr=aVisitedPtr;
	for(n=0;n<mExpandedHeight;n++)
	{
		aVisited[n]=aPtr;
		//aData[n]=aPtr;
		
		aPtr+=mExpandedWidth;
		//aVisitedPtr+=mExpandedWidth;
	}
	
	unsigned int aAlpha=pAlpha;
	IMAGE_ALPHA_SHIFT(aAlpha);
	
	for(i=0;i<mExpandedWidth;i++)
	{
		for(n=0;n<mExpandedHeight;n++)
		{
			aVisited[n][i]=0xFFFFFFFF;
		}
	}
	
	for(i=0;i<mExpandedWidth;i++)
	{
		for(n=0;n<mExpandedHeight;n++)
		{
			if((aData[n][i]&IMAGE_ALPHA_BITS)>aAlpha)
			{
				if(n>0)
				{
					if((aData[n-1][i]&IMAGE_ALPHA_BITS)<=aAlpha)
					{
						aVisited[n-1][i]=0;
					}
				}
				if(n<mExpandedHeight-1)
				{
					if((aData[n+1][i]&IMAGE_ALPHA_BITS)<=aAlpha)
					{
						aVisited[n+1][i]=0;
					}
				}
				if(i>0)
				{
					if((aData[n][i-1]&IMAGE_ALPHA_BITS)<=aAlpha)
					{
						aVisited[n][i-1]=0;
					}
				}
				if(i<mExpandedWidth-1)
				{
					if((aData[n][i+1]&IMAGE_ALPHA_BITS)<=aAlpha)
					{
						aVisited[n][i+1]=0;
					}
				}
			}
		}
	}
	
	int aXStart, aXEnd, aYStart, aYEnd, aWeightX, aWeightY, aWeight;
	
	for(i=0;i<mExpandedWidth;i++)
	{
		for(n=0;n<mExpandedHeight;n++)
		{
			if(aVisited[n][i]==0)
			{
				aXStart=i-aSize;
				if(aXStart<0)aXStart=0;
				
				aYStart=n-aSize;
				if(aYStart<0)aYStart=0;
				
				aXEnd=i+aSize;
				if(aXEnd>=mExpandedWidth)aXEnd=mExpandedWidth-1;
				
				aYEnd=n+aSize;
				if(aYEnd>=mExpandedHeight)aYEnd=mExpandedHeight-1;

				for(aX=aXStart;aX<=aXEnd;aX++)
				{
					for(aY=aYStart;aY<=aYEnd;aY++)
					{
						aWeightX=aX-i;
						aWeightY=aY-n;
						if(aWeightX<0)aWeightX=-aWeightX;
						if(aWeightY<0)aWeightY=-aWeightY;						
						aWeight=aWeightX+aWeightY;

						if((aWeight<=aSizeWeight)&&((aData[aY][aX]&IMAGE_ALPHA_BITS)<=aAlpha)&&(aWeight<aVisited[aY][aX]))
						{
							aVisited[aY][aX]=aWeight;
						}
					}
				}
			}
		}
	}
	
	for(n=0;n<mExpandedHeight;n++)
	{
		for(i=0;i<mExpandedWidth;i++)
		{
			if(aVisited[n][i]!=0xFFFFFFFF)
			{
				aData[n][i]=pColor;
			}
		}
	}
	delete[]aData;
	delete[]aVisited;
	delete[]aVisitedPtr;
}

void FImage::MakePowerOf2()
{
	if(mWidth<=0||mHeight<=0)return;
	
    if(((mExpandedWidth&(mExpandedWidth-1))==0)&&((mExpandedHeight&(mExpandedHeight-1))==0))
	{
		return;
	}
	
	int aPower=1;
	int aHPower=0;
	int aVPower=0;
	
	while(aHPower==0||aVPower==0)
	{
		if(aHPower==0&&aPower>=mExpandedWidth)aHPower=aPower;
		if(aVPower==0&&aPower>=mExpandedHeight)aVPower=aPower;
		aPower*=2;
	}
	
	int aOldWidth=mWidth;
	int aOldHeight=mHeight;
	
	unsigned int *aOldData=mData;
	
	mExpandedWidth=0;
	mExpandedHeight=0;
	mData=0;
	
	MakeBlank(aHPower, aVPower);
	
	
	
	mExpandedWidth=aHPower;
	mExpandedHeight=aVPower;
	
	mOffsetX=(mExpandedWidth-aOldWidth)/2;
	mOffsetY=(mExpandedHeight-aOldHeight)/2;
	
	mWidth=aOldWidth;
	mHeight=aOldHeight;
	
	Stamp(aOldData, mOffsetX, mOffsetY, mWidth, mHeight);
	
	delete[]aOldData;
}



void FImage::Stamp(unsigned int *pData, int x, int y, int pWidth, int pHeight)
{
	//printf("Stamping{%d} (x=%d, y=%d, w=%d, h=%d) (realW=%d realH=%d)\n", pData,x,y,pWidth,pHeight,mExpandedWidth,mExpandedHeight);
    
	if(!pData||x>=mExpandedWidth||y>=mExpandedHeight)return;
    
	int aWidth=pWidth;
	int aHeight=pHeight;
    
	int aStampWidth=aWidth;
	unsigned int *aSrc=pData;
	unsigned int *aLastSrc;
	if(x<0)
	{
		aWidth+=x;
		aSrc-=x;
		x=0;
	}
	if(y<0)
	{
		aHeight+=y;
		aSrc-=y*aStampWidth;
		y=0;
	}
	if(aWidth<1||aHeight<1)return;
	if(x+aWidth>mExpandedWidth)aWidth=mExpandedWidth-x;
	if(y+aHeight>mExpandedHeight)aHeight=mExpandedHeight-y;
	unsigned int *aPtr=&mData[y*mExpandedWidth+x];
	unsigned int *aCap;
	unsigned int aCount=aHeight;
	unsigned int aSkipAhead=(mExpandedWidth-aWidth);
	while(aCount>0)
	{
		aCap=aPtr+aWidth;
		aLastSrc=aSrc;
		while(aPtr<aCap)*aPtr++=*aSrc++;
		aSrc=aLastSrc+aStampWidth;
		aPtr+=aSkipAhead;
		aCount--;
	}
}

void FImage::Stamp(FImage *pFImage, int x, int y, int pFImageX, int pFImageY, int pFImageWidth, int pFImageHeight)
{
	//Olschool Stamping...

	if(!pFImage)return;
    
    int aOffsetX = pFImage->mOffsetX;
    int aOffsetY = pFImage->mOffsetY;
	
	if(x<0)
	{
		pFImageWidth+=x;
		//pFImageX-=x;
		x=0;
	}
    
	if(y<0)
	{
		pFImageHeight+=y;
		//pFImageY-=y;
		y=0;
	}
	
	if(pFImageX<0)
	{
		pFImageWidth+=pFImageX;
        
        //aOffsetX += pFImageX;
        //aOffsetY += pFImageY;
        
		pFImageX=0;
	}
	if(pFImageY<0)
	{
		pFImageHeight+=pFImageY;
		pFImageY=0;
	}
	
	
	if(pFImageX>pFImage->mWidth)return;
	if(pFImageY>pFImage->mHeight)return;
	
	if(pFImageX+pFImageWidth>pFImage->mExpandedWidth)
	{
		pFImageWidth -= (pFImageX+pFImageWidth) - pFImage->mExpandedWidth;
	}
	if(pFImageY+pFImageHeight>pFImage->mExpandedHeight)
	{
		pFImageHeight -= (pFImageY+pFImageHeight) - pFImage->mExpandedHeight;
	}
	
	
	
	if(x+pFImageWidth>mWidth)
	{
		pFImageWidth-=(x+pFImageWidth)-(mWidth);
	}
	if(y+pFImageHeight>mHeight)
	{
		pFImageHeight-=(y+pFImageHeight)-(mHeight);
	}
	
	
	if(pFImageWidth<1 || pFImageHeight<1)return;
	
	//Why would we ever wanna stamp after we bind?..
	x+=mOffsetX;
	y+=mOffsetY;
	
	pFImageX+=aOffsetX;//pFImage->mOffsetX;
	pFImageY+=aOffsetY;//pFImage->mOffsetY;
	
	//Now we stamp one line at a time...
	unsigned int *aCopy=&pFImage->mData[pFImageY*pFImage->mExpandedWidth+pFImageX];
	unsigned int aCopySkip=pFImage->mExpandedWidth-pFImageWidth;
	
	unsigned int *aPaste=&mData[y*mExpandedWidth+x];
	unsigned int aPasteSkip=mExpandedWidth-pFImageWidth;
    
	unsigned int *aCap;
	
	unsigned int aLines=pFImageHeight;
	while(aLines)
	{
		aCap=aCopy+pFImageWidth;
		while(aCopy<aCap)
		{
			while(aCopy<aCap)
            {
                //printf("Pasting :%x\n", *aCopy);
                *aPaste++=*aCopy++;
            }
			aCopy+=aCopySkip;
			aPaste+=aPasteSkip;
		}
		aLines--;
	}
    
    return;
	
	/*
	if(!pFImage)return;
	
	if(x<0)
	{
		pFImageWidth+=x;
		pFImageX-=x;
		x=0;
	}
	if(y<0)
	{
		pFImageHeight+=y;
		pFImageY-=y;
		y=0;
	}
	
	
	if(pFImageX<0)
	{
		pFImageWidth+=pFImageX;
		pFImageX=0;
	}
	if(pFImageY<0)
	{
		pFImageHeight+=pFImageY;
		pFImageY=0;
	}
	
	
	if(pFImageX>pFImage->mWidth)return;
	if(pFImageY>pFImage->mHeight)return;
	
	if(pFImageX+pFImageWidth>pFImage->mWidth)
	{
		pFImageWidth -= (pFImageX+pFImageWidth) - pFImage->mWidth;
	}
	if(pFImageY+pFImageHeight>pFImage->mHeight)
	{
		pFImageHeight -= (pFImageY+pFImageHeight) - pFImage->mHeight;
	}
	
	
	
	if(x+pFImageWidth>mWidth)
	{
		pFImageWidth-=(x+pFImageWidth)-mWidth;
	}
	if(y+pFImageHeight>mHeight)
	{
		pFImageHeight-=(y+pFImageHeight)-mHeight;
	}
	
	
	if(pFImageWidth<1 || pFImageHeight<1)return;
	
	//Why would we ever wanna stamp after we bind?..
	x+=mOffsetX;
	y+=mOffsetY;
	
	pFImageX+=pFImage->mOffsetX;
	pFImageY+=pFImage->mOffsetY;
	
	
	//Now we stamp one line at a time...
	unsigned int *aCopy=&pFImage->mData[pFImageY*pFImage->mExpandedWidth+pFImageX];
	unsigned int aCopySkip=pFImage->mExpandedWidth-pFImageWidth;
	
	unsigned int *aPaste=&mData[y*mExpandedWidth+x];
	unsigned int aPasteSkip=mExpandedWidth-pFImageWidth;
    
	unsigned int *aCap;
	
	unsigned int aLines=pFImageHeight;
	while(aLines)
	{
		aCap=aCopy+pFImageWidth;
		while(aCopy<aCap)
		{
			while(aCopy<aCap)
            {
				if(IMAGE_ALPHA(*aCopy) > IMAGE_ALPHA(*aPaste))*aPaste=*aCopy;
                //printf("Pasting :%x\n", *aCopy);
                aPaste++;
				aCopy++;
            }
			aCopy+=aCopySkip;
			aPaste+=aPasteSkip;
		}
		aLines--;
	}
	
	*/
	
}

void FImage::StampBlend(FImage *pFImage,int x, int y, int pFImageX, int pFImageY, int pFImageWidth, int pFImageHeight)
{
	if(!pFImage)return;
	
	if(x<0)
	{
		pFImageWidth+=x;
		pFImageX-=x;
		x=0;
	}
    
	if(y<0)
	{
		pFImageHeight+=y;
		pFImageY-=y;
		y=0;
	}
	
	if(pFImageX<0)
	{
		pFImageWidth+=pFImageX;
		pFImageX=0;
	}
    
	if(pFImageY<0)
	{
		pFImageHeight+=pFImageY;
		pFImageY=0;
	}
	
	if(pFImageX>pFImage->mWidth)return;
	if(pFImageY>pFImage->mHeight)return;
	
	if(pFImageX+pFImageWidth>pFImage->mWidth)
	{
		pFImageWidth -= (pFImageX+pFImageWidth) - pFImage->mWidth;
	}
	if(pFImageY+pFImageHeight>pFImage->mHeight)
	{
		pFImageHeight -= (pFImageY+pFImageHeight) - pFImage->mHeight;
	}
	
	
	
	if(x+pFImageWidth>mWidth)
	{
		pFImageWidth-=(x+pFImageWidth)-mWidth;
	}
	if(y+pFImageHeight>mHeight)
	{
		pFImageHeight-=(y+pFImageHeight)-mHeight;
	}
	
	
	if(pFImageWidth<1 || pFImageHeight<1)return;
	
	//Why would we ever wanna stamp after we bind?..
	x+=mOffsetX;
	y+=mOffsetY;
	
	pFImageX+=pFImage->mOffsetX;
	pFImageY+=pFImage->mOffsetY;
	
	
	//Now we stamp one line at a time...
	unsigned int *aCopy=&pFImage->mData[pFImageY*pFImage->mExpandedWidth+pFImageX];
	unsigned int aCopySkip=pFImage->mExpandedWidth-pFImageWidth;
	
	unsigned int *aPaste=&mData[y*mExpandedWidth+x];
	unsigned int aPasteSkip=mExpandedWidth-pFImageWidth;
	
	unsigned int *aCap;
	
	unsigned int aLines=pFImageHeight;
	while(aLines)
	{
		aCap=aCopy+pFImageWidth;
		while(aCopy<aCap)
		{
			while(aCopy<aCap)
			{
				
				unsigned int aAlphaOriginal = IMAGE_ALPHA(*aPaste); //204
				unsigned int aAlphaOver = IMAGE_ALPHA(*aCopy); //51
				unsigned int aAlphaOverInverse = 255 - aAlphaOver;
				unsigned int aFinalAlpha = aAlphaOver + (aAlphaOverInverse * aAlphaOriginal) / 255;
				//unsigned int aFinalAlpha = aAlphaOver + (aAlphaOverInverse * aAlphaOriginal) >> 8;
				
				//printf("%d = %d + (%d * %d) / 255\n", aFinalAlpha, aAlphaOver, aAlphaOverInverse, aAlphaOriginal);
		
				
				unsigned int aFinalRed = ((IMAGE_RED(*aCopy) * aAlphaOver) + ((aAlphaOverInverse * aAlphaOriginal * IMAGE_RED(*aPaste))/255))/255;
				unsigned int aFinalGreen = ((IMAGE_GREEN(*aCopy) * aAlphaOver) + ((aAlphaOverInverse * aAlphaOriginal * IMAGE_GREEN(*aPaste))/255))/255;
				unsigned int aFinalBlue = ((IMAGE_BLUE(*aCopy) * aAlphaOver) + ((aAlphaOverInverse * aAlphaOriginal * IMAGE_BLUE(*aPaste))/255))/255;

				if(aFinalRed>160)aFinalRed=160;
                if(aFinalGreen>160)aFinalGreen=160;
                if(aFinalBlue>160)aFinalBlue=160;

				
				*aPaste = ((aFinalAlpha << 24) | (aFinalRed << 0) | (aFinalBlue << 16) | (aFinalGreen << 8));
				
				//*aPaste = ((aFinalAlpha << 24));
				
				aPaste++;
				aCopy++;
				
			}
			aCopy+=aCopySkip;
			aPaste+=aPasteSkip;
		}
		aLines--;
	}
}

/*
void FImage::StampSoft(FImage *pFImage,int x, int y, unsigned int pColor, int pFImageX, int pFImageY, int pFImageWidth, int pFImageHeight)
{
	
	
	
	
	//return;
	if(!pFImage)return;
	
	if(x<0)
	{
		pFImageWidth+=x;
		pFImageX-=x;
		x=0;
	}
	if(y<0)
	{
		pFImageHeight+=y;
		pFImageY-=y;
		y=0;
	}
	
	
	if(pFImageX<0)
	{
		pFImageWidth+=pFImageX;
		pFImageX=0;
	}
	if(pFImageY<0)
	{
		pFImageHeight+=pFImageY;
		pFImageY=0;
	}
	
	
	if(pFImageX>pFImage->mWidth)return;
	if(pFImageY>pFImage->mHeight)return;
	
	if(pFImageX+pFImageWidth>pFImage->mWidth)
	{
		pFImageWidth -= (pFImageX+pFImageWidth) - pFImage->mWidth;
	}
	if(pFImageY+pFImageHeight>pFImage->mHeight)
	{
		pFImageHeight -= (pFImageY+pFImageHeight) - pFImage->mHeight;
	}
	
	pColor=0x0F0F0F;
	
	if(x+pFImageWidth>mWidth)
	{
		pFImageWidth-=(x+pFImageWidth)-mWidth;
	}
	if(y+pFImageHeight>mHeight)
	{
		pFImageHeight-=(y+pFImageHeight)-mHeight;
	}
	
	
	if(pFImageWidth<1 || pFImageHeight<1)return;
	
	//Why would we ever wanna stamp after we bind?..
	x+=mOffsetX;
	y+=mOffsetY;
	
	pFImageX+=pFImage->mOffsetX;
	pFImageY+=pFImage->mOffsetY;
	
	
	//Now we stamp one line at a time...
	unsigned int *aCopy=&pFImage->mData[pFImageY*pFImage->mExpandedWidth+pFImageX];
	unsigned int aCopySkip=pFImage->mExpandedWidth-pFImageWidth;
	
	unsigned int *aPaste=&mData[y*mExpandedWidth+x];
	unsigned int aPasteSkip=mExpandedWidth-pFImageWidth;
	
	unsigned int *aCap;
	
	unsigned int aLines=pFImageHeight;
	
	//int aCounttt = 0;
	//if(gRand.Get(3)==0)aCounttt=-500000;
	
	while(aLines)
	{
		aCap=aCopy+pFImageWidth;
		while(aCopy<aCap)
		{
			while(aCopy<aCap)
			{
				int aAlpha;
				int aAlpha1 = IMAGE_ALPHA(*aPaste);
				int aAlpha2 = IMAGE_ALPHA(*aCopy);
				
				//aCounttt++;
				//if(aCounttt > 350)return;
				
				aAlpha = aAlpha1 <= aAlpha2 ? aAlpha2 : aAlpha1;
				
				//aAlpha = (aAlpha1 + aAlpha2) / 2;
				
				//aAlpha+=10;
				
				if(aAlpha > 255)// || aAlpha <=0)
				{
					//printf("Bizzarre?!?!?! %d\n", aAlpha);
					aAlpha = 255;
				}
				
				if(aAlpha<0)aAlpha=0;
				
				//if(aAlprintf("Alpha: %d\n", aAlpha);
				
				*aPaste = (pColor & 0x00FFFFFF) | (aAlpha << 24);
				// *aCopy = (pColor) | (aAlpha << 24);
				
				//unsigned int aPostAlpha = *aPaste & 0xFF000000;
				
				aPaste++;
				aCopy++;
			}
			aCopy+=aCopySkip;
			aPaste+=aPasteSkip;
		}
		aLines--;
	}
}
*/


FImage *FImage::Clone()
{
    return Crop(0, 0, mExpandedWidth, mExpandedHeight);
}

FImage *FImage::Crop(int x, int y, int pWidth, int pHeight)
{
    FImage *aReturn=new FImage();
    if(pWidth <= 0 || pHeight <= 0)return aReturn;
    if(pWidth > 4096 || pHeight > 4096)return aReturn;
    
    aReturn->Make(pWidth, pHeight, IMAGE_RGBA(255, 255, 255, 0));
    
    if(mExpandedWidth > 0 && mExpandedHeight > 0)
    {
        int aStartCopyX = x;//x;
        int aStartCopyY = y;//y;
        
        int aStartPasteX = 0; // (mExpandedWidth - pWidth) / 2;
        int aStartPasteY = 0; // (mExpandedHeight - pHeight) / 2;
        
        if(aStartCopyX < 0)
        {
            pWidth += aStartCopyX;
            aStartPasteX -= aStartCopyX;
            aStartCopyX =0 ;
        }
        
        if(aStartCopyY < 0)
        {
            pHeight += aStartCopyY;
            aStartPasteY -= aStartCopyY;
            aStartCopyY = 0;
        }
        
        if(aStartPasteX < 0)
        {
            pWidth += aStartPasteX;
            aStartCopyX -= aStartPasteX;
            aStartPasteX = 0;
        }
        
        if(aStartPasteY < 0)
        {
            pHeight += aStartPasteY;
            aStartCopyY -= aStartPasteY;
            aStartPasteY = 0;
        }
        
        if(aStartCopyX < mExpandedWidth && aStartCopyY < mExpandedHeight)
        {
            int aEndCopyX = aStartCopyX + pWidth;
            int aEndCopyY = aStartCopyY + pHeight;
            
            int aEndPasteX = aStartPasteX + pWidth;
            int aEndPasteY = aStartPasteY + pHeight;
            
            int aFix;
            
            if(aEndCopyY > mExpandedHeight)
            {
                aFix = (aEndCopyY - mExpandedHeight);
                aEndPasteY -= aFix;
                aEndCopyY -= aFix;
            }
            if(aEndPasteY > pHeight)
            {
                aFix = (aEndPasteY - pHeight);
                aEndPasteY -= aFix;
                aEndCopyY -= aFix;
            }
            
            
            
            if(aEndCopyX > mExpandedWidth)
            {
                aFix = (aEndCopyX - mExpandedWidth);
                aEndPasteX -= aFix;
                aEndCopyX -= aFix;
            }
            if(aEndPasteX > pWidth)
            {
                aFix = (aEndPasteX - pWidth);
                aEndPasteX -= aFix;
                aEndCopyX -= aFix;
            }
            
            if(aStartCopyX < aEndCopyX && aStartCopyY < aEndCopyY)
            {
                if(aStartPasteX < aEndPasteX && aStartPasteY  < aEndPasteY)
                {
            
            unsigned int *aPtr;
            unsigned int **aData=new unsigned int*[mExpandedHeight];
            aPtr=mData;
            for(int n=0;n<mExpandedHeight;n++)
            {
                aData[n]=aPtr;
                aPtr+=mExpandedWidth;
            }
            
            unsigned int **aNewData=new unsigned int*[aReturn->mExpandedHeight];
            aPtr=aReturn->mData;
            for(int n=0;n<aReturn->mExpandedHeight;n++)
            {
                aNewData[n]=aPtr;
                aPtr+=aReturn->mExpandedWidth;
            }
            
            for(int aCopyX=aStartCopyX, aPasteX=aStartPasteX;aCopyX<aEndCopyX;)
            {
                for(int aCopyY=aStartCopyY, aPasteY=aStartPasteY;aCopyY<aEndCopyY;)
                {
                    aNewData[aPasteY][aPasteX]=aData[aCopyY][aCopyX];
                    
                    aCopyY++;
                    aPasteY++;
                }
                
                aCopyX++;
                aPasteX++;
            }
            delete[]aData;
            delete[]aNewData;
                }
                else
                {
                    printf("Copy Indeces Out Of Bounds! Copy[%d %d %d %d] Paste[%d %d %d %d]\n", aStartCopyX, aStartCopyY, aEndCopyX, aEndCopyY, aStartPasteX, aStartPasteY, aEndPasteX, aEndPasteY);
                }
            }
            else
            {
                printf("Copy Indeces Out Of Bounds! Copy[%d %d %d %d] Paste[%d %d %d %d]\n", aStartCopyX, aStartCopyY, aEndCopyX, aEndCopyY, aStartPasteX, aStartPasteY, aEndPasteX, aEndPasteY);
            }
        }
    }
    return aReturn;
}



void FImage::StampSoft(FImage *pFImage,int x, int y, unsigned int pColor, int pFImageX, int pFImageY, int pFImageWidth, int pFImageHeight)
{
	
	
	
	
	//return;
	if(!pFImage)return;
	
	if(x<0)
	{
		pFImageWidth+=x;
		pFImageX-=x;
		x=0;
	}
	if(y<0)
	{
		pFImageHeight+=y;
		pFImageY-=y;
		y=0;
	}
	
	
	if(pFImageX<0)
	{
		pFImageWidth+=pFImageX;
		pFImageX=0;
	}
	if(pFImageY<0)
	{
		pFImageHeight+=pFImageY;
		pFImageY=0;
	}
	
	
	if(pFImageX>pFImage->mWidth)return;
	if(pFImageY>pFImage->mHeight)return;
	
	if(pFImageX+pFImageWidth>pFImage->mWidth)
	{
		pFImageWidth -= (pFImageX+pFImageWidth) - pFImage->mWidth;
	}
	if(pFImageY+pFImageHeight>pFImage->mHeight)
	{
		pFImageHeight -= (pFImageY+pFImageHeight) - pFImage->mHeight;
	}
	
	//pColor=0x0F0F0F;
	
	if(x+pFImageWidth>mWidth)
	{
		pFImageWidth-=(x+pFImageWidth)-mWidth;
	}
	if(y+pFImageHeight>mHeight)
	{
		pFImageHeight-=(y+pFImageHeight)-mHeight;
	}
	
	
	if(pFImageWidth<1 || pFImageHeight<1)return;
	
	//Why would we ever wanna stamp after we bind?..
	x+=mOffsetX;
	y+=mOffsetY;
	
	pFImageX+=pFImage->mOffsetX;
	pFImageY+=pFImage->mOffsetY;
	
	
	//Now we stamp one line at a time...
	unsigned int *aCopy=&pFImage->mData[pFImageY*pFImage->mExpandedWidth+pFImageX];
	unsigned int aCopySkip=pFImage->mExpandedWidth-pFImageWidth;
	
	unsigned int *aPaste=&mData[y*mExpandedWidth+x];
	unsigned int aPasteSkip=mExpandedWidth-pFImageWidth;
	
	unsigned int *aCap;
	
	unsigned int aLines=pFImageHeight;
	
	//int aCounttt = 0;
	//if(gRand.Get(3)==0)aCounttt=-500000;
	
	while(aLines)
	{
		aCap=aCopy+pFImageWidth;
		while(aCopy<aCap)
		{
			while(aCopy<aCap)
			{
				int aAlpha;
				int aAlpha1 = IMAGE_ALPHA(*aPaste);
				int aAlpha2 = IMAGE_ALPHA(*aCopy);
				
				if(aAlpha2 != 0)
				{
					//aCounttt++;
					//if(aCounttt > 350)return;
					
					aAlpha = aAlpha1 <= aAlpha2 ? aAlpha2 : aAlpha1;
					
					//aAlpha = (aAlpha1 + aAlpha2) / 2;
					
					//aAlpha+=10;
					
					if(aAlpha > 255)// || aAlpha <=0)
					{
						printf("Bizzarre?!?!?! %d\n", aAlpha);
						aAlpha = 255;
					}
					
					if(aAlpha<0)
					{
						printf("KillAlpha: %d\n", aAlpha);
						aAlpha=0;
					}
					
					//if(aAlprintf("Alpha: %d\n", aAlpha);
					
					*aPaste = (pColor & 0x00FFFFFF) | (IMAGE_ALPHA_SHIFT(aAlpha));
					//*aCopy = (pColor) | (aAlpha << 24);
					
					//unsigned int aPostAlpha = *aPaste & 0xFF000000;
				}
				
				aPaste++;
				aCopy++;
			}
			aCopy+=aCopySkip;
			aPaste+=aPasteSkip;
		}
		aLines--;
	}
}


void FImage::StampErase(FImage *pFImage,int x, int y, int pFImageX, int pFImageY, int pFImageWidth, int pFImageHeight)
{
	if(!pFImage)return;
	
	if(x<0)
	{
		pFImageWidth+=x;
		pFImageX-=x;
		x=0;
	}
	if(y<0)
	{
		pFImageHeight+=y;
		pFImageY-=y;
		y=0;
	}
	
	
	if(pFImageX<0)
	{
		pFImageWidth+=pFImageX;
		pFImageX=0;
	}
	if(pFImageY<0)
	{
		pFImageHeight+=pFImageY;
		pFImageY=0;
	}
	
	
	if(pFImageX>pFImage->mWidth)return;
	if(pFImageY>pFImage->mHeight)return;
	
	if(pFImageX+pFImageWidth>pFImage->mWidth)
	{
		pFImageWidth -= (pFImageX+pFImageWidth) - pFImage->mWidth;
	}
	if(pFImageY+pFImageHeight>pFImage->mHeight)
	{
		pFImageHeight -= (pFImageY+pFImageHeight) - pFImage->mHeight;
	}
	
	
	
	if(x+pFImageWidth>mWidth)
	{
		pFImageWidth-=(x+pFImageWidth)-mWidth;
	}
	if(y+pFImageHeight>mHeight)
	{
		pFImageHeight-=(y+pFImageHeight)-mHeight;
	}
	
	
	if(pFImageWidth<1 || pFImageHeight<1)return;
	
	//Why would we ever wanna stamp after we bind?..
	x+=mOffsetX;
	y+=mOffsetY;
	
	pFImageX+=pFImage->mOffsetX;
	pFImageY+=pFImage->mOffsetY;
	
	
	//Now we stamp one line at a time...
	unsigned int *aCopy=&pFImage->mData[pFImageY*pFImage->mExpandedWidth+pFImageX];
	unsigned int aCopySkip=pFImage->mExpandedWidth-pFImageWidth;
	
	unsigned int *aPaste=&mData[y*mExpandedWidth+x];
	unsigned int aPasteSkip=mExpandedWidth-pFImageWidth;
	
	unsigned int *aCap;
	
	unsigned int aLines=pFImageHeight;
	while(aLines)
	{
		aCap=aCopy+pFImageWidth;
		while(aCopy<aCap)
		{
			while(aCopy<aCap)
			{
				unsigned int aAlphaOver = IMAGE_ALPHA(*aCopy);
				
				if(aAlphaOver > 0)
				{
					unsigned int aAlphaOriginal = IMAGE_ALPHA(*aPaste);
					unsigned int aFinalAlpha = (aAlphaOriginal > aAlphaOver) ? (aAlphaOriginal-aAlphaOver) : 0;
					*aPaste = ((aFinalAlpha << 24) | ((*aPaste) & 0x00FFFFFF));
				}
				aPaste++;
				aCopy++;
			}
			aCopy+=aCopySkip;
			aPaste+=aPasteSkip;
		}
		aLines--;
	}
}

void FImage::StampErase(FImage *pFImage, int x, int y)
{
	if(pFImage)
	{
		StampErase(pFImage, x, y, 0, 0, pFImage->mWidth,pFImage->mHeight);
	}
}

void FImage::StampSoft(FImage *pFImage,unsigned int pColor, int x, int y)
{
	if(pFImage)
	{
		StampSoft(pFImage, x, y, pColor, 0, 0, pFImage->mWidth,pFImage->mHeight);
	}
}

void FImage::StampBlend(FImage *pFImage, int x, int y)
{
	if(pFImage)
	{
		StampBlend(pFImage, x, y, 0, 0, pFImage->mWidth,pFImage->mHeight);
	}
}

void FImage::Stamp(FImage *pFImage, int x, int y)
{
	if(pFImage)
	{
		Stamp(pFImage, x, y, 0, 0, pFImage->mWidth,pFImage->mHeight);
	}
}

void FImage::Replace(unsigned int pOldColor, unsigned int pNewColor)
{
	unsigned int *aSearch=mData;
	unsigned int *aCap=&mData[mExpandedWidth*mExpandedHeight];
	while(aSearch<aCap)
	{
		if(*aSearch==pOldColor)
		{
			*aSearch=pNewColor;
		}
		aSearch++;
		
	}
}

void FImage::ReplaceAlpha(unsigned int pOldAlpha, unsigned int pNewColor)
{
	unsigned int *aSearch=mData;
	unsigned int *aCap=&mData[mExpandedWidth*mExpandedHeight];
	while(aSearch<aCap)
	{
		if(IMAGE_ALPHA(*aSearch)==pOldAlpha)
		{
			*aSearch=pNewColor;
		}
		aSearch++;
		 
	}
}

void FImage::Invert()
{
    unsigned int aRed,aGreen,aBlue,aAlpha;
    unsigned int *aSearch=mData;
	unsigned int *aCap=&mData[mExpandedWidth*mExpandedHeight];
	while(aSearch<aCap)
	{
        aRed = 255-IMAGE_RED(*aSearch);
        aGreen = 255-IMAGE_GREEN(*aSearch);
        aBlue = 255-IMAGE_BLUE(*aSearch);
        aAlpha = IMAGE_ALPHA(*aSearch);
        
        *aSearch=(IMAGE_RED_SHIFT(aRed) | IMAGE_GREEN_SHIFT(aGreen) | IMAGE_BLUE_SHIFT(aBlue) | IMAGE_ALPHA_SHIFT(aAlpha));
        aSearch++;
        
    }
}


void FImage::SubtractRGBA()
{
    int aSubAmount=32;
    unsigned int aRed,aGreen,aBlue,aAlpha;
    unsigned int *aSearch=mData;
	unsigned int *aCap=&mData[mExpandedWidth*mExpandedHeight];
	while(aSearch<aCap)
	{
        
        aRed=IMAGE_RED(*aSearch);
        aGreen=IMAGE_GREEN(*aSearch);
        aBlue=IMAGE_BLUE(*aSearch);
        aAlpha=IMAGE_ALPHA(*aSearch);
        
        //if(aRed>=aSubAmount)aRed-=aSubAmount;
        //else aRed=0;
        //if(aGreen>=aSubAmount)aGreen-=aSubAmount;
        //else aGreen=0;
        //if(aBlue>=aSubAmount)aBlue-=aSubAmount;
        //else aBlue=0;
        
        if(aAlpha>=aSubAmount)aAlpha-=aSubAmount;
        else aAlpha=0;
        
        *aSearch=(IMAGE_RED_SHIFT(aRed) | IMAGE_GREEN_SHIFT(aGreen) | IMAGE_BLUE_SHIFT(aBlue) | IMAGE_ALPHA_SHIFT(aAlpha));
        aSearch++;
        
    }
}

void FImage::DivideRGBA()
{
    
    unsigned int aRed,aGreen,aBlue,aAlpha;
    
    unsigned int *aSearch=mData;
	unsigned int *aCap=&mData[mExpandedWidth*mExpandedHeight];
	while(aSearch<aCap)
	{
        aRed=IMAGE_RED(*aSearch)>>1;
        aGreen=IMAGE_GREEN(*aSearch)>>1;
        aBlue=IMAGE_BLUE(*aSearch)>>1;
        aAlpha=IMAGE_ALPHA(*aSearch)>>1;
        
        *aSearch=(IMAGE_RED_SHIFT(aRed) | IMAGE_GREEN_SHIFT(aGreen) | IMAGE_BLUE_SHIFT(aBlue) | IMAGE_ALPHA_SHIFT(aAlpha));
        aSearch++;
    }
}


void FImage::SubtractAlpha(int pAmount)
{
	if(pAmount>0)pAmount=-pAmount;
	
	unsigned int *aSearch=mData;
	unsigned int *aCap=&mData[mExpandedWidth*mExpandedHeight];
	
	int aAlpha;
	
	while(aSearch<aCap)
	{
        aAlpha=((int)IMAGE_ALPHA(*aSearch)) + pAmount;
		if(aAlpha<0)aAlpha=0;
		
		*aSearch = (*aSearch & 0x00FFFFFF) | IMAGE_ALPHA_SHIFT(aAlpha);
		
        aSearch++;
    }
	
}


void FImage::SetPixel(int x, int y, unsigned int pRed, unsigned int pGreen, unsigned int pBlue, unsigned int pAlpha)
{
	SetPixel(x, y,(pRed<<24)|(pGreen<<16)|(pBlue<<8)|(pAlpha));
}

void FImage::SetPixel(int x, int y, unsigned int pColor)
{
	if(x<0||x>=mExpandedWidth||y<0||y>=mExpandedHeight)return;
	mData[y*mExpandedWidth+x]=pColor;
}





void FImage::SetPixelBlendMax(int x, int y, unsigned int pColor)
{
    if(x<0||x>=mExpandedWidth||
       y<0||y>=mExpandedHeight)return;
    
    unsigned int aNewRed=IMAGE_RED(pColor);
    unsigned int aNewGreen=IMAGE_GREEN(pColor);
    unsigned int aNewBlue=IMAGE_BLUE(pColor);
    unsigned int aNewAlpha=IMAGE_ALPHA(pColor);
    
    unsigned int aRed=IMAGE_RED(mData[y*mExpandedWidth+x]);
    unsigned int aGreen=IMAGE_GREEN(mData[y*mExpandedWidth+x]);
    unsigned int aBlue=IMAGE_BLUE(mData[y*mExpandedWidth+x]);
    unsigned int aAlpha=IMAGE_ALPHA(mData[y*mExpandedWidth+x]);
    
    if(aRed > aNewRed)aNewRed=aRed;
    if(aBlue > aNewBlue)aNewBlue=aBlue;
    if(aGreen > aNewGreen)aNewGreen=aGreen;
    if(aAlpha > aNewAlpha)aNewAlpha=aAlpha;
    
	mData[y*mExpandedWidth+x] = (0x00000000 | IMAGE_ALPHA_SHIFT(aNewAlpha));
}


bool FImage::IsBlank()
{
	bool aReturn=true;
	unsigned int *aSearch=mData;
	unsigned int *aCap=&mData[mExpandedWidth*mExpandedHeight];
	while(aSearch<aCap)
	{
		if((IMAGE_ALPHA(*aSearch)))aReturn=false;
		aSearch++;
	}
	return aReturn;
}

//void				Flood(int pColor=0x000000FF){Flood(0,0,mExpandedWidth,mHeight,pColor);}


void FImage::Outline(int pSize, int pRed, int pGreen, int pBlue, int pAlpha)
{
    //Left Side
    
    
    unsigned int aColor = IMAGE_RGBA(pRed, pGreen, pBlue, pAlpha);
    
    
    //Left Side
    Flood(mOffsetX,mOffsetY,pSize,mHeight,aColor);
    
    
    //Right Side
    Flood(mOffsetX + mWidth - (pSize) - 1, mOffsetY, pSize, mHeight,aColor);
    
    
    //Top
    Flood(mOffsetX,mOffsetY,mWidth,pSize,aColor);
    
    
    //Bottom
    Flood(mOffsetX,mOffsetY + mHeight - pSize - 1,mWidth,pSize,aColor);
    
    
}

void FImage::OutlineRect(int x, int y, int pWidth, int pHeight, int pSize, unsigned int pColor)
{
    
    Flood(x-pSize, y-pSize, pWidth+pSize*2, pSize, pColor);
    Flood(x-pSize, y-pSize, pSize, pHeight+pSize*2, pColor);
    
    Flood(x, y + pHeight, pWidth + pSize , pSize, pColor);
    
    Flood(x+pWidth, y - pSize, pSize , pHeight+pSize * 2, pColor);
    
}

void FImage::Flood(int x, int y, int pWidth, int pHeight, unsigned int pColor)
{
	if(x<0)
	{
		pWidth+=x;
		x=0;
	}
	if(y<0)
	{
		pHeight+=y;
		y=0;
	}
	if(pWidth<0||pHeight<0||x>=mExpandedWidth||y>=mExpandedHeight)return;
	if(x+pWidth>mExpandedWidth)pWidth=mExpandedWidth-x;
	if(y+pHeight>mExpandedHeight)pHeight=mExpandedHeight-y;
	unsigned int *aPtr=&mData[y*mExpandedWidth+x];
	unsigned int *aCap;
	unsigned int aCount=pHeight;
	unsigned int aSkipAhead=(mExpandedWidth-pWidth);
	while(aCount>0)
	{
		aCap=aPtr+pWidth;
		while(aPtr<aCap)*aPtr++=pColor;
		aPtr+=aSkipAhead;
		aCount--;
	}
}

void FImage::FloodTransparent(int pColor)
{
    unsigned int *aSearch=mData;
	unsigned int *aCap=&mData[mExpandedWidth*mExpandedHeight];
	
	//int aAlpha;
	
	while(aSearch<aCap)
	{
        if(IMAGE_ALPHA(*aSearch) < 240)
        {
            *aSearch = pColor;
        }
        aSearch++;
    }
}

void FImage::Print()
{
	printf("\n");
	printf("FImage W=%d H=%d\n", mExpandedWidth, mExpandedHeight);
	printf("\n");
	for(int n=0;n<mExpandedHeight;n++)
	{
		FString aString;
		for(int i=0;i<mExpandedWidth;i++)
		{
			//aString+=Sprintf("%u8X|", ((mData[n*mExpandedWidth+i])<<0));
		}
		printf("Row[%3d]={%s}\n", n,aString.c());
	}
}

/*
void FImage::LoadOverDirect(char *pFile)
{
    
    FImage aFImage;
    aFImage.LoadDirect(pFile);
    Stamp(&aFImage);
    Rebind();		
}

void FImage::LoadOver(char *pFile)
{
	if(mPath==pFile)
	{
		return;
	}
	mPath=pFile;
	
	FString aPath=gDirBundle+pFile;
	
	LoadOverDirect(aPath.c());
}

void FImage::LoadDirect(char *pFile)
{
    
	//printf("LoadDirect: [%s]\n", pFile);
	Kill();
	
	mPath=pFile;
    mScale=1.0f;
	
	FString aPath=pFile;
	mData=LoadFImage(aPath.c(),mWidth,mHeight,mScale);
    
	mExpandedWidth=mWidth;
	mExpandedHeight=mHeight;
	mOffsetX=0;
	mOffsetY=0;
	if(mExpandedWidth==0||mExpandedHeight==0)
	{
		//printf("Must have had an error loading: [%s]\n", aPath.c());
	}
}

void FImage::LoadClean(char *pFile)
{
    Kill();
	
	mPath=pFile;
    mScale=1.0f;
	
	FString aPath=pFile;
	mData=LoadFImageClean(aPath.c(),mWidth,mHeight);
    
	mExpandedWidth=mWidth;
	mExpandedHeight=mHeight;
	mOffsetX=0;
	mOffsetY=0;
	if(mExpandedWidth==0||mExpandedHeight==0)
	{
		//printf("Must have had an error loading: [%s]\n", aPath.c());
	}
}

void FImage::Load(char *pFile)
{
    FString aFile=pFile;
    FString aExtension = aFile.RemoveExtension();
    mPath=aFile;
    
    if(gIsIpad)
    {
        if(mWidth==0)LoadDirect(gDirBundle + aFile + FString("@2x.png"));
        if(mWidth==0)LoadDirect(gDirBundle + aFile + FString("@2x.jpg"));
        if(mWidth==0)LoadDirect(gDirBundle + aFile + FString("@2x.jpeg"));
        
        if(mWidth==0)LoadDirect(gDirBundle + aFile + FString("@2x.PNG"));
        if(mWidth==0)LoadDirect(gDirBundle + aFile + FString("@2x.JPG"));
        if(mWidth==0)LoadDirect(gDirBundle + aFile + FString("@2x.JPEG"));
    }
    
    if(mWidth==0)LoadDirect(gDirBundle + aFile + FString(".png"));
    if(mWidth==0)LoadDirect(gDirBundle + aFile + FString(".jpg"));
    if(mWidth==0)LoadDirect(gDirBundle + aFile + FString(".jpeg"));
    
    if(mWidth==0)LoadDirect(gDirBundle + aFile + FString(".PNG"));
    if(mWidth==0)LoadDirect(gDirBundle + aFile + FString(".JPG"));
    if(mWidth==0)LoadDirect(gDirBundle + aFile + FString(".JPEG"));
    
    if(mWidth==0)LoadDirect(gDirBundle + aFile);
    
    
    if(gFImageBundler.mAutoBundle)
    {
        if(mWidth > 0 && mHeight > 0)
        {
            FImage *aBundled = new FImage();
            
            aBundled->Make(mWidth, mHeight);
            aBundled->Stamp(this);
            aBundled->mPath=mPath;
            gFImageBundler.AddFImage(aBundled);
            
            delete aBundled;
        }
    }
    
}

void FImage::LoadOver(unsigned int *pData, int pWidth, int pHeight)
{
	mData=pData;
	
	mWidth=pWidth;
	mHeight=pHeight;
	
	
	mExpandedWidth=mWidth;
	mExpandedHeight=mHeight;
	
	if(mBindIndex==-1)
	{
		MakePowerOf2();
		Bind();
	}
	else
	{
		//Stamp(unsigned int *pData, int x, int y, int pWidth, int pHeight);
		Stamp(pData, (mExpandedWidth-mWidth)/2, (mExpandedHeight-mHeight)/2,mWidth,mHeight);
		//delete[]pData;
		Rebind();
	}
}
*/

void FImage::Rebind()
{
	//glBindTexture(GL_TEXTURE_2D, mBindIndex);
	//glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	//glTexFImage2D(GL_TEXTURE_2D, 0, GL_RGBA,mExpandedWidth,mExpandedHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE,mData);
    
    gfx_bindTexture(mBindIndex,mData,mExpandedWidth,mExpandedHeight);
}

void FImage::Bind()
{
	if(mExpandedWidth<=0||mExpandedHeight<=0||mBindIndex>0)
	{
        //printf("Can't Bind: [W:%d H:%d I:%d]\n", mExpandedWidth, mExpandedHeight, mBindIndex);
		return;
	}
	
	MakePowerOf2();
    
    mBindIndex = gfx_generateTexture(mData, mExpandedWidth, mExpandedHeight);
    
	if(gAppBase)gAppBase->BindAdd(mBindIndex);
}



unsigned int AverageColors(unsigned int pColor1, unsigned int pColor2)
{
	unsigned int aRed1 = IMAGE_RED(pColor1);
	unsigned int aGreen1 = IMAGE_GREEN(pColor1);
	unsigned int aBlue1 = IMAGE_BLUE(pColor1);
	unsigned int aAlpha1 = IMAGE_ALPHA(pColor1);
	
	unsigned int aRed2 = IMAGE_RED(pColor2);
	unsigned int aGreen2 = IMAGE_GREEN(pColor2);
	unsigned int aBlue2 = IMAGE_BLUE(pColor2);
	unsigned int aAlpha2 = IMAGE_ALPHA(pColor2);
	
	unsigned int aFinalRed = ((aRed1 + aRed2) >> 1);
	unsigned int aFinalGreen = ((aGreen1 + aGreen2) >> 1);
	unsigned int aFinalBlue = ((aBlue1 + aBlue2) >> 1);
	unsigned int aFinalAlpha = ((aAlpha1 + aAlpha2) >> 1);
    
	return ((aFinalAlpha << 24) | (aFinalRed << 0) | (aFinalBlue << 16) | (aFinalGreen << 8));
}
