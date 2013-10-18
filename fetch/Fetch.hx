package fetch;
import tools.haxelib.*;
import tools.haxelib.Main;
import tools.haxelib.Data;
import fetch.Data;
import fetch.Etc.*;
import haxe.Serializer;
using sys.io.File;
using sys.FileSystem;
@:access(tools.haxelib)
class Fetch {
	var site:SiteProxy;
	function new() {
		initSite();
	}
	function initSite() {
		var siteUrl = "http://" + Main.SERVER.host + ":" + Main.SERVER.port + "/" + Main.SERVER.dir;
		var remotingUrl =  siteUrl + "api/" + Main.SERVER.apiVersion + "/" + Main.SERVER.url;
		site = new SiteProxy(haxe.remoting.HttpConnection.urlConnect(remotingUrl).api);
	}
	function fetch() {
		var projects:List<{ id : Int, name : String }> = site.search("");
		var i = 0;
		var infos:Array<ProjectInfos> = [for(p in projects) {
			if(i % 40 == 0)
				Sys.println('${Std.int((i / projects.length) * 100)}% fetched');
			i++;
			site.infos(p.name);
		}];
		var data:FetchData = {infos: infos};
		if(!TMP.exists())
			TMP.createDirectory();
		var dataString:String = Serializer.run(data);
		'$TMP/$FILE'.saveContent(dataString);
	}
	static function main() {
		var f = new Fetch();
		f.fetch();
	}
}