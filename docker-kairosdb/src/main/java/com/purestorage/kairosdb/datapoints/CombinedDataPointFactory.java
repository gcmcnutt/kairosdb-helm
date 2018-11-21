package com.purestorage.kairosdb.datapoints;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import org.kairosdb.core.DataPoint;
import org.kairosdb.core.datapoints.DataPointFactory;

import java.io.DataInput;
import java.io.IOException;

public class CombinedDataPointFactory implements DataPointFactory {
    public static final String DST_COMBINED = "kairos_combined";
    public static final String GROUP_TYPE = "combined";

    @Override
    public String getDataStoreType() {
        return DST_COMBINED;
    }

    @Override
    public String getGroupType() {
        return GROUP_TYPE;
    }

    @Override
    public DataPoint getDataPoint(long timestamp, JsonElement json) throws IOException {
        if (json.isJsonObject()) {
            JsonObject object = json.getAsJsonObject();
            float br = object.get("br").getAsFloat();
            float bw = object.get("bw").getAsFloat();
            float ir = object.get("ir").getAsFloat();
            float iw = object.get("iw").getAsFloat();
            float lr = object.get("lr").getAsFloat();
            float lw = object.get("lw").getAsFloat();

            return new CombinedDataPoint(timestamp, br, bw, ir, iw, lr, lw);
        } else {
            throw new IOException("JSON object is not a valid complex data point");
        }
    }

    @Override
    public DataPoint getDataPoint(long timestamp, DataInput buffer) throws IOException {
        float br = buffer.readFloat();
        float bw = buffer.readFloat();
        float ir = buffer.readFloat();
        float iw = buffer.readFloat();
        float lr = buffer.readFloat();
        float lw = buffer.readFloat();

        return new CombinedDataPoint(timestamp, br, bw, ir, iw, lr, lw);
    }

    public DataPoint createDataPoint(long timestamp, double br, double bw, double ir, double iw, double lr, double lw) {
        return new CombinedDataPoint(timestamp, (float) br, (float) bw, (float) ir, (float) iw, (float) lr, (float) lw);
    }
}
