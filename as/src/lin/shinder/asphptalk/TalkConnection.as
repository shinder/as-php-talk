/**
 * User: shinder
 * Date: 2011/3/20
 * Time: AM 2:04
 */
package lin.shinder.asphptalk {
import flash.display.DisplayObject;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.utils.Dictionary;
import lin.shinder.asphptalk.utils.HttpDomain;

public class TalkConnection {
    private static var instances:Dictionary;

    private var instanceId:String;
    private var protocolAndDomain:String;
    // private var urlLoader:URLLoader;
    private var _gatewayFullPath:String;

    public function TalkConnection(displayObject:DisplayObject=null, instanceId:String='main') {
        this.instanceId = instanceId;
        this.protocolAndDomain = new HttpDomain(displayObject).protocolAndDomain;
    }

    public function connect(gatewayPath:String, protocolAndDomain:String=null):void {
        var urlLoader:URLLoader;

        if(! instances ) {
            instances = new Dictionary();
            instances[instanceId] = this;
        }
        if(protocolAndDomain) {
            this.protocolAndDomain = protocolAndDomain;
        } else {
            protocolAndDomain = this.protocolAndDomain;
        }
        if(gatewayPath.charAt(0) != '/') {
            gatewayPath = '/' + gatewayPath;
        }
        _gatewayFullPath = protocolAndDomain + gatewayPath;
        urlLoader = new URLLoader();
        urlLoader.addEventListener(IOErrorEvent.IO_ERROR, whenIOError);
        urlLoader.load(new URLRequest(_gatewayFullPath));
    }

    private function whenIOError(event:IOErrorEvent):void {
        throw new Error('Can not connect to the AS-PHP-Talk gateway!');
    }

    public function call(command:String, responder:TalkResponder, ...args):TalkConnectionHandler {

        return new TalkConnectionHandler().call(gatewayFullPath, command, responder, args);
    }
    /**
     * TODO
     *      public function post
     *      public function upload
     *
     *
     * */

    public function get gatewayFullPath():String {
         return _gatewayFullPath;
    }

    public static function getInstanceByName(instanceId:String='main'):TalkConnection {
         return instances[instanceId];
    }
}
}
