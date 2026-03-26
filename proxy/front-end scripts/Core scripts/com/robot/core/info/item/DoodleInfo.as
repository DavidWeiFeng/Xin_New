package com.robot.core.info.item
{
   import com.robot.core.config.xml.DoodleXMLInfo;
   import flash.utils.IDataInput;
   
   public class DoodleInfo
   {
      
      public var userID:uint;
      
      public var id:uint;
      
      public var color:uint;
      
      public var texture:uint;
      
      public var URL:String;
      
      public var preURL:String;
      
      public var price:uint;
      
      public var coins:uint;
      
      public function DoodleInfo(_arg_1:IDataInput = null)
      {
         super();
         if(Boolean(_arg_1))
         {
            this.userID = _arg_1.readUnsignedInt();
            this.color = _arg_1.readUnsignedInt();
            this.texture = _arg_1.readUnsignedInt();
            this.coins = _arg_1.readUnsignedInt();
            this.URL = DoodleXMLInfo.getSwfURL(this.texture);
            this.preURL = DoodleXMLInfo.getPrevURL(this.texture);
         }
      }
   }
}

