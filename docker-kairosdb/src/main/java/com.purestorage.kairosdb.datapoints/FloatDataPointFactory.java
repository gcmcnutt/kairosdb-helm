package com.purestorage.kairosdb.datapoints;

import com.google.gson.JsonElement;
import org.kairosdb.core.DataPoint;
import org.kairosdb.core.datapoints.DataPointFactory;

import java.io.DataInput;
import java.io.IOException;

public class FloatDataPointFactory implements DataPointFactory {
    public static final String DST_FLOAT = "kairos_float";
    public static final String GROUP_TYPE = "float";

    @Override
    public String getDataStoreType() {
        return DST_FLOAT;
    }

    @Override
    public String getGroupType() {
        return GROUP_TYPE;
    }

    @Override
    public DataPoint getDataPoint(long timestamp, JsonElement json) {
        return new FloatDataPoint(timestamp, json.getAsFloat());
    }

    @Override
    public DataPoint getDataPoint(long timestamp, DataInput buffer) throws IOException {
        float value = buffer.readFloat();

        return new FloatDataPoint(timestamp, value);
    }
}
