#include "FList.h"
#include "stdafx.h"

FList::FList()
{
	mData=0;
	mSize=0;
	mCount=0;
	mProperties=0;
}

FList::~FList()
{
	Clear();
}
		
void FList::Clear()
{
	delete[]mData;
	mData=0;
	mSize=0;
	mCount=0;
}

void FList::Size(int pSize)
{
	if(pSize<=0)
	{
		Clear();
		return;
	}
	if(mCount>pSize)mCount=pSize;
	void **aData=new void*[pSize];
	void **aCopy=mData;
	void **aPaste=aData;
	void **aShelf=mData+mCount;
	while(aCopy<aShelf)
	{
		*aPaste=*aCopy;
		aCopy++;
		aPaste++;
	}
	delete[]mData;
	mData=aData;
	mSize=pSize;
}

void FList::Add(void *pItem)
{
	if(!pItem)return;
	if(mCount==mSize)
	{
		mSize=mCount+mCount/2+1;
		void **aData=new void*[mSize];
		void **aCopy=mData;
		void **aPaste=aData;
		void **aShelf=mData+mCount;
		while(aCopy<aShelf)
		{
			*aPaste=*aCopy;
			aCopy++;
			aPaste++;
		}
		delete[]mData;
		mData=aData;
	}
	mData[mCount]=pItem;
	mCount++;
}

void FList::Insert(void *pItem, int pSlot)
{
	if(!pItem)return;
	if(mCount==mSize)
	{
		mSize=mCount+mCount/2+1;
		void **aData=new void*[mSize];
		void **aCopy=mData;
		void **aPaste=aData;
		void **aShelf=mData+mCount;
		while(aCopy<aShelf)
		{
			*aPaste=*aCopy;
			aCopy++;
			aPaste++;
		}
		delete[]mData;
		mData=aData;
	}
	if(pSlot<0)pSlot=0;
	if(pSlot>mCount)pSlot=mCount;
	void **aSlot=&mData[pSlot-1];
	void **aPaste=&mData[mCount];
	void **aCopy=&mData[mCount-1];
	while(aCopy>aSlot)
	{
		*aPaste=*aCopy;
		aPaste--;
		aCopy--;
	}
	mData[pSlot]=pItem;
	mCount++;
}

void FList::Add(FList &pFList)
{
	if(mCount+pFList.mCount>mSize)
	{
		mSize=mCount+pFList.mCount;
		void **aData=new void*[mSize];
		void **aCopy=mData;
		void **aPaste=aData;
		void **aShelf=mData+mCount;
		while(aCopy<aShelf)
		{
			*aPaste=*aCopy;
			aCopy++;
			aPaste++;
		}
		delete[]mData;
		mData=aData;
	}
	for(int i=0;i<pFList.mCount;i++)Add(pFList.mData[i]);
}

void FList::Remove(FList &pFList)
{
	for(int i=0;i<pFList.mCount;i++)Remove(pFList.mData[i]);
}

void FList::RemoveAtIndex(int pIndex)
{
    if(pIndex < 0 || pIndex >= mCount)return;
    
    void **aSeek=mData+pIndex;
	void **aShelf=mData+mCount;
    
    void **aCopy=aSeek;
    aSeek++;
    
    while(aSeek<aShelf)
    {
        *aCopy=*aSeek;
        aCopy++;
        aSeek++;
    }
    
    mCount--;
}

void FList::Remove(void *pItem)
{
	void **aSeek=mData;
	void **aShelf=mData+mCount;
	while(aSeek<aShelf)
	{
		if(*aSeek==pItem)break;
		aSeek++;
	}
	if(aSeek<aShelf)
	{
		void **aCopy=aSeek;
		aSeek++;
		while(aSeek<aShelf)
		{
			if(*aSeek!=pItem)
			{
				*aCopy=*aSeek;
				aCopy++;
			}
			aSeek++;
		}
		mCount=aCopy-mData;
	}
}

void *FList::FetchBest(int pIndex)
{
    if(pIndex<=0)pIndex=0;
    if(pIndex>=mCount)pIndex=mCount-1;
    return Fetch(pIndex);
}

void *FList::Fetch(int pIndex)
{
    if(pIndex >= 0 && pIndex < mCount)return mData[pIndex];
    return 0;
}

void *FList::FetchCircular(int pIndex)
{
    if(mCount > 0)
    {
        if(pIndex < 0 || pIndex >= mCount)
        {
            
            pIndex = pIndex % mCount;
            if(pIndex < 0)pIndex+=mCount;
            if(pIndex >= mCount)pIndex-=mCount;
            
        }
        
        return mData[pIndex];
    }
    
    return 0;
}

void *FList::Pop()
{
	void *aReturn=0;
	if(mCount>0)
	{
		aReturn=mData[0];
		for(int i=1;i<mCount;i++)
		{
			mData[i-1]=mData[i];
		}
		mCount--;
	}
	return aReturn;
}

void FList::RemoveFirst(void *pItem)
{
	void **aSeek=mData;
	void **aShelf=mData+mCount;
	while(aSeek<aShelf)
	{
		if(*aSeek==pItem)break;
		aSeek++;
	}
	if(aSeek<aShelf)
	{
		void **aCopy=aSeek;
		aSeek++;
		while(aSeek<aShelf)
		{
			*aCopy=*aSeek;
			aCopy++;
			aSeek++;
		}
		mCount--;
	}
}

void FList::MoveObjectUp(void *pItem)
{
    void **aSeek=mData;
	void **aShelf=mData+mCount;
	while(aSeek<aShelf)
	{
		if(*aSeek==pItem)break;
		aSeek++;
	}
    if(aSeek<(aShelf-1))
    {

            void *aHold = *aSeek;
            *aSeek = *(aSeek+1);
            *(aSeek+1)=aHold;
            printf("Moving Up: (Success!!!)\n");

    }
    else
    {
        printf("Moving Up: (Object Not Found, Or At End..)\n");
    }
}

void FList::MoveObjectDown(void *pItem)
{
    void **aSeek=mData;
	void **aShelf=mData+mCount;
	while(aSeek<aShelf)
	{
		if(*aSeek==pItem)break;
		aSeek++;
	}
    if(aSeek<aShelf)
    {
        
        if(aSeek > mData)
        {
            void *aHold = *aSeek;
            *aSeek = *(aSeek-1);
            *(aSeek-1)=aHold;
            printf("Moving Down: (Success)\n");
        }
        else
        {
            printf("Moving Down: (Object Not Found, Or At End..)\n");
        }
    }
}

int FList::Find(void *pItem)
{
	void **aSeek=mData;
	void **aShelf=mData+mCount;
	while(aSeek<aShelf)
	{
		if(*aSeek==pItem)break;
		aSeek++;
	}
	int aReturn=-1;
	if(aSeek<aShelf)aReturn=(int)(aSeek-mData);
	return aReturn;
}

bool FList::Exists(void *pItem)
{
	void **aSeek=mData;
	void **aShelf=mData+mCount;
	while(aSeek<aShelf)
	{
		if(*aSeek==pItem)break;
		aSeek++;
	}
	return aSeek<aShelf;
}

void FList::Reverse()
{
	if(mCount>0)
	{
		void **aTop=mData+(mCount-1);
		void **aBottom=mData;
		void *aHold;
		while(aTop>aBottom)
		{
			aHold=*aTop;
			*aTop=*aBottom;
			*aBottom=aHold;
			aTop--;
			aBottom++;
		}
	}
}

void FList::RemoveLast(void *pItem)
{
	if(mCount==0)return;
	void **aSeek=mData+(mCount-1);
	void **aShelf=mData;
	while(aSeek>=aShelf)
	{
		if(*aSeek==pItem)break;
		aSeek--;
	}
	while(aSeek<aShelf&&*aSeek!=pItem)aSeek++;
	if(aSeek>=aShelf)
	{
		void **aCopy=aSeek;
		aShelf=mData+mCount;
		aSeek++;
		while(aSeek<aShelf)
		{
			*aCopy=*aSeek;
			aCopy++;
			aSeek++;
		}
		mCount--;
	}
}


void FList::RemoveAllBefore(int pIndex)
{
    if(pIndex >= (mCount - 1))
    {
        mCount=0;
    }
    else if(pIndex <= 0)
    {
        //Do Nothing
    }
    else
    {
        int aNewCount = mCount - pIndex;
        
        for(int i=0;i<aNewCount;i++)
        {
            mData[i]=mData[i+pIndex];
        }
        mCount = aNewCount;
    }
    
}

void FList::RemoveAllAfter(int pIndex)
{
    if(pIndex >= (mCount - 1))
    {
        //Do Nothing
    }
    else if(pIndex < 0)
    {
        mCount=0;
    }
    else
    {
        mCount=pIndex+1;
    }
}


void FList::MoveToFront(void *pItem)
{
	void **aSeek=mData;
	void **aShelf=mData+mCount;
	while(aSeek<aShelf)
	{
		if(*aSeek==pItem)break;
		aSeek++;
	}
	if(aSeek<aShelf)
	{
		aShelf=mData;
		while(aSeek>mData)
		{
			*aSeek=*(aSeek-1);
			aSeek--;
		}
		*mData=pItem;
	}
}

void FList::MoveToBack(void *pItem)
{
	void **aSeek=mData;
	void **aShelf=mData+mCount;
	while(aSeek<aShelf)
	{
		if(*aSeek==pItem)break;
		aSeek++;
	}
	if(aSeek<aShelf)
	{
		aShelf--;
		while(aSeek<aShelf)
		{
			*aSeek=*(aSeek+1);
			aSeek++;
		}
		*aShelf=pItem;
	}
}

void FList::Swap(void *pItem1, void *pItem2)
{
	void **aSeek1=mData;
	void **aSeek2=mData;
	void **aShelf=mData+mCount;
	while(aSeek1<aShelf)
	{
		if(*aSeek1==pItem1)break;
		aSeek1++;
	}
	while(aSeek2<aShelf)
	{
		if(*aSeek2==pItem2)break;
		aSeek2++;
	}
	if(aSeek1<aShelf&&aSeek2<aShelf)
	{
		*aSeek1=pItem2;
		*aSeek2=pItem1;
	}
}

void *FList::FetchRandom()
{
	void *aReturn=0;
	if(mCount>0)aReturn=mData[gRand.Get(mCount)];
	return aReturn;
}

void FList::Shuffle()
{
	void *aHold;
	int aRand;
	for(int i=0;i<mCount;i++)
	{
		aHold=mData[i];
		aRand=gRand.Get(mCount);
		mData[i]=mData[aRand];
		mData[aRand]=aHold;
	}
}



/*
void FList::Sort(void *pParameter)
{
	for (int i=1,int j;i<mCount;i++)
	{
		void *aHold=mData[i];
		j=i;
		while((j>0) && ((mData[j-1]+<aHold))
		{
			mIndex[j]=mIndex[j-1];
			j--;
		}
		mIndex[j]=aHold;
	}
}
 */

bool FList::IsSorted()
{
	for(int i=1;i<mCount;i++)if(mData[i-1]>mData[i])return false;
	return true;
}

void FList::ISort()
{
	int *aData=(int*)mData;
	int aStart;
	int aKey;
	int aCheck;
	for(aStart=1; aStart<mCount;aStart++)
	{
		aKey=aData[aStart];
		aCheck=aStart-1;
		while(aCheck>=0 && aData[aCheck] > aKey)
		{
			aData[aCheck+1]=aData[aCheck];
			aCheck--;
		}
		aData[aCheck+1]=aKey;
	}
}

void FList::Sort()
{
	if(mCount<2)return;
	
	int *aData=(int*)mData;
	
	//Insertion sort blocks of a given size...
#define INSERT_SORT_BLOCK_SIZE 7
	
	int aStart, aEnd, aKey, aCheck, aIndex;
	
	for(aIndex=0;aIndex<mCount;aIndex+=INSERT_SORT_BLOCK_SIZE)
	{
		aEnd=aIndex+INSERT_SORT_BLOCK_SIZE;
		if(aEnd>mCount)aEnd=mCount;
		for(aStart=aIndex+1; aStart<aEnd;aStart++)
		{
			aKey=aData[aStart];
			aCheck=aStart-1;
			while(aCheck>=aIndex && aData[aCheck] > aKey)
			{
				aData[aCheck+1]=aData[aCheck];
				aCheck--;
			}
			aData[aCheck+1]=aKey;
		}
	}
	
	if(mCount<INSERT_SORT_BLOCK_SIZE)return;
	
	//Now... We merge shit...
	
	int aBlockSize=INSERT_SORT_BLOCK_SIZE;
	int aMergeIndex1,aMergeIndex2;
	int aEndIndex1, aEndIndex2;
	int aNewIndex;
	
	int *aNew=new int[mCount];
	int *aHold=aData;
	
	aData=aNew;
	aNew=aHold;
	
	while(aBlockSize<mCount)
	{
		aHold=aData;
		aData=aNew;
		aNew=aHold;
		aIndex=0;
		while(aIndex<mCount)
		{
			aNewIndex=aIndex;
			aMergeIndex1=aIndex;
			aIndex+=aBlockSize;
			aEndIndex1=aIndex;
			aMergeIndex2=aIndex;
			aIndex+=aBlockSize;
			aEndIndex2=aIndex;
			if(aEndIndex1>mCount)aEndIndex1=mCount;
			if(aEndIndex2>mCount)aEndIndex2=mCount;
			while(aMergeIndex1<aEndIndex1 && aMergeIndex2<aEndIndex2)
			{
				if(aData[aMergeIndex1]<aData[aMergeIndex2])
				{
					aNew[aNewIndex]=aData[aMergeIndex1];
					aMergeIndex1++;
				}
				else
				{
					aNew[aNewIndex]=aData[aMergeIndex2];
					aMergeIndex2++;
				}
				aNewIndex++;
			}
			while(aMergeIndex1<aEndIndex1)
			{
				aNew[aNewIndex]=aData[aMergeIndex1];
				aMergeIndex1++;
				aNewIndex++;
			}
			while(aMergeIndex2<aEndIndex2)
			{
				aNew[aNewIndex]=aData[aMergeIndex2];
				aMergeIndex2++;
				aNewIndex++;
			}
		}
		aBlockSize*=2;
	}
	delete[]aData;
	mData=(void**)aNew;
}

void FList::Print()
{
	printf("~*~Printing FList~*~\n");
	printf("Size=%d Count=%d\n", mSize, mCount);
	
	int aSkip=0;
	
	for(int i=0;i<mCount;i++)
	{
		//int aInt=*((int*)(mData[i]));
		//printf("[%x]", (unsigned int)mData[i]);
		
		aSkip++;
		if(aSkip==20)
		{
			aSkip=0;
			printf("\n");
		}
		
	}
	
	printf("~*~End FList Print~*~\n");
	
}