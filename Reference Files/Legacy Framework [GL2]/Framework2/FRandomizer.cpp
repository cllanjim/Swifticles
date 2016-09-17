#include "FRandomizer.h"
#include "core_os.h"

FRandomizer::FRandomizer()
{
	Seed(os_system_time());
}

FRandomizer::~FRandomizer()
{
	
}

void FRandomizer::Seed(int pSeed)
{
	mIndex=624;
	mData[0]=pSeed;
	for(int i=1;i<624;i++)mData[i]=(1812433253*(mData[i-1]^(mData[i-1]>>30))+i);
}

int FRandomizer::Get(int pMax, bool pNegative)
{
	unsigned aReturn=0;
	
	if(pMax<0)
	{
		pMax=-pMax;
		pNegative=true;
	}
	
	if (mIndex==624)
	{
		int i=0;
		int aFinalMask[2]={0,0x9908b0d};
		for(;i<624-397;i++)
		{
			aReturn=(mData[i]&0x80000000)|(mData[i+1]&0x7fffffff);
			mData[i]=mData[i+397]^(aReturn>>1)^(aFinalMask[aReturn&1]);//mag01[y & 0x1];(aReturn&1?0x9908b0d:0);//
		}
		for(;i<624;i++)
		{
	
			aReturn=(mData[i]&0x80000000)|(mData[i+1]&0x7fffffff);
			mData[i]=mData[i+(397-624)]^(aReturn>>1)^(aFinalMask[aReturn&1]);
		}
		mIndex=0;
	}
	
	pNegative=pNegative&&((mData[mIndex]&0x8)==0);
	
	aReturn = mData[mIndex++];
	aReturn ^= aReturn>>11;
	aReturn ^= (aReturn<<7)&0x9d2c5680;
	aReturn ^= (aReturn<<15)&0xefc60000;
	aReturn ^= (aReturn>>18);
	if(aReturn&&pMax>0)aReturn %= pMax;
	if(pMax==0)aReturn=0;
	if(pNegative)aReturn=-aReturn;
	
	return aReturn;
}

int FRandomizer::Get(int pMin, int pMax)
{
	return pMin+Get(pMax-pMin);
}

float FRandomizer::GetFloat()
{
	return (float)Get(0xFFFFFFF+1)/(float)(0xFFFFFFF);
}

float FRandomizer::GetFloat(float pMax)
{
	return GetFloat()*pMax;
}

float FRandomizer::GetFloat(float pMin, float pMax)
{
	return pMin+(pMax-pMin)*GetFloat();
}

float FRandomizer::GetFloat(float pMin, float pMax, bool pNegative)
{
	pNegative=pNegative&&((mData[mIndex]&0x8)==0);
	float aReturn=pMin+(pMax-pMin)*GetFloat();
	if(pNegative)aReturn=-aReturn;
	return aReturn;
}

