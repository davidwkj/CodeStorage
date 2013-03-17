# -*- coding: utf-8 -*-
from pyamf.remoting.client import RemotingService
import time,random
import datetime
from cookie import getCookie


class FishInf():
    '''FishInf'''
    def __init__(self,email,fishName):
        self.email=email
        self.fishName=fishName
        self.time=str(datetime.datetime.now())
        
    def save(self):
        print u"%s 抓到了%s 时间是：%s" %(self.email,self.fishName,self.time)

class CatchFish():
    
    ''' Catch Fish'''
    def __init__(self,email,passwd,level,num=10,time=40,fishlist=[]):
        ''' level=2/3,fishs is a list for catch fishs'''
        self.email=email
        self.passwd=passwd
        self.levle=level
        self.num=num
        self.fishlist=fishlist
        self.cookie,self.uid,self.reffre=getCookie(email,passwd)
        
        #Login ok?
        if self.cookie is None:
            exit()
        
        self.id=1
        self.default_time=40-10
        
        #For creack update..
        self.varify_code=""
        self.js_script=""
        self.postBackCode=""
        
        self.productList=[]
        self.totalNum=0
        self.levelKey=[["21","22","23","24","25"],["31","32","33","34","35"]]
        
            
    def getServices(self):
        '''get game services'''
        client = RemotingService('http://xiaonei.paopaoyu.cn/gateway/')
        client.amf_version=0
        client.client_type=3
        client.strict=True
        client.request_number=self.id
        self.id+=1
        client.addHTTPHeader('Referer',self.reffre)
        client.addHTTPHeader('Cookie:',self.cookie)
        client.user_agent="Mozilla-xx/5.0 (Windows; U; Windows NT 6.1; zh-CN; rv:1.9.1.3) Gecko/20090824 waigua"
        service = client.getService('gameService')
        return service
    
    
    def getFishName(self,result):
        '''Get Fish Name'''
        try:
            if result.has_key("fish") and result["fish"].has_key("name"):
                fishName=result["fish"]["name"] 
                varify_code=result["varify_code"]
#                print fishName,varify_code
                return (fishName,varify_code)
        except:
            return ("Nofish","No_code")
    
    def printFish(self,fishName,ok):
        if ok:
            print u" %s 发现了%s,伟大的外挂决定收下了" %(str(datetime.datetime.now()),fishName)
        else:
            print u" %s 发现了%s,伟大的外挂决定不要这种垃圾鱼" %(str(datetime.datetime.now()),fishName)
    
    def isInFishs(self,fishName):
        if self.fishlist is None :
            self.printFish(fishName, True)
            return True
        if len(self.fishlist)==0:
            self.printFish(fishName, True)
            return True
        for fish in self.fishlist:
            if fishName.find(fish)>-1:
                self.printFish(fishName, True)
                return True
        self.printFish(fishName, False)
        return False
    
    def isCatchFish(self,fishName,LN,isOK=False):
        service = self.getServices()
        result=service.catchFishCompleteLevelAMF(self.uid,self.levelKey[self.levle-2][LN],isOK)
        if isOK:
            inf=FishInf(self.email,fishName)
            self.objlist.append(inf)
        if "js_script" in result:
            self.js_script=result["js_script"]
            s_index=self.js_script.find(',')
            s1=self.js_script[s_index-2:s_index].replace("(","")
            s2=self.js_script[s_index+1:s_index+4].replace(")","")
            self.postBackCode=self.getCode(int(s1), int(s2))

        
    def getCode(self,inta,intb):
        return self.varify_code[inta:intb][::-1] 
           
    def save(self):
        for obj in self.objlist:
            obj.save()
    
        
    def fishing(self):
        self.objlist=[]        
        
        LN=self.levle-2
        service = self.getServices()
        result=service.catchFishStartLevelAMF(self.uid,self.levelKey[LN][0],self.levle)
        fishName,self.varify_code=self.getFishName(result)

        ## post back..
        time.sleep(random.randint(self.default_time,self.default_time+5))
        self.isCatchFish(fishName, 0,self.isInFishs(fishName))
        
        ##NextLive
        time.sleep(random.randint(1,2))
        service = self.getServices()
        service.catchFishStartLevelAMF(self.uid,self.levelKey[LN][1])
    
        ##2 Post Back
        time.sleep(random.randint(self.default_time+5,self.default_time+10)) ## 60s
        service = self.getServices()
        service.catchFishCompleteLevelAMF(self.uid,self.levelKey[LN][1],False)
    
        ## 3 level
        time.sleep(random.randint(1,2))
        service = self.getServices()
        result=service.catchFishStartLevelAMF(self.uid,self.levelKey[LN][2])
        fishName,self.varify_code=self.getFishName(result)
    
        ## 3 Post Back
        time.sleep(random.randint(self.default_time+10,self.default_time+15))## 80s
        self.isCatchFish(fishName, 2,self.isInFishs(fishName))

        ## 4 level
        time.sleep(random.randint(1,2))
        service = self.getServices()
        service.catchFishStartLevelAMF(self.uid,self.levelKey[LN][3])
    
        ##4 Post Back
        time.sleep(random.randint(self.default_time+15,self.default_time+20)) ## 100s
        service = self.getServices()
        service.catchFishCompleteLevelAMF(self.uid,self.levelKey[LN][3],False)
    
        #5 level
        time.sleep(random.randint(1,2))
        service = self.getServices()
        result=service.catchFishStartLevelAMF(self.uid,self.levelKey[LN][4])
        fishName,self.varify_code=self.getFishName(result)
    
        ## 5 Post Back
        time.sleep(random.randint(self.default_time+20,self.default_time+25))## 120s
        self.isCatchFish(fishName,4, self.isInFishs(fishName))
    
        ##end
        time.sleep(random.randint(5,10))
        service = self.getServices()
        result=service.catchFishGiveUpLevelAMF(self.uid,self.levelKey[LN][4],self.postBackCode)
 
        
        time.sleep(random.randint(5,10))
        if "success" in result:
            if result["success"]:
                self.num-=1
                self.save()
            else:
                print u"游戏已经更新，外挂已经退出，请通知GM更新外挂"
                exit()
                
    def doFishing(self):
        errInt=0
        while(self.num>0):
            try:
                self.fishing()
            except:
                errInt +=1
                if errInt >=3:
                    print u"发生3次网络错误，程序退出"
                    exit()
                print u'发生第%s次网络错误，重新连接中' % errInt
                self.fishing()
    