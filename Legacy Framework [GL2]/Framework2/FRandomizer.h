/*
 *  FRandomizer.h
 *  (c) 2009 Nick Raptis
 */

#pragma once

class FRandomizer
{
public:
	FRandomizer();
	~FRandomizer();
	
	void				Seed(int pSeed); 
	int					Get(int pMax, bool pNegative=false);
	int					Get(int pMin, int pMax);
	
	inline bool			GetBool(){return Get(2)!=0;}
	inline int			Sign(){return Get(2)?1:-1;}
	
	inline int			Negate(int pNumber){return (Get(2)==0)?pNumber:-pNumber;}
	inline float		Negate(float pNumber){return (Get(2)==0)?pNumber:-pNumber;}
	
	float				GetFloat();
	float				GetFloat(float pMax);
	float				GetFloat(float pMin, float pMax);
	float				GetFloat(float pMin, float pMax, bool pNegative);
	
	inline int operator	[](int pMax){return Get(pMax);}
	inline int operator	[](float pMax){return GetFloat(pMax);}
	
	unsigned int		mData[624];
	
	int					mIndex;

};