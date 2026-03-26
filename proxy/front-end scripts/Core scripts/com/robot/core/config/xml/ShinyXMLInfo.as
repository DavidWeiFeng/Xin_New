package com.robot.core.config.xml
{
   import com.robot.core.config.*;
   import org.taomee.ds.*;
   import org.taomee.utils.*;
   
   public class ShinyXMLInfo
   {
      
      private static var _dataMap:HashMap;
      
      private static var _path:String = "291";
      
      public function ShinyXMLInfo()
      {
         super();
      }
      
      public static function setup(callBack:Function) : void
      {
         var petNode:XML = null;
         var filterNode:XML = null;
         _dataMap = new HashMap();
         var onLoad:Function = function(_arg_1:XML):void
         {
            var petId:String = null;
            var filterMap:HashMap = null;
            var filterList:XMLList = null;
            var shinyId:String = null;
            var petList:XMLList = _arg_1.elements("Pet");
            for each(petNode in petList)
            {
               petId = petNode.@ID.toString();
               filterMap = new HashMap();
               filterList = petNode.elements("filter");
               for each(filterNode in filterList)
               {
                  shinyId = filterNode.@shinyId.toString();
                  filterMap.add(shinyId,filterNode);
               }
               _dataMap.add(petId,filterMap);
            }
            callBack();
            xmlLoader = null;
         };
         var xmlLoader:XmlLoader = new XmlLoader();
         xmlLoader.loadXML(_path,XmlConfig.getXmlVerByPath(_path),onLoad);
      }
      
      public static function getShinyArray(petId:uint, shinyId:uint) : Array
      {
         var shinyArray:Array = null;
         var args:String = null;
         var strArray:Array = null;
         var filterNode:XML = null;
         shinyArray = [0.8,0.1,0.1,0,50,0.1,0.8,0.1,0,50,0.1,0.1,0.8,0,50,0,0,0,1,0];
         var petMap:HashMap = _dataMap.getValue(petId.toString());
         if(Boolean(petMap))
         {
            filterNode = petMap.getValue(shinyId.toString());
            if(Boolean(filterNode))
            {
               try
               {
                  args = filterNode.@args;
                  strArray = args.split(",");
                  return strArray;
               }
               catch(e:Error)
               {
                  return shinyArray;
               }
            }
         }
         return shinyArray;
      }
      
      public static function getGlowArray(petId:uint, shinyId:uint) : Array
      {
         var glowArray:Array = null;
         var glow:String = null;
         var strArray:Array = null;
         var filterNode:XML = null;
         glowArray = [16761125,1,20,20,1.6];
         var petMap:HashMap = _dataMap.getValue(petId.toString());
         if(Boolean(petMap))
         {
            filterNode = petMap.getValue(shinyId.toString());
            if(Boolean(filterNode))
            {
               try
               {
                  glow = filterNode.@glow;
                  strArray = glow.split(",");
                  return strArray;
               }
               catch(e:Error)
               {
                  return glowArray;
               }
            }
         }
         return glowArray;
      }
   }
}

