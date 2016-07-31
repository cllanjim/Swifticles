#include "FString.h"
#include "stdafx.h"
#include <vector>

void FString::AddCommas()
{
	if(mLength > 3)
	{
		int aLength=mLength+mLength;
		char *aNew=new char[aLength+1];
		
		aLength=0;
		
		for(int i=mLength-1, k=0;i>=0;i--)
		{
            
			aNew[aLength]=mData[i];
			aLength++;
            
			k++;
			if(k==3 && i > 0)
			{
				aNew[aLength]=',';
				aLength++;
				k=0;
			}
		}
		
		delete[]mData;
		mData=aNew;
		
		mLength=aLength;
		mData[mLength]=0;
		
		Reverse();
        
		/*
		int aCommaCount=mLength / 3;
		int aCommaOffset=mLength % 3;
		if(aCommaOffset == 0)
		{
			aCommaOffset=3;
			aCommaCount--;
		}
		mLength=mLength+aCommaCount;
		char *aNew=new char[mLength+1];
		*/
        
        
        
	}
}

FString FString::GetNumber(int thePosition)
{
	FString aReturn;
	if(mData && thePosition < mLength && thePosition >= 0)
	{
		char *aSeek = &mData[thePosition];
		while(*aSeek && !(*aSeek >= '0' && *aSeek <= '9'))aSeek++;
		if(!*aSeek)goto RETURN;
		char *aStart = aSeek;
		bool aHaveDecimal = false;
		if(aStart > &mData[thePosition])
		{
			aSeek--;
			if(*aSeek == '+' || *aSeek == '-' || *aSeek == '.')
			{
				aStart--;
				if(*aSeek == '.')
				{
					aHaveDecimal=true;
					if(aStart > &mData[thePosition])
					{
						aStart--;
						if(*aStart != '+' && *aStart != '-')aStart++;
					}
				}
			}
			aSeek++;
		}
		while(*aSeek && (*aSeek >= '0' && *aSeek <= '9'))aSeek++;
		if(!aHaveDecimal)
		{
			if(*aSeek == '.')
			{
				aSeek++;
				while(*aSeek && (*aSeek >= '0' && *aSeek <= '9'))aSeek++;
			}
		}
		int aLength = (int)(aSeek - aStart);
		char *aNumber = new char[aLength + 1];
		aNumber[aLength] = 0;
		memcpy(aNumber, aStart, aLength);
		aReturn.mData = aNumber;
		aReturn.mLength = aLength;
		//aReturn.mRefs=new int;*aReturn.mRefs=1;
		mCursor=aSeek;
	}
RETURN:;
	return aReturn;
}

bool FString::ScrambledEquals(FString &pString)
{
	if(mLength!=pString.mLength)return false;
	
	int aCount1[256];
	int aCount2[256];
	
	for(int i=0;i<256;i++)
	{
		aCount1[i]=0;
		aCount2[i]=0;
	}
	
	unsigned char *aData=(unsigned char*)mData;
	while(*aData)
	{
		aCount1[(unsigned int)(*aData)]++;
		aData++;
	}
	
	aData=(unsigned char*)pString.mData;
	while(*aData)
	{
		aCount2[(unsigned int)(*aData)]++;
		aData++;
	}
	
	
	for(int i=0;i<256;i++)
	{
		if(aCount1[i]!=aCount2[i])return false;
	}
	return true;
}

void FString::ToPoint(float &theX, float &theY)
{
	theX=0;
	theY=0;
	if(mData)
	{
		char *aPtr = mData;
		while(*aPtr && !(*aPtr == '.' || *aPtr == '-' || (*aPtr >= '0' && *aPtr <= '9')))aPtr++;
		char *aXStart=aPtr;
		if(*aPtr == '-')aPtr++;
		while(*aPtr && (*aPtr == '.' || (*aPtr >= '0' && *aPtr <= '9')))aPtr++;
		int aXLength = (int)(aPtr - aXStart);
		while(*aPtr && !(*aPtr == '.' || *aPtr == '-' || (*aPtr >= '0' && *aPtr <= '9')))aPtr++;
		char *aYStart=aPtr;
		if(*aPtr == '-')aPtr++;
		while(*aPtr && (*aPtr == '.' || (*aPtr >= '0' && *aPtr <= '9')))aPtr++;
		int aYLength = (int)(aPtr - aYStart);
		if(aXLength > 0 && aYLength > 0)
		{
			
			char *aX = new char[aXLength + 1];
			char *aY = new char[aYLength + 1];
			
			aX[aXLength]=0;
			aY[aYLength]=0;
			
			memcpy(aX, aXStart, aXLength);
			memcpy(aY, aYStart, aYLength);
			
			theX = (float)atof(aX);
			theY = (float)atof(aY);
			
			delete [] aX;
			delete [] aY;
			
		}
	}
}

FString FString::RemovePath(bool pRemoveExtension)
{
	int aStartIndex=0;
	int aEndIndex=mLength;
	
	if(mLength > 0)
	{
		for(int i=mLength-1;i>=0;i--)
		{
			if(mData[i]=='\\' || mData[i]=='/')
			{
				aStartIndex=i+1;
				break;
			}
		}
		if(pRemoveExtension)
		{
			for(int i=mLength-1;i>=aStartIndex;i--)
			{
				if(mData[i] == '.')
				{
					aEndIndex=i-1;
				}
			}
		}
	}
    
    FString aReturn = GetSubString(aStartIndex, aEndIndex-aStartIndex+1);
    
    *this = GetSubString(aStartIndex, aEndIndex-aStartIndex+1);
	
    return aReturn;
    
}

FString FString::RemoveExtension()
{
    FString aReturn;
    for(int i=mLength-1;i>=0;i--)
    {
        if(mData[i] == '.')
        {
            aReturn=GetSubString(i+1, 1000);
            *this=GetSubString(0, i);
            break;
        }
    }
    
    return aReturn;
}

void FString::Encrypt(char *theKey)
{
	if(!theKey || !mData)return;
	//PrepForInlineModification();
	char *aTraverseData = mData;
	char *aShelf = &mData[mLength];
	char *aTraverseKey = theKey;
	while(aTraverseData < aShelf)
	{
		if(*aTraverseKey==0)aTraverseKey=theKey;
		if(*aTraverseData != *aTraverseKey)*aTraverseData ^= *aTraverseKey;
		aTraverseData++;
		aTraverseKey++;
	}
}

void FString::Decrypt(char *theKey)
{
	if(!theKey || !mData)return;
	//PrepForInlineModification();
	char *aTraverseData = mData;
	char *aShelf = &mData[mLength];
	char *aTraverseKey = theKey;
	while(aTraverseData < aShelf)
	{
		if(*aTraverseKey==0)aTraverseKey=theKey;
		if(*aTraverseData != *aTraverseKey)*aTraverseData ^= *aTraverseKey;
		aTraverseData++;
		aTraverseKey++;
	}
}

bool FString::IsNumber()
{
	if(!mData)return false;
	char *aChar = mData;
	bool aReturn = false;
	if(*aChar == '-' || *aChar == '+')aChar++;
	if(*aChar >= '0' && *aChar <= '9')
	{
		aReturn=true;
		while(*aChar >= '0' && *aChar <= '9')aChar++;
	}
	if(*aChar == '.')aChar++;
	if(*aChar >= '0' && *aChar <= '9')
	{
		aReturn=true;
		while(*aChar >= '0' && *aChar <= '9')aChar++;
	}
	aReturn &= *aChar == 0;
	return aReturn;
}

void FString::Concatenate(char *theString, int theNum)
{
	if(theNum > 0 && theString != 0)
	{
		int aNum = theNum;
		char *aTraverse = theString;
		while(aNum && *aTraverse){--aNum;++aTraverse;}
		aNum = (theNum - aNum);
		if(theNum > 0)
		{
			int aNewLen = mLength + aNum;
			char *aChar = new char[aNewLen + 1];aChar[aNewLen]=0;
			Stamp(aChar,mData,0,mLength);
			Stamp(aChar,theString,mLength,aNum);
			Free();
			mData=aChar;
			mLength=aNewLen;
			//mRefs=new int;*mRefs=1;
		}
	}
}

void FString::Concatenate(FString &theString, int theNum)
{
	if(theNum > 0 && theString.mLength > 0)
	{
		//int aNum = min(theNum, theString.mLength);
        int aNum = theString.mLength;
        if(theNum < aNum)aNum = theNum;
        
		int aNewLen = mLength + aNum;
		char *aChar = new char[aNewLen + 1];aChar[aNewLen]=0;
		Stamp(aChar,mData,0,mLength);
		Stamp(aChar,theString.mData,mLength,aNum);
		Free();
		mData=aChar;
		mLength=aNewLen;
		//mRefs=new int;*mRefs=1;
	}
}


int FString::CountCharacter(char c)
{
	int aReturn=0;
	char *aStart = mData;
	char *aEnd = &mData[mLength];
	while(aStart < aEnd){if(*aStart++==c)aReturn++;}
	return aReturn;
}

bool FString::ContainsDuplicateCharacters()
{
	for(int i=0;i<256;i++)
	{
		if(CountCharacter((char)i)>1)return true;
	}
	return false;
}


void FString::Reverse()
{
	if(mLength > 1)
	{
		//PrepForInlineModification();
		char *aStart = mData;
		char *aEnd = &mData[mLength-1];
		char *aHalf = &mData[mLength / 2];
		char aTemp;
		while(aStart < aHalf)
		{
			aTemp = *aStart;
			*aStart = *aEnd;
			*aEnd = aTemp;
			aStart++;
			aEnd--;
		}
	}
}

void FString::Remove(char *theDisallowed)
{
	if(!theDisallowed || mLength == 0)return;
	char *aNew = new char[mLength+1];
	char *aStamp = aNew;
	char *aChar = mData;
	char *aTraverse;
	while(*aChar)
	{
		aTraverse = theDisallowed;
		*aStamp = *aChar;
		aStamp++;
		while(*aTraverse)
		{
			if(*aTraverse == *aChar)
			{
				aStamp--;
				break;
			}
			aTraverse++;
		}
		aChar++;
	}
	*aStamp=0;
	Free();
	mLength = (int)(aStamp - aNew);
	mData = aNew;
	//mRefs = new int;*mRefs=1;
}

void FString::Filter(char *theAllowed)
{
	if(!theAllowed || mLength == 0)
	{
		Free();
		return;
	}
	char *aNew = new char[mLength+1];
	char *aStamp = aNew;
	char *aChar = mData;
	char *aTraverse;
	while(*aChar)
	{
		aTraverse = theAllowed;
		while(*aTraverse)
		{
			if(*aTraverse == *aChar)
			{
				*aStamp = *aTraverse;
				aStamp++;
				break;
			}
			aTraverse++;
		}
		aChar++;
	}
	*aStamp=0;
	Free();
	mLength = (int)(aStamp - aNew);
	mData = aNew;
	//mRefs = new int;*mRefs=1;
}

void FString::Delete(char *theString)
{
    Replace(theString, (char *)"");
}

void FString::Delete(int thePosition, int theLength)
{
	int aFinish = thePosition + theLength;
	if(aFinish > mLength)aFinish = mLength;
	if(thePosition < 0)thePosition=0;
	theLength=aFinish-thePosition;
	if(thePosition >= mLength || mLength == 0 || theLength < 1)return;
	int aNewLength = thePosition + (mLength - (thePosition + theLength));
	char *aChar = new char[aNewLength + 1];
	aChar[aNewLength]=0;
	Stamp(aChar, mData, 0, thePosition);
	Stamp(aChar, &mData[thePosition + theLength], thePosition, (mLength - (thePosition + theLength)));
	Free();
	mData = aChar;
	//mRefs = new int;*mRefs=1;
	mLength = aNewLength;
}

void FString::Delete(int thePosition)
{
	if(thePosition >= mLength || mLength == 0)return;
	if(thePosition <= 0){Free();return;}
	char *aChar = new char[thePosition + 1];aChar[thePosition]=0;
	Stamp(aChar, mData, 0, thePosition);
	Free();
	mData = aChar;
	//mRefs = new int;*mRefs=1;
	mLength = thePosition;
}

FString FString::GetSubString(int thePosition, int theLength)
{
	FString aReturn;
	if(thePosition < mLength && theLength > 0)
	{
		int aEnd = thePosition + theLength;
		if(thePosition < 0)thePosition=0;
		if(aEnd > mLength)aEnd=mLength;
		theLength = aEnd - thePosition;
		if(aEnd > thePosition)
		{
			char *aChar = new char[theLength+1];
			aChar[theLength]=0;
			Stamp(aChar, &mData[thePosition],0,theLength);
			aReturn.mData=aChar;
			aReturn.mLength=theLength;
			//aReturn.mRefs=new int;*aReturn.mRefs=1;
		}
	}
	return aReturn;
}

void FString::RemoveLeadingSpaces()
{
	if(mLength == 0)return;
	if(*mData > 32)return;
	char *aFinal = &mData[mLength-1];
	char *aChar = mData;
	while(aChar <= aFinal && *aChar < 33){aChar++;}
	int aOff = (int)(aChar - mData);
	int aLength = mLength - aOff;
	aChar = new char[aLength + 1];
	aChar[aLength]=0;
	Stamp(aChar,&mData[aOff],0,aLength);
	Free();
	mData=aChar;
	//mRefs=new int;*mRefs=1;
	mLength=aLength;
}

void FString::RemoveTrailingSpaces()
{
	if(mLength == 0)return;
	char *aChar = &mData[mLength-1];
	if(*aChar > 32)return;
	while(aChar >= mData && *aChar < 33){aChar--;}
	int aLength = (int)(aChar - mData + 1);
	aChar = new char[aLength + 1];
	aChar[aLength]=0;
	Stamp(aChar,mData,0,aLength);
	Free();
	mData=aChar;
	//mRefs=new int;*mRefs=1;
	mLength=aLength;
}

void FString::Insert(char theChar, int theQuantity, int thePosition)
{
	if(theQuantity <= 0)return;

	if(thePosition < 0)thePosition = 0;
	if(thePosition > mLength)thePosition=mLength;
	int aNewLen = mLength + theQuantity;
	char *aChar = new char[aNewLen + 1];
	Stamp(aChar, mData, 0, thePosition);

	char *aStamp = &aChar[thePosition];
	char *aStampFin = &aChar[thePosition + theQuantity];
	while(aStamp < aStampFin)
	{
		*aStamp=theChar;
		aStamp++;
	}

	Stamp(aChar, &mData[thePosition], thePosition + theQuantity, mLength - thePosition);
	Free();
	mLength = aNewLen;
	aChar[mLength]=0;
	//mRefs=new int;*mRefs=1;
	mData = aChar;
}

void FString::Insert(char theChar, int thePosition)
{
	if(theChar)
	{
		if(thePosition < 0)thePosition = 0;
		if(thePosition > mLength)thePosition=mLength;
		int aNewLen = mLength + 1;
		char *aChar = new char[aNewLen + 1];
		Stamp(aChar, mData, 0, thePosition);
		aChar[thePosition]=theChar;
		Stamp(aChar, &mData[thePosition], thePosition + 1, mLength - thePosition);
		Free();
		mLength = aNewLen;
		aChar[mLength]=0;
		//mRefs=new int;*mRefs=1;
		mData = aChar;
	}
}

void FString::Insert(char *theString, int thePosition)
{
	if(int aLen = Length(theString))
	{
		if(thePosition < 0)thePosition = 0;
		if(thePosition > mLength)thePosition=mLength;
		int aNewLen = mLength + aLen;
		char *aChar = new char[aNewLen + 1];
		Stamp(aChar, mData, 0, thePosition);
		Stamp(aChar, theString, thePosition, aLen);
		Stamp(aChar, &mData[thePosition], thePosition + aLen, mLength - thePosition);
		Free();
		mLength = aNewLen;
		aChar[mLength]=0;
		//mRefs=new int;*mRefs=1;
		mData = aChar;
	}
}

void FString::Insert(char *theString, int thePosition, int theAmount)
{
    int aLen = Length(theString);
    if(theAmount < aLen)aLen = theAmount;
	//int aLen = min(Length(theString), theAmount);
	if(aLen > 0)
	{
		if(thePosition < 0)thePosition = 0;
		if(thePosition > mLength)thePosition=mLength;
		int aNewLen = mLength + aLen;
		char *aChar = new char[aNewLen + 1];
		Stamp(aChar, mData, 0, thePosition);
		Stamp(aChar, theString, thePosition, aLen);
		Stamp(aChar, &mData[thePosition], thePosition + aLen, mLength - thePosition);
		Free();
		mLength = aNewLen;
		aChar[mLength]=0;
		//mRefs=new int;*mRefs=1;
		mData = aChar;
	}
}

void FString::Insert(FString &theString, int thePosition, int theAmount)
{
    int aLen = theString.mLength;
    if(theAmount < aLen)aLen = theAmount;
	//int aLen = min(theString.mLength, theAmount);
	if(aLen > 0)
	{
		if(thePosition < 0)thePosition = 0;
		if(thePosition > mLength)thePosition=mLength;
		int aNewLen = mLength + aLen;
		char *aChar = new char[aNewLen + 1];
		Stamp(aChar, mData, 0, thePosition);
		Stamp(aChar, theString.mData, thePosition, aLen);
		Stamp(aChar, &mData[thePosition], thePosition + aLen, mLength - thePosition);
		Free();
		mLength = aNewLen;
		aChar[mLength]=0;
		//mRefs=new int;*mRefs=1;
		mData = aChar;
	}
}

void FString::Insert(FString &theString, int thePosition)
{
	if(thePosition < 0)thePosition = 0;
	if(thePosition > mLength)thePosition=mLength;
	if(int aLen = theString.mLength)
	{
		int aNewLen = mLength + aLen;
		char *aChar = new char[aNewLen + 1];
		Stamp(aChar, mData, 0, thePosition);
		Stamp(aChar, theString.mData, thePosition, aLen);
		Stamp(aChar, &mData[thePosition], thePosition + aLen, mLength - thePosition);
		Free();
		mLength = aNewLen;
		aChar[mLength]=0;
		//mRefs=new int;*mRefs=1;
		mData = aChar;
	}
}

void FString::Write(char theChar, int thePosition)
{
	if(theChar)
	{
		if(thePosition < 0)thePosition = 0;
		if(thePosition > mLength)thePosition=mLength;
		int aNewLen = 1 + thePosition;
		char *aChar;
		if(aNewLen > mLength)
		{
			aChar = new char[aNewLen + 1];
			Stamp(aChar, mData, 0, mLength);
			Free();
			aChar[thePosition]=theChar;
		}
		else
		{
			aNewLen=mLength;
			aChar = new char[mLength + 1];
			Stamp(aChar, mData, 0, thePosition);
			Stamp(aChar, &mData[thePosition + 1], thePosition + 1, mLength - thePosition - 1);
			Free();
			aChar[thePosition]=theChar;
		}
		mLength = aNewLen;
		aChar[mLength]=0;
		//mRefs=new int;*mRefs=1;
		mData = aChar;
	}
}

void FString::Write(char theChar, int theQuantity, int thePosition)
{
	if(thePosition < 0)thePosition = 0;
	if(thePosition > mLength)thePosition=mLength;
	if(theQuantity > 0)
	{
		int aNewLen = theQuantity + thePosition;
		char *aChar;
		if(aNewLen > mLength)
		{
			aChar = new char[aNewLen + 1];
			Stamp(aChar, mData, 0, mLength);
			Free();
		}
		else
		{
			aNewLen=mLength;
			aChar = new char[mLength + 1];
			Stamp(aChar, mData, 0, thePosition);
			Stamp(aChar, &mData[thePosition + theQuantity], thePosition + theQuantity, mLength - thePosition - theQuantity);
			Free();
		}

		char *aStamp = &aChar[thePosition];
		char *aStampFin = &aChar[thePosition + theQuantity];
		while(aStamp < aStampFin)
		{
			*aStamp=theChar;
			aStamp++;
		}

		mLength = aNewLen;
		aChar[mLength]=0;
		//mRefs=new int;*mRefs=1;
		mData = aChar;
	}
}

void FString::Write(char *theString, int thePosition, int theAmount)
{
	if(thePosition < 0)thePosition = 0;
	if(thePosition > mLength)thePosition=mLength;
	
    int aLen = Length(theString);
    if(theAmount < aLen)aLen = theAmount;
    //int aLen = min(theAmount,Length(theString));
    
    
	if(aLen > 0)
	{
		int aNewLen = aLen + thePosition;
		char *aChar;
		if(aNewLen > mLength)
		{
			aChar = new char[aNewLen + 1];
			Stamp(aChar, mData, 0, mLength);
			Free();
			Stamp(aChar, theString, thePosition, aLen);
		}
		else
		{
			aNewLen=mLength;
			aChar = new char[mLength + 1];
			Stamp(aChar, mData, 0, thePosition);
			Stamp(aChar, &mData[thePosition + aLen], thePosition + aLen, mLength - thePosition - aLen);
			Free();
			Stamp(aChar, theString, thePosition, aLen);
		}
		mLength = aNewLen;
		aChar[mLength]=0;
		//mRefs=new int;*mRefs=1;
		mData = aChar;
	}
}

void FString::Write(FString &theString, int thePosition, int theAmount)
{
	if(thePosition < 0)thePosition = 0;
	if(thePosition > mLength)thePosition=mLength;
	//int aLen = min(theAmount,theString.mLength);
    int aLen = theString.mLength;
    if(theAmount < aLen)aLen = theAmount;
    
	if(aLen > 0)
	{
		int aNewLen = aLen + thePosition;
		
		char *aChar;
		if(aNewLen > mLength)
		{
			aChar = new char[aNewLen + 1];
			Stamp(aChar, mData, 0, mLength);
			Free();
			Stamp(aChar, theString.mData, thePosition, aLen);
		}
		else
		{
			aNewLen=mLength;
			aChar = new char[mLength + 1];
			Stamp(aChar, mData, 0, thePosition);
			Stamp(aChar, &mData[thePosition + aLen], thePosition + aLen, mLength - thePosition - aLen);
			Free();
			Stamp(aChar, theString.mData, thePosition, aLen);
		}
		
		mLength = aNewLen;
		aChar[mLength]=0;
		//mRefs=new int;*mRefs=1;
		mData = aChar;
	}
}

void FString::Write(char *theString, int thePosition)
{
	if(thePosition < 0)thePosition = 0;
	if(thePosition > mLength)thePosition=mLength;
	if(int aLen = Length(theString))
	{
		int aNewLen = aLen + thePosition;
		char *aChar;
		if(aNewLen > mLength)
		{
			aChar = new char[aNewLen + 1];
			Stamp(aChar, mData, 0, mLength);
			Free();
			Stamp(aChar, theString, thePosition, aLen);
		}
		else
		{
			aNewLen=mLength;
			aChar = new char[mLength + 1];
			Stamp(aChar, mData, 0, thePosition);
			Stamp(aChar, &mData[thePosition + aLen], thePosition + aLen, mLength - thePosition - aLen);
			Free();
			Stamp(aChar, theString, thePosition, aLen);
		}
		mLength = aNewLen;
		aChar[mLength]=0;
		//mRefs=new int;*mRefs=1;
		mData = aChar;
	}
}

void FString::Write(FString &theString, int thePosition)
{
	if(thePosition < 0)thePosition = 0;
	if(thePosition > mLength)thePosition=mLength;
	if(int aLen = theString.mLength)
	{
		int aNewLen = aLen + thePosition;
		char *aChar;
		if(aNewLen > mLength)
		{
			aChar = new char[aNewLen + 1];
			Stamp(aChar, mData, 0, mLength);
			Free();
			Stamp(aChar, theString.mData, thePosition, aLen);
		}
		else
		{
			aNewLen=mLength;
			aChar = new char[mLength + 1];
			Stamp(aChar, mData, 0, thePosition);
			Stamp(aChar, &mData[thePosition + aLen], thePosition + aLen, mLength - thePosition - aLen);
			Free();
			Stamp(aChar, theString.mData, thePosition, aLen);
		}
		mLength = aNewLen;
		aChar[mLength]=0;
		//mRefs=new int;*mRefs=1;
		mData = aChar;
	}
}

FString FString::operator+(char theChar)
{
	int aLength = mLength + 1;
	char *aChar = new char[aLength + 1];
	aChar[aLength]=0;
	FString aReturn;
	//aReturn.mRefs=new int;*aReturn.mRefs=1;
	aReturn.mLength=aLength;
	aReturn.mData=aChar;
	Stamp(aChar,mData,0,mLength);
	aChar[mLength]=theChar;
	return aReturn;
}

FString FString::operator + (FString theString)
{
	int aLength = mLength + theString.mLength;
	char *aChar = new char[aLength + 1];
	aChar[aLength]=0;
	FString aReturn;
	//aReturn.mRefs=new int;*aReturn.mRefs=1;
	aReturn.mLength=aLength;
	aReturn.mData=aChar;
	Stamp(aChar,mData,0,mLength);
	Stamp(aChar,theString.mData,mLength,theString.mLength);
	return aReturn;
}

FString FString::operator + (char *theString)
{
	int aCharLength = Length(theString);
	int aLength = mLength + aCharLength;
	char *aChar = new char[aLength + 1];
	aChar[aLength]=0;
	FString aReturn;
	//aReturn.mRefs=new int;*aReturn.mRefs=1;
	aReturn.mLength=aLength;
	aReturn.mData=aChar;
	Stamp(aChar,mData,0,mLength);
	Stamp(aChar,theString,mLength,aCharLength);
	return aReturn;
}

void FString::operator+=(char theChar)
{
	if(!theChar)return;
	int aLength = mLength + 1;
	char *aChar = new char[aLength + 1];
	aChar[aLength]=0;
	Stamp(aChar,mData,0,mLength);
	aChar[mLength]=theChar;
	Free();
	mData = aChar;
	mLength = aLength;
	//mRefs=new int;*mRefs=1;
}

void FString::operator+=(char*theString)
{
	if(!theString)return;
	if(*theString==0)return;
	int aCharLength = Length(theString);
	int aLength = mLength + aCharLength;
	char *aChar = new char[aLength + 1];
	aChar[aLength]=0;
	Stamp(aChar,mData,0,mLength);
	Stamp(aChar,theString,mLength,aCharLength);
	Free();
	mData = aChar;
	mLength = aLength;
	//mRefs=new int;*mRefs=1;
}

void FString::operator+=(FString theString)
{
	char *aOther=theString.mData;
	if(!aOther)return;
	if(*aOther==0)return;
	int aLength = mLength + theString.mLength;
	char *aChar = new char[aLength + 1];
	aChar[aLength]=0;
	Stamp(aChar,mData,0,mLength);
	Stamp(aChar,theString.mData,mLength,theString.mLength);
	Free();
	mData = aChar;
	mLength = aLength;
	//mRefs=new int;*mRefs=1;
}

#define lower(c)(((c)>=65&&(c)<=90)?(c)+32:(c))
int FString::CompareI(char *theString)
{
	if(!mData){if(theString)return -1;return 0;}if(!theString)return 1;
	char *aChar = mData;
	while(lower(*aChar)==lower(*theString)&&*aChar)
	{
		aChar++;
		theString++;
	}
	if(*aChar>*theString)return 1;
	if(*aChar<*theString)return -1;
	return 0;
}

bool FString::EqualsStar(char *theString)
{
	if(!mData){if(theString)return -1;return 0;}if(!theString)return 1;
	char *aChar = mData;
	while((*aChar==*theString || *aChar=='*' || *theString=='*')&&(*aChar)&&(*theString))
	{
		aChar++;
		theString++;
	}
	return *aChar == *theString; 
}

int FString::CompareS(char *theString)
{
	if(!mData){if(theString)return -1;return 0;}if(!theString)return 1;
	char *aChar = mData;
	while(*aChar==*theString&&*aChar)
	{
		aChar++;
		theString++;
	}
	if(*aChar>*theString)return 1;
	if(*aChar<*theString)return -1;
	return 0;
}

int FString::CompareI(char *theString, int theCount)
{
	if(theCount<=0)return 0;
	if(!mData){if(theString)return -1;return 0;}if(!theString)return 1;
	char *aChar = mData;
	while(lower(*aChar)==lower(*theString)&&*aChar&&theCount)
	{
		aChar++;
		theString++;
		theCount--;
	}
	if(theCount)
	{
		if(*aChar>*theString)return 1;
		if(*aChar<*theString)return -1;
	}
	return 0;
}

int FString::CompareS(char *theString, int theCount)
{
	if(theCount<=0)return 0;
	if(!mData){if(theString)return -1;return 0;}if(!theString)return 1;
	char *aChar = mData;
	while(*aChar==*theString&&*aChar&&theCount)
	{
		aChar++;
		theString++;
		theCount--;
	}
	if(theCount)
	{
		if(*aChar>*theString)return 1;
		if(*aChar<*theString)return -1;
	}
	return 0;
}

bool FString::Prefix(char *pString)
{
	if(!mData)return false;
	if(!pString)return true;
	
	char *aChar = mData;
	
	while(*aChar==*pString&&*aChar)
	{
		aChar++;
		pString++;
	}
	
	if(*pString==0)return true;
	return false;
}

bool FString::PrefixI(char *pString)
{
	if(!mData)return false;
	if(!pString)return true;
	
	char *aChar = mData;
	
	while(lower(*aChar)==lower(*pString)&&*aChar)
	{
		aChar++;
		pString++;
	}
	
	if(*pString==0)return true;
	return false;
}

int FString::FindI(char theChar, int thePosition)
{
	if(thePosition >= mLength || thePosition < 0)return -1;
	if(theChar >= 'A' && theChar <= 'Z')theChar+=32;
	char *aFinal = &mData[mLength];
	char *aChar = &mData[thePosition];
	while(aChar < aFinal)
	{
		char aCompare = *aChar;
		if(aCompare >= 'A' && aCompare <= 'Z')aCompare+=32;
		if(aCompare == theChar)return (int)(aChar - mData);
		aChar++;
	}
	return -1;
}

bool FString::EndsWith(char *pString)
{
	return Find(pString, mLength - Length(pString)) != -1;
}

bool FString::StartsWith(char *pString)
{
	return Find(pString, 0) == 0;
}

int FString::Find(char theRangeLow, char theRangeHigh, int thePosition)
{
	if(thePosition >= mLength || thePosition < 0)return -1;
	char *aFinal = &mData[mLength];
	char *aChar = &mData[thePosition];
	while(aChar < aFinal)
	{
		if(*aChar >= theRangeLow && *aChar <= theRangeHigh)return (int)(aChar - mData);
		aChar++;
	}
	return -1;
}

int FString::Find(char theChar, int thePosition)
{
	if(thePosition >= mLength || thePosition < 0)return -1;
	char *aFinal = &mData[mLength];
	char *aChar = &mData[thePosition];
	while(aChar < aFinal)
	{
		if(*aChar == theChar)return (int)(aChar - mData);
		aChar++;
	}
	return -1;
}

int FString::Find(char *theString, int thePosition)
{
	if(!theString || thePosition >= mLength || thePosition < 0)return -1;
	char *aChar = &mData[thePosition];
	char *aFinish = &mData[mLength];
	while(aChar<aFinish)
	{
		if(*aChar == *theString)
		{
			char *aChar2 = aChar;
			char *aString2 = theString;
			while(aChar2 <= aFinish)
			{
				if(*aString2 == 0)return (int)(aChar - mData);
				if(*aString2 != *aChar2)break;
				aString2++;
				aChar2++;
			}
		}
		aChar++;
	}
	return -1;
}

int FString::ToInt()
{
    if(mData)
    {
        return (int)atoi(mData);
    }
    return 0;
}


char FString::ToChar()
{
    if(mData)
    {
        return (char)atoi(mData);
    }
    return 0;
}

float FString::ToFloat()
{
    if(mData)
    {
        return (float)atof(mData);
    }
    return 0;
}

double FString::ToDouble()
{
    if(mData)
    {
        return (double)atof(mData);
    }
    return 0;
}


int FString::FindI(char *theString, int thePosition)
{
	if(!theString || thePosition >= mLength || thePosition < 0)return -1;
	char *aChar = &mData[thePosition];
	char *aFinish = &mData[mLength];
	char aC1, aC2;
	while(aChar<aFinish)
	{
		aC1 = *aChar;
		aC2 = *theString;
		if(aC1 >= 'A' && aC1 <= 'Z')aC1+=32;
		if(aC2 >= 'A' && aC2 <= 'Z')aC2+=32;
		if(aC1 == aC2)
		{
			char *aChar2 = aChar;
			char *aString2 = theString;
			while(aChar2 <= aFinish)
			{
				if(*aString2 == 0)return (int)(aChar - mData);
				aC1 = *aString2;
				aC2 = *aChar2;
				if(aC1 >= 'A' && aC1 <= 'Z')aC1+=32;
				if(aC2 >= 'A' && aC2 <= 'Z')aC2+=32;
				if(aC1 != aC2)break;
				aString2++;
				aChar2++;
			}
		}
		aChar++;
	}
	return -1;
}

int FString::GetHash(char *theString, int theCount, int theTableSize)//, int &theLength)
{
	if(!theString || theTableSize < 1)return 0;
	unsigned long aReturn = 5381;
	char *aString=theString;
	while(int aChar = *aString++ != 0 && theCount--)aReturn=((aReturn<< 5)+aReturn)^aChar;
	//theLength = (int)(aString - theString);
	return aReturn % theTableSize;
}

int FString::GetHashI(char *theString, int theCount, int theTableSize)//, int &theLength)
{
	if(!theString || theTableSize < 1)return 0;
	unsigned long aReturn = 5381;
	char *aString=theString;
	while(int aChar = *aString++ != 0 && theCount--)
	{
		if(aChar >= 'A' && aChar <= 'Z')aChar+=32;
		aReturn=((aReturn<< 5)+aReturn)^aChar;
	}
	//theLength = (int)(aString - theString);
	return aReturn % theTableSize;
}

int FString::GetHash(char *theString, int theTableSize)
{
	if(!theString || theTableSize < 1)return 0;
	unsigned long aReturn = 5381;
	char *aString=theString;
	while(int aChar = *aString++)aReturn=((aReturn<< 5)+aReturn)^aChar;
	return aReturn % theTableSize;
}

int FString::GetHashI(char *theString, int theTableSize)
{
	if(!theString || theTableSize < 1)return 0;
	unsigned long aReturn = 5381;
	char *aString=theString;
	while(int aChar = *aString++)
	{
		if(aChar >= 'A' && aChar <= 'Z')aChar+=32;
		aReturn=((aReturn<< 5)+aReturn)^aChar;
	}
	return aReturn % theTableSize;
}

int FString::GetHash(int theTableSize)
{
	if(!mData || theTableSize < 1)return 0;
	unsigned long aReturn = 5381;
	char *aString=mData;
	while(int aChar = *aString++)aReturn=((aReturn<< 5)+aReturn)^aChar;
	return aReturn % theTableSize;
}

int FString::GetHashI(int theTableSize)
{
	if(!mData || theTableSize < 1)return 0;
	unsigned long aReturn = 5381;
	char *aString=mData;
	while(int aChar = *aString++)
	{
		if(aChar >= 'A' && aChar <= 'Z')aChar+=32;
		aReturn=((aReturn<< 5)+aReturn)^aChar;
	}
	return aReturn % theTableSize;
}

void FString::Replace(char theOriginal, char theNew)
{
	if(mLength == 0)return;
	int aFind = Find(theOriginal);
	if(aFind != -1)
	{
		//PrepForInlineModification();
		char *aChar = &mData[aFind];
		while(*aChar)
		{
			if(*aChar == theOriginal)*aChar=theNew;
			aChar++;
		}
	}
}

void FString::Replace(char *theOriginal, char *theNew)
{
    /*
	if(mLength == 0 || !theOriginal || !theNew)return;
	int aFind = Find(theOriginal);
	if(aFind != -1)
	{
		int aLengthO = Length(theOriginal);
		int aLengthN = Length(theNew);
		int aDiff = aLengthN - aLengthO;
		int aNewLength = mLength;
		ChrList aFindList;
		while(aFind != -1)
		{
			aFindList += &mData[aFind];
			aFind = Find(theOriginal, aFind+1);
			aNewLength += aDiff;
		}
		char *aChar = new char[aNewLength + 1];
		aChar[aNewLength] = 0;
		char *aNew = aChar;
		char *aOld = mData;
		while(char *aGet = aFindList.Get())
		{
			while(aOld < aGet)
			{
				*aNew=*aOld;
				aNew++;
				aOld++;
			}
			char *aCopy = theNew;
			while(*aCopy)
			{
				*aNew=*aCopy;
				aNew++;
				aCopy++;
			}
			aOld+=aLengthO;
		}
		char *aFinal = &mData[mLength];
		while(aOld<aFinal)
		{
			*aNew=*aOld;
			aNew++;
			aOld++;
		}
		Free();
		mData=aChar;
		mLength=aNewLength;
	}
    */
}

void FString::Uppercase()
{
	int aFind = Find('a','z');
	if(aFind != -1)
	{
		//PrepForInlineModification();
		char *aChar = &mData[aFind];
		char *aFinish = &mData[mLength];
		while(aChar < aFinish)
		{
			if(*aChar >= 'a' && *aChar <= 'z')*aChar-=32;
			aChar++;
		}
	}
}

void FString::Lowercase()
{
	int aFind = Find('A','Z');
	if(aFind != -1)
	{
		//PrepForInlineModification();
		char *aChar = &mData[aFind];
		char *aFinish = &mData[mLength];
		while(aChar < aFinish)
		{
			if(*aChar >= 'A' && *aChar <= 'Z')*aChar+=32;
			aChar++;
		}
	}
}

void FString::ParseChar(char *theChar, flag theFlags)
{
	Free();
	if(int aLen = Length(theChar))
	{
		int aWidth;
		GET_WIDTH(theFlags,aWidth);
		if(aWidth < aLen)aWidth=aLen;
		char *aChar = new char[aWidth+1];aChar[aWidth]=0;
		char *aFinal = &aChar[aWidth];
		char *aHold = aChar;
		int aDiff = aWidth - aLen;
		if(!(theFlags & (FLEFT_JUSTIFY)))while(aDiff--)*aChar++ = ' ';
		aChar = GetStamp(aChar,theChar,0,aLen);
		while(aChar < aFinal)*aChar++ = ' ';
		mLength = aWidth;
		mData = aHold;
		//mRefs = new int;*mRefs=1;
	}
}

void FString::ParseLong(long long theLong, flag theFlags)
{
	static char	*gLower = (char*)"0123456789abcdefghijklmnopqrstuvwxyz";
	static char	*gUpper = (char*)"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	Free();
	char *aDigit;
	int aWidth, aPrecision, aRadix;
	GET_WIDTH(theFlags,aWidth);
	GET_FRAC(theFlags,aPrecision);
	GET_RADIX(theFlags, aRadix);
	if(aRadix < 2 || aRadix > 36)aRadix = 10;
	char *aRaw = new char[66];
	char *aChar = new char[66 + 66/3 + 2 + 1 + aWidth + aPrecision];char *aHold = aChar;
	if(theFlags & FLOWER_CASE)aDigit=gLower;
	else aDigit=gUpper;

	if(theFlags & FLEFT_JUSTIFY)theFlags &= ~FLEAD_ZEROS;
	char aFill = (theFlags & FLEAD_ZEROS)? '0' : ' ';
	char aSign = 0;
	if(theFlags & FSIGNED)
	{
		if(theLong < 0)
		{
			aSign = '-';
			theLong = -theLong;
			aWidth--;
		}
		else if(theFlags & FFORCE_SIGN)
		{
			aSign = '+';
			aWidth--;
		}
		else if(theFlags & FSPACE_FOR_PLUS)
		{
			aSign = ' ';
			aWidth--;
		}
	}

	if(theFlags & FSPECIAL)
	{
		if(aRadix == 16)aWidth -= 2;
		else if(aRadix == 8)aWidth--;
	}

	int aIndex = 0;
	if(!theLong)aRaw[aIndex++] = '0';
	else
	{
		while(theLong != 0)
		{
			aRaw[aIndex++] = aDigit[((unsigned long)theLong)% (unsigned)aRadix];
			theLong = ((unsigned long)theLong)/ (unsigned)aRadix;
		}
	}

	int aCommaCount=0;
	int aCommaOffset;
	bool aCommas = (theFlags & FCOMMAS) != 0;
	if(aCommas)
	{
		if(aIndex < 4 || aIndex < aPrecision || theFlags & FLEAD_ZEROS || aRadix != 10)
		{
			aCommas=false;
		}
		if(aIndex < 4 || aIndex < aPrecision || theFlags & FLEAD_ZEROS || aRadix != 10)
		{
			aCommas=false;
		}
		else
		{
			aCommaCount=aIndex / 3;
			aCommaOffset=aIndex % 3;
			if(aCommaOffset == 0)
			{
				aCommaOffset=3;
				aCommaCount--;
			}
		}

	}

	if(aIndex > aPrecision)aPrecision = aIndex;
	aWidth -= (aPrecision + aCommaCount);

	if(!(theFlags & (FLEAD_ZEROS | FLEFT_JUSTIFY)))while(aWidth-- > 0)*aChar++ = ' ';

	if(aSign)*aChar++ = aSign;

	if(theFlags & FSPECIAL)
	{
		if(aRadix == 8)
		{
			*aChar++ = '0';
		}
		else if(aRadix == 16)
		{
			*aChar++ = '0';
			*aChar++ = 'x';
		}
	}

	if(!(theFlags & FLEFT_JUSTIFY))while(aWidth-- > 0)*aChar++ = aFill;

	while(aIndex < aPrecision--)*aChar++ = '0';
	if(aCommas)
	{
		while(aIndex-- > 0)
		{
			*aChar++ = aRaw[aIndex];
			if(--aCommaOffset == 0 && aCommaCount-- > 0)
			{
				*aChar++ = ',';
				aCommaOffset=3;
			}
		}
	}
	else
	{
		while(aIndex-- > 0)*aChar++ = aRaw[aIndex];
	}
	while(aWidth-- > 0)*aChar++ = ' ';
	*aChar=0;

	delete[]aRaw;

	*this = aHold;
	delete [] aHold;
}


void FString::ParseDouble(double theDouble, flag theFlags)
{
	Free();
	
	int aWidth, aPrecision;
	GET_WIDTH(theFlags,aWidth);
	if(theFlags & FDECIMAL_PT)GET_FRAC(theFlags,aPrecision);
	else aPrecision=6;
	
	bool aSign=false;
	if(theDouble<0)
	{
		aSign=true;
		theDouble=-theDouble;
	}
	int aWholeNumber=(int)theDouble;
	double aFraction=theDouble-(float)aWholeNumber;
	int aWholeDigits=0;
	
	int aMultiply=10;
	int aHold=aPrecision;
	while(aHold>0)
	{
		aMultiply*=10;
		aHold--;
	}
	aFraction *= (float)aMultiply;
	int aFractionNumber = (int)aFraction;
	int aLastDigit = ((int)aFractionNumber) % 10;
	aFractionNumber/=10;
	
	//.567[8] = .568
	if(aLastDigit>=5)aFractionNumber++;
	
	//.9999999[9] = 1
	if(aFractionNumber >= (aMultiply / 10))
	{
		aFractionNumber=0;
		aWholeNumber++;
	}
	
	aHold=aWholeNumber;
	while(aHold)
	{
		aWholeDigits++;
		aHold /= 10;
	}
	if(aWholeDigits==0)aWholeDigits=1;
	
	mLength=aWholeDigits + 1 + aPrecision;
    
    if(aSign)
    {
        mLength += 1;
    }
    
	mData = new char[mLength+1];
    
    if(aSign)
    {
        mData[0] = '-';
        for(int i=aWholeDigits-1;i>=0;i--)
        {
            mData[i+1]=((char)(aWholeNumber%10))+'0';
            aWholeNumber/=10;
        }
        
        aWholeDigits++;
        mData[aWholeDigits]='.';
        
        for(int i=mLength-1;i>aWholeDigits;i--)
        {
            mData[i]=((char)(aFractionNumber%10))+'0';
            aFractionNumber/=10;
        }
    }
    else
    {
        for(int i=aWholeDigits-1;i>=0;i--)
        {
            mData[i]=((char)(aWholeNumber%10))+'0';
            aWholeNumber/=10;
        }
        
        mData[aWholeDigits] = '.';
        
        for(int i=mLength-1;i>aWholeDigits;i--)
        {
            mData[i]=((char)(aFractionNumber%10))+'0';
            aFractionNumber/=10;
        }
    }
    
	mData[mLength] = 0;
    
}
	
	/*
	 Free();
	 int aWidth, aPrecision;
	 GET_WIDTH(theFlags,aWidth);
	if(theFlags & FDECIMAL_PT)GET_FRAC(theFlags,aPrecision);
	else aPrecision=6;
	bool aAddDecimal = !(aPrecision == 0 && (theFlags & FDECIMAL_PT) && !(theFlags & FSPECIAL));
	if(aAddDecimal)aWidth--;
	if(theFlags & FLEFT_JUSTIFY)
	{
		theFlags &= ~FLEAD_ZEROS;
	}
	char aFill = (theFlags & FLEAD_ZEROS)? '0' : ' ';
	char aSign = 0;
	if(theDouble < 0)
	{
		aSign = '-';
		theDouble = -theDouble;
		aWidth--;
	}
	else if(theFlags & FFORCE_SIGN)
	{
		aSign = '+';
		aWidth--;
	}
	else if(theFlags & FSPACE_FOR_PLUS)
	{
		aSign = ' ';
		aWidth--;
	}
#define BUFF_SIZE (350 + 255)
	char *aChar = new char[BUFF_SIZE+aWidth+aPrecision];
	char *aRaw = new char[BUFF_SIZE];
	char *aHold = aChar;
	int aDecimal, aSignPtr;

	fcvt(aRaw,BUFF_SIZE,theDouble,aPrecision,&aDecimal,&aSignPtr);
	int aLen = Length(aRaw);
	if(aDecimal < 1)
	{
		char *aNewBuff = new char[BUFF_SIZE];
		char *aBufPtr = aNewBuff;
		while(aDecimal < 1 && aPrecision >= 0)
		{
			*aBufPtr='0';aBufPtr++;
			aDecimal++;
			aPrecision--;
		}
		aDecimal = 1;
		aBufPtr = GetStamp(aBufPtr, aRaw, 0, aLen);
		*aBufPtr = 0;
		delete [] aRaw;
		aRaw = aNewBuff;
		aLen = Length(aNewBuff);
	}
	int aCommaCount=0;
	int aCommaOffset;
	bool aCommas = (theFlags & FCOMMAS) != 0;
	if(aCommas)
	{
		if(aDecimal < 4 || theFlags & FLEAD_ZEROS)
		{
			aCommas=false;
		}
		else
		{
			aCommaCount=aDecimal / 3;
			aCommaOffset=aDecimal % 3;
			if(aCommaOffset == 0)
			{
				aCommaOffset=3;
				aCommaCount--;
			}
		}

	}
	aWidth -= (aLen + aCommaCount);
	if(!(theFlags & (FLEAD_ZEROS | FLEFT_JUSTIFY)))while(aWidth-- > 0)*aChar++ = ' ';
	if(aSign)*aChar++ = aSign;
	if(!(theFlags & FLEFT_JUSTIFY))while(aWidth-- > 0)*aChar++ = aFill;
	if(aCommas)
	{
		int aHoldCommaCount = aCommaCount;
		char* aHoldRaw = aRaw;
		char *aShelf = &aRaw[aDecimal];
		while(aRaw < aShelf)
		{
			*aChar++ = *aRaw++;
			if(--aCommaOffset == 0 && aCommaCount-- > 0)
			{
				*aChar++ = ',';
				aCommaOffset=3;
			}
		}
		aRaw=aHoldRaw;
		aCommaCount=aHoldCommaCount;
	}
	else
	{
		aChar = GetStamp(aChar,aRaw,&aRaw[aDecimal]);
	}
	if(aAddDecimal)*aChar++='.';
	aChar = GetStamp(aChar,&aRaw[aDecimal + aCommaCount],&aRaw[aLen]);
	while(aWidth-- > 0)*aChar++ = ' ';
	*aChar=0;
	*this = aHold;
	delete [] aRaw;
	delete [] aHold;
	*/ 


/*
void FString::Format(char *theFormat, va_list &aArgs)
{
	Free();if(!theFormat)return;
	char *aSearch = theFormat;
	int aFind=-1;
	while(*aSearch && *aSearch != '%')aSearch++;
	if(*aSearch){aFind = (int)(aSearch - theFormat);aSearch++;}
	if(aFind != -1)
	{
		//mRefs=new int;*mRefs=1;
		mLength = 0;
		char *aCopyStart = &theFormat[0];
		char *aCopyShelf = &theFormat[aFind];
		ChrList aStart;
		ChrList aShelf;
		FStringList aStrings;
		int aPrevious = 0;
		while(aFind != -1)
		{
			int aSpecWid;
			FString *aNewString;
			if(*(aCopyShelf + 1) == '%')
			{
				aSpecWid = 1;
				aCopyShelf++;
				aSearch++;
				aNewString=0;
			}
			else
			{
				aNewString = ProcessSpecifier(aCopyShelf,aSpecWid,aArgs);
			}
			char *aDest = &aCopyShelf[aSpecWid];
			mLength += (int)(aCopyShelf - aCopyStart);
			if(aNewString)mLength+=aNewString->mLength;
			aStart += aCopyStart;
			aShelf += aCopyShelf;
			aStrings += aNewString;
			aPrevious=aFind;
			aFind=-1;
			while(*aSearch && *aSearch != '%')aSearch++;
			if(*aSearch){aFind = (int)(aSearch - theFormat);aSearch++;}
			aCopyStart = aDest;
			aCopyShelf = &theFormat[aFind];
		}
		mLength += (int)(aSearch - aCopyStart);
		mData = new char[mLength + 1];
		mData[mLength] = 0;
		char *aStamp = mData;
		while(char *aCopyStart=aStart.Get())
		{
			aCopyShelf=aShelf.Get();
			aStamp = GetStamp(aStamp, aCopyStart, aCopyShelf);
			FString *aString = aStrings.Get();
			if(aString)aStamp=GetStamp(aStamp,aString->mData,0,aString->mLength);
			delete aString;
		}
		Stamp(aStamp,aCopyStart,aSearch);
	}
	else
	{
		mLength = (int)(aSearch - theFormat);
		mData = new char[mLength+1];mData[mLength]=0;
		Stamp(mData,theFormat,0,mLength);
		//mRefs=new int;*mRefs=1;
	}
	 
}

FString *FString::ProcessSpecifier(char *thePosition, int &theLength, va_list &aArgs)
{
	char *aStart = thePosition;

	FString *aString = new FString();
	if(*thePosition == '%')
	{
		flag aFlag = FDEFAULT;
RELOOP:
		thePosition++;

		if(*thePosition == '0' && (*(thePosition-1)!='.'))
		{
			aFlag |= FLEAD_ZEROS;
			goto RELOOP;
		}
		else if(*thePosition == ' ')
		{
			aFlag |= FSPACE_FOR_PLUS;
			goto RELOOP;
		}
		else if(*thePosition == 'u')
		{
			aFlag &= (~FSIGNED);
			goto RELOOP;
		}
		else if(*thePosition == '*')
		{
			int aVal = va_arg(aArgs, int);
			if(aFlag & FDECIMAL_PT){SET_FRAC(aFlag,aVal);}
			else {SET_WIDTH(aFlag,aVal);}
			goto RELOOP;
		}
		else if(*thePosition == '-')
		{
			aFlag |= FLEFT_JUSTIFY;
			goto RELOOP;
		}
		else if(*thePosition == '+')
		{
			aFlag |= FFORCE_SIGN;
			goto RELOOP;
		}
		else if(*thePosition == '^')
		{
			aFlag &= (~FSIGNED);
			goto RELOOP;
		}
		else if(*thePosition == '.')
		{
			aFlag |= FDECIMAL_PT;
			goto RELOOP;
		}
		else if(*thePosition == '#')
		{
			aFlag |= FSPECIAL;
			goto RELOOP;
		}
		else if(*thePosition == ',')
		{
			aFlag |= FCOMMAS;
			goto RELOOP;
		}
		else if(*thePosition >= '0' && *thePosition <= '9')
		{
			char *aNum = thePosition;int aSum = 0;
			while (*aNum >= '0' && *aNum <= '9')
			{
				aSum = aSum * 10 + *aNum - '0';
				aNum++;
			}
			thePosition += aNum - thePosition - 1;
			if(aFlag & FDECIMAL_PT){SET_FRAC(aFlag,aSum);}
			else {SET_WIDTH(aFlag,aSum);}
			goto RELOOP;
		}
		else if(*thePosition == 's' || *thePosition == 'S')
		{
			aString->ParseChar(va_arg(aArgs, char*),aFlag);
		}
		else if(*thePosition == 'c' || *thePosition == 'C')
		{
			*aString = (char)(va_arg(aArgs, int));
		}
		else if(*thePosition == 'f' || *thePosition == 'g' || *thePosition == 'e' || *thePosition == 'F' || *thePosition == 'G' || *thePosition == 'E')
		{
			aString->ParseDouble(va_arg(aArgs, double), aFlag);
		}
		else if(*thePosition == 'd' || *thePosition == 'i' || *thePosition == 'I' || *thePosition == 'D')
		{
			aString->ParseLong(va_arg(aArgs, int), aFlag);
		}
		else if(*thePosition == 'l' || *thePosition == 'L')
		{
			aString->ParseLong(va_arg(aArgs, long long), aFlag);
		}
		else if(*thePosition == 'x')
		{
			aFlag |= FLOWER_CASE;
			goto PARSE_HEX;
		}
		else if(*thePosition == 'X')
		{
PARSE_HEX:
			SET_RADIX(aFlag, 16);
			aString->ParseLong(va_arg(aArgs, int), aFlag);
		}
		else if(*thePosition == 'P' || *thePosition == 'p')
		{
			SET_RADIX(aFlag, 16);
			aFlag &= (~FSIGNED);
			aString->ParseLong(va_arg(aArgs, int), aFlag);
		}
		else if(*thePosition == 'b' || *thePosition == 'B')
		{
			SET_RADIX(aFlag, 2);
			aString->ParseLong(va_arg(aArgs, int), aFlag);
		}
		else if(*thePosition == 'o' || *thePosition == 'O')
		{
			SET_RADIX(aFlag, 8);
			aString->ParseLong(va_arg(aArgs, int), aFlag);
		}
		else
		{
			thePosition--;
		}
	}
	theLength = (int)(thePosition - aStart + 1);
	return aString;
}

FString IntToString(int theInt, bool addCommas)
{
	FString aReturn;
	FString::flag aFlag = FDEFAULT;
	if(addCommas)aFlag |= FCOMMAS;
	aReturn.ParseInt(theInt,aFlag);
	return aReturn;
}

FString SuperscriptNumber(int theNumber)
{
	FString aNumber;
	aNumber.ParseInt(theNumber,0);
	char aFinal=aNumber[aNumber.mLength-1];
	if (aNumber.mLength>=2) if (aNumber[aNumber.mLength-2]=='1')aFinal='0';
	switch (aFinal)
	{
	case '0':
	case '4':
	case '5':
	case '6':
	case '7':
	case '8':
	case '9':
		aNumber+="th";
		break;
	case '1':
		aNumber+="st";
		break;
	case '2':
		aNumber+="nd";
		break;
	case '3':
		aNumber+="rd";
		break;
	}
	return aNumber;
}

FString FormatDate(int theMonth, int theDay, int theYear)
{
	if (theMonth==-1 && theDay==-1 && theYear==-1)
	{
		time_t aTime;
		aTime=time(NULL);
		struct tm *aNow=NULL;
		aNow=localtime(&aTime);
		
		theMonth=aNow->tm_mon+1;
		theDay=aNow->tm_mday;
		theYear=1900+aNow->tm_year;
	}
	
	if (theMonth<0) theMonth=0;
	if (theMonth>13) theMonth=13;
	
	const char *aMonthString[]=
	{
		"???",
		"January",
		"February",
		"March",
		"April",
		"May",
		"June",
		"July",
		"August",
		"September",
		"October",
		"November",
		"December",
		"???"
	};
	
	return Sprintf("%s %s, %.4d",aMonthString[theMonth],SuperscriptNumber(theDay).c(),theYear);	
}

FString FormatTime(int theHour, int theMinute)
{
	
	if (theHour==-1 && theMinute==-1)
	{
		time_t aTime;
		aTime=time(NULL);
		struct tm *aNow=NULL;
		aNow=localtime(&aTime);
		
		theHour=aNow->tm_hour;
		theMinute=aNow->tm_min;
	}
	
	int aDisplayHour=theHour;
	if (aDisplayHour==0) aDisplayHour=12;
	if (aDisplayHour>12) aDisplayHour-=12;
	return Sprintf("%d:%.2d%s",aDisplayHour,theMinute,(theHour>=12)?"pm" : "am");	
	
	
}

bool FString::ToBool()
{
    if(CompareI("true") == 0)return true;
    if(CompareI("yes") == 0)return true;
    if(CompareI("on") == 0)return true;
    if(CompareI("enabled") == 0)return true;
    if(CompareI("1") == 0)return true;
    return false;
}

*/







