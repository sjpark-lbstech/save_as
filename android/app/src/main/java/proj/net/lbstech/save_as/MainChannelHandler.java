package proj.net.lbstech.save_as;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.TaskStackBuilder;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;

import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;
import androidx.exifinterface.media.ExifInterface;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Build;
import android.os.Environment;
import android.provider.MediaStore;

import io.flutter.Log;

import androidx.annotation.NonNull;

import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationServices;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import proj.net.lbstech.save_as.DTO.ImageContent;

public class MainChannelHandler implements MethodChannel.MethodCallHandler, EventChannel.StreamHandler {

    // application context
    private final Context context;
    private final Core core;
    private EventChannel.EventSink sink;

    MainChannelHandler(Context context){
        this.context = context;
        core = new Core();
    }

    @Override
    public void onMethodCall(MethodCall call,@NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "device":
                core.getDeviceInformation(result);
                break;
            case "location":
                core.getLocation(result);
                break;
            case "connection":
                core.getConnectionState(result);
                break;
            case "dir#tmp":
                core.getCachedDir(result);
                break;
            case "dir#public":
                core.getPublicDir(result);
                break;
            case "imageContent":
                core.getImageContents(result);
                break;
            case "modifyImage":
                if (call.hasArgument("ratioState") && call.hasArgument("fullRatio")) {
                    String tmbPath = call.argument("thumbnailPath");
                    String orgPath = call.argument("filePath");
                    @SuppressWarnings("ConstantConditions")
                    int ratioState = call.argument("ratioState");
                    @SuppressWarnings("ConstantConditions")
                    double fullRatio = call.argument("fullRatio");
                    core.modifyImage(result, tmbPath, orgPath, ratioState, fullRatio);
                }else {
                    Log.i("MAIN_CHANNEL", "인자 key 값 잘못 들어옴 : " + call.arguments.toString());
                    result.error("인자 key 값 잘못 들어옴", null, null);
                }
                break;
            case "show#noti" :
                String title = call.argument("title");
                String msg = call.argument("msg");
                core.showNotification(result, title, msg);
                break;
            case "rotateImage" :
                String srcPath = call.argument("src");
                String edgePath = call.argument("edge");
                String srcTargetPath = call.argument("srcRotated");
                String edgeTargetPath = call.argument("edgeRotated");
                core.rotateImage(result, srcPath, edgePath, srcTargetPath, edgeTargetPath);
                break;

        }
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        if (sink == null) sink = events;
    }

    @Override
    public void onCancel(Object arguments) {
        if (sink != null) sink = null;
    }

    void action(int value) {
        if (sink != null) sink.success(value);
    }

    boolean isEventChannelEnable(){ return sink != null; }

    // inner class
    private class Core{
        private FusedLocationProviderClient fusedLocationProvider;
        private FileInputStream fis;
        private FileOutputStream fos;

        Core(){
            fusedLocationProvider = LocationServices.getFusedLocationProviderClient(context);
        }

        /**
         * if (call.method.equals("device"))
         */
        void getDeviceInformation(MethodChannel.Result result){
            HashMap<String, Object> arg = new HashMap<>();
            arg.put("osType", "android");
            arg.put("version", Build.VERSION.SDK_INT);
            result.success(arg);
        }

        /**
         * if (call.method.equals("location"))
         */
        void getLocation(MethodChannel.Result result){
            fusedLocationProvider.getLastLocation().addOnSuccessListener(location -> {
                HashMap<String, Double> arg = new HashMap<>();
                if (location == null) {
                    Log.i("MAIN_CHANNEL", "위치 누락 : fusedALocation is null. 원인불명");
                    result.error("unknown error, location is null", null, null);
                    return;
                }
                arg.put("latitude", location.getLatitude());
                arg.put("longitude", location.getLongitude());
                result.success(arg);
            }).addOnFailureListener(exception -> {
                if (exception instanceof SecurityException){
                    Log.i("MAIN_CHANNEL", "권한 누락 : 위치권한");
                    result.error("permission error", exception.getMessage(), exception.getLocalizedMessage());
                }else {
                    result.error("unknown error", exception.getMessage(), exception.getLocalizedMessage());
                }
            });
        }

        /**
         * if (call.method.equals("connection"))
         */
        void getConnectionState(MethodChannel.Result result){
            ConnectivityManager cm = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
            NetworkInfo activeNetwork = cm.getActiveNetworkInfo();
            result.success(activeNetwork != null && activeNetwork.isConnected());
        }

        /**
         * if (call.method.equals("dir#tmp"))
         */
        void getCachedDir(MethodChannel.Result result){
            String path = context.getCacheDir().getPath();
            if (path == null){
                result.error("캐시파일 패스를 찾을 수 없습니다.", null, null);
            }
            result.success(path);
        }

        /**
         * if (call.method.equals("dir#public"))
         */
        void getPublicDir(MethodChannel.Result result){
            File file = context.getExternalFilesDir(Environment.DIRECTORY_DCIM);
            if (file != null) {
                result.success(file.getPath());
            }else {
                Log.i("MAIN_CHANNEL", "외부 저장소 없음");
                result.error("no external storage", "", "");
            }
        }

        /**
         * if (call.method.equals("imageContent"))
         */
        void getImageContents(MethodChannel.Result result){
            if (context.getExternalFilesDir(Environment.DIRECTORY_DCIM) != null) {
                Cursor imageCursor = context.getContentResolver()
                        .query(
                                MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                                null,
                                null,
                                null,
                                MediaStore.Images.Media._ID + " DESC");

                Cursor tmbCursor = context.getContentResolver().query(
                        MediaStore.Images.Thumbnails.EXTERNAL_CONTENT_URI,
                        null, null, null,
                        MediaStore.Images.Media._ID + " DESC");

                HashMap<Long, Integer> pkToPos = new HashMap<>();
                ImageContent[] contents;
                if (imageCursor != null) {
                    contents = new ImageContent[imageCursor.getCount()];
                    int pathColumn = imageCursor.getColumnIndex(MediaStore.MediaColumns.DATA);
                    int indexColumn = imageCursor.getColumnIndex(MediaStore.MediaColumns._ID);
                    int mimeColumn = imageCursor.getColumnIndex(MediaStore.MediaColumns.MIME_TYPE);
                    int titleColumn = imageCursor.getColumnIndex(MediaStore.MediaColumns.TITLE);

                    if (tmbCursor == null){ // 썸네일이 없는 경우
                        int pos = 0;
                        imageCursor.moveToFirst();
                        while(!imageCursor.isLast()){
                            contents[pos] = new ImageContent(
                                    imageCursor.getLong(indexColumn),
                                    imageCursor.getString(mimeColumn),
                                    imageCursor.getString(titleColumn),
                                    imageCursor.getString(pathColumn),
                                    null
                            );
                            imageCursor.moveToNext();
                            pos++;
                        }
                    }else { // 썸네일이 있는 경우
                        int pos = 0;
                        imageCursor.moveToFirst();
                        while(!imageCursor.isLast()){
                            long pk = imageCursor.getLong(indexColumn);
                            contents[pos] = new ImageContent(
                                    pk,
                                    imageCursor.getString(mimeColumn),
                                    imageCursor.getString(titleColumn),
                                    imageCursor.getString(pathColumn),
                                    null
                            );
                            imageCursor.moveToNext();
                            pkToPos.put(pk, pos);
                            pos++;
                        }

                        int tmbPathColumn = tmbCursor.getColumnIndex(MediaStore.MediaColumns.DATA);
                        int tmbIndexColumn = tmbCursor.getColumnIndex(MediaStore.Images.Thumbnails.IMAGE_ID);

                        tmbCursor.moveToFirst();
                        while (!tmbCursor.isLast()) {
                            String tmbPath = tmbCursor.getString(tmbPathColumn);
                            long tmbPk = tmbCursor.getLong(tmbIndexColumn);

                            if(pkToPos.containsKey(tmbPk)) {
                                @SuppressWarnings("ConstantConditions") int i = pkToPos.get(tmbPk);
                                contents[i].setThumbnailPath(tmbPath);
                            }
                            tmbCursor.moveToNext();
                        }
                        tmbCursor.close();
                    }
                    imageCursor.close();

                    ArrayList<HashMap> data = new ArrayList<>();
                    for (int i = 0; i < contents.length; i ++){
                        if (contents[i] != null) {
                            data.add(contents[i].toMap());
                        }
                    }
                    result.success(data);
                }else {
                    // image cursor 없는 경우
                    result.error("image cursor is null", null, null);
                }
            }else {
                // 외부 경로가 없는 경우
                Log.i("MAIN_CHANNEL", "외부 저장소 없음");
                result.error("no external storage", "", "");
            }
        }

        /**
         * if (call.method.equals("modifyImage"))
         */
        void modifyImage(MethodChannel.Result result, String tmbPath, String orgPath, int ratioState, double fullRatio){
            final int RATIO_3TO4 = 0XAAA1;
            final int RATIO_1TO1 = 0XAAA2;
            final int RATIO_FULL = 0XAAA3;
            Log.i("MAIN_CHANNEL", "현제 화면 비율 : " +
                    (ratioState == RATIO_3TO4 ? "3:4" : ratioState == RATIO_1TO1 ? "1:1" : "full"));
            File org = new File(orgPath);

            try {
                fis = new FileInputStream(org);
                Bitmap orgBitmap = BitmapFactory.decodeStream(fis);

                // 촬영된 사진의 exif 데이터에서 회전각 구하고 정방향으로 사진 회전
                int rotate = getPhotoOrientationDegree(orgPath);
                Matrix matrix = new Matrix();
                switch (rotate){
                    case 0 :
                        matrix.postRotate(0);
                        break;
                    case 90 :
                        matrix.postRotate(90);
                        break;
                    case 180 :
                        matrix.postRotate(180);
                        break;
                    case 270 :
                        matrix.postRotate(-90);
                        break;
                }
                orgBitmap = Bitmap.createBitmap(orgBitmap, 0,0, orgBitmap.getWidth(), orgBitmap.getHeight(), matrix, true);
                // 기본 너비, 높이
                int width = orgBitmap.getWidth();
                int height = orgBitmap.getHeight();
                int shorter;
                int longer;
                boolean isLandscape;
                if (width > height) {
                    shorter = height;
                    longer = width;
                    isLandscape = true;
                }else{
                    shorter = width;
                    longer = height;
                    isLandscape = false;
                }
                // 이미지 크롭
                switch (ratioState){
                    case RATIO_FULL :
                        if (isLandscape) orgBitmap = cropCenterBitmap(orgBitmap, longer, (int) (longer*fullRatio));
                        else orgBitmap = cropCenterBitmap(orgBitmap, (int) (longer*fullRatio), longer);
                        break;
                    case RATIO_1TO1 :
                        orgBitmap = cropCenterBitmap(orgBitmap, shorter, shorter);
                        break;
                    case RATIO_3TO4 :
                        if (isLandscape) orgBitmap = cropCenterBitmap(orgBitmap, (int) (shorter*1.25), shorter);
                        else orgBitmap = cropCenterBitmap(orgBitmap, shorter, (int) (shorter*1.25));
                        break;
                }
                byte[] originData = bitmapToByteArray(orgBitmap);
                fos = new FileOutputStream(org);
                fos.write(originData);
                fos.flush();
                fos.close();

                // 원본사진 줄여서 썸네일로 저장
                Bitmap tmbBitmap = resizeBitmap(orgBitmap, 500);
                byte[] tmbData = bitmapToByteArray(tmbBitmap);
                fos = new FileOutputStream(new File(tmbPath));
                fos.write(tmbData);
                fos.flush();
                fos.close();

                fis.close();

            } catch (FileNotFoundException e) {
                Log.i("MAIN_CHANNEL", "modifyImage : FileNotFoundException... 파일 패스 에러");
                result.error("modifyImage : FileNotFoundException... 파일 패스 에러", e.getMessage(), e.getLocalizedMessage());
            } catch (IOException e) {
                Log.i("MAIN_CHANNEL", "modifyImage : IOException... 입출력 에러");
                result.error("modifyImage : IOException... 입출력 에러", e.getMessage(), e.getLocalizedMessage());
            }

            result.success(null);
        }

        /**
         * if (call.method.equals("rotateImage"))
         */
        void rotateImage(MethodChannel.Result result, String srcPath, String edgePath, String srcTargetPath, String edgeTargetPath){
            double degree = -90.0;
            File srcFile = new File(srcPath);
            File srcRotatedFile = new File(srcTargetPath);

            File edgeFile = new File(edgePath);
            File edgeTargetFile = new File(edgeTargetPath);

            try {
                // 원본 회전 후 타겟에 write
                fis = new FileInputStream(srcFile);
                Bitmap srcBitmap = BitmapFactory.decodeStream(fis);
                Matrix matrix = new Matrix();
                matrix.postRotate((float) degree);
                srcBitmap = Bitmap.createBitmap(srcBitmap, 0, 0, srcBitmap.getWidth(), srcBitmap.getHeight(), matrix, true);
                fos = new FileOutputStream(srcRotatedFile);
                fos.write(bitmapToByteArray(srcBitmap));
                fos.flush();
                fos.close();
                fis.close();

                // 외곽선 사진 회전 후 타겟에 write
                fis = new FileInputStream(edgeFile);
                Bitmap edgeBitmap = BitmapFactory.decodeStream(fis);
                edgeBitmap = Bitmap.createBitmap(edgeBitmap, 0, 0, edgeBitmap.getWidth(), edgeBitmap.getHeight(), matrix, true);
                fos = new FileOutputStream(edgeTargetFile);
                edgeBitmap.compress(Bitmap.CompressFormat.PNG, 100, fos);
                fos.flush();
                fos.close();
                fis.close();

            } catch (FileNotFoundException e) {
                Log.i("MAIN_CHANNEL", "rotateImage : FileNotFoundException... 파일 패스 에러");
                result.error("modifyImage : FileNotFoundException... 파일 패스 에러", e.getMessage(), e.getLocalizedMessage());
            } catch (IOException e) {
                Log.i("MAIN_CHANNEL", "rotateImage : IOException... 입출력 에러");
                result.error("modifyImage : IOException... 입출력 에러", e.getMessage(), e.getLocalizedMessage());
            }

            result.success(true);
        }

        /**
         * if (call.method.equals("show#noti"))
         */
        void showNotification(MethodChannel.Result result, String title, String msg){
            Intent intent = new Intent(context, MainActivity.class);
            TaskStackBuilder stackBuilder = TaskStackBuilder.create(context);
            stackBuilder.addNextIntent(intent);
            PendingIntent pendingIntent
                    = stackBuilder.getPendingIntent(0, PendingIntent.FLAG_UPDATE_CURRENT);

            String CHANNEL_ID = "proj.net.lbstech.main_channel/noti";
            NotificationManagerCompat notificationManager = NotificationManagerCompat.from(context);

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
                NotificationChannel channel = new NotificationChannel(CHANNEL_ID, CHANNEL_ID,
                        NotificationManager.IMPORTANCE_DEFAULT);
                notificationManager.createNotificationChannel(channel);
            }
            NotificationCompat.Builder builder = new NotificationCompat.Builder(context, CHANNEL_ID);
            builder.setContentIntent(pendingIntent)
                    .setContentTitle(title)
                    .setContentText(msg)
                    .setSmallIcon(R.mipmap.ic_launcher)
                    .setAutoCancel(true);
            if(notificationManager.areNotificationsEnabled()){
                notificationManager.notify(9299, builder.build());
                result.success(null);
            }else {
                result.error("알람을 표시할 수 없습니다.", null, null);
            }
        }

        // ======================= inner methods. =========================

        private int getPhotoOrientationDegree(String filepath){
            int degree = 0;
            ExifInterface exif = null;
            try{
                exif = new ExifInterface(filepath);
            } catch (IOException e){
                Log.d("get Photo Orientation", "Error: "+e.getMessage());
            }

            if (exif != null){
                int orientation = exif.getAttributeInt(ExifInterface.TAG_ORIENTATION, -1);
                if (orientation != -1) {
                    switch(orientation) {
                        case ExifInterface.ORIENTATION_ROTATE_90:
                            degree = 90;
                            break;
                        case ExifInterface.ORIENTATION_ROTATE_180:
                            degree = 180;
                            break;
                        case ExifInterface.ORIENTATION_ROTATE_270:
                            degree = 270;
                            break;
                    }
                }
            }
            return degree;
        }

        private Bitmap cropCenterBitmap(Bitmap src, int w, int h) {
            if(src == null)
                return null;

            int width = src.getWidth();
            int height = src.getHeight();

            System.out.println("width : " + width + ", height : " + height + ", w : " + w + ", y : " + h);

            if(width < w && height < h)
                return src;

            int x = 0;
            int y = 0;

            if(width > w){
                x = (width - w) / 2;
            }
            if(height > h){
                y = (height - h) / 2;
            }

            int cw = w; // crop width
            int ch = h; // crop height

            if(w > width)
                cw = width;
            if(h > height)
                ch = height;

            return Bitmap.createBitmap(src, x, y, cw, ch);
        }

        private byte[] bitmapToByteArray( Bitmap bitmap ) {
            ByteArrayOutputStream stream = new ByteArrayOutputStream() ;
            bitmap.compress( Bitmap.CompressFormat.JPEG, 100, stream) ;
            return stream.toByteArray();
        }

        private Bitmap resizeBitmap(Bitmap src, int max) {
            if(src == null)
                return null;

            int width = src.getWidth();
            int height = src.getHeight();
            float rate = 0.0f;

            if (width > height) {
                rate = max / (float) width;
                height = (int) (height * rate);
                width = max;
            } else {
                rate = max / (float) height;
                width = (int) (width * rate);
                height = max;
            }

            return Bitmap.createScaledBitmap(src, width, height, true);
        }

    }
}
