// (C) 2006-2009 Nick Rapis

#include "FString.h"

#ifndef FRAMEWORK_XML_H
#define FRAMEWORK_XML_H

#define EnumTags(__XML_TAG__,__XML_SUBTAG_NAME__)for(FXMLTag **__XML_ENUM_START__=(FXMLTag**)__XML_TAG__->mTags.mElement,**__XML_ENUM_END__=(FXMLTag**)(__XML_TAG__->mTags.mElement+__XML_TAG__->mTags.mCount),*__XML_SUBTAG_NAME__=(__XML_TAG__->mTags.mElement+__XML_TAG__->mTags.mCount>0)?*__XML_ENUM_START__:0;__XML_SUBTAG_NAME__!=0;__XML_SUBTAG_NAME__=(++__XML_ENUM_START__<__XML_ENUM_END__)?*__XML_ENUM_START__:0)
#define EnumParams(__XML_TAG__,__XML_PARAMETER_NAME__)for(FXMLParameter **__XML_ENUM_START__=(FXMLParameter**)__XML_TAG__->mParameters.mElement,**__XML_ENUM_END__=(FXMLParameter**)(__XML_TAG__->mParameters.mElement+__XML_TAG__->mParameters.mCount),*__XML_PARAMETER_NAME__=(__XML_TAG__->mParameters.mElement+__XML_TAG__->mParameters.mCount>0)?*__XML_ENUM_START__:0;__XML_PARAMETER_NAME__!=0;__XML_PARAMETER_NAME__=(++__XML_ENUM_START__<__XML_ENUM_END__)?*__XML_ENUM_START__:0)

#define EnumTagsMatching(__XML_TAG__,__XML_SUBTAG_NAME__,__NAME__)EnumTags(__XML_TAG__,__XML_SUBTAG_NAME__)if(__XML_SUBTAG_NAME__->mName&&__NAME__)if(strcmp(__XML_SUBTAG_NAME__->mName,__NAME__)==0)
#define EnumParamsMatching(__XML_TAG__,__XML_PARAMETER_NAME__,__NAME__)EnumParams(__XML_TAG__,__XML_PARAMETER_NAME__)if(strcmp(__XML_PARAMETER_NAME__->mName,__NAME__)==0)

#define XML_VARIABLE_START(c) (((c>='a'&&c<='z')||(c>='A'&&c<='Z'))||c=='_'||c=='$')
#define XML_VARIABLE_BODY(c) (((c>='a'&&c<='z')||(c>='A'&&c<='Z')||(c>='0'&&c<='9'))||c=='_'||c=='$')

class FXMLElement
{
public:
	FXMLElement(){mName=0;mValue=0;}
    
	virtual ~FXMLElement(){delete[]mName;mName=0;delete[]mValue;mValue=0;}
    
    void            SetName(char *pName);
    void            SetName(const char *pName){SetName((char*)pName);}
    
    void            SetValue(char *pValue);
    void            SetValue(const char *pValue){SetValue((char*)pValue);}
    
	char            *mName;
	char            *mValue;
};

class FXMLElementList
{
public:
	FXMLElementList(){mElement=0;mCount=0;mSize=0;}
	~FXMLElementList(){Clear();}
	void					Clear();
	void					operator += (FXMLElement *theElement);
	inline FXMLElement		*operator[](int theSlot){if(theSlot>=0&&theSlot<mCount)return mElement[theSlot];else return 0;}
	FXMLElement				**mElement;
	int						mCount;
	int						mSize;
};


class FXMLParameter : public FXMLElement
{
public:
	
    FXMLParameter(const char *pName=0, const char *pValue=0){FXMLElement();mName=0;mValue=0;FXMLElement();SetName(pName);SetValue(pValue);}
    
};

class FXMLTag : public FXMLElement
{
public:
    FXMLTag(const char *pName=0, const char *pValue=0){FXMLElement();mName=0;mValue=0;FXMLElement();SetName(pName);SetValue(pValue);}
    
	virtual				~FXMLTag(){delete[]mName;delete[]mValue;mName=0;mValue=0;}
	inline void			operator += (FXMLTag *theTag){mTags += theTag;}
	inline void			operator += (FXMLParameter *theParam){mParameters += theParam;}
	
	char				*GetParamValue(char *pName, const char*pDefault=0);
	inline char			*GetParamValue(const char *pName, const char*pDefault=0){return GetParamValue((char*)pName);}
	inline char			*GetParamValue(FString pName, const char*pDefault=0){return GetParamValue((char*)pName.c());}
    
    char				*GetSubtagValue(char *pName, const char*pDefault=0);
	inline char			*GetSubtagValue(const char *pName, const char*pDefault=0){return GetSubtagValue((char*)pName);}
	inline char			*GetSubtagValue(FString pName, const char*pDefault=0){return GetSubtagValue((char*)pName.c());}
    
    void                AddTag(const char* pName, const char* pValue);
    void                AddParam(const char* pName, const char* pValue);
	
    
    void                AddParamInt(const char* pName, int pInt);
    void                AddParamFloat(const char* pName, float pFloat);
    void                AddParamBool(const char* pName, bool pBool);
    void                AddParamChar(const char* pName, char pChar);
    
    int                 GetParamInt(const char* pName);
    float               GetParamFloat(const char* pName);
    bool                GetParamBool(const char* pName);
    char                GetParamChar(const char* pName);
    
	FXMLElementList		mTags;
	FXMLElementList		mParameters;
};

class FXML
{
public:
    
	FXML();
	~FXML();
	
	void				Load(char *pFile);
	inline void			Load(const char *pFile){Load((char*)pFile);}
	inline void			Load(FString pFile){Load(pFile.c());}
    
    
    void                Save(char *pFile);
    inline void			Save(const char *pFile){Save((char*)pFile);}
	inline void			Save(FString pFile){Save(pFile.c());}
	
	void				Parse(char *pData, int pLength);
	
	void				Print();
	void				Export();
	void				Export(int depth, FXMLTag *tag);
	void				ExportAppend(char *pText);
	inline void			ExportAppend(const char *pText){ExportAppend((char*)pText);}
    
	FXMLTag				*GetNestedTag1(char *pName1);
	inline FXMLTag		*GetNestedTag1(FString pName1){return GetNestedTag1(pName1.c());}
	
	FXMLTag				*GetNestedTag2(char *pName1, char *pName2);
	inline FXMLTag		*GetNestedTag2(FString pName1, FString pName2){return GetNestedTag2(pName1.c(),pName2.c());}
	
	FXMLTag				*GetNestedTag3(char *pName1, char *pName2, char *pName3);
	inline FXMLTag		*GetNestedTag3(FString pName1, FString pName2, FString pName3){return GetNestedTag3(pName1.c(),pName2.c(),pName3.c());}
	
	FXMLTag				*GetNestedTag4(char *pName1, char *pName2, char *pName3, char *pName4);
	inline FXMLTag		*GetNestedTag4(FString pName1, FString pName2, FString pName3, FString pName4){return GetNestedTag4(pName1.c(),pName2.c(),pName3.c(),pName4.c());}
    
	void				Clear();
	
	inline FXMLTag		*GetRoot(){return mRoot;}
	
	FXMLTag				*mRoot;
    
	char				*mOutput;
	int					mOutputSize;
	int					mOutputLength;
};

char *SkipQuote(char *pSeek);
char *SkipComment(char *pSeek);

#endif