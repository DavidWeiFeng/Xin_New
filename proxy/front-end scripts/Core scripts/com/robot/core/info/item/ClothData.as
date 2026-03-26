package com.robot.core.info.item
{
   public class ClothData
   {
      
      private var xml:XML;
      
      public function ClothData(_arg_1:XML)
      {
         super();
         this.xml = _arg_1;
      }
      
      public function get price() : uint
      {
         return this.xml.@Price;
      }
      
      public function get type() : String
      {
         return this.xml.@type;
      }
      
      public function get id() : int
      {
         return int(this.xml.@ID);
      }
      
      public function get name() : String
      {
         return this.xml.@Name;
      }
      
      public function getUrl(_arg_1:uint = 0) : String
      {
         if(_arg_1 == 0 || _arg_1 == 1)
         {
            return XML(this.xml.parent()).@url + this.id.toString() + ".swf";
         }
         return XML(this.xml.parent()).@url + this.id.toString() + "_" + _arg_1 + ".swf";
      }
      
      public function getIconUrl(_arg_1:uint = 0) : String
      {
         return this.getUrl(_arg_1).replace(/swf\//,"icon/");
      }
      
      public function getPrevUrl(_arg_1:uint = 0) : String
      {
         return this.getUrl(_arg_1).replace(/swf\//,"prev/");
      }
      
      public function get actionDir() : int
      {
         if(String(this.xml.@actionDir) == "")
         {
            return -1;
         }
         return int(this.xml.@actionDir);
      }
      
      public function get repairPrice() : uint
      {
         return uint(this.xml.@RepairPrice);
      }
   }
}

