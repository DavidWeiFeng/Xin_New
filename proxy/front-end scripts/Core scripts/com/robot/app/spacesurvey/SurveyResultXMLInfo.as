package com.robot.app.spacesurvey
{
   public class SurveyResultXMLInfo
   {
      
      private static var xmllist:XMLList;
      
      private static var xmlClass:Class = SurveyResultXMLInfo_xmlClass;
      
      private static var xml:XML = XML(new xmlClass());
      
      public function SurveyResultXMLInfo()
      {
         super();
      }
      
      public static function parseInfo() : void
      {
         if(xmllist == null)
         {
            xmllist = xml.descendants("star");
         }
      }
      
      public static function getIconName(name:String) : String
      {
         var xml:XML = null;
         SurveyResultXMLInfo.parseInfo();
         for each(xml in xmllist)
         {
            if(String(xml.@name) == name)
            {
               return xml.@icon;
            }
         }
         return "";
      }
      
      public static function getIntrolInfo(name:String) : String
      {
         var xml:XML = null;
         SurveyResultXMLInfo.parseInfo();
         for each(xml in xmllist)
         {
            if(String(xml.@name) == name)
            {
               return xml.@introl;
            }
         }
         return "";
      }
      
      public static function getSpaceName(id:uint) : String
      {
         var xml:XML = null;
         SurveyResultXMLInfo.parseInfo();
         for each(xml in xmllist)
         {
            if(uint(xml.@id) == id)
            {
               return xml.@Name;
            }
         }
         return "";
      }
      
      public static function getSpaceID(name:String) : String
      {
         var xml:XML = null;
         SurveyResultXMLInfo.parseInfo();
         for each(xml in xmllist)
         {
            if(String(xml.@name) == name)
            {
               return String(xml.@id);
            }
         }
         return "";
      }
      
      public static function getPetsByID(id:uint) : String
      {
         var xml:XML = null;
         SurveyResultXMLInfo.parseInfo();
         for each(xml in xmllist)
         {
            if(uint(xml.@id) == id)
            {
               return xml.@pet;
            }
         }
         return "";
      }
      
      public static function getPetsByName(name:String) : String
      {
         var xml:XML = null;
         SurveyResultXMLInfo.parseInfo();
         for each(xml in xmllist)
         {
            if(String(xml.@name) == name)
            {
               return xml.@pet;
            }
         }
         return "";
      }
      
      public static function getEnergysByID(id:uint) : String
      {
         var xml:XML = null;
         SurveyResultXMLInfo.parseInfo();
         for each(xml in xmllist)
         {
            if(uint(xml.@id) == id)
            {
               return xml.@energy;
            }
         }
         return "";
      }
      
      public static function getEnergysByName(name:String) : String
      {
         var xml:XML = null;
         SurveyResultXMLInfo.parseInfo();
         for each(xml in xmllist)
         {
            if(String(xml.@name) == name)
            {
               return xml.@energy;
            }
         }
         return "";
      }
   }
}

