package proj.net.lbstech.save_as.DTO;

import java.util.HashMap;

public class ImageContent {
    private final long index;
    private String mimeType;
    private String title;
    private String absolutePath;
    private String thumbnailPath;

    public ImageContent(long index, String mimeType, String title, String absolutePath, String thumbnailPath){
        this.index = index;
        this.mimeType = mimeType;
        this.title = title;
        this.absolutePath = absolutePath;
        this.thumbnailPath = thumbnailPath;
    }

    public HashMap<String, Object> toMap(){
        HashMap<String, Object> map = new HashMap<>();
        map.put("index", index);
        map.put("mimeType", mimeType);
        map.put("title", title);
        map.put("absolutePath", absolutePath);
        map.put("thumbnailPath", thumbnailPath);
        return map;
    }

    public void setThumbnailPath(String thumbnailPath) {
        this.thumbnailPath = thumbnailPath;
    }
}
