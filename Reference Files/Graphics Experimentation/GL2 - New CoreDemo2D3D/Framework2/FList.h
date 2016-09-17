#ifndef LIST_H
#define LIST_H

#define LIST_UNIQUE 0x00000002

#define EnumList(__TYPE__,__NAME__,__LIST__)for(__TYPE__ **__ENUM_START__=(__TYPE__**)(__LIST__).mData,**__ENUM_END__=(__TYPE__**)(__ENUM_START__+(__LIST__).mCount),*__NAME__=(__TYPE__*)(((__LIST__).mCount)?*__ENUM_START__:0);__NAME__!=0;__NAME__=(++__ENUM_START__<__ENUM_END__)?*__ENUM_START__:0)

#define EnumListReverse(__TYPE__,__NAME__,__LIST__)for(__TYPE__ **__ENUM_START__=(__TYPE__**)((__LIST__).mData+(__LIST__).mCount-1), **__ENUM_END__=(__TYPE__**)((__LIST__).mData), *__NAME__=((__LIST__).mCount?*__ENUM_START__:0);__NAME__!=0;__NAME__=(--__ENUM_START__>=__ENUM_END__)?*__ENUM_START__:0)

#define FreeList(pType,pFList){EnumList(pType,__LIST_ITERATOR_NAME__,pFList){delete __LIST_ITERATOR_NAME__;}pFList.Clear();}

class FList
{
public:
	FList();
	~FList();
	
	void					Clear();
	
	void					Size(int pSize);
	
	int						Find(void *pitem);
	
	bool					Exists(void *pItem);
    
	void					Add(void *pItem);
	void					Add(FList &pFList);
	inline void operator	+=(void *pItem){Add(pItem);}
	inline void operator	+=(FList &pFList){Add(pFList);}
	
	void					Insert(void *pItem, int pSlot=0);
	
    void                    RemoveAtIndex(int pIndex);
    
	void					Remove(void *pItem);
	void					Remove(FList &pFList);
	inline void operator	-=(void *pItem){Remove(pItem);}
	inline void operator	-=(FList &pFList){Remove(pFList);}
    
    void                    RemoveAllBefore(int pIndex);
    void                    RemoveAllAfter(int pIndex);
    
    void                    RemoveAll(){mCount=0;}
	
	void					*Pop();
	
	void					RemoveFirst(void *pItem);
	inline void				DeleteFirst(void *pItem){RemoveFirst(pItem);}
	void					RemoveLast(void *pItem);
	inline void				DeleteLast(void *pItem){RemoveLast(pItem);}
    
    
    void                    MoveObjectUp(void *pItem);
    void                    MoveObjectDown(void *pItem);
	
	void					MoveToFront(void *pItem);
	void					MoveToBack(void *pItem);
	void					Swap(void *pItem1, void *pItem2);
	
	void					Print();
    
    void                    *FetchBest(int pIndex);
	
	void                    *Fetch(int pIndex);
    void                    *FetchCircular(int pIndex);
	inline void				*operator[](int pIndex){return Fetch(pIndex);}
	
	void					*FetchRandom();
	
	inline void				*Last(){return mCount>0 ? mData[mCount-1] : 0;}
	inline void				*First(){return mCount>0 ? mData[0] : 0;}
	
	void					Shuffle();
	
	void					Reverse();
	
	
	void					Sort();
	bool					IsSorted();
	void					ISort();
	
	inline int				Count(){return mCount;}
	
	void					**mData;
	int						mSize;
	int						mCount;
	int						mProperties;
};

#endif