package
{
	import mx.controls.Alert;
	
	public class CommonOperation extends AbstractFishmanager
	{
		public function CommonOperation()
		{
			super();
		}
		 
		public var level:uint;//哪一关
		public var functionjugeRouyu:Function;
		[Bindable]
		public var fishNameForFind:String;
		public var skey2:String;//倒鱼的参数
		
		 /********收潜艇********begin******/
		public function shouyu():void{
				getPetStatus(uint(this.owner_id),aftrtPrepare); 
		}
		public function aftrtPrepare(data:Object):void{
			var fishList:Object=data["fish_list"];
			var aa:String;
        	 var fishIdArray:Array=new Array();
        	 for (var aa in fishList)
            {
                
                  fishIdArray.push(fishList[aa]["style"]);
                
            }
			harvest(fishIdArray,afterharvest);
		}
		public function afterharvest(data:Object):void{
			dispatch(level,commonresult);
		}
		  /********收潜艇********end******/
		  
		  
		  
		 /********自动合成********begin******/
		 
		public function hecheng():void{
				getFormularyList(0,chooseBig)
		}
		public function chooseBig(data:Object):void{
		 	var fishList:Object=data.objList;
			 var aa:String;
			 var tempfish;
			 var xingjiabitmp:Number=0;
        	 for (var aa in fishList)
            {
            	
                var fish1:Object= fishList[aa];
                if(int(fish1.base_rate)>=70&&Boolean(fish1.is_level_enough)&&Boolean(fish1.is_essence_enough)){
               		 var jingyan:int=int(fish1.get_exp)*1000;
    				var shijian:int=int(fish1.total_time);
    				var xingjiabi:Number=jingyan/shijian;
    				if(xingjiabi>xingjiabitmp){
    					xingjiabitmp=xingjiabi;
    					tempfish=fish1;
    				}
                }
    				
    				
            }
            for(var i=0;i<5;i++){
            	addSynthesize(int(tempfish.id),commonresult);
            }
				     
						 
		 }
		 /********自动合成********end******/
		 
		 
		 	 /********领取********begin******/
		 public function lingqu():void{
		 	  		getSynthesizeInfo(lingquresult);
		 }
		 private function lingquresult(date:Object){
		 	 //printObject(date);
		 	 var aa:String;
        	 for (var aa in  date.synth_list)
            {
               var temp:Object=date.synth_list[aa];
              var synth_id1:int=int(temp.synth_id);
              if(uint(temp.synth_status)==2){
              	compeleteSynthesize(synth_id1,commonresult);
              }
    			 
            }
		 }
		 	 /********领取********end******/
		 	 
		 	 /********加合成********begin******/
		 public function jiahecheng(sId:uint):void{
		 	  	this.other_id=sId;
		 	  		 getMemberSyntheize(uint(owner_id),sId,jiahechengresult)
		  }
		  public function jiahechengresult(date:Object):void{
		  		 	 var pp:uint=uint(date["synth_id"]);
		  		 	 addRateFriend(uint(owner_id),other_id,pp,commonresult);
		  }
		 	 
		 	 /********加合成********end******/
		 	 
		 	 /********清理塑料袋******begin******/
		 public function dianjinghua():void{
	 	  	var aa:Array=new Array();
	 	  	aa.push(2);
         	aa.push(3);
         	aa.push(5);
          	aa.push(7);
         	aa.push(11);
          	aa.push(13);
         	aa.push(15);
 			for(var i:int=0;i<aa.length;i++){
	 	  		getBagList(aa[i],"f",getBagListresult);
	 	 	}
		}
	 	 public function getBagListresult(date:Object):void{
	  		 	var fishList:Object=date['obj_list'];
		 		for(var aa in fishList){
		 			var fishObj:Object=fishList[aa];
	 			 	 if(functionjugeRouyu(String(fishObj.name))){
	 			 	 	decomposeFish(uint(fishObj['id']),commonresult);
	 			 	 } 
		 		}  
	  		}
		  		
			
					 	 
		 	 /********清理塑料袋********end******/
		 	 
		 	 /********喂鱼*******begin******/
		 	public function weiyu():void{
		 		getMyFishTank(uint(owner_id),weiyuresult);
	 	  	}
	 	  	public function weiyuresult(date:Object):void{
		 		 var str:String;
			 	 for(var str in date){
			 	 	var name1:String=date[str]['name'];
			 	 	if(name1.indexOf('鱼塘')>-1||name1.indexOf('w')>-1){
			 	 		feedFish(date[str]['id']);
			 	 	}
			 	 }
	 	  	}
		 	private function feedFish(tankid:String):void{
					//先把鱼缸所有鱼取出来，找到最大的鱼饱食度
					getMyFishTankObjectList(uint(owner_id),uint(tankid),queryFishresult);
	 				//喂鱼100-num	
			}
			private function queryFishresult(date:Object){
				var fishList:Object=date['fish_list'];   
				var maxhungry:Number=-1;				
				for (var aa in fishList)
				{
					if(maxhungry<Number(fishList[aa]['hungry'])){
						maxhungry=Number(fishList[aa]['hungry']);
					}
				}
				if(maxhungry>=0){
					var fishfood:Number=100-maxhungry;
					feedAMF(uint(owner_id),date['fish_tank']['id'],int(fishfood/10)*10,commonresult);					  			 
				}
			}
		 	 /********喂鱼**********end******/
		 	 
		 	 
		 	 /********倒鱼*******begin******/
		 	public function daoyu():void{
		 		if(skey!=skey2){
		 			getMyFishTank(uint(owner_id),daoyuresult);
		 		}
	 	  	}
	 	  	private var tankid:String;
	 	  	public function daoyuresult(date:Object):void{
		 		var str:String;
				for(var str in date){
					var name1:String=date[str]['name'];
					if(name1=='倒鱼'||name1=='daoyu'){
						var id1:String=date[str]['id'];
						count=0;
			         	tankid=id1;
			         	setTankTroll(tankid);
			         	var aa:Array=new Array();
			         	aa.push(1);
			         	aa.push(2);
			         	aa.push(3);
			         	aa.push(5);
			          	aa.push(7);
			         	aa.push(9);
			         	aa.push(11);
			          	aa.push(13);
			         	aa.push(15);
			         	
			         	count=0;
			         	//大号钓鱼
			         	for(var i:int=0;i<aa.length;i++){
			         		getBagList(aa[i],"f",querySuLiaodaiResult);
			         	}
				       	break;
					}
				 
				}
	 	  	}
	 	  	private var count:int=0;	
			private function querySuLiaodaiResult(date:Object){			   
				var fishiList:Object=date['obj_list'];	
					 
				for(var aa in fishiList){
					var fish1:Object=fishiList[aa];					
					var fishId:String=String(fish1['id']);
					torllAfish(tankid,fishId);
					count++;
					if(count>=100){
						break;
					}
				}			 
			}
			private function torllAfish(tankId:String,fishId:String){
				moveObject( commonresult,uint(fishId), "f", Number(tankId), 0, 0);
	         	trollAMFForOther(commonresult,skey2,uint(owner_id),uint(tankId),null);
			}
	 	  	private function  setTankTroll(tankid:String):void
			{
				//查询
				getMyFishTankObjectList(uint(owner_id),uint(tankid),setTankTrollResult);
			}
			private function  setTankTrollResult(date:Object):void
			{
				//查询
				var tankObj:Object=date['fish_tank'];
				 setMyFishTank(uint(tankObj.id), tankObj.name, Boolean(tankObj.is_first), true, 1,  100,false,"",commonresult);
			}
			
		 	 /********倒鱼**********end******/
		 /********找鱼**********begin******/
			public function zhaoyu():void{
				//塑料袋
				var family:int=getZu(fishNameForFind); 
				if(family!=0)
	         		getBagList(family,"f",zhaoyuResult);
	         	
			}
			 
			private function getZu(fishName:String):int{
				 for(var i:int=0;i<Parameters.xunfeng.length;i++){
				 	if(fishName.indexOf(String(Parameters.xunfeng[i]))>-1)
					{
						return 3;
					}
				}
				for(var i:int=0;i<Parameters.sandao.length;i++){
				 	if(fishName.indexOf(String(Parameters.sandao[i]))>-1)
					{
						return 5;
					}
				}
				for(var i:int=0;i<Parameters.douhua.length;i++){
				 	if(fishName.indexOf(String(Parameters.douhua[i]))>-1)
					{
						return 7;
					}
				}
				for(var i:int=0;i<Parameters.tuantuan.length;i++){
				 	if(fishName.indexOf(String(Parameters.tuantuan[i]))>-1)
					{
						return 2;
					}
				}
				for(var i:int=0;i<Parameters.jujiao.length;i++){
				 	if(fishName.indexOf(String(Parameters.jujiao[i]))>-1)
					{
						return 11;
					}
				}
				for(var i:int=0;i<Parameters.baomi.length;i++){
				 	if(fishName.indexOf(String(Parameters.baomi[i]))>-1)
					{
						return 13;
					}
				}
				for(var i:int=0;i<Parameters.xzu.length;i++){
				 	if(fishName.indexOf(String(Parameters.xzu[i]))>-1)
					{
						return 1;
					}
				}
				return 0;
			}
			public function zhaoyuResult(date:Object):void{
				var fishList:Object=date['obj_list'];
				var isBag:Boolean=false;
				for(var aa in fishList){
					var fishObj:Object=fishList[aa];
					if(String(fishObj.name).indexOf(fishNameForFind)>-1){
							Alert.show( skey.split(",")[1]+"的塑料袋");
							isBag=true;
							break;
					}
				}
				if(!isBag){
					//继续寻找鱼缸
					//todo
				}
			}
			
	
		 /********找鱼鱼**********end******/
		  
	}
}