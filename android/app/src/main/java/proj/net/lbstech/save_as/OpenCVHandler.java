package proj.net.lbstech.save_as;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class OpenCVHandler implements MethodChannel.MethodCallHandler {

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        if (call.method.equals("getCanny")){
            String srcPath = call.argument("src");
            String edgePath = call.argument("edge");

            try{
                getCanny(srcPath, edgePath);
            }catch (Exception e){
                e.printStackTrace();
                result.error("openCV", "error whiling getCanny", false);
            }
            result.success(true);
        }
    }

    public native void getCanny(String srcPath, String edgePath);
}
