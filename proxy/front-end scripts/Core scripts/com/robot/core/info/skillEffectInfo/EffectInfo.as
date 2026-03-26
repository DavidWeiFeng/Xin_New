package com.robot.core.info.skillEffectInfo
{
   import com.robot.core.config.xml.SkillXMLInfo;
   import flash.utils.Dictionary;
   
   public class EffectInfo extends AbstractEffectInfo
   {
      
      private var _msg:String;
      
      private var _param:String;
      
      private var _fightTypeDic:Dictionary = new Dictionary();
      
      public function EffectInfo(param1:int, param2:String, param3:String)
      {
         super();
         _argsNum = param1;
         this._msg = param2;
         this._param = param3;
         this._fightTypeDic["0"] = "物理攻击";
         this._fightTypeDic["1"] = "特殊攻击";
         this._fightTypeDic["2"] = "物理攻击和特殊攻击";
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:* = null;
         var _loc12_:int = 0;
         var _loc13_:Array = param1.slice();
         var _loc14_:String = this._msg;
         var _loc15_:int = 0;
         if(Boolean(this._param) && this._param.length > 0)
         {
            _loc2_ = this._param.split("|");
            _loc15_ = 0;
            while(_loc15_ < _loc2_.length)
            {
               if(Boolean(_loc3_ = String(_loc2_[_loc15_])) && _loc3_.length > 0)
               {
                  if(Boolean(_loc4_ = _loc3_.split(",")) && _loc4_.length > 0)
                  {
                     _loc5_ = String(_loc4_[0]);
                     _loc6_ = int(_loc4_[1]);
                     _loc7_ = String(_loc4_[2]);
                     _loc8_ = "";
                     if(_loc5_ == "0")
                     {
                        _loc9_ = _loc7_.split("-");
                        _loc10_ = param1.slice(_loc6_,int(_loc6_) + 7);
                        _loc8_ = getPropertyStr(_loc10_);
                        _loc13_[_loc6_] = _loc8_;
                     }
                     else if(_loc5_ == "14")
                     {
                        if(int(param1[int(_loc6_)]) >= 0)
                        {
                           _loc13_[_loc6_] = "+" + param1[int(_loc6_)];
                        }
                     }
                     else if(_loc5_ == "16")
                     {
                        _loc11_ = "";
                        _loc12_ = 0;
                        while(_loc12_ < 6)
                        {
                           if(int(param1[_loc6_ + _loc12_]) > 0)
                           {
                              if(_loc11_.length > 0)
                              {
                                 _loc11_ += "、";
                              }
                              _loc11_ += this.getCommParamStr(int(_loc5_),_loc12_);
                           }
                           _loc12_++;
                        }
                        _loc13_[_loc6_] = _loc8_ + _loc11_;
                     }
                     else if(_loc5_ != "19")
                     {
                        if(_loc5_ == "22")
                        {
                           _loc13_[_loc6_] = SkillXMLInfo.petTypeNameCN(param1[int(_loc6_)]);
                        }
                        else
                        {
                           _loc8_ = this.getCommParamStr(int(_loc5_),param1[int(_loc6_)]);
                           _loc13_[_loc6_] = _loc8_;
                        }
                     }
                  }
               }
               _loc15_++;
            }
         }
         if(Boolean(param1))
         {
            _loc15_ = 0;
            while(_loc15_ < param1.length)
            {
               _loc14_ = _loc14_.split("{" + _loc15_ + "}").join(_loc13_[_loc15_]);
               _loc15_++;
            }
         }
         return _loc14_;
      }
      
      private function getCommParamStr(param1:int, param2:int) : String
      {
         var _loc3_:String = "";
         var _loc4_:Array = EffectInfoManager.getEffectParamType(param1);
         return _loc3_ + _loc4_[param2];
      }
   }
}

