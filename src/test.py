# -*- coding: utf-8 -*-
from fish import CatchFish
if __name__ == "__main__":

    '''email,passwd,level,num'''
    #说明：2为雌性，3为杜牧  ,10为抓几次'''
    #time=40设置为时间，40为最低时间，建议设置为60'''
    #fishlist为需要过滤的鱼，修改时注意标点符号都是英文的。。
    fishlist=[u'丽丽',u'骨骨']
    fishman1=CatchFish("test","test123",2,10,time=40,fishlist=fishlist)
    fishman1.doFishing()
    


    
    