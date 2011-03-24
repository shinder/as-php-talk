/**
 * Author: shinder
 * Date: 2011/3/20
 * Time: PM 3:28
 */
package lin.shinder.asphptalk.utils {
import flash.display.DisplayObject;
import flash.net.LocalConnection;

public class HttpDomain {
    private var defaultProtocol:String = 'http';
    private var _protocol:String;
    private var _domain:String;
    private var displayObject:DisplayObject;

    public function HttpDomain(displayObject:DisplayObject=null) {
        this.displayObject = displayObject;
        getProtocolAndDomain();
    }

    private function getProtocolAndDomain():void {
        var url:String;

        if(! isDefaultProtocol) {
            url = displayObject.stage.loaderInfo.loaderURL;
            if(url.indexOf('http') == 0) {
                _protocol = url.slice(0, url.indexOf('://'));
                _domain = url.slice(url.indexOf('://')+3, url.indexOf("/", 10));
            }
        }

        if(! _domain) {
            _protocol = defaultProtocol;
            _domain = new LocalConnection().domain;
        }
    }

    public function get isDefaultProtocol():Boolean {
        return ! displayObject.stage;
    }

    public function get protocol():String {
        return _protocol;
    }

    /* including the port number */
    public function get domain():String {
        return _domain;
    }

    public function get protocolAndDomain():String {
        return _protocol + '://' + _domain;
    }
}
}
