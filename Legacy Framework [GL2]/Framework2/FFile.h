//
//  FFile.h
//  CoreDemo
//
//  Created by Nick Raptis on 10/1/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#ifndef CoreDemo_FFile_h
#define CoreDemo_FFile_h

#include "FString.h"

class FFile
{
public:
    
    FFile();
    virtual ~FFile();
    
    virtual void		Clear();
	
	inline void			SetSize(int size){Size(size);}
	void				Size(int size);
	
	void				WriteBool(bool write);
	bool				ReadBool();
	
	void				WriteChar(unsigned char write);
	char				ReadChar();
	
	void				WriteShort(short write);
	short				ReadShort();
	
	void				WriteInt(int write);
	int					ReadInt();
	
	void				Write(char *write, int theLength);
	void				Write(char *write);
    
	inline void			WriteFloat(float write){WriteInt(*((int*)(&write)));}
	inline float		ReadFloat(){unsigned int aRead = ReadInt(); return *((float*)(&aRead));}
	
	void				WriteString(char *pString);
    inline void			WriteString(FString pString){WriteString(pString.c());}
    inline void			WriteString(const char * pString){WriteString((char*)pString);}
    
	FString				ReadString();
	
	void				WriteBits(unsigned int pWrite, int pBitCount);
	unsigned int		ReadBits(int pBitCount);
	int					ReadBits(int pBitCount, bool pSigned);
    
	bool				HasMoreData(int pBitCount);
    
	void				Save(char *pFile=0);
    virtual void		Save(const char *pFile){Save((char*)pFile);}
	inline void			Save(FString pString){Save(pString.c());}
	
	void				Load(char *pFile=0);
    virtual void		Load(const char *pFile){Load((char*)pFile);}
	inline void			Load(FString pString){Load(pString.c());}
    
	void				Print(bool include_tail=true);
    void                PrintFile();
	
	void				operator=(FFile &theFFile);
    
	char				*MakeFile(char *pFile, bool pMakeDirectory=true);
	char				*GetFile(char *pFile){return MakeFile(pFile,false);}
	
    FString             mPath;
	unsigned char		*mData;
	unsigned int		mLength;
	unsigned int		mSize;
	
	//protected:
	unsigned int		mReadCursor;
	unsigned int		mWriteCursor;
	void				Grow();
};
#endif
