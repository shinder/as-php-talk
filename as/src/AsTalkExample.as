/**
 * Author: shinder
 * Date: 2011/3/24
 * Time: PM 5:05
 */
package {
import com.adobe.serialization.json.JSON;

import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextField;

import lin.shinder.asphptalk.TalkConnection;
import lin.shinder.asphptalk.TalkResponder;

public class AsTalkExample extends Sprite {
    public var info_txt:TextField;

    public function AsTalkExample() {
        init();
    }

    private function init():void {
        info_txt = new TextField();
        this.addChild(info_txt);
        info_txt.multiline = true;
        info_txt.width = stage.stageWidth;
        info_txt.height = stage.stageHeight;

        var tc:TalkConnection = new TalkConnection(this);
        var responder:TalkResponder = new TalkResponder(onResult, onFault);

        tc.connect('/talkserver/exampleServer1.php');
        /* Automatically getting the protocol name and the domain name */
        info_txt.appendText('Gateway: '+ tc.gatewayFullPath + '\n');

        tc.call('examples.ExampleClass2.exampleHello2', responder, "Shinder Lin");

    }
    private function onFault(event:Event):void {
        info_txt.appendText( event.toString() + '\n');
    }

    private function onResult(result:*):void {
        info_txt.appendText( result.toString() + '\n');
    }
}
}
