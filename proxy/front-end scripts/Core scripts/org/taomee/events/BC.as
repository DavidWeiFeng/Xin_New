package org.taomee.events
{
   public class BC
   {
      
      public function BC()
      {
         super();
      }
      
      public static function addEvent(_arg_1:*, _arg_2:*, _arg_3:String, _arg_4:Function, _arg_5:Boolean = false, _arg_6:int = 0, _arg_7:Boolean = false) : void
      {
         var _local_8:Object = null;
         var _local_9:Array = null;
         var _local_10:Boolean = false;
         var _local_11:uint = 0;
         _arg_2.addEventListener(_arg_3,_arg_4,_arg_5,_arg_6,_arg_7);
         if(!_arg_1.BC_List)
         {
            _arg_1.BC_List = new Object();
         }
         _local_8 = _arg_1.BC_List;
         if(!_local_8[_arg_3])
         {
            _local_8[_arg_3] = new Object();
         }
         if(_arg_5)
         {
            if(!_local_8[_arg_3].EventList1)
            {
               _local_8[_arg_3].EventList1 = new Array();
            }
            _local_9 = _local_8[_arg_3].EventList1;
         }
         else
         {
            if(!_local_8[_arg_3].EventList2)
            {
               _local_8[_arg_3].EventList2 = new Array();
            }
            _local_9 = _local_8[_arg_3].EventList2;
         }
         if(Boolean(_local_9.length))
         {
            _local_10 = true;
            _local_11 = 0;
            while(_local_11 < _local_9.length)
            {
               if(_local_9[_local_11].p == _arg_2 && _local_9[_local_11].e == _arg_3 && _local_9[_local_11].f == _arg_4 && _local_9[_local_11].u == _arg_5)
               {
                  _local_10 = false;
                  break;
               }
               _local_11++;
            }
            if(_local_10)
            {
               _local_9.push({
                  "a":_arg_1,
                  "p":_arg_2,
                  "e":_arg_3,
                  "f":_arg_4,
                  "u":_arg_5
               });
            }
         }
         else
         {
            _local_9.push({
               "a":_arg_1,
               "p":_arg_2,
               "e":_arg_3,
               "f":_arg_4,
               "u":_arg_5
            });
         }
      }
      
      public static function removeEvent(a:*, p:* = null, event:String = null, func:Function = null, useCapture:Boolean = false) : void
      {
         var j:* = undefined;
         var tempObj:Array = null;
         var myobj:Object = null;
         j = undefined;
         var i:* = undefined;
         j = undefined;
         tempObj = null;
         if(a.BC_List != null)
         {
            myobj = a.BC_List;
            if(p == null && event == null && func == null)
            {
               for(i in myobj)
               {
                  if(myobj[i]["EventList1"] != null)
                  {
                     tempObj = myobj[i]["EventList1"];
                     j = 0;
                     while(j < tempObj.length)
                     {
                        try
                        {
                           tempObj[j].p.removeEventListener(tempObj[j].e,tempObj[j].f,true);
                           tempObj.splice(j,1);
                           j--;
                        }
                        catch(E:Error)
                        {
                           tempObj.splice(j,1);
                           j--;
                        }
                        j++;
                     }
                  }
                  if(myobj[i]["EventList2"] != null)
                  {
                     tempObj = myobj[i]["EventList2"];
                     j = 0;
                     while(j < tempObj.length)
                     {
                        try
                        {
                           tempObj[j].p.removeEventListener(tempObj[j].e,tempObj[j].f,false);
                           tempObj.splice(j,1);
                           j--;
                        }
                        catch(E:Error)
                        {
                           tempObj.splice(j,1);
                           j--;
                        }
                        j++;
                     }
                  }
               }
            }
            else if(p == null && event == null && func != null)
            {
               if(useCapture)
               {
                  for(i in myobj)
                  {
                     if(myobj[i]["EventList1"] != null)
                     {
                        tempObj = myobj[i]["EventList1"];
                        j = 0;
                        while(j < tempObj.length)
                        {
                           if(func == tempObj[j].f)
                           {
                              try
                              {
                                 tempObj[j].p.removeEventListener(tempObj[j].e,tempObj[j].f,true);
                                 tempObj.splice(j,1);
                                 j--;
                              }
                              catch(E:Error)
                              {
                                 tempObj.splice(j,1);
                                 j--;
                              }
                           }
                           j++;
                        }
                     }
                  }
               }
               else
               {
                  for(i in myobj)
                  {
                     if(myobj[i]["EventList2"] != null)
                     {
                        tempObj = myobj[i]["EventList2"];
                        j = 0;
                        while(j < tempObj.length)
                        {
                           if(func == tempObj[j].f)
                           {
                              try
                              {
                                 tempObj[j].p.removeEventListener(tempObj[j].e,tempObj[j].f,false);
                                 tempObj.splice(j,1);
                                 j--;
                              }
                              catch(E:Error)
                              {
                                 tempObj.splice(j,1);
                                 j--;
                              }
                           }
                           j++;
                        }
                     }
                  }
               }
            }
            else if(p == null && event != null && func == null)
            {
               if(myobj[event] != null)
               {
                  if(myobj[event]["EventList1"] != null)
                  {
                     tempObj = myobj[event]["EventList1"];
                     j = 0;
                     while(j < tempObj.length)
                     {
                        if(event == tempObj[j].e)
                        {
                           try
                           {
                              tempObj[j].p.removeEventListener(tempObj[j].e,tempObj[j].f,true);
                              tempObj.splice(j,1);
                              j--;
                           }
                           catch(E:Error)
                           {
                              tempObj.splice(j,1);
                              j--;
                           }
                        }
                        j++;
                     }
                  }
                  if(myobj[event]["EventList2"] != null)
                  {
                     tempObj = myobj[event]["EventList2"];
                     j = 0;
                     while(j < tempObj.length)
                     {
                        if(event == tempObj[j].e)
                        {
                           try
                           {
                              tempObj[j].p.removeEventListener(tempObj[j].e,tempObj[j].f,false);
                              tempObj.splice(j,1);
                              j--;
                           }
                           catch(E:Error)
                           {
                              tempObj.splice(j,1);
                              j--;
                           }
                        }
                        j++;
                     }
                  }
               }
            }
            else if(p != null && event == null && func == null)
            {
               for(i in myobj)
               {
                  if(myobj[i]["EventList1"] != null)
                  {
                     tempObj = myobj[i]["EventList1"];
                     j = 0;
                     while(j < tempObj.length)
                     {
                        if(p == tempObj[j].p)
                        {
                           try
                           {
                              tempObj[j].p.removeEventListener(tempObj[j].e,tempObj[j].f,true);
                              tempObj.splice(j,1);
                              j--;
                           }
                           catch(E:Error)
                           {
                              tempObj.splice(j,1);
                              j--;
                           }
                        }
                        j++;
                     }
                  }
                  if(myobj[i]["EventList2"] != null)
                  {
                     tempObj = myobj[i]["EventList2"];
                     j = 0;
                     while(j < tempObj.length)
                     {
                        if(p == tempObj[j].p)
                        {
                           try
                           {
                              tempObj[j].p.removeEventListener(tempObj[j].e,tempObj[j].f,false);
                              tempObj.splice(j,1);
                              j--;
                           }
                           catch(E:Error)
                           {
                              tempObj.splice(j,1);
                              j--;
                           }
                        }
                        j++;
                     }
                  }
               }
            }
            else if(p == null && event != null && func != null)
            {
               if(myobj[event] != null)
               {
                  if(useCapture)
                  {
                     if(myobj[event]["EventList1"] != null)
                     {
                        tempObj = myobj[event]["EventList1"];
                        j = 0;
                        while(j < tempObj.length)
                        {
                           if(func == tempObj[j].f && event == tempObj[j].e)
                           {
                              try
                              {
                                 tempObj[j].p.removeEventListener(tempObj[j].e,tempObj[j].f,true);
                                 tempObj.splice(j,1);
                                 j--;
                              }
                              catch(E:Error)
                              {
                                 tempObj.splice(j,1);
                                 j--;
                              }
                           }
                           j++;
                        }
                     }
                  }
                  else if(myobj[event]["EventList2"] != null)
                  {
                     tempObj = myobj[event]["EventList2"];
                     j = 0;
                     while(j < tempObj.length)
                     {
                        if(func == tempObj[j].f && event == tempObj[j].e)
                        {
                           try
                           {
                              tempObj[j].p.removeEventListener(tempObj[j].e,tempObj[j].f,false);
                              tempObj.splice(j,1);
                              j--;
                           }
                           catch(E:Error)
                           {
                              tempObj.splice(j,1);
                              j--;
                           }
                        }
                        j++;
                     }
                  }
               }
            }
            else if(p != null && event != null && func == null)
            {
               if(myobj[event] != null)
               {
                  if(myobj[event]["EventList1"] != null)
                  {
                     tempObj = myobj[event]["EventList1"];
                     j = 0;
                     while(j < tempObj.length)
                     {
                        if(p == tempObj[j].p && event == tempObj[j].e)
                        {
                           try
                           {
                              tempObj[j].p.removeEventListener(tempObj[j].e,tempObj[j].f,true);
                              tempObj.splice(j,1);
                              j--;
                           }
                           catch(E:Error)
                           {
                              tempObj.splice(j,1);
                              j--;
                           }
                        }
                        j++;
                     }
                  }
                  if(myobj[event]["EventList2"] != null)
                  {
                     tempObj = myobj[event]["EventList2"];
                     j = 0;
                     while(j < tempObj.length)
                     {
                        if(p == tempObj[j].p && event == tempObj[j].e)
                        {
                           try
                           {
                              tempObj[j].p.removeEventListener(tempObj[j].e,tempObj[j].f,false);
                              tempObj.splice(j,1);
                              j--;
                           }
                           catch(E:Error)
                           {
                              tempObj.splice(j,1);
                              j--;
                           }
                        }
                        j++;
                     }
                  }
               }
            }
            else if(p != null && event == null && func != null)
            {
               if(useCapture)
               {
                  for(i in myobj)
                  {
                     if(myobj[i]["EventList1"] != null)
                     {
                        tempObj = myobj[i]["EventList1"];
                        j = 0;
                        while(j < tempObj.length)
                        {
                           if(func == tempObj[j].f && p == tempObj[j].p)
                           {
                              try
                              {
                                 tempObj[j].p.removeEventListener(tempObj[j].e,tempObj[j].f,true);
                                 tempObj.splice(j,1);
                                 j--;
                              }
                              catch(E:Error)
                              {
                                 tempObj.splice(j,1);
                                 j--;
                              }
                           }
                           j++;
                        }
                     }
                  }
               }
               else
               {
                  for(i in myobj)
                  {
                     if(myobj[i]["EventList2"] != null)
                     {
                        tempObj = myobj[i]["EventList2"];
                        j = 0;
                        while(j < tempObj.length)
                        {
                           if(func == tempObj[j].f && p == tempObj[j].p)
                           {
                              try
                              {
                                 tempObj[j].p.removeEventListener(tempObj[j].e,tempObj[j].f,false);
                                 tempObj.splice(j,1);
                                 j--;
                              }
                              catch(E:Error)
                              {
                                 tempObj.splice(j,1);
                                 j--;
                              }
                           }
                           j++;
                        }
                     }
                  }
               }
            }
            else if(p != null && event != null && func != null)
            {
               if(myobj[event] != null)
               {
                  if(useCapture)
                  {
                     if(myobj[event]["EventList1"] != null)
                     {
                        tempObj = myobj[event]["EventList1"];
                        j = 0;
                        while(true)
                        {
                           if(j < tempObj.length)
                           {
                              if(!(func == tempObj[j].f && p == tempObj[j].p))
                              {
                                 continue;
                              }
                              try
                              {
                                 p.removeEventListener(event,func,useCapture);
                                 tempObj.splice(j,1);
                                 j--;
                              }
                              catch(E:Error)
                              {
                                 tempObj.splice(j,1);
                                 j--;
                              }
                           }
                           j++;
                        }
                     }
                  }
                  else if(myobj[event]["EventList2"] != null)
                  {
                     tempObj = myobj[event]["EventList2"];
                     j = 0;
                     while(j < tempObj.length)
                     {
                        if(func == tempObj[j].f && p == tempObj[j].p)
                        {
                           try
                           {
                              p.removeEventListener(event,func,useCapture);
                              tempObj.splice(j,1);
                              j--;
                           }
                           catch(E:Error)
                           {
                              tempObj.splice(j,1);
                              j--;
                              return;
                           }
                           return;
                        }
                        j++;
                     }
                  }
               }
            }
         }
      }
   }
}

