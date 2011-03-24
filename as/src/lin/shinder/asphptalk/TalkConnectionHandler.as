/**
 * Author: shinder
 * Date: 2011/3/21
 * Time: AM 12:03
 */
package lin.shinder.asphptalk {
import com.adobe.serialization.json.JSON;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;

[Event(name="complete", type="flash.events.Event")]
[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]
[Event(name="ioError", type="flash.events.IOErrorEvent")]
[Event(name="progress", type="flash.events.ProgressEvent")]
[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
public class TalkConnectionHandler extends EventDispatcher {
    private var gateway:String;
    private var command:String;
    private var responder:TalkResponder;
    private var args:Array;
    private var loader:URLLoader;
    private var request:URLRequest;
    private var variables:URLVariables;

    public function TalkConnectionHandler() {
        loader = new URLLoader();
        loader.addEventListener(Event.COMPLETE, handler);
        loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handler);
        loader.addEventListener(IOErrorEvent.IO_ERROR, handler);
        loader.addEventListener(ProgressEvent.PROGRESS, handler);
        loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handler);
    }

    public function call(gateway:String, command:String, responder:TalkResponder, args:Array):TalkConnectionHandler {
        this.gateway = gateway;
        this.command = command;
        this.responder = responder;
        this.args = args;
        request = new URLRequest(gateway);
        request.method = URLRequestMethod.POST;

        variables = new URLVariables();
        variables.jsonTalk = command;
        variables.args = JSON.encode( args );
        request.data = variables;
        loader.load( request );

        return this;
    }

    private function handler(event:Event):void {

            switch( event.type ) {
                case Event.COMPLETE:
                        try {
                            responder.resultFunction( JSON.decode(loader.data) );
                        } catch (exception:*) {
                            trace (exception.toString());
                            trace ('Raw data:' + loader.data);
                        }
                    break;
                case IOErrorEvent.IO_ERROR:
                case SecurityErrorEvent.SECURITY_ERROR:
                        responder.faultFunction( event );
                    break;
            }
        dispatchEvent( event );
    }
}
}
