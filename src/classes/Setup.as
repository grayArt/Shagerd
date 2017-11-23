package classes
{
	import appManager.displayContentElemets.TitleText;
	
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	public class Setup extends EventDispatcher
	{
		private static var ManagerEventNameClass:String;
		private static var projectAddress:String;
		private static var createVar:String='';
		private static var addData:String='';
		public function Setup(target:IEventDispatcher=null)
		{
			super(target);
		}
		public static function load(ProjectAddress_p:String):void
		{
			//reade Manager for get name var
			projectAddress = ProjectAddress_p;
			var managerPath:File = File.applicationDirectory.resolvePath(projectAddress+'/project/src/mainClass/core/'+'Manager.as')
			var managerByte:ByteArray = FileManager.loadFile(managerPath);
				managerByte.position = 0;
			var managerString:String = managerByte.readUTFBytes(managerByte.length);
			
			//get Manager events Name classs
			ManagerEventNameClass = managerString.split(' ').join('');
			ManagerEventNameClass = ManagerEventNameClass.split('dispatchEvent(new')[1];
			ManagerEventNameClass = ManagerEventNameClass.split('(')[0];		
		}
		
		/**service page ui:
		 * 1-one dynamic links
		 * 2-linkItem
		 * 3-show in man Class*/
		public static function serviceFormat(ServiceName_p:String,Foramt_p:int):void
		{
			var serviceUiString:String;
			var serviceNameLowerCase:String = ServiceName_p.toLowerCase();
			var claseName:String = ServiceName_p+'Ui';
			
			//load base service page ui
			var fileTextName:String;
			if(Foramt_p==1)
			{
				fileTextName = 'ServiceUi';
			}
			else if(Foramt_p==3)
			{
				fileTextName = 'ServiceFormat3Ui';
				
				
			}

			serviceUiString = getBaseClassText('Data/'+fileTextName+'.text');
			
			serviceUiString = serviceUiString.split('className').join(claseName);
			serviceUiString = serviceUiString.split('serviceName').join('service_'+serviceNameLowerCase);
			serviceUiString = serviceUiString.split('serviceClass').join(ServiceName_p);
			serviceUiString = serviceUiString.split('ManagerEventNameClass').join(ManagerEventNameClass);
			
			if(Foramt_p==3)
			{
				serviceUiString = replaceData(ServiceName_p,serviceUiString);		
			}
			var serviceWriteBytes:ByteArray =new ByteArray();;
			serviceWriteBytes.position = 0;
			serviceWriteBytes.writeUTFBytes(serviceUiString);
			var serviceUiWriteBytesPath:File = File.applicationDirectory.resolvePath(projectAddress+'/project/src/ui/pages/'+claseName+'.as'); 
			FileManager.seveFile(serviceUiWriteBytesPath,serviceWriteBytes);
			//trace('serviseUiString :',serviceUiString);
			if(Foramt_p == 1)
			{
				createLinkItem(ServiceName_p);
			}
		}
		
		private static function getBaseClassText(address_p:String):String
		{
			var serviceUiPath:File = File.applicationDirectory.resolvePath(address_p); 
			var serviceUiByte:ByteArray = FileManager.loadFile(serviceUiPath);
			serviceUiByte.position = 0 ;
			return serviceUiByte.readUTFBytes(serviceUiByte.length);
		}
		
		private static function createLinkItem(ServiceName_p:String):void
		{
			//load base linkItem clase
			var linkItemUiString:String = getBaseClassText('Data/LinkItemClaseCrateName.text');

			
		
			
			linkItemUiString = replaceData(ServiceName_p,linkItemUiString);
			
			
			var linkItemWriteBytes:ByteArray =new ByteArray();;
			linkItemWriteBytes.position = 0;
			linkItemWriteBytes.writeUTFBytes(linkItemUiString);
			var serviceUiWriteBytesPath:File = File.applicationDirectory.resolvePath(projectAddress+'/project/src/ui/linkItem/'+ServiceName_p+'LinkItem'+'.as'); 
			FileManager.seveFile(serviceUiWriteBytesPath,linkItemWriteBytes);

			//trace('linkItemUiString :',linkItemUiString);

			
	
		}
		private static function replaceData(ServiceName_p:String,claseUiString_p:String):String
		{
			var linkItemClaeName:String = ServiceName_p+'RespondResultModel';
			
			var linkItemPath:File = File.applicationDirectory.resolvePath(projectAddress+'/project/src/mainClass/webservice/type/'+linkItemClaeName+'.as');
			if(!linkItemPath.exists)
			{
				linkItemClaeName = ServiceName_p+'Respond';
				linkItemPath = File.applicationDirectory.resolvePath(projectAddress+'/project/src/mainClass/webservice/type/'+linkItemClaeName+'.as');
			}
			
			var linkItemUiByte:ByteArray = FileManager.loadFile(linkItemPath);
			linkItemUiByte.position = 0;
			var serviceResult:String = linkItemUiByte.readUTFBytes(linkItemUiByte.length);


			var splitVaraibaleIndex:int = serviceResult.indexOf('{');
			serviceResult = serviceResult.substr(splitVaraibaleIndex+1,serviceResult.length);
			
			splitVaraibaleIndex = serviceResult.indexOf('{');
			serviceResult = serviceResult.substr(splitVaraibaleIndex+1,serviceResult.length);
			
			
			splitVaraibaleIndex = serviceResult.indexOf('public function');
			serviceResult = serviceResult.substr(0,splitVaraibaleIndex);

			
			
			var linkItemStringGetVar:String = serviceResult.split('public').join('private');
			linkItemStringGetVar = linkItemStringGetVar.split(':String').join(':TitleText');
			linkItemStringGetVar = linkItemStringGetVar.split(':Number').join(':TitleText');
			linkItemStringGetVar = linkItemStringGetVar.split(':Date').join(':TitleText');
			linkItemStringGetVar = linkItemStringGetVar.split(':int').join(':TitleText');
			linkItemStringGetVar = linkItemStringGetVar.split(':uint').join(':TitleText');
			linkItemStringGetVar = linkItemStringGetVar.split(':Boolean').join(':MovieClip');
			
			
			claseUiString_p = claseUiString_p.split('//addVariable').join(linkItemStringGetVar);
			
			splitVar(serviceResult);
			
			claseUiString_p = claseUiString_p.split('LinkItemClaseCrateName').join(ServiceName_p+'LinkItem');
			claseUiString_p = claseUiString_p.split('classeModelName').join(linkItemClaeName);

			
			claseUiString_p = claseUiString_p.split('//importData').join('import mainClass.webservice.type.'+linkItemClaeName);
			claseUiString_p = claseUiString_p.split('//addObj').join(createVar);
			claseUiString_p = claseUiString_p.split('//addData').join(addData);
			return claseUiString_p;
			
		}
		private static function splitVar(codStr_p:String,cont_p:int=0):void
		{
			var startIndex:int = codStr_p.indexOf('var '); 
			var endIndex:int;
			var indTypeIndex:int;
			if(startIndex>-1)
			{
				codStr_p = codStr_p.substring(startIndex+4,codStr_p.length);
				endIndex = codStr_p.indexOf(':');
				indTypeIndex = codStr_p.indexOf(';');
				var type:String = codStr_p.substring(endIndex+1,indTypeIndex).split(' ').join('');
				var getVar:String = codStr_p.substring(0,endIndex);
				createVar += "\t\t\t"+getVar+" = Obj.get('"+getVar+"_mc'"+",this);\n"
				if(type !='Date' && type !='Boolean')
				{
					
					if(type =='Number')
					{
						addData += "\n\t\t\tif("+getVar+"!=null)\n\t\t\t{\n\t\t\t\t"+getVar+".setUp(data."+getVar+".toString());\n\t\t\t}";
					}
					else
					{
						addData += "\n\t\t\tif("+getVar+"!=null)\n\t\t\t{\n\t\t\t\t"+getVar+".setUp(data."+getVar+");\n\t\t\t}";
					}
				}
				if(type =='Date')
				{
					var myshamsiString:String = 'var _shamsiDate_'+cont_p+':MyShamsi = MyShamsi.miladiToShamsi(data.'+getVar+');';
					addData += "\n\t\t\tif("+getVar+"!=null)\n\t\t\t{\n\t\t\t\t"+myshamsiString+"\n\t\t\t\t"+getVar+".setUp(_shamsiDate_"+cont_p+".showStringFormat(false,false),false);\n\t\t\t}";
				}
				if(type =='Boolean')
				{
					addData += "\n\t\t\tif("+getVar+"!=null)\n\t\t\t{\n\t\t\t\t//"+getVar+"\n\t\t\t}";
				}
				if(codStr_p.length>0)
				{
					splitVar(codStr_p.substring(endIndex+1,codStr_p.length),cont_p+1);
				}	
			}
		}
			
	}
}