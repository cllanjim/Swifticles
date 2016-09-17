#ifndef FSTRING_H
#define FSTRING_H

#include <string.h>
#include <stdarg.h>
#include <algorithm>
#include <math.h>

class FString
{
public:
	//
	//Stuff used by Format()
	//
	typedef unsigned int flag;
	//
	//Bits of flags used for parsing via Format()
	//
#define FLEAD_ZEROS		0x1		//1		//
#define FSIGNED			0x2		//2		//
#define FFORCE_SIGN		0x4		//3		//
#define FSPACE_FOR_PLUS	0x8		//4		//
#define FLEFT_JUSTIFY	0x10	//5		//
#define FSPECIAL		0x20	//6		//
#define FLOWER_CASE		0x40	//7		//Force lower case.
#define FDECIMAL_PT		0x80	//8		// Percision
#define FCOMMAS			0x100	//9		// 123,456,789 - Only works without leading zeros on decimal numbers.
#define FRADIX			0x00007E00//(0x200+0x400+0x800+0x1000+0x2000+0x4000)////(0x200+0x400+0x800+0x1000+0x2000+0x4000)//10-15
#define FFIELD_WIDTH	0x007F8000//(0x8000+0x10000+0x20000+0x40000+0x80000+0x100000+0x200000+0x400000)//16 -> 23 (8)
#define FFRAC_NUMBERS	0x7F800000//(0x800000+0x1000000+0x2000000+0x4000000+0x8000000+0x10000000+0x20000000+0x40000000)//24 -> 31 (8)
	//
	//Flag manipulating macros.
	//
#define SET_RADIX(theFlag,theRadix)theFlag &= (~FRADIX); theFlag |= ((theRadix & 63) << 9)
#define GET_RADIX(theFlag,theVar)theVar = ((theFlag & FRADIX) >> 9);
#define SET_WIDTH(theFlag,theNumber)theFlag &= (~FFIELD_WIDTH);theFlag |= ((theNumber & 255) << 15)
#define GET_WIDTH(theFlag,theVar)theVar = ((theFlag & FFIELD_WIDTH) >> 15)
#define SET_FRAC(theFlag,theNumber)theFlag &= (~FFRAC_NUMBERS);theFlag |= ((theNumber & 255) << 23)
#define GET_FRAC(theFlag,theVar)theVar = ((theFlag & FFRAC_NUMBERS) >> 23)
	//
	//Default flag - radix = 10, signed = true
	//
#define FDEFAULT		(0x1400 + FSIGNED)
	//
	//End stuff used by Format()
	//


	FString(void){Constructor();}
	FString(const FString &theString){Constructor();*this=theString;}
	//String(FString &theString){Constructor();*this=theString;}
	FString(char *theString){Constructor();*this=theString;}
	FString(void *theString){Constructor();*this=theString;}
	FString(char *theString, int theCount){Constructor();Write(theString,0,theCount);}
	FString(const char *theString){Constructor();*this=theString;}
	FString(int theInt){Constructor();ParseInt(theInt);}
	FString(int theInt, bool commas){Constructor();ParseInt(theInt);if(commas)AddCommas();}
	FString(char theChar){Constructor();mData=new char[2];mLength=1;mData[0]=theChar;mData[1]=0;}
	FString(long long thelong){Constructor();ParseLong(thelong);}
	FString(float theFloat){Constructor();ParseFloat(theFloat);}
	FString(double theDouble){Constructor();ParseDouble(theDouble);}
	
	FString(bool theBool){Constructor();ParseBool(theBool);}
	~FString(void){Free();}
	
	//
	//Raw character data.
	//Don't alter this unless you know what you're doing!
	//Strings may be sharing char arrays when you set them
	//equal to each other, so try to 
	//
	char					*mData;
	char					*mCursor;
	int						mLength;

	inline void				Init(){mData=0;mLength=0;mCursor=0;}

	//
	//Calculate the length of a character array.
	//[Must be terminated with a null space]
	//
	static int				Length(char *theString){if(!theString)return 0;const char*aPtr=theString;while(*aPtr)aPtr++;return (int)(aPtr-theString);}

	//
	//Convert a FString that represents another data type to the desired data type...
	//
	int						ToInt();
	char					ToChar();
	float					ToFloat();
	double					ToDouble();
	void					ToPoint(float &theX, float &theY);
	//inline Point			ToPoint() {Point aPoint;ToPoint(aPoint.mX,aPoint.mY);return aPoint;}
	bool					ToBool();

	inline FString			GetNumber(){return GetNumber(0);}
	inline FString			GetNextNumber(){return GetNumber((int)(mCursor-mData));}
	FString					GetNumber(int thePosition);
	
	
	bool					ScrambledEquals(FString &pString);
	
	void					AddCommas();

	//
	//Resize the FString. Extra spaces
	//will be filled in with ' '.
	//
	inline void				Truncate(int theNewSize){if(theNewSize<0)theNewSize=0;if(theNewSize < mLength){mData[theNewSize]=0;mLength=theNewSize;}}

	//
	//Get the length of the FString nice and quick.
	//
	inline int				Length(){return mLength;}
	inline int				GetLength(){return mLength;}
	
	
	bool					EndsWith(char *pString);
	bool					StartsWith(char *pString);
	
	bool					EqualsStar(char *pString);

	//
	//Honestly, these shouldn't ever be used outside of the FString function...
	//If you set up the char array manually, just use Realize()
	//
	inline int				GetLen(){return Length(mData);}
	inline int				Len(){return Length(mData);}
	inline int				strlen(){return Length(mData);}

	//
	//Some advanced operations for removing all characters from a FString,
	//or removing everything but some characters from a FString.
	//

	void					Filter(char *theAllowed);
	void					Filter(FString &theAllowed){Filter(theAllowed.mData);}

	void					Remove(char *theDisallowed);
	void					Remove(FString &theDisallowed){Remove(theDisallowed.mData);}

	
	int						CountCharacter(char c);
	bool					ContainsDuplicateCharacters();
	
	//
	//{+/-}{.}0-9{.}0-9{.} Where one or none of the decimals exist...
	//
	bool					IsNumber();

	//
	//Resets the FString to null. (Not "", null)
	//
	inline void				Free(){delete[]mData;Init();}
	inline void				Clear(){Free();}

	//
	//Get a subString of the FString.
	//
	FString					GetSubString(int thePosition, int theLength);
	FString					GetSubString(int thePosition){return GetSubString(thePosition, mLength);}
	inline FString			GetSegment(int thePosition, int theLength){return GetSubString(thePosition,theLength);}

	//
	//Write over the FString starting at the specified location...
	//"Hat".Write("Jam", 2) -> "HaJam"
	//"abcdefg".Write("123", 0) -> "123defg"
	//
	void					Write(char theChar, int thePosition=0);
	void					Write(char *theString, int thePosition=0);
	void					Write(FString &theString, int thePosition=0);
	void					Write(char *theString, int thePosition, int theAmount);
	void					Write(FString &theString, int thePosition, int theAmount);
	void					Write(char theChar, int theQuantity, int thePosition);

	inline void				strpad(char theChar, int theQuantity){Write(theChar,theQuantity);}

	inline void				strcpy(char *theString){*this=theString;}
	inline void				strcpy(const char *theString){*this=(char*)theString;}
	inline void				strcpy(FString &theString){*this=theString;}
	inline void				strcpy(){Free();}
	inline void				strncpy(char *theString, int theLen){Free();Write(theString,0,theLen);}
	inline void				strncpy(FString &theString, int theLen){Free();Write(theString,0,theLen);}

	//
	//Insert new text starting at the specified location...
	//"Hat".Insert("Jam", 2) -> "HaJamt"
	//"abcdefg".Insert("123", 0) -> "123abcdefg"
	//
	void					Insert(char theChar, int thePosition=0);
	void					Insert(char *theString, int thePosition=0);
	void					Insert(FString &theString, int thePosition=0);
	void					Insert(char *theString, int thePosition, int theAmount);
	void					Insert(FString &theString, int thePosition, int theAmount);
	void					Insert(char theChar, int theQuantity, int thePosition);

	//
	//Format the FString...
	//
	void					Format(char *theFormat, va_list &aArgs);
	void					Format(char *theFormat, ...){va_list aArgs;va_start(aArgs, theFormat);Format(theFormat, aArgs);va_end(aArgs);}
	void					sprintf(char *theFormat, ...){va_list aArgs;va_start(aArgs, theFormat);Format(theFormat, aArgs);va_end(aArgs);}

	//
	//String representations of other data types...
	//
	void					ParseDouble(double theDouble, flag theFlags=FDEFAULT);
	inline void				ParseFloat(float theFloat, flag theFlags=FDEFAULT){ParseDouble(theFloat,theFlags);}
	inline void				ParseAddress(void *theAddr){ParseLong((long long)theAddr, 0x52021);}
	inline void				ParseAddress(int theAddr){ParseLong((long long)theAddr, 0x52021);}
	void					ParseChar(char *theChar, flag theFlags=FDEFAULT); 
	void					ParseBool(bool theBool){if(theBool)*this="TRUE";else *this="FALSE";}
	void					ParseLong(long long theLong, flag theFlags=FDEFAULT);
	inline void				ParseInt(int theInt, flag theFlags=FDEFAULT){ParseLong(theInt,theFlags);}

	//
	//Eliminate "spaces" (ASCII characters less than 33) from the
	//beginning or end of the FString...
	//
	void					RemoveLeadingSpaces();
	void					RemoveTrailingSpaces();

	//
	//Goes through the FString and replaces all cases
	//of one substring with different text...
	//
	void					Replace(char *theOriginal, char *theNew);
	void					Replace(char theOriginal, char theNew);

	//
	//Remove stuff from a FString.
	//
	void					Delete(char *theString);
	void					Delete(int thePosition, int theLength);
	void					Delete(int thePosition);
	
	//
	//Reverse the FString? Why the hell not!
	//
	void					Reverse();

	//
	//For oldschool windows machines that need carriage return before line feeds.
	//
	void					AppendCRLF(){*this += "\r\n";}

	//
	//Set character at an index to something.
	//
	void					SetChar(int theIndex, char theChar){if(theIndex >= 0 && theIndex < mLength){mData[theIndex]=theChar;if(theChar == 0)mLength = theIndex;}}

	//
	//Find the first location in the FString where
	//the specified data is stored. Returns -1
	//if the specified data does not exist in the FString.
	//
	int						Find(char *theString, int thePosition);
	inline int				Find(FString &theString, int thePosition){return Find(theString.mData, thePosition);}
	inline int				Find(const char *theString, int thePosition){return Find((char*)theString, thePosition);}
	int						Find(char theRangeLow, char theRangeHigh, int thePosition);
	int						Find(char theChar, int thePosition);
	inline int				Find(char *theString){return Find(theString,0);}
	inline int				Find(const char *theString){return Find((char*)theString,0);}
	inline int				Find(FString &theString){return Find(theString.mData,0);}
	inline int				Find(char theRangeLow, char theRangeHigh){return Find(theRangeLow,theRangeHigh,0);}
	inline int				Find(char theChar){return Find(theChar,0);}

	int						FindI(char *theString, int thePosition);
	inline int				FindI(FString &theString, int thePosition){return FindI(theString.mData, thePosition);}
	inline int				FindI(const char *theString, int thePosition){return FindI((char*)theString, thePosition);}
	int						FindI(char theChar, int thePosition);
	inline int				FindI(char *theString){return FindI(theString, 0);}
	inline int				FindI(FString &theString){return FindI(theString.mData, 0);}
	inline int				FindI(const char *theString){return FindI((char*)theString, 0);}
	inline int				FindI(char theChar){return FindI(theChar, 0);}


	inline int				strchr(char theChar){return Find(theChar);}

	//
	//Does the FString contain some of this stuff? Find out today!
	//
	inline bool				Contains(char theRangeLow, char theRangeHigh){return Find(theRangeLow,theRangeHigh)!=-1;}
	inline bool				Contains(char theChar){return Find(theChar)!=-1;}
	inline bool				Contains(char *theString){return Find(theString,0) != -1;}
	inline bool				Contains(FString &theString){return Find(theString.mData,0) != -1;}
	
	
	
	FString					RemovePath(bool pRemoveExtension);
    FString                 RemoveExtension();
	

	//
	//Generates a number between 0 and theTableSize.
	//Each FString produces a unique hash value,
	//but different FStrings may produce the same
	//hash value.
	//
	int						GetHash(int theTableSize);
	int						GetHashI(int theTableSize);

	static int				GetHash(char *theString, int theTableSize);
	static int				GetHashI(char *theString, int theTableSize);

	static int				GetHash(char *theString, int theCount, int theTableSize);
	static int				GetHashI(char *theString, int theCount, int theTableSize);

	//
	//Sets the case of all letters.
	//
	void					Uppercase();
	void					Lowercase();

	//
	//Get a copy of the FString with a certain case.
	//
	FString					ToUpper(){FString aReturn = *this;aReturn.Uppercase();return aReturn;}
	FString					ToLower(){FString aReturn = *this;aReturn.Lowercase();return aReturn;}

	//
	//Get a copy of the character array.
	//*This must be deleted manually!*
	//
	char					*ToCharArray(){if(mLength < 1)return 0;char *aChar = new char[mLength+1];aChar[mLength]=0;Stamp(aChar,mData,0,mLength);return aChar;}


	void					Encrypt(char *theKey);
	void					Encrypt(const char *theKey){Encrypt((char*)theKey);}
	virtual void			Encrypt(FString &theKey){Encrypt(theKey.mData);}

	void					Decrypt(char *theKey);
	void					Decrypt(const char *theKey){Decrypt((char*)theKey);}
	virtual void			Decrypt(FString &theKey){Decrypt(theKey.mData);}
    
    

	//
	//Compares this FString with another FString.
	//-1 = less than
	// 0 = equal
	// 1 = greater than
	//
	inline int				Compare(char *theString){return CompareS(theString);}
	inline int				Compare(const char *theString){return CompareS(theString);}
	inline int				Compare(FString &theString){return CompareS(theString);}
	inline int				Compare(char *theString, int theCount){return CompareS(theString,theCount);}
	inline int				Compare(const char *theString, int theCount){return CompareS(theString,theCount);}
	inline int				Compare(FString &theString, int theCount){return CompareS(theString,theCount);}

	//Compare force case insensitive
	int						CompareI(char *theString);
	inline int				CompareI(const char *theString){return CompareI((char*)theString);}
	inline int				CompareI(FString &theString){return CompareI(theString.mData);}
	int						CompareI(char *theString, int theCount);
	inline int				CompareI(const char *theString, int theCount){return CompareI((char*)theString,theCount);}
	inline int				CompareI(FString &theString, int theCount){return CompareI(theString.mData,theCount);}

	inline bool				strcmpi(char *theString){return CompareI(theString)==0;}
	inline bool				strcmpi(const char *theString){return CompareI(theString)==0;}
	inline bool				strcmpi(FString &theString){return CompareI(theString.mData)==0;}
	inline bool				strnicmp(char *theString, int theLength){return CompareI(theString, theLength)==0;}
	inline bool 			strnicmp(FString &theString, int theLength){return CompareI(theString.mData, theLength)==0;}

	//Compare force case sensitive
	int						CompareS(char *theString);
	inline int				CompareS(const char *theString){return CompareS((char*)theString);}
	inline int				CompareS(FString &theString){return CompareS(theString.mData);}
	int						CompareS(char *theString, int theCount);
	inline int				CompareS(const char *theString, int theCount){return CompareS((char*)theString,theCount);}
	inline int				CompareS(FString &theString, int theCount){return CompareS(theString.mData,theCount);}

	inline bool				strcmp(char *theString){return CompareS(theString)==0;}
	inline bool				strcmp(const char *theString){return CompareS(theString)==0;}
	inline bool				strcmp(FString &theString){return CompareS(theString.mData)==0;}
	inline bool 			strncmp(char *theString, int theLength){return Compare(theString, theLength)==0;}
	inline bool				strncmp(FString &theString, int theLength){return Compare(theString.mData, theLength)==0;}
	
	
	
	bool					Prefix(char *pString);
	inline bool				Prefix(FString &pString){return Prefix(pString.mData);}
	
	bool					PrefixI(char *pString);
	inline bool				PrefixI(FString &pString){return PrefixI(pString.mData);}

	//
	//Connect two FStrings together!
	//Use +=, + instead unless you need a certain length!
	//

	inline void				Concatenate(char *theString){*this += theString;}
	inline void				Concatenate(const char *theString){*this += theString;}
	inline void				Concatenate(char theChar){*this += theChar;}
	inline void				Concatenate(FString &theString){*this += theString;}
	void					Concatenate(char *theString, int theNum);
	void					Concatenate(FString &theString, int theNum);
	inline void				Concatenate(const char *theString, int theNum){Concatenate((char*)theString,theNum);}

	inline void				strncat(char *theString, int theNum){Concatenate(theString, theNum);}
	inline void				strncat(const char *theString, int theNum){Concatenate(theString, theNum);}
	inline void				strncat(FString &theString, int theNum){Concatenate(theString, theNum);}
	inline void				strcat(char *theString){*this += theString;}
	inline void				strcat(FString &theString){*this += theString;}
	inline void				strncat(const char *theString){*this += theString;}
	inline void				strcat(char theChar){*this += theChar;}

	//
	//Fetch raw character data.
	//Don't alter this unless you know what you're doing!
	//
	inline char				*c(){if(mData==0){*this="";} return mData;}

	//operator				char*(){return mData;}
	//operator				const char*(){return mData;}

	inline bool				operator!=(char*theString){return Compare(theString)!=0;}
	inline bool				operator!=(const char*theString){return Compare(theString)!=0;}
	inline bool				operator!=(FString &theString){return Compare(theString.mData)!=0;}

	inline bool				operator==(char*theString){return Compare(theString)==0;}
	inline bool				operator==(const char*theString){return Compare(theString)==0;}
	inline bool				operator==(FString &theString){return Compare(theString.mData)==0;}

	inline bool				operator>(char*theString){return Compare(theString)>0;}
	inline bool				operator>(const char*theString){return Compare(theString)>0;}
	inline bool				operator>(FString &theString){return Compare(theString.mData)>0;}

	inline bool				operator>=(char*theString){return Compare(theString)>=0;}
	inline bool				operator>=(const char*theString){return Compare(theString)>=0;}
	inline bool				operator>=(FString &theString){return Compare(theString.mData)>=0;}

	inline bool				operator<(char*theString){return Compare(theString)<0;}
	inline bool				operator<(const char*theString){return Compare(theString)<0;}
	inline bool				operator<(FString &theString){return Compare(theString.mData)<0;}

	inline bool				operator<=(char*theString){return Compare(theString)<=0;}
	inline bool				operator<=(const char*theString){return Compare(theString)<=0;}
	inline bool				operator<=(FString &theString){return Compare(theString.mData)<=0;}


	void					operator=(char*theString){Free();if(theString){mLength = Length(theString);mData = new char[mLength+1];mData[mLength]=0;Stamp(mData,theString,0,mLength);}}
	void					operator=(const char*theString){*this=(char*)theString;}
	void					operator=(const FString &theString){if(this != &theString){Free();*this=theString.mData;}}
	void					operator=(int theInt){ParseInt(theInt);}
	void					operator=(long long theLong){ParseLong(theLong);}
	void					operator=(float theFloat){ParseDouble((double)theFloat);}
	void					operator=(double theDouble){ParseDouble(theDouble);}
	void					operator=(void *thePtr){ParseAddress(thePtr);}
	void					operator=(bool theBool){ParseBool(theBool);}
	void					operator=(char theChar){Free();mData=new char[2];mLength=1;mData[0]=theChar;mData[1]=0;}
	
	void					operator+=(char*theString);
	inline void				operator+=(const char*theString){*this += (char*)theString;}
	void					operator+=(FString theString);
	void					operator+=(char theChar);
	inline void				operator+=(int theInt){*this += FString(theInt).c();}
	inline void				operator+=(long long theDouble){*this += FString(theDouble).c();}
	inline void				operator+=(void *thePtr){*this += FString(thePtr).c();}
	inline void				operator+=(float theFloat){*this += FString(theFloat).c();}
	inline void				operator+=(double theDouble){*this += FString(theDouble).c();}
	inline void				operator+=(bool theBool){*this += FString(theBool).c();}

	inline void				operator--(){Delete(0,1);}

	inline void				operator-=(int theNumber){Truncate(mLength-theNumber);}

	
	FString					operator+(FString theString);
	FString					operator+(char *theString);
	FString					operator+(char theChar);
	//inline FString			operator+(FString theString){return *this + theString.c();}
	inline FString			operator+(const char *theString){return *this + (char*)theString;}
	inline FString			operator+(bool theBool){return *this + FString(theBool).c();}
	inline FString			operator+(int theInt){return *this + FString(theInt).c();}
	inline FString			operator+(long long theLong){return *this + FString(theLong).c();}
	inline FString			operator+(float theFloat){return *this + FString(theFloat).c();}
	inline FString			operator+(double theDouble){return *this + FString(theDouble).c();}
	inline FString			operator+(void *thePtr){return *this + FString(thePtr).c();}

	inline char				operator[](int theSlot){if(theSlot < 0 || theSlot >= mLength)return 0;return mData[theSlot];}

	//operator				char*(){return c();}
	
	inline void				Stamp(char *theDestination, char *theString, int thePosition, int theLength){memcpy(&theDestination[thePosition],theString,theLength);}
	inline void				Stamp(char *theDestination, char *thePosition, char *theEnd){memcpy(theDestination,thePosition,theEnd-thePosition);}
	inline void				StampBlank(char *theDestination, int thePosition, int theLength){memset(&theDestination[thePosition],' ',theLength);}
	inline void				Stamp(char *theDestination, char theChar, int thePosition, int theLength){memset(&theDestination[thePosition],theChar,theLength);}
	inline char				*GetStamp(char *theDestination, char *theString, int thePosition, int theLength){memcpy(&theDestination[thePosition],theString,theLength);return &theDestination[thePosition+theLength];}
	inline char				*GetStamp(char *theDestination, char *thePosition, char *theEnd){int aJump = (int)(theEnd-thePosition); memcpy(theDestination,thePosition,aJump);return &theDestination[aJump];}
	inline char				*GetStampBlank(char *theDestination, int thePosition, int theLength){memset(&theDestination[thePosition],' ',theLength);return &theDestination[thePosition+theLength];}	

	//void					PrepForInlineModification(){if(mData && mLength > 0){if(*mRefs > 1){--*mRefs;char *aChar = mData;mRefs = new int;*mRefs=1;aChar = new char[mLength+1];aChar[mLength]=0;Stamp(aChar,mData,0,mLength);mData=aChar;}}}
	bool					Contains(char *theString, char theChar){if(!theString)return false;while(*theString){if(theChar == *theString)return true;theString++;}return false;}
	FString					*ProcessSpecifier(char *thePosition, int &theLength, va_list &aArgs);

	inline void				Constructor(){Init();}

    /*
	typedef struct ChrList
	{
		typedef struct CharPtr{char *mData;CharPtr*mNext;};
		ChrList(){mHead=mTail=mCursor=0;}
		~ChrList(){if(mHead){while(mHead){CharPtr *aHold=mHead->mNext;delete mHead;mHead=aHold;}}}
		CharPtr *mHead, *mTail, *mCursor;
		void operator += (char *theChar){CharPtr *aPtr = new CharPtr();aPtr->mData=theChar;aPtr->mNext=0;if(mTail){mTail->mNext=aPtr;}else{mHead=aPtr;mCursor=mHead;}mTail=aPtr;}
		char *Get(){if(mCursor){char *aChar=mCursor->mData;mCursor=mCursor->mNext;return aChar;}return 0;}
	};
	typedef struct FStringList
	{
		typedef struct FStringPtr{FString *mString;FStringPtr*mNext;};
		FStringList(){mHead=mTail=mCursor=0;}
		~FStringList(){if(mHead){while(mHead){FStringPtr *aHold=mHead->mNext;delete mHead;mHead=aHold;}}}
		FStringPtr *mHead, *mTail, *mCursor;
		void operator += (FString *theChar){FStringPtr *aPtr = new FStringPtr();aPtr->mString=theChar;aPtr->mNext=0;if(mTail){mTail->mNext=aPtr;}else{mHead=aPtr;mCursor=mHead;}mTail=aPtr;}
		FString *Get(){if(mCursor){FString *aChar=mCursor->mString;mCursor=mCursor->mNext;return aChar;}return 0;}
	};
    */
};

inline void		operator--(FString &theString, int theDummy){theString.Truncate(theString.mLength-1);}

inline FString	operator+(char * theChar, FString &theString){return FString(theChar) + theString;}
inline FString	operator+(const char * theChar, FString &theString){return FString(theChar) + theString;}
inline FString	operator+(int theInt, FString &theString){return FString(theInt) + theString;}
inline FString	operator+(long long theLong, FString &theString){return FString(theLong) + theString;}
inline FString	operator+(bool theBool, FString &theString){return FString(theBool) + theString;}
inline FString	operator+(float theFloat, FString &theString){return FString(theFloat) + theString;}
inline FString	operator+(double theDouble, FString &theString){return FString(theDouble) + theString;}
inline FString	operator+(void *thePtr, FString &theString){return FString(thePtr) + theString;}
inline FString	operator+(char theChar, FString &theString){return FString(theChar) + theString;}

inline bool		operator==(char *theChar, FString theString){return theString == theChar;}

#endif

