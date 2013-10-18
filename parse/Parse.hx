package parse;
import sys.io.*;
import haxe.io.*;
import fetch.Data;
import fetch.Etc.*;
import haxe.Utf8;
using sys.io.File;
using StringTools;
class Parse {
	static inline var NEWLINE = "\n".code;
	static inline var ESC_NEWLINE = "\\n";
	static inline var TAB = "\t".code;
	static inline var TYPE = "A";
	var libs:fetch.Data.FetchData;
	var out:StringBuf;
	function new() {
		this.libs = haxe.Unserializer.run('$TMP/$FILE'.getContent());
	}
	/*
		Should be done in this format:
			$title\t$type\t\t\t$categories\t\t$see_also\t\t$external_links\t\t$images\t$abstract\t$source_url\n
	*/
	function parse() {
		out = new StringBuf();
		for(l in libs.infos) {
			out.add(l.name);
			out.addChar(TAB);
			out.add(TYPE);
			out.addChar(TAB);
			out.addChar(TAB);
			out.addChar(TAB);
			while(!l.tags.isEmpty()) {
				var tag = l.tags.pop();
				out.add(tag);
				if(!l.tags.isEmpty())
					out.add(ESC_NEWLINE);
			}
			out.addChar(TAB);
			out.addChar(TAB);
			out.addChar(TAB);
			out.addChar(TAB);
			out.addChar(TAB);
			out.addChar(TAB);
			out.addChar(TAB);
			out.add("<div>");
			out.add(l.desc);
			if(l.website != null) {
				out.add(" - <a href=\"");
				out.add(l.website.htmlEscape(true));
				out.add("\">Official Website</a>");
			}
			out.add("</div>");
			out.add("<pre>");
			out.add('$ haxelib install ${l.name.htmlEscape()}');
			out.add("</pre>");
			out.addChar(TAB);
			out.add('http://lib.haxe.org/p/${l.name.urlEncode()}');
			out.addChar(NEWLINE);
		}
		OUTPUT.saveContent(Utf8.encode(out.toString()));
	}
	static function main() {
		new Parse().parse();
	}
}