package com.purestorage.kairosdb.datapoints;


import org.json.JSONException;
import org.json.JSONWriter;
import org.kairosdb.core.datapoints.DataPointHelper;

import java.io.DataOutput;
import java.io.IOException;

public class FloatDataPoint extends DataPointHelper {
    private static final String API_TYPE = "float";
    private float m_value;

    public FloatDataPoint(long timestamp, float value) {
        super(timestamp);
        m_value = value;
    }

    @Override
    public void writeValueToBuffer(DataOutput buffer) throws IOException {
        buffer.writeFloat(m_value);
    }

    @Override
    public void writeValueToJson(JSONWriter writer) throws JSONException {
        writer.value(m_value);
    }

    @Override
    public String getApiDataType() {
        return API_TYPE;
    }

    @Override
    public String getDataStoreDataType() {
        return FloatDataPointFactory.DST_FLOAT;
    }

    @Override
    public boolean isLong() {
        return false;
    }

    @Override
    public long getLongValue() {
        return 0;
    }

    @Override
    public boolean isDouble() {
        return true;
    }

    @Override
    public double getDoubleValue() {
        return m_value;
    }
}
