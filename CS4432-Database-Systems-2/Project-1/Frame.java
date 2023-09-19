/**
 * @Author Alexander MacDonald
 * @Date 3/29/2023
 * @Class CS4432
 */
public class Frame {
    private String content;

    private boolean dirty;
    private boolean pinned;
    private int blockId;
    private long timestamp;

    public Frame() {
        dirty = false;
        pinned = false;
        blockId = -1;
        timestamp = System.currentTimeMillis();
    }

    public Frame(String content, int blockId) {
        dirty = false;
        pinned = false;
        this.blockId = blockId;
        this.content = content;
        timestamp = System.currentTimeMillis();
    }

    //Getters
    public int getBlockId() {
        return blockId;
    }

    public boolean getPin() {
        return pinned;
    }

    public boolean getDirty() {
        return dirty;
    }

    public long getTimestamp() {
        return timestamp;
    }

    public String getContent() {
        return content;
    }

    //Setters
    public void pin() {
        pinned = true;
    }

    public void unpin() {
        pinned = false;
    }

    public void dirty() {
        dirty = true;
    }

    public void clean() {
        dirty = false;
    }

    public void setBlockId(int n) {
        blockId = n;
    }

    public void setContent(String b) {
        content = b;
    }

    public void updateTimestamp() {
        timestamp = System.currentTimeMillis();
    }

}
