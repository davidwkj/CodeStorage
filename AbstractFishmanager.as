package
{
	import com.adobe.crypto.MD5;
	
	import flash.net.Responder;
	
	import jp.strippers.remoting.PendingCall;
	import jp.strippers.remoting.RemotingService;
	import jp.strippers.remoting.ServiceFactory;
	
	import mx.controls.Alert;
	public class AbstractFishmanager extends PaopaoyuManager
	{
		 
		public var _amfService:RemotingService;
		public var _snsService:RemotingService;
		[Bindable]
		public var rouyuArray:Array=new Array();//肉鱼集合
		[Bindable]
	 	private var _skey:String;
        private var _amfServiceName:String = "amfService";
        private var _snsServiceName:String = "snsService";
        private var _serviceFactory:ServiceFactory;
        [Bindable]
	 	public var owner_id:String;
	 	 [Bindable]
	 	public var other_id:uint;
        [Bindable]
        public var userInfor:Object;
        [Bindable]
		 public var message:String="";
		 
		public function AbstractFishmanager()
		{
			var url1=Parameters.gateWay;
		  	_serviceFactory = ServiceFactory.getInstance(url1);
	 		_amfService = _serviceFactory.getService(_amfServiceName);
		    _snsService = _serviceFactory.getService(_snsServiceName);
		   
		}
		public function initService():void{
			var url1=Parameters.gateWay;
			if(_serviceFactory==null){
				_serviceFactory = ServiceFactory.getInstance(url1);
			}
			if(_amfService==null||!_amfService.connection.connected){
				_amfService = _serviceFactory.getService(_amfServiceName);
			}
		}
		[Bindable]
		public function   set skey(_skey:String):void{
			this._skey=_skey;
			login();
		}
		
		[Bindable]
		public function   get skey():String{
			return _skey;
		}
		public function login():void{
				 
        	var  loc:PendingCall =_snsService.getInSiteInvitationStatusAMF(skey);
        	 loc.responder=new Responder(commonresult,error);
        	 getUserInformation(loginresult);
			getPubSeaInfo(commonresult);
		}
		 
		public function loginresult(date:Object):void{
			userInfor=date["user_info"];
 			owner_id=userInfor['id'];
 			getPetStatus(uint(owner_id),commonresult);
 			getBagList(1,"f",commonresult);  
    		afterlogin();
		}
		public function  afterlogin():void{
		
		}
		public function error(date:Object):void{
 			printObject(date);
		}
	 
		public function commonresult(date:Object){
		}
		public function printObject(date:Object):void{
        	var aa:String;
        	var message:String="";
        	 for (var aa in date)
            {
                
                message += aa +"|"+ date[aa];
                message+="\n================\n";
            }
             Alert.show(message);
        }
        
		  public function getSig2Of(... _args) : String
        {
            var expandedArray:Array;
            var i:uint;
            var orderedArr:Array;
            var n:String;
            var strArr:Array;
            var arrIndex:uint;
            var argStr:Object;
            var s1:String;
            var s2:String;
            var md1:String;
            var md2:String;
            var randNum:Number;
            var md5Rand:String;
            var rand:String;
            var md3:String;
            var ascii:uint;
            var index:uint;
            var testChar:String;
            var prefix:String;
            var suffix:String;
            var sig:String;
            var item:Object;
            var elmt:Object;
            var args = _args;
            expandedArray = args;
            i = 0;
            while (i < expandedArray.length) {  //把参数中有数组的分解并放到最后(捉到的单鱼都是数组的，也放到最后)
                item = expandedArray[i];
                if ((item is Array)){
                    for each (elmt in item) {
                        expandedArray.push(elmt);
                    };
                };
                i = (i + 1);
            };
            expandedArray = expandedArray.filter(function (_arg1:Object, _arg2:int, _arg3:Array):Boolean{
                var _local4:*;
                return (!((_arg1 is Array)));
            });  				//把参数中有数组的分解并放到最后end
            orderedArr = [];
            for (n in expandedArray) {
                if (args[n] != null){
                    orderedArr[n] = expandedArray[n].toString();
                } else {
                    orderedArr[n] = "null";
                };
            };
            orderedArr.sort(Array.DESCENDING);
            strArr = ["", ""];
            arrIndex = 0;
            for each (argStr in orderedArr) {
                strArr[arrIndex] = (strArr[arrIndex] + argStr);
                arrIndex = ((arrIndex + 1) % 2);
            };
            s1 = strArr[0];
            s2 = strArr[1];
            md1 = MD5.hash(s1);
            md2 = MD5.hash(s2);
            randNum = Math.random();
            md5Rand = MD5.hash(randNum.toString());
            rand = md5Rand.substr(0, 8);
            md3 = MD5.hash(((md1 + rand) + md2));
            ascii = md1.charCodeAt((md1.length - 1));
            testChar = "09az";
            if (ascii <= testChar.charCodeAt(1)){
                index = (ascii - testChar.charCodeAt(0));
            } else {
                index = ((10 + ascii) - testChar.charCodeAt(2));
            };
            prefix = md3.substr(0, index);
            suffix = md3.substr(index);
            suffix = suffix.substr(0, (suffix.length - 8));
            sig = ((prefix + rand) + suffix);
            return (sig);
        }// end function

		    public function getSigOf(... args) : String
        {
        	 
            var _loc_3:Object = null;
            var _loc_4:Number = NaN;
            var _loc_5:String = null;
            var _loc_6:String = null;
            var _loc_7:String = null;
            var _loc_8:String = null;
            var _loc_9:String = null;
            var _loc_10:String = null;
             
            var sb:String="";
            for each (_loc_3 in args)
            {
                
                if (_loc_3 != null)
                {
                    sb += _loc_3.toString();
                    continue;
                }
                sb+= "null";
            }
            _loc_4 = Math.random();
            _loc_5 = MD5.hash(_loc_4.toString());
            _loc_6 = _loc_5.substr(0, 8);
           	sb += _loc_6;
            _loc_7 = MD5.hash(sb);
            _loc_8 = _loc_7.substr(0, 10);
            _loc_9 = _loc_7.substr(10);
            _loc_9 = _loc_9.substr(0, _loc_9.length - 8);
            _loc_10 = _loc_8 + _loc_6 + _loc_9;
            return _loc_10;
        }// end function 


		  public function getPetStatus(param1:uint,functionname:Function)
        {
            var _loc_2:PendingCall = null;
            
            _loc_2 = _amfService.getPetStatusAMF(getSigOf(param1, skey),skey, param1);
            _loc_2.responder = new Responder(functionname, error);
            return;
        }// end function
        
         public function harvest(param1:Array,functionname:Function)
        {
            var _loc_2:PendingCall = null;
             
            _loc_2 = _amfService.harvestAMF(getSig2Of(skey, param1), skey);
            _loc_2.responder = new Responder(functionname, error);
            return;
        }// end function

 		public function dispatch(param1:uint,functionname:Function)
        {
            var _loc_2:PendingCall = null;
            _loc_2 = _amfService.dispatchAMF(getSigOf(param1, skey), skey, param1);
            _loc_2.responder = new Responder(functionname, error);
            return;
        }// end function
        
         public function getFormularyList(param1:uint,functionname:Function)
        {
            var _loc_2:PendingCall = null;
            _loc_2 = _amfService.getFormulaListAMF(getSigOf(param1,  skey), skey, param1);
            _loc_2.responder = new Responder(functionname, error);
            return;
        }// end function
         public function addSynthesize(param1:uint,functionname:Function)
        {
            var _loc_2:PendingCall = null;
           
            _loc_2 = _amfService.addSynthesisAMF(getSigOf(param1,  skey), skey, param1);
            _loc_2.responder = new Responder(functionname, error);
            return;
        }// end function
        
        
          public function getSynthesizeInfo(functionname:Function)
        {
            var _loc_1:PendingCall = null;
           
            _loc_1 = _amfService.getSynthesisInfoAMF(getSigOf(skey), skey);
            _loc_1.responder = new Responder(functionname, error);
            return;
        }// end function
        
        public function compeleteSynthesize(param1:uint,functionname:Function)
        {
            var _loc_2:PendingCall = null;
           
            _loc_2 = _amfService.completeSynthesisAMF(getSigOf(param1,  skey),  skey, param1);
            _loc_2.responder = new Responder(functionname, error);
            return;
        }// end function
         public function getMyFishTank(param1:uint,functionname:Function)
        {
            var _loc_2:PendingCall = null;
           
            _loc_2 = _amfService.getMyFishTankListAMF(getSigOf(param1,  skey), skey, param1);
            _loc_2.responder = new Responder(functionname, error);
            return;
        }// end function
         public function getUserInfoBySnsId(param1:String,functionname:Function)
        {
            var _loc_2:PendingCall = null;
            
            _loc_2 = _amfService.getUserInfoBySnsIdAMF(getSigOf(param1,   skey), skey, param1);
            _loc_2.responder = new Responder(functionname, error);
            return;
        }// end function
        
          public function getMemberSyntheize(param1:uint, param2:uint,functionname:Function)
        {
            var _loc_3:PendingCall = null;
             
            _loc_3 = _amfService.getMemberSynthesisAMF(getSigOf(param2,   skey),  skey, param2);
            _loc_3.responder = new Responder(functionname, error);
            return;
        }// end function
        
          public function addRateFriend(param1:uint, param2:uint, param3:uint,functionname:Function)
        {
            var _loc_4:PendingCall = null;
            
            _loc_4 = _amfService.addRateFriendAMF(getSigOf(param3, param2,  skey),  skey, param2, param3);
            _loc_4.responder = new Responder(functionname, error);
            return;
        }// end function
 		public function getBagList(param1:int, param2:String,functionname:Function) : void
 	       {
            var _loc_3:PendingCall = null;
             
            _loc_3 = _amfService.getMyBagObjectListAMF(getSigOf(param2, param1,  skey), skey, param1, param2);
            _loc_3.responder = new Responder(functionname, error);
            return;
        }// end function
         public function decomposeFish(param1:uint,functionname:Function)
        {
            var _loc_2:PendingCall = null;
           
            _loc_2 = _amfService.decomposeFishAMF(getSigOf(param1,  skey),  skey, param1);
            _loc_2.responder = new Responder(functionname, error);
            return;
        }// end function
        
         public function getUserInformation(functionname:Function) : void
        {
            var _loc_1:PendingCall = null;
            
            _loc_1 = _amfService.getUserInfoAMF(getSigOf( skey), skey);
            _loc_1.responder = new Responder(functionname, error);
            return;
        }// end function
         public function getPubSeaInfo(functionname:Function)
        {
            var _loc_1:PendingCall = null;
             
            _loc_1 = _amfService.getPubSeaInfoAMF(getSigOf( skey), skey);
            _loc_1.responder = new Responder(functionname, error);
            return;
        }// end function
  		public function getMyFishTankObjectList(param1:uint, param2:uint,functionname:Function)
        {
            var _loc_3:PendingCall = null;
            _loc_3 = _amfService.getMyFishTankObjectListAMF(getSigOf(param2, param1,  skey),  skey, param1, param2);
            _loc_3.responder = new Responder(functionname, error);
            return;
        }// end function
        public function feedAMF(param1:uint, param2:uint, param3:uint,functionname:Function)
        {
            var _loc_4:PendingCall = null;
            _loc_4 = _amfService.feedAMF(getSigOf(param3, param2, param1,  skey), skey, param1, param2, param3);
            _loc_4.responder = new Responder(functionname, error);
            return;
        }// end function
        public function setMyFishTank(param1:uint, param2:String, param3:Boolean, param4:Boolean, param5:Number, param6:uint, param7:Boolean, param8:String,functionname:Function)
        {
            var _loc_9:PendingCall = null;
            _loc_9 = _amfService.setMyFishTankAMF(getSigOf(param8, param7, param6, param5, param4, param3, param2, param1, skey),skey, param1, param2, param3, param4, param5, param6, param7, param8);
            _loc_9.responder = new Responder(functionname, error);
            return;
        }// end function 
         public function moveObject(functionname:Function,param1:uint, param2:String, param3:Number = 0, param4:int = 0, param5:int = 0)
        {
            var _loc_6:PendingCall = null;
            _loc_6 = _amfService.moveObjectAMF(getSigOf(param5, param4, param3, param2, param1, skey), skey, param1, param2, param3, param4, param5);
            _loc_6.responder = new Responder(functionname, error);
            return;
        }// end function
        public function trollAMF(functionname:Function,param1:uint, param2:uint, param3:String = null)
        {
            var _loc_4:PendingCall = null;
            if (param3 == null)
            {
                _loc_4 = _amfService.trollAMF(getSigOf(param2, param1, skey), skey, param1, param2);
            }
            else
            {
                _loc_4 = _amfService.trollAMF(getSigOf(param3, param2, param1, skey),skey, param1, param2, param3);
            }
            _loc_4.responder =new Responder(functionname, error);
            return;
        }// end function
         public function trollAMFForOther(functionname:Function,skey_2:String,param1:uint, param2:uint, param3:String = null)
        {
            var _loc_4:PendingCall = null;
            if (param3 == null)
            {
                _loc_4 = _amfService.trollAMF(getSigOf(param2, param1, skey_2), skey_2, param1, param2);
            }
            else
            {
                _loc_4 = _amfService.trollAMF(getSigOf(param3, param2, param1, skey_2),skey_2, param1, param2, param3);
            }
            _loc_4.responder =new Responder(functionname, error);
            return;
        }// end function
         
 
	}
}