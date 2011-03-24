/**
 * Author: shinder
 * Date: 2011/3/21
 * Time: AM 1:12
 */
package lin.shinder.asphptalk {
public class TalkResponder {
    public var resultFunction:Function;
    public var faultFunction:Function;

    public function TalkResponder(resultFunc:Function, faultFunc:Function) {
        resultFunction = resultFunc;
        faultFunction = faultFunc;
    }
}
}
