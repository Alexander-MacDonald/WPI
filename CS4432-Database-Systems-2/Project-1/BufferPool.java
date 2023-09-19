/**
 * @Author Alexander MacDonald
 * @Date 3/29/2023
 * @Class CS4432
 */
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

public class BufferPool {
    private Frame[] buffers;
    //Initialize Function
    //Creates buffer with n frames
    public BufferPool(int n) {
        //init frames
        buffers = new Frame[n];
        //fill with new empty frames
        for(int i = 0; i < buffers.length; i++) {
            buffers[i] = new Frame();
        }
        //confirmation
        System.out.println("OUTPUT: Initialized Buffer Pool Size: " + n);
    }

    /*  GET
        Case 1: Block in Buffers
        Case 2: Block not in Buffers; Buffers has empty Frame
        Case 3: Block not in Buffers; No empty Frames; Frames can be emptied
        Case 4: Block not in Buffers; No empty Frames; No Frames can be emptied
     */
    public void get(int n) {
        //indices of existing, empty, or removed frames in buffer
        int exists;
        int empty;
        int removed;

        int file = getFile(n);
        if(file == -1) {
            System.out.println("OUTPUT: Error: Invalid Record Number");
            return;
        }
        //Case 1
        if((exists = existsInBuffer(file)) != -1) {
            System.out.println("OUTPUT: The corresponding block #" + file + " already exist in frame #" + (exists+1));
            printRecord(n, buffers[exists]);
            return;
        }
        //Case 2
        if((empty = emptyFrame()) != -1) {
            addToBuffer(file, empty);
            printRecord(n, buffers[empty]);
            return;
        }
        //Case 3
        if((removed = removeFrame()) != -1) {
            addToBuffer(file, removed);
            printRecord(n, buffers[removed]);
            return;
        }
        //Case 4
        System.out.println("OUTPUT: The corresponding block #" + file + " cannot be accessed from disk because the memory buffers are full; Read was unsuccessful");

    }

    /*  SET
        Case 1: Block in Memory
        Case 2: Block not in memory & Buffer has empty frame
        Case 3: Block not in memory & Buffer can remove frames
        Case 4: Block not in memory & Buffer cannot remove frames
     */
    public void set(int n, String content) {
        //indices of existing, empty, or removed frames in buffer
        int exists;
        int empty;
        int removed;

        int file = getFile(n);
        if(file == -1) {
            System.out.println("OUTPUT: Error: Invalid Record Number");
            return;
        }
        //Case 1
        if((exists = existsInBuffer(file)) != -1) {
            System.out.println("OUTPUT: The corresponding block #" + file + " already exist in frame #" + (exists + 1));
            setRecord(n, buffers[exists], content);
            return;
        }
        //Case 2
        if((empty = emptyFrame()) != -1) {
            addToBuffer(file, empty);
            setRecord(n, buffers[empty], content);
            return;
        }
        //Case 3
        if((removed = removeFrame()) != -1) {
            addToBuffer(file, removed);
            setRecord(n, buffers[removed], content);
            return;
        }
        //Case 4
        System.out.println("OUTPUT: The corresponding block #" + file + " cannot be accessed from disk because the memory buffers are full; Write was unsuccessful");
    }

    /* PIN
        Case 1: Block in Memory and Pinned is true
        Case 2: Block in Memory and Pinned is false
        Case 3: Block not in Memory and buffer has empty slot
        Case 4: Block not in Memory and buffer can remove slot
        Case 5: Block not in Memory and buffer cannot remove any slots
     */
    public void pin(int fileNum) {
        //indices of existing, empty, or removed frames in buffer
        int exists;
        int empty;
        int removed;

        if(fileNum > 7 || fileNum < 1) {
            System.out.println("OUTPUT: Error: Invalid Record Number");
            return;
        }
        if((exists = existsInBuffer(fileNum)) != -1) {
            if(!buffers[exists].getPin()) {
                //Case 2
                System.out.println("OUTPUT: File " + fileNum + " pinned in Frame #" + (exists+1) + "; Not already pinned");
                buffers[exists].pin();
                //referenced in memory, update timestamp
                buffers[exists].updateTimestamp();
                return;
            }
            //Case 1
            //referenced in memory, update timestamp
            buffers[exists].updateTimestamp();
            System.out.println("OUTPUT: File " + fileNum + " pinned in Frame #" + (exists+1) + "; Already pinned");
            return;
        }
        //Case 3
        if((empty = emptyFrame()) != -1) {
            addToBuffer(fileNum, empty);
            buffers[empty].pin();
            return;
        }
        //Case 4
        if((removed = removeFrame()) != -1) {
            addToBuffer(fileNum, removed);
            buffers[removed].pin();
            return;
        }
        //Case 5
        System.out.println("OUTPUT: The corresponding block #" + fileNum + " cannot be accessed from disk because the memory buffers are full; Pin was unsuccessful");
    }

    /*  UNPIN
        Case 1: Block in memory, pinned is true
        Case 2: Block in memory, pinned is false
        Case 3: Block not in memory
     */
    public void unpin(int fileNum) {
        //indices of existing frame in buffer
        int exists;

        if(fileNum > 7 || fileNum < 1) {
            System.out.println("OUTPUT: Error: Invalid Record Number");
            return;
        }
        if((exists = existsInBuffer(fileNum)) != -1) {
            if(!buffers[exists].getPin()) {
                //Case 2
                System.out.println("OUTPUT: File " + fileNum + " unpinned in Frame #" + (exists+1) + "; Already unpinned");
                //referenced in memory, update timestamp
                buffers[exists].updateTimestamp();
                return;
            }
            //Case 1
            System.out.println("OUTPUT: File " + fileNum + " unpinned in Frame #" + (exists+1) + "; Not already unpinned");
            buffers[exists].unpin();
            buffers[exists].updateTimestamp();
            return;
        }
        System.out.println("OUTPUT: The corresponding block " + fileNum + " cannot be unpinned because it is not in memory");
    }

    //Returns index of a frame in buffer pool loaded with an existing block
    private int existsInBuffer(int file) {
        //if the block is in the buffer
        for(int i = 0; i < buffers.length; i++) {
            if(buffers[i].getBlockId() == file) {
                return i;
            }
        }
        return -1;
    }

    //Returns index of a frame in buffer pool that is empty
    private int emptyFrame() {
        //if a frame in the buffer is empty
        for(int i = 0; i < buffers.length; i++) {
            if(buffers[i].getBlockId() == -1) {
                return i;
            }
        }
        return -1;
    }

    //Returns index of a frame in buffer pool that was removed & writes data of removed block if dirty
    private int removeFrame() {
        //LRU Buffer that removes least recently used Frame that CAN be removed
        int lruFrame = -1;
        long minTime = Long.MAX_VALUE;
        //comparison of all frames to see LRU frame
        for(int i = 0; i < buffers.length; i++) {
            if(!buffers[i].getPin()) {
                if(buffers[i].getTimestamp() < minTime) {
                    minTime = buffers[i].getTimestamp();
                    lruFrame = i;
                }
            }
        }
        //if all frames are pinned there are no frames to remove
        if(lruFrame == -1) {
            return lruFrame;
        }
        System.out.println("OUTPUT: Removed block #" + buffers[lruFrame].getBlockId() + " from frame #" + (lruFrame + 1));
        if(buffers[lruFrame].getDirty()) {
            System.out.println("OUTPUT: Wrote block #" + buffers[lruFrame].getBlockId() + " data to disk");
            writeData(buffers[lruFrame]);
        }
        else {
            System.out.println("OUTPUT: No data writing necessary");
        }
        //reset frame
        buffers[lruFrame].setBlockId(-1);
        buffers[lruFrame].clean();
        return lruFrame;

    }

    //Bring requested block into buffer pool at specified frame index
    private void addToBuffer(int fileName, int idx) {
        try {
            String str;
            //open corresponding file
            BufferedReader data = new BufferedReader(new FileReader("Project1/F" + fileName + ".txt"));
            //there's one line
            str = data.readLine();
            buffers[idx] = new Frame(str, fileName);
            System.out.println("OUTPUT: Brought Block #" + fileName + " into Frame #" + (idx+1));
            data.close();
        }
        catch (IOException e){
            System.out.println("OUTPUT: Error Reading File");
        }
    }

    //Writes frame's updated contents to the disk
    private void writeData(Frame frame) {
        try {
            FileWriter writer = new FileWriter("Project1/F" + frame.getBlockId() + ".txt");
            writer.write(frame.getContent());
            writer.close();
        }
        catch (IOException e) {
            System.out.println("OUTPUT: Error Writing File");
        }
    }

    //Decides block number based on record number
    private int getFile(int recordNum) {
        if(recordNum <= 100) {
            return 1;
        }
        else if(recordNum <= 200) {
            return 2;
        }
        else if(recordNum <= 300) {
            return 3;
        }
        else if(recordNum <= 400) {
            return 4;
        }
        else if(recordNum <= 500) {
            return 5;
        }
        else if(recordNum <= 600) {
            return 6;
        }
        else if(recordNum <= 700) {
            return 7;
        }
        return -1;
    }

    //Prints specified record
    private void printRecord(int recordNum, Frame frame) {
        //timestamp read
        frame.updateTimestamp();
        //index things
        recordNum -= 1;
        //separate all the records
        String[] records = frame.getContent().split("\\.");
        //print the record
        for(int i = 0; i < records.length; i++) {
            if(i == (recordNum % 100)) {
                System.out.println("OUTPUT: Record #" + (recordNum+1) + ": " + records[i]);
            }
        }
    }

    //Sets frame's content to specified string
    private void setRecord(int recordNum, Frame frame, String content) {
        //timestamp & dirty set
        frame.updateTimestamp();
        frame.dirty();
        //index things
        recordNum -= 1;
        //separate all the records
        String[] records = frame.getContent().split("\\.");
        //set the record
        for(int i = 0; i < records.length; i++) {
            if(i == (recordNum % 100)) {
                System.out.println("OUTPUT: Record #" + (recordNum+1) + ": " + records[i]);
                System.out.println("OUTPUT: CHANGED TO");
                records[i] = content;
                System.out.println("OUTPUT: Record #" + (recordNum+1) + ": " + records[i]);
            }
        }
        String updatedContent = String.join(".", records);
        frame.setContent(updatedContent);
    }

    //Helper function to see all the frames that are in memory
    public void printFrames() {
        for(int i = 0; i < buffers.length; i++) {
            System.out.println(
                    "OUTPUT: Frame: " + (i+1) +
                            " | BlockId: " + buffers[i].getBlockId() +
                            " | Pinned: " + buffers[i].getPin() +
                            " | Dirty: " + buffers[i].getDirty() +
                            " | Timestamp: " + buffers[i].getTimestamp());
        }
    }
}