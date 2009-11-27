/**
 * Copyright (C) 2009  HungryHobo@mail.i2p
 * 
 * The GPG fingerprint for HungryHobo@mail.i2p is:
 * 6DD3 EAA2 9990 29BC 4AD2 7486 1E2C 7B61 76DC DC12
 * 
 * This file is part of I2P-Bote.
 * I2P-Bote is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * I2P-Bote is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with I2P-Bote.  If not, see <http://www.gnu.org/licenses/>.
 */

package i2p.bote.folder;

import i2p.bote.packet.DataPacket;
import i2p.bote.packet.UniqueId;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import net.i2p.util.Log;

/**
 * This class stores new files under a random file name with the .pkt extension.
 *
 * @param <PacketType> The type of data stored in this folder
 */
public class PacketFolder<PacketType extends DataPacket> extends Folder<PacketType> {
    protected static final String PACKET_FILE_EXTENSION = ".pkt";
    
    private Log log = new Log(PacketFolder.class);

    public PacketFolder(File storageDir) {
        super(storageDir, PACKET_FILE_EXTENSION);
    }
    
    public <T extends PacketType> void add(T packetToStore) {
        String filename = new UniqueId().toBase64() + PACKET_FILE_EXTENSION;
        add(packetToStore, filename);
    }

    /**
     * 
     * @param packetToStore
     * @param filename A filename relative to this folder's storage directory.
     */
    protected void add(DataPacket packetToStore, String filename) {
        FileOutputStream outputStream = null;
        try {
            File file = new File(storageDir, filename);
            outputStream = new FileOutputStream(file);
            packetToStore.writeTo(outputStream);
        } catch (Exception e) {
            log.error("Can't save packet to file: <" + filename + ">", e);
        }
        finally {
            if (outputStream != null)
                try {
                    outputStream.close();
                }
                catch (IOException e) {
                    log.error("Can't close file: <" + filename + ">", e);
                }
        }
    }
    
    public void delete(UniqueId packetId) {
        // TODO
    }

    @Override
    @SuppressWarnings("unchecked")
    protected PacketType createFolderElement(File file) throws Exception {
        return (PacketType)DataPacket.createPacket(file);
    }
}